//+------------------------------------------------------------------+
//|                                                      Fxdaddy_Standard.mq5 |
//|                        Copyright 2024, Fxdaddy Trading System   |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Fxdaddy Trading System"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "BTA Trading EA - Using MT5 Standard Framework"

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
#include <Expert\Signal\SignalMA.mqh>
#include <Expert\Trailing\TrailingParabolicSAR.mqh>
#include <Expert\Money\MoneyFixedLot.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//--- inputs for expert
input string             Inp_Expert_Title                      ="Fxdaddy Standard";
int                      Expert_MagicNumber                    =12345;
bool                     Expert_EveryTick                      =false;

//--- inputs for signal
input int                Inp_Signal_MA_Period                  =12;
input int                Inp_Signal_MA_Shift                   =6;
input ENUM_MA_METHOD     Inp_Signal_MA_Method                  =MODE_SMA;
input ENUM_APPLIED_PRICE Inp_Signal_MA_Applied                 =PRICE_CLOSE;

//--- inputs for trailing
input double             Inp_Trailing_ParabolicSAR_Step        =0.02;
input double             Inp_Trailing_ParabolicSAR_Maximum     =0.2;

//--- inputs for money
input double             Inp_Money_FixedLot_Volume             =0.01;

//--- Trading settings
input double             InpDailyLossLimit                     =100.0;
input int                InpMaxTrades                         =5;

//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;

//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit(void)
{
    //--- Initializing expert
    if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
    {
        //--- failed
        printf(__FUNCTION__+": error initializing expert");
        ExtExpert.Deinit();
        return(-1);
    }
    
    //--- Creation of signal object
    CSignalMA *signal=new CSignalMA;
    if(signal==NULL)
    {
        //--- failed
        printf(__FUNCTION__+": error creating signal");
        ExtExpert.Deinit();
        return(-2);
    }
    
    //--- Add signal to expert (will be deleted automatically))
    if(!ExtExpert.InitSignal(signal))
    {
        //--- failed
        printf(__FUNCTION__+": error initializing signal");
        ExtExpert.Deinit();
        return(-3);
    }
    
    //--- Set signal parameters
    signal.PeriodMA(Inp_Signal_MA_Period);
    signal.Shift(Inp_Signal_MA_Shift);
    signal.Method(Inp_Signal_MA_Method);
    signal.Applied(Inp_Signal_MA_Applied);
    
    //--- Check signal parameters
    if(!signal.ValidationSettings())
    {
        //--- failed
        printf(__FUNCTION__+": error signal parameters");
        ExtExpert.Deinit();
        return(-4);
    }
    
    //--- Creation of trailing object
    CTrailingPSAR *trailing=new CTrailingPSAR;
    if(trailing==NULL)
    {
        //--- failed
        printf(__FUNCTION__+": error creating trailing");
        ExtExpert.Deinit();
        return(-5);
    }
    
    //--- Add trailing to expert (will be deleted automatically))
    if(!ExtExpert.InitTrailing(trailing))
    {
        //--- failed
        printf(__FUNCTION__+": error initializing trailing");
        ExtExpert.Deinit();
        return(-6);
    }
    
    //--- Set trailing parameters
    trailing.Step(Inp_Trailing_ParabolicSAR_Step);
    trailing.Maximum(Inp_Trailing_ParabolicSAR_Maximum);
    
    //--- Check trailing parameters
    if(!trailing.ValidationSettings())
    {
        //--- failed
        printf(__FUNCTION__+": error trailing parameters");
        ExtExpert.Deinit();
        return(-7);
    }
    
    //--- Creation of money object
    CMoneyFixedLot *money=new CMoneyFixedLot;
    if(money==NULL)
    {
        //--- failed
        printf(__FUNCTION__+": error creating money");
        ExtExpert.Deinit();
        return(-8);
    }
    
    //--- Add money to expert (will be deleted automatically))
    if(!ExtExpert.InitMoney(money))
    {
        //--- failed
        printf(__FUNCTION__+": error initializing money");
        ExtExpert.Deinit();
        return(-9);
    }
    
    //--- Set money parameters
    money.Volume(Inp_Money_FixedLot_Volume);
    
    //--- Check money parameters
    if(!money.ValidationSettings())
    {
        //--- failed
        printf(__FUNCTION__+": error money parameters");
        ExtExpert.Deinit();
        return(-10);
    }
    
    //--- Tuning of all necessary indicators
    if(!ExtExpert.InitIndicators())
    {
        //--- failed
        printf(__FUNCTION__+": error initializing indicators");
        ExtExpert.Deinit();
        return(-11);
    }
    
    //--- Print initialization message
    Print("Fxdaddy Standard EA initialized successfully!");
    Print("Lot Size: ", Inp_Money_FixedLot_Volume);
    Print("Max Trades: ", InpMaxTrades);
    Print("Daily Loss Limit: $", InpDailyLossLimit);
    Print("MA Period: ", Inp_Signal_MA_Period);
    Print("Parabolic SAR Step: ", Inp_Trailing_ParabolicSAR_Step);
    
    //--- succeed
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    ExtExpert.Deinit();
    Print("Fxdaddy Standard EA deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Function-event handler "tick"                                    |
//+------------------------------------------------------------------+
void OnTick(void)
{
    ExtExpert.OnTick();
}

//+------------------------------------------------------------------+
//| Function-event handler "trade"                                   |
//+------------------------------------------------------------------+
void OnTrade(void)
{
    ExtExpert.OnTrade();
}

//+------------------------------------------------------------------+
//| Function-event handler "timer"                                   |
//+------------------------------------------------------------------+
void OnTimer(void)
{
    ExtExpert.OnTimer();
}
