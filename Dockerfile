FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=abc123.$

COPY AdventureWorksDW2017.bak /var/opt/mssql/backup/AdventureWorksDW2017.bak
COPY NextGenSample_FB_Reports_Persistent_Report.bak /var/opt/mssql/backup/NextGenSample_FB_Reports_Persistent_Report.bak

RUN ( /opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -Q "RESTORE DATABASE AdventureWorksDW2017 FROM DISK = '/var/opt/mssql/backup/AdventureWorksDW2017.bak' WITH MOVE 'AdventureWorksDW2017' TO '/var/opt/mssql/data/AdventureWorksDW2017.mdf', MOVE 'AdventureWorksDW2017_log' TO '/var/opt/mssql/data/AdventureWorksDW2017.ldf'" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -Q "RESTORE DATABASE NextGenSample_FB_Reports_Persistent_Report FROM DISK = '/var/opt/mssql/backup/NextGenSample_FB_Reports_Persistent_Report.bak' WITH MOVE 'NextGenSample_FB_Reports_Persistent_Report' TO '/var/opt/mssql/data/NextGenSample_FB_Reports_Persistent_Report.mdf', MOVE 'NextGenSample_FB_Reports_Persistent_Report_log' TO '/var/opt/mssql/data/NextGenSample_FB_Reports_Persistent_Report.ldf'" \
    && pkill sqlservr

CMD ["/opt/mssql/bin/sqlservr"]