Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ip-72-55-165-217.static.privatedns.com
	([72.55.165.217] helo=mail.redgrid.net ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lew@ldsit.com>) id 1K9sM8-0001Se-HR
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 03:57:34 +0200
Received: from localhost (localhost [127.0.0.1])
	by mail.redgrid.net (Postfix) with ESMTP id 1802498319
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 21:50:18 -0400 (EDT)
Received: from mail.redgrid.net ([127.0.0.1])
	by localhost (mail.redgrid.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Z61tuRp-739 for <linux-dvb@linuxtv.org>;
	Fri, 20 Jun 2008 21:50:11 -0400 (EDT)
Received: from luigi.lan (c122-108-20-110.eburwd9.vic.optusnet.com.au
	[122.108.20.110])
	by mail.redgrid.net (Postfix) with ESMTP id C25309830A
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 21:50:10 -0400 (EDT)
Content-Disposition: inline
From: Lew <lew@ldsit.com>
To: linux-dvb@linuxtv.org
Date: Sat, 21 Jun 2008 11:57:16 +1000
MIME-Version: 1.0
Message-Id: <200806211157.16540.lew@ldsit.com>
Subject: [linux-dvb] Diff's to add twinhan mini ter variant
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

Hi Guys,

I've been siting on this one for a while, but I found a twinhan mini ter dvb 
card that needed some minor adjustments to be recognised.

As compared againsttip today...
In linux/drivers/media/video/bt8xx/linux/drivers/media/video/bt8xx

320a321
> 	{ 0x0001feff, BTTV_BOARD_TWINHAN_DST,   "Twinhan VisionPlus DVB" },


In /linux/drivers/media/dvb/bt8xx/bt878.c
404d403
>	BROOKTREE_878_DEVICE(0xfeff, 0x0001, "Twinhan VisionPlus DVB"),

lspci -vv of the device (pre driver change)....

05:02.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
	Subsystem: Unknown device feff:0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at ca102000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:02.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
	Subsystem: Unknown device feff:0001
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at ca103000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Le me know if you need any more info.

Cheers,

-- 
Lewis Shobbrook
------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
