
select * from all_objects where object_name like '%INB%INVOICE%'
/
select * from inb_invoice_header
delete from  inb_invoice_header where id is null
select * from inb_invoice_lines

GRANT EXECUTE ON DBMS_CLOUD_AI TO ADMIN;
/
Step 3: Grant Network ACL Access
This allows the database to make outbound HTTPS calls to the OpenAI API.

As ADMIN:
allows the database to make outbound HTTPS calls to the OpenAI API.
/

Step 3: Grant Network ACL Access
This allows the database to make outbound HTTPS calls to the OpenAI API.
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'api.openai.com',
        ace  => xs$ace_type(
                    privilege_list => xs$name_list('http'),
                    principal_name => 'ADMIN',
                    principal_type => xs_acl.ptype_db)
    );
END;
/
Step 3: allow the database to make outbound HTTPS calls to the cohere API.

  BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
         host => 'api.cohere.ai',
         ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => 'ADMIN',
                             principal_type => xs_acl.ptype_db)
   );
END;
https://dashboard.cohere.com/welcome/login
Sc2mbJGk3dML7rjknby3F5khgKlaQk6PgJdvjh7b



Step 4: Create Credential for OpenAI
Now connect as ADB_USER and create a credential that stores your OpenAI API key:

BEGIN
    DBMS_CLOUD.DROP_CREDENTIAL (
        credential_name => 'BHARATHOPENAIV'
    );
END;
Step 4: Create Credential for cohere

/
BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
        credential_name => 'BHARATHCOHERE',
        username        => 'BHARATHCOHERE',
        password        => 'xxxx'
    );
END;

/
BEGIN
    DBMS_CLOUD_AI.CREATE_PROFILE(
        profile_name => 'BHARATHCOHEREPROFILE',
        attributes   => '{"provider": "cohere",
            "credential_name": "BHARATHCOHERE",
            "object_list": [
                {"owner": "ADMIN", "name": "INB_INVOICE_HEADER"},
                {"owner": "ADMIN", "name": "INB_INVOICE_LINES"}
            ]
        }'
    );
END;


/

Step 5: Create the AI Profile
Create the AI profile specifying the provider, credential, and target database objects. The object_list defines which tables and views Select AI will reference when generating SQL from natural language.

BEGIN
    DBMS_CLOUD_AI.CREATE_PROFILE(
        profile_name => 'BBHARATHOPENAIPROFILECOHERE',
        attributes   => '{"provider": "cohere",
            "credential_name": "BHARATHOPENAIV",
            "object_list": [
                {"owner": "ADMIN", "name": "INB_INVOICE_HEADER"},
                {"owner": "ADMIN", "name": "INB_INVOICE_LINES"}
            ]
        }'
    );
END;
/

Step 6: Test It!
Use DBMS_CLOUD_AI.GENERATE to test different Select AI actions.

Generate SQL from natural language:
just test it now

SELECT DBMS_CLOUD_AI.GENERATE(
    prompt       => 'how many invoices exist',
    profile_name => 'BHARATHCOHEREPROFILE',
    action       => 'showsql'
) FROM DUAL;
/



Run the query and get results:

SELECT DBMS_CLOUD_AI.GENERATE(
    prompt       => 'how many Invoices exist',
    profile_name => 'BHARATHCOHEREPROFILE',
    action       => 'runsql'
) FROM DUAL;

Get a narrative response:

SELECT DBMS_CLOUD_AI.GENERATE(
    prompt       => 'how many invoices belong to CAPITAL ONE',
    profile_name => 'BHARATHCOHEREPROFILE',
    action       => 'narrate'
) FROM DUAL;



Explain the generated SQL:

SELECT DBMS_CLOUD_AI.GENERATE(
    prompt       => 'how many invoices belong to CAPITAL ONE',
    profile_name => 'BHARATHCOHEREPROFILE',
    action       => 'explainsql'
) FROM DUAL;


Using the SELECT AI Shorthand
first perform profile once and use the shorter SELECT AI syntax:

EXEC DBMS_CLOUD_AI.SET_PROFILE('BHARATHCOHEREPROFILE');


SELECT AI how many Invoices exist;


SELECT AI  how many invoices belong to CAPITAL ONE;




SELECT AI narrate what are the top 3 customers in San Francisco;
SELECT AI chat what is Oracle Autonomous Database;

BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
        credential_name => 'BHARATHOPENAIV',
        username        => 'BHARATHOPENAI',
        password        => 'xxxx'
    );
END;

/

SELECT AI narrate give me all invoices list which belong to CAPITAL ONE
