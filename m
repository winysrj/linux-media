Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <james.ellis@gmail.com>) id 1K6QZM-0001U7-Jn
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 15:40:59 +0200
Received: by wf-out-1314.google.com with SMTP id 27so3091001wfd.17
	for <linux-dvb@linuxtv.org>; Wed, 11 Jun 2008 06:40:51 -0700 (PDT)
To: linux-dvb@linuxtv.org
Date: Wed, 11 Jun 2008 23:40:41 +1000
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806112340.41546.je@customr.net>
From: James Ellis <james.ellis@gmail.com>
Subject: [linux-dvb] Avermedia HC82 express card
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

Hi

I recently got a new laptop and this express card was included in the package. 
I'm interested in support for it in Linux, although given I didn't ask for 
it, I won't be too miffed if it cannot yet be supported.
I think the main problem is getting the firmware...

Here is what I can gather...

Plugging the express card in (after "pciehp pciehp_force=1") shows:

==> /var/log/syslog <==
Jun 11 23:14:02 box kernel: [34224.509805] pciehp: Card present on 
Slot(0013_0005)

==> /var/log/messages <==
Jun 11 23:14:03 box kernel: [34225.206518] program_fw_provided_values: Could 
not get hotplug parameters

Windows shows the card details as:
Avermedia HC82 Express-Card Hybrid Analog

Output of lspci -vvnn

0d:00.0 Multimedia controller [0480]: Philips Semiconductors Unknown device 
[1131:7160] (rev 03)
        Subsystem: Avermedia Technologies Inc Unknown device [1461:0555]
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 0
        Region 0: Memory at f9c00000 (64-bit, non-prefetchable) [disabled] 
[size=1M]
        Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/5 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [50] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <256ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <4us, L1 <64us
                Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [74] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] Vendor Specific Information


Installing the driver from Dell 
(http://support.us.dell.com/support/downloads/download.aspx?c=us&l=en&s=gen&releaseid=R175809&formatcnt=1&libid=0&fileid=239014) 
in Windows gives the following files, that look like drivers. Are their any 
others that could be candidates ?

AVerBDA716x.sys
MV716.ax

The question then is how can the firmware be installed in linux ? I've read 
the linux-dvb wiki but am still unsure.

Any help appreciated..

Thanks
James

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
