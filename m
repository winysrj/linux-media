Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39070 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbZICWut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2009 18:50:49 -0400
Received: by bwz19 with SMTP id 19so308771bwz.37
        for <linux-media@vger.kernel.org>; Thu, 03 Sep 2009 15:50:50 -0700 (PDT)
From: =?utf-8?q?Micha=C5=82?= <mishaaq@gmail.com>
To: linux-media@vger.kernel.org
Subject: saa716x driver and support Leadtek Winfast ExDTV 2300H
Date: Fri, 4 Sep 2009 00:52:13 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909040052.13834.mishaaq@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Recently I've found that saa716x driver is done (almost?), so I wanted to 
check it on my express card tuner: Leadtek Winfast ExDTV 2300H. I've compiled 
it and modprobe'd, but, unfortunately, it didn't worked - nothing happend. I 
assume that this card is not supported by this card yet. Is there any chance 
to change it?

card specification:
http://www.leadtek.com.tw/eng/tv_tuner/specification.asp?pronameid=428&lineid=6&act=2

uname -a:
Linux compal 2.6.28-15-generic #49-Ubuntu SMP Tue Aug 18 18:40:08 UTC 2009 
i686 GNU/Linux

lspci -vvv:
06:00.0 Multimedia controller: Philips Semiconductors Device 7160 (rev 03)
        Subsystem: LeadTek Research Inc. Device 6645                      
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 64 bytes                                                                
        Interrupt: pin A routed to IRQ 7                                                                     
        Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=1M]                                    
        Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/5 Enable-                      
                Address: 0000000000000000  Data: 0000                                                        
        Capabilities: [50] Express (v1) Endpoint, MSI 00                                                     
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256ns, 
L1 <1us                       
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-                                      
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                           
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-                                         
                        MaxPayload 128 bytes, MaxReadReq 128 bytes                                           
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-                          
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <4us, L1 <64us             
                        ClockPM- Suprise- LLActRep- BwNot-                                                   
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- 
CommClk-                             
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                       
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-           
        Capabilities: [74] Power Management version 2                                                        
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot-,D3cold-)                   
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                  
        Capabilities: [80] Vendor Specific Information <?>                                                   
        Capabilities: [100] Vendor Specific Information <?>

There isn't any entries in dmesg about this card or modprobe'd driver.

Regards,
Michał
