% matholiday.m
% send your holiday wishes to family and friends
% LYZ @ Dec 24th, 2013

%%%%%% Parameters %%%%%%
% contact CSV file name
filename = 'fake.csv';

% Gmail address
mail = 'example@example.com';

% Gmail password (MODIFY NEXT LINE BEFORE DISTRIBUTING TO OTHERS)
password = 'example';

% Email subject
subject = 'Greetings from Santa -- Happy Holidays!';

%%%%%%%%%%%%%%%%%%%%%%%%%

% get contact lists
[list,nContacts] = convertcsv(filename);

% create task list
nameCell = cell(nContacts,1);
addrCell = cell(nContacts,3);

for i = 1:nContacts,
    % if has title, use title + last name. Otherwise, use first name
    if ~isempty(list{i,3})
        nameCell{i} = [list{i,3},' ',list{i,2}];
    else
        nameCell{i} = list{i,1};
    end
    
    % email address
    for j = 1:3,
        addrCell{i,j} = list{i,j+3};
    end
    display([nameCell{i},':',addrCell{i,1},'|',addrCell{i,2},'|',addrCell{i,3}]);
end

% set up email service
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

fprintf('------------------------\n');
fprintf('Start to send emails...\n');

% Send the email
for i = 1:nContacts,
    % It is email context. Edit it and send your wishes
    mail_context = [...
        'Dear ',nameCell{i},' :', 10 ... % use 10 as line break
        10 ...
        'Start to write your wishes here. If it is too long, you can break it ',...
        'into two lines for typing. Do not forget about the whitespaces ',...
        'If you want to start a new paragraph, use two 10 as line breaks.',10 ...
        10 ...
        'Thanks,',10,'Santa',...
        ];
    
    % clear empty email address (for multiple addresses)
    addr = {};
    for j = 1:3,
        if ~isempty(addrCell{i,j}),
            addr = [addr {addrCell{i,j}}];
        end
    end
    sendmail(addr,subject,mail_context);
    display(['Send to: ',nameCell{i}]);
    
    % pause -- avoid spam filter block
    pause(2);
end
fprintf('------------------------\n');
fprintf('Sent all! Happy Holiday\n');

