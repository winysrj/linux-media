Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34757 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbZAJMqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 07:46:05 -0500
Received: by bwz14 with SMTP id 14so30151902bwz.13
        for <linux-media@vger.kernel.org>; Sat, 10 Jan 2009 04:46:02 -0800 (PST)
Message-ID: <730f85f90901100446x252afbd3ma60b66126d29d9a5@mail.gmail.com>
Date: Sat, 10 Jan 2009 14:46:01 +0200
From: "Kevin Palberg" <kpalberg@gmail.com>
To: linux-media@vger.kernel.org
Subject: Memory corruption with Terratec Cinergy 1200 DVB-C MK3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can consistently generate kernel oops (or panic) with the following steps:

1) leave the computer turned off for several hours (6+ hours, overnight)
2) turn on, login and start a tv viewing app (gxine)
3) on gnome-terminal, su to root and run "memtest all"

The memtest command will get stuck trying to mlock memory (it doesn't
get far enough to actually test it) and I get a kernel oops
(usually in __rmqueue_smallest when it is manipulating a linked list.)

If I reboot the machine I can no longer cause this oops. Running
"memtest all" causes gxine to get OOM killed, mlock succeeds
and memtest starts testing memory.

However, the oops is not related to how long the computer has been on.
I can turn the computer on, use it for hours, reboot
as much as I like, but right after the first time I use a dvb
application I can cause the oops. Reboot the machine after that and I
can no longer cause the oops, no matter how much I run dvb
applications or any other applications.

I also got the same oops with simply:
1) czap -c channels.conf OneOfMyChannels
2) after czap has lock, let it run for about 5-10 seconds and abort with ctrl-c
3) run "memtest all"

I tested kernels 2.6.24.3 and 2.6.27.7 (x86 32-bit). I get no oopses
with the Debian etchnhalf amd64 kernel 2.6.24.

So, is this a kernel bug? Perhaps dvb-c hardware doesn't get properly
initialized when it's cold, when its state is random or whatever.
Or a hardware bug?

Here's the lspci info of the card:

05:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146
[1131:7146] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device [153b:1176]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fbfffc00 (32-bit, non-prefetchable) [size=512]


 - kpalberg
