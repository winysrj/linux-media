Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LHdeq-0005N0-LT
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 13:25:13 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1036889ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 04:25:09 -0800 (PST)
Date: Tue, 30 Dec 2008 13:25:02 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <495A06B7.7060506@makhutov.org>
Message-ID: <alpine.DEB.2.00.0812301246050.29535@ybpnyubfg.ybpnyqbznva>
References: <20081227180001.GS12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812300758390.29535@ybpnyubfg.ybpnyqbznva>
	<495A06B7.7060506@makhutov.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compile DVB drivers for kernel 2.6.11
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

On Tue, 30 Dec 2008, Artem Makhutov wrote:

> and also this diff:
> --- s2-liplianin.org/v4l/compat.h       2008-12-27 13:00:38.000000000 +0100

Ah, that's what I was trying to remember --

If you happen to have a snapshot of Markus Rechberger's
mcentral v4l-dvb-kernel before late November, when it
was replaced (due to being misleading and/or obsolete)
with a link to his em28xx source, you should also take
a look at that compat.h file, as it has quite a few
version checks to 2.6.9 and earlier.  That may also be
helpful.

If you don't have this snapshot, I can send you a copy
of this file that I archived.


> Can you send over me the diffs you did?

I'll pack them together and send you a personal mail
with a pointer to them, or an attachment, whatever
fits best...

The kernel panics my code gave me are not a NULL
pointer, but instead, a kernel paging request, that
looks as if it may be related to later-than-2.6.14-
hacks which I merged in.  Actually, there appear to
be several similar panics, as I appear to have been
tweaking the code during these...

I do get a NULL pointer panic from my attempt to
add support for one particular device to the 2.6.14
codebase, that I've tracked to one particular thing
I've been too lazy or preoccupied to finally fix.


(now to see if I can *find* those diffs...)

barry bouwsma
disorganised

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
