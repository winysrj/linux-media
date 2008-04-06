Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.ip-minds.de ([84.200.240.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jean.bruenn@ip-minds.de>) id 1JiV75-0005vP-MJ
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 15:40:52 +0200
Message-ID: <52153.82.83.248.119.1207489187.squirrel@webmail.ip-minds.de>
Date: Sun, 6 Apr 2008 15:39:47 +0200 (CEST)
From: jean.bruenn@ip-minds.de
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] WinTV HVR 1400 (cx23885)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

i bought a dvb-t card ago some days, now i'm tried to get it working in
linux without any luck. It seems that there are not many information
available for that card (google displays mostly other cards or product
information).

    Hauppauge WinTV HVR 1400 Hybrid TV ExpressCard (Analog and Digital Tuner)

When inserting it into my notebook, my kernel is loading the "cx23885"
module and displaying:

    "Your board isn't known (yet) to the driver. You can
     try to pick one of the existing card configs via
     card=<n> insmod option. Updating to the latest
     version might help as well."

I tried the 5 available cards (0 = unknown/generic, 1 = wintv-hvr1800lp, 2
= wintv-hvr1800, 3 = wintv-hvr1250, 4 = dvico fusionhdtv5 express)

Where
    0 works without an error msg, but i don't have /dev/dvb/* /dev/videoX
or /dev/v4l/*
    1,2,3 prints out: cx23885_dev_setup() Failed to register dvb adapters
on VID_C and does not give a /dev/dvb/* /dev/videoX or /dev/v4l/*
    4 gives /dev/dvb* but no /dev/videoX or /dev/v4l/*

My questions are easy...:
    1 is that card supported?
    2 any idea how to get that card working (i don't have windows, so i
cannot use that card)

Here are some more information, if you need further information or
details, just let me know:

    03:00.0 0400: 14f1:8852 (rev 02)
            Subsystem: 0070:8010

lspci -vvv
    03:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev
02)
            Subsystem: Hauppauge computer works Inc. Unknown device 8010
            Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
            Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
            Latency: 0, Cache Line Size: 64 bytes
            Interrupt: pin A routed to IRQ 20
            Region 0: Memory at d3000000 (64-bit, non-prefetchable) [size=2M]
            Capabilities: [40] Express (v1) Endpoint, MSI 00
                    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                    DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                            MaxPayload 128 bytes, MaxReadReq 512 bytes
                    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                    LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <2us, L1 <4us
                            ClockPM- Suprise- LLActRep- BwNot-
                    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                    LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
            Capabilities: [80] Power Management version 2
                    Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                    Status: D0 PME-Enable- DSel=0 DScale=0 PME-
            Capabilities: [90] Vital Product Data <?>
            Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                    Address: 0000000000000000  Data: 0000
            Capabilities: [100] Advanced Error Reporting <?>
            Capabilities: [200] Virtual Channel <?>
            Kernel driver in use: cx23885
            Kernel modules: cx23885

Cheers
Jean



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
