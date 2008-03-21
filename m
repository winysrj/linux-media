Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JcVWV-0003eI-2r
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 01:54:22 +0100
Received: from berkeloid.vlook.shikadi.net ([192.168.4.11])
	by vitalin.sorra.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JcVWP-0003FM-VB
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 10:54:14 +1000
Received: from korath.teln.shikadi.net ([192.168.0.14])
	by berkeloid.teln.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JcVWP-0006Z4-4J
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 10:54:13 +1000
Message-ID: <47E30735.1020604@shikadi.net>
Date: Fri, 21 Mar 2008 10:54:13 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47E226E7.7030601@shikadi.net>
	<200803201002.47240.Nicola.Sabbi@poste.it>
In-Reply-To: <200803201002.47240.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] dvbstream reliability issues?
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

> I use it for hours, even forgetting that it's recording, without 
> segfaults.
> Try to run it under gdb (after having compiled it with -g) and 
> see with "bt" where it segfaults, or bugs can't be fixed

What's your reception like?  This particular card (DVico Fusion HDTV)
seems to be somewhat less sensitive compared to my other cards, and I
think getting corrupted data coming in is what breaks dvbstream.  The
recording itself is full of blips as if the reception is quite bad.

When the recording just stops (no crash) gdb doesn't seem to reveal
anything amazing:

<Ctrl+C>
Program received signal SIGINT, Interrupt.
0xffffe410 in __kernel_vsyscall ()
(gdb) bt
#0  0xffffe410 in __kernel_vsyscall ()
#1  0xb7ebf77b in poll () from /lib/libc.so.6
#2  0x0804aeeb in main (argc=12, argv=0xbfe38484) at dvbstream.c:1516
(gdb) fr 2
#2  0x0804aeeb in main (argc=12, argv=0xbfe38484) at dvbstream.c:1516
1516            poll(pfds,1,500);
(gdb) cont
Continuing.
[Still no DVB data being written to disk]
<Ctrl+C>
Program received signal SIGINT, Interrupt.
0xffffe410 in __kernel_vsyscall ()
(gdb) bt
#0  0xffffe410 in __kernel_vsyscall ()
#1  0xb7ebf77b in poll () from /lib/libc.so.6
#2  0x0804aeeb in main (argc=12, argv=0xbfe38484) at dvbstream.c:1516
(gdb) fr 2
#2  0x0804aeeb in main (argc=12, argv=0xbfe38484) at dvbstream.c:1516
1516            poll(pfds,1,500);


If I kill dvbstream and reload it then all is fine, so it seems that
maybe the card loses sync with the signal, and either dvbstream needs to
retune the card, or perhaps the kernel driver should do that automatically.

When it crashes it looks like this:


Program received signal SIGSEGV, Segmentation fault.
0xb7ee153c in memcpy () from /lib/libc.so.6
(gdb) bt
#0  0xb7ee153c in memcpy () from /lib/libc.so.6
#1  0x08049714 in collect_section (section=0x815bef0, pusi=<value
     optimized out>, buf=0x3ffff59e <Address 0x3ffff59e out of bounds>,
     len=3221135360) at dvbstream.c:579
#2  0x0804b21b in main (argc=12, argv=0xbffe8084) at dvbstream.c:683

(gdb) fr 1
#1  0x08049714 in collect_section (section=0x815bef0, pusi=<value
     optimized out>, buf=0x3ffff59e <Address 0x3ffff59e out of bounds>,
     len=3221135360) at dvbstream.c:579
579       memcpy(&(section->buf[section->pos]), buf, len);

(gdb) fr 2
#2  0x0804b21b in main (argc=12, argv=0xbffe8084) at dvbstream.c:683
683       skip = collect_section(&(pmt->section), pusi, b, l);


It looks like the default CFLAGS do some optimisation - let me know if
you need me to recompile it without this.

Cheers,
Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
