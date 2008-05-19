Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1Jy4ht-0002Lg-2r
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 14:43:16 +0200
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp02.msg.oleane.net (MTA) with ESMTP id m4JCh9Q4030204
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 14:43:09 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 19 May 2008 14:43:09 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAhauPQoA2x0i56RbawkCZWgEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <3cc3561f0805190426m5b7dce4bxfed33ad9f5d1339@mail.gmail.com>
Subject: [linux-dvb] RE :  RE : inserting user PIDs in TS
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

> I am not sure that I agreen on having to modify PCR even if you add
> data to the mux. Every service has it's own PCR, If you add a new pid
> without PCR, then you just have to increase output datarate
> accordingly.

You are right in general, but not quite in the precise values.

> As long as the PCR leaves the muxing software at the same
> time as it would do without injecting the pid,

This is simply quite impossible to acheive, unless you exactly add
a fixed number of packets between *each* original packet. If you
leave two consecutive original packets together and insert a new
packet between two original packets (P1 P2 P3 => P1 P2 Pnew P3),
you introduce PCR jitter.

A PCR value is precise to the bit.

Inserting a packet means inserting many bits (188*8). In an existing
PID, you will find PCR's in, say, packets Px, Py and Pz. These packets
are not necessarily equally spaced in the TS. During your muxing
operation, you will add, say, 1 packet between Px and Py and 2 (or zero)
packets between Py and Pz. Thus, some PCR's become wrong.

> there should be no
> difference at the receiving end.

Remember that the PCR's represent a "system clock", not a program
clock (which is implemented by DTS and PTS). PCR's are used as system
clock reference by the receiving STB. They must be extremely precise.

Usually, the PCR's are restamped by a hardware oscillator at the output
of the MUX and even sometimes restamped inside the modulator itself.

Of course, if the TS is used in a software codec running as a PC
application, PCR jitter is harmless since the system clock of the
rendering engine is likely to be the PC system clock, not the PCR's.
STB are different.

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
