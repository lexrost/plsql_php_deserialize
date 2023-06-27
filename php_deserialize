create or replace function php_deserialize(str text) returns json as
    $$
    DECLARE
        def_len int;
        data_len int;
        total_len int := length(str);

        p int := 1;
        alpha char := substr(str,1,1);

        stack text := '';
        bytes bytea;

        part text;
        k text; -- key
        v text; -- value

        parsed text := '';

        error_message text;
    BEGIN
        if str is null then return NUll::json; end if;
        if total_len = 0 or length(trim(str)) = 0  then return NUll::json; end if;
        if alpha != 'a' then raise 'expected array got: %', str; end if;

        while  p <= total_len loop
            alpha :=  substr(str,p,1);
--             raise info 'p: %', p;
--             raise info 'stack: %', stack;
--             raise info 'alpha: %', alpha;
--             raise info 'parsed: %', parsed;
            if alpha = '{'
                then
                    if right(stack, 1) = '}'
                        then raise 'invalid braces';
                    else
                        stack := stack || alpha ;
                        parsed := parsed || coalesce( k ||':','') || alpha;
                        k := Null;
                        p := p + 1;
                    end if;
            elsif alpha = '}'
                then
                    if right(stack,1) = '{'
                        then
                            stack := substr(stack,1,length(stack)-1);
                            if substr(reverse(parsed),1,1) = ','
                                then
                                    parsed := reverse(substr(reverse(parsed),2));
                            end if;
                            if length(stack) < 1
                                then
                                    parsed := parsed || alpha ;
--                                     raise info 'stack is closed, exiting parsed data: %', parsed;
                                    return parsed;
                                    exit;
                            else
                                    parsed := parsed || alpha || ',';
                            end if;
                            p := p +1;
                    else
                        raise 'invalid braces expected } or none got { str: %' ,substr(str,p);
                    end if;
--             end if;
            -- parsing and skipping
            elsif alpha = 's' and substring(substr(str,p) from '^s:[0-9]+:') is not null
               then
                  def_len := length(substring(substr(str,p) from '^s\:[0-9]+\:'))::int;
                  data_len := substring(substr(str,p) from '^s\:([0-9]+)\:')::int;
--                   raise info 'part to parse: %', substr(str,p + def_len + 1, data_len );
                  part := replace(substr(str,p + def_len + 1, data_len),'\','\\');
                  bytes := part::bytea; --estimation
                  bytes := substr(bytes,1,data_len)::bytea; -- true data string in bytes
                  part :=  convert_from(bytes, 'UTF-8')::text;
--                   raise info 'part parsed: %', part;
                  data_len := length(part)::int; -- true data length in char
                  p := p + def_len + 1 + data_len + 1;
--                   part := '"' || part || '"';
                  part := to_json(part);
            elsif alpha = 'i' and substring(substr(str,p) from '^i\:\-?[0-9]+') is not null
               then
--                     raise info 'I am i skip block skipping %', substring(substr(str,p) from '^i\:[0-9]+');
                    part := to_json( substring(substr(str,p) from '^i\:\-?([0-9]+)'));
                    p := p + length(substring(substr(str,p) from '^i\:\-?[0-9]+'));

            elsif alpha = 'b' and substring(substr(str,p) from '^b\:[01]') is not null

               then
                    part := substring(substr(str,p) from '^b\:([01])')::boolean::text;
                    p := p + 4;
            elsif alpha = 'N' and   substring(substr(str,p) from '^N;') is not null
                then
                    part := 'null';
                    p := p + 1;
            elsif alpha = 'd' and substring(substr(str,p) from '^d\:\-?[0-9.]+') is not null
                then
                    part := to_json( substring(substr(str,p) from '^d\:(\-?[0-9.]+)'));
                    p := p + length(substring(substr(str,p) from '^d\:\-?[0-9.]+'));
            else
                  p := p + 1;
            end if;

            -- add parsed to parsed
            if k is null
                then
                    k := part;
            elsif v is null
                then
                    v := part;
            end if;

            if k is not null and v is not null
                then
                  parsed := parsed || k || ':' || v || ',';
                  k := null;
                  v := null;
            end if;

            part := null;
--             raise info 'after skipping block p: %', p;
--             raise info 'after skipping block str: %', substr(str,p);
--             raise info 'end loop iteration';
        end loop;

--
        if length(stack) > 0
            then
--                 raise info 'No closing bracket';
                return null::json;
        else
                return parsed::json;
        end if;

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS error_message := MESSAGE_TEXT;
        error_message := error_message || ' [current string] [' || str || ']';
        RAISE 'error message: %', error_message;

    END;
    $$ LANGUAGE plpgsql IMMUTABLE
