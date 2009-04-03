Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:56240 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbZDCFCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 01:02:23 -0400
Received: by fg-out-1718.google.com with SMTP id e12so443685fga.17
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 22:02:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com>
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com>
Date: Fri, 3 Apr 2009 18:02:20 +1300
Message-ID: <e6ac15e50904022202k1f71120bgc10837efd1ec0f24@mail.gmail.com>
Subject: SDMC DM1105N not being detected
From: mp3geek <mp3geek@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
