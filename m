Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.fisk.me.uk ([87.127.77.141] helo=fisk.me.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nick@fisk.me.uk>) id 1KjZoy-0005W7-K3
	for linux-dvb@linuxtv.org; Sat, 27 Sep 2008 15:26:53 +0200
Received: from [192.168.1.4] (unknown [192.168.1.4])
	by fisk.me.uk (Fisk Server) with ESMTPA id AF97D824C
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 14:26:49 +0100 (BST)
From: Nick Fisk <nick@fisk.me.uk>
To: linux-dvb@linuxtv.org
In-Reply-To: 
Date: Sat, 27 Sep 2008 14:26:18 +0100
Message-Id: <1222521978.23202.5.camel@localhost>
Mime-Version: 1.0
Subject: [linux-dvb]  saa7134 ioremap() problem
Reply-To: nick@fisk.me.uk
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

Hi,

I also have a card based on the saa7134 chip and I am encountering the
same problem as described in this thread.

My card:-

00:01.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
Video Broadcast Decoder (rev d1)
	Subsystem: Avermedia Technologies Inc Unknown device 2c00
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at febef800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-




I was wondering if this fix would be included in 2.6.27?

If there is any testing or other information that I can provide that
would help please let me know.

Nick


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
