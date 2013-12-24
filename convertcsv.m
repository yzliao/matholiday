function [list,nContacts] = convertcsv(filename)
% LYZ @ Dec 24th, 2013
% Borrow some ideas from Edgar Guevara Codina's secretsanta

% Read a .CSV file with contacts exported from gmail (in Outlook format).
% Input:
% filename  CSV file
%
% Output:
% list      cell with names and emails of each contacts
% nContacts number of contacts

csvfile = textread(filename, '%s', 'delimiter', '\n', 'whitespace', '');

% header
csv_header = csvfile{1};
[~, ~, ~, ~, ~, ~, splitStr] = regexp(csv_header, ',');

% first name col num -- 1
firstNameIdx = find(cellfun(@(x) strcmp('First Name',x),splitStr));

% last name col num -- 3
lastNameIdx = find(cellfun(@(x) strcmp('Last Name',x),splitStr));

% title col num -- 4
titleIdx = find(cellfun(@(x) strcmp('Title',x),splitStr));

% email 1 col num -- 15
email1Idx = find(cellfun(@(x) strcmp('E-mail Address',x),splitStr));

% email 2 col num -- 16
email2Idx = find(cellfun(@(x) strcmp('E-mail 2 Address',x),splitStr));

% email 3 col num -- 17
email3Idx = find(cellfun(@(x) strcmp('E-mail 3 Address',x),splitStr));

% allocate list cell
numContacts = size(csvfile,1)-1;
list = cell(numContacts,6);

for i = 1:numContacts,
    [~,~,~,~,~,~, thisRow] = regexp(csvfile{i+1},',');
    
    if length(thisRow) < email3Idx,
        continue;
    end
    
    list{i,1} = thisRow{firstNameIdx};
    list{i,2} = thisRow{lastNameIdx};
    list{i,3} = thisRow{titleIdx};
    list{i,4} = thisRow{email1Idx};
    list{i,5} = thisRow{email2Idx};
    list{i,6} = thisRow{email3Idx};
end


% filter results, remove no name and no email contacts
removeIdx = [];
for i = 1:numContacts,
    if isempty(list{i,1}) || ...
            (isempty(list{i,4}) && isempty(list{i,5}) && isempty(list{i,6}))
        removeIdx = [removeIdx i];
    end
end

saveIdx = 1:numContacts;
saveIdx(removeIdx) = [];
list = list(saveIdx,:);
nContacts = size(list,1);