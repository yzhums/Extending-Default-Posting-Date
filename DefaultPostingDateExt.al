enumextension 50100 DefaultPostingDateExt extends "Default Posting Date"
{
    value(50000; Today)
    {
    }
    value(50001; "Beginning of the month")
    {
    }
    value(50002; "End of the month")
    {
    }
}

codeunit 50111 DefaultPostingDateHandler
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnInitRecordOnBeforeAssignOrderDate, '', false, false)]
    local procedure OnInitRecordOnBeforeAssignOrderDate(var SalesHeader: Record "Sales Header"; var NewOrderDate: Date)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        case SalesSetup."Default Posting Date" of
            SalesSetup."Default Posting Date"::Today:
                SalesHeader."Posting Date" := Today;
            SalesSetup."Default Posting Date"::"Beginning of the month":
                SalesHeader."Posting Date" := CalcDate('<-CM>', Today);
            SalesSetup."Default Posting Date"::"End of the month":
                SalesHeader."Posting Date" := CalcDate('<CM>', Today);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnInitRecordOnAfterAssignDates, '', false, false)]
    local procedure OnInitRecordOnAfterAssignDates(var PurchaseHeader: Record "Purchase Header")
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.Get();
        case PurchSetup."Default Posting Date" of
            PurchSetup."Default Posting Date"::Today:
                PurchaseHeader."Posting Date" := Today;
            PurchSetup."Default Posting Date"::"Beginning of the month":
                PurchaseHeader."Posting Date" := CalcDate('<-CM>', Today);
            PurchSetup."Default Posting Date"::"End of the month":
                PurchaseHeader."Posting Date" := CalcDate('<CM>', Today);
        end;
    end;
}
