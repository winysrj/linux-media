Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mp3geek@gmail.com>) id 1LpbSI-0007ms-In
	for linux-dvb@linuxtv.org; Fri, 03 Apr 2009 06:56:40 +0200
Received: by fg-out-1718.google.com with SMTP id l27so843687fgb.2
	for <linux-dvb@linuxtv.org>; Thu, 02 Apr 2009 21:56:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Apr 2009 17:56:35 +1300
Message-ID: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com>
From: mp3geek <mp3geek@gmail.com>
To: linux-dvb@linuxtv.org
Cc: liplianin@me.by
Subject: [linux-dvb] SDMC DM1105N not being detected
Reply-To: linux-media@vger.kernel.org
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

Not even being detected in Linux 2.6.29.1, I have the modules "dm1105"
loaded, but since its not even being detected by linux..

lspci -vv shows this (I'm assuming this is the card..), dmesg shows
nothing dvb being loaded

00:0b.0 Ethernet controller: Device 195d:1105 (rev 10)
    Subsystem: Device 195d:1105
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 30 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 5
    Region 0: I/O ports at 9400 [size=256]


The chip says the following, SDMC DM1105N, EasyTV-DVBS V1.0B
(2008-04-26), 0735 E280034

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
