Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <IxAYMzFpK2ojlw@sofortsurf.de>) id 1JfR4o-0001Rx-BV
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 03:45:54 +0100
Date: Sat, 29 Mar 2008 03:41:54 +0100
From: "L." <IxAYMzFpK2ojlw@sofortsurf.de>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-ID: <20080329024154.GA23883@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Analog capture (saa7113) not working on KNC1 DVB-C Plus
	(MK3)
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

with a KNC One "TV-Station DVB-C Plus" PCI card (MK3 - Philips SAA7146
with CU1216L/A I G H-3 Tunerbox with TDA10023) equipped with composite 
and s-video inputs ('Plus' version, Philips SAA7113), analog capture 
is not working. Most recent kernel sources I tested were 2.6.25-rc7.

DVB-C television works fine with this card using 'budget_av' kernel
module (from kernel 2.6.20 on, using e9hack's tda1002x patch, and
later with mainstream kernel sources alone), but when opening an
analog input, there are no data coming. A black screen is shown with
'xawtv' application. Xawtv correctly shows up the two video sources
this card provides: 'S-Video' and 'Composite'. 

I checked the cables and video sources, they work fine with another
card with analog input.

I can do tests or compile something if you want me to. Information from 
lspci, dmesg and lsmod please see below. Help to get analog capture
working is appreciated very much.

Thank you

L.

'lspci -nn' and 'lspci -vv' show:

00:14.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)

00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: KNC One Unknown device 0023
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 7
        Region 0: Memory at de00d000 (32-bit, non-prefetchable) [size=512]

Note: Subsystem ID 1894:0023 is a KNC One TV-Station DVB-C Plus (MK3)

dmesg shows:

[...]
Linux video capture interface: v2.00
saa7146: register extension 'budget_av'.
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LNKB] -> GSI 7 (level, low) -> IRQ 7
saa7146: found saa7146 @ mem de984000 (revision 1, irq 7) (0x1894,0x0023).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (KNC1 DVB-C Plus MK3).
adapter failed MAC signature check
encoded MAC from EEPROM was ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
saa7146_vv: saa7146 (0): registered device video0 [v4l2]
KNC1-0: MAC addr = [...]
DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
budget-av: ci interface initialised.
[...]

'lsmod' shows:

[...]
tda10023                6500  1 
budget_av              20000  1 
dvb_pll                14308  1 budget_av
saa7146_vv             48672  2 budget_av
video_buf              24388  1 saa7146_vv
videodev               27104  2 saa7146_vv
v4l2_common            24096  2 saa7146_vv,videodev
v4l1_compat            14340  2 saa7146_vv,videodev
firmware_class          9568  2 pcmcia,budget_av
budget_core            10980  1 budget_av
dvb_core               78024  2 budget_av,budget_core
saa7146                18408  3 budget_av,saa7146_vv,budget_core
ttpci_eeprom            2368  1 budget_core
[...]

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
