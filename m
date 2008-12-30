Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LHZ3P-0004pX-6c
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 08:30:17 +0100
Received: by ey-out-2122.google.com with SMTP id 25so519944eya.17
	for <linux-dvb@linuxtv.org>; Mon, 29 Dec 2008 23:30:11 -0800 (PST)
Date: Tue, 30 Dec 2008 08:29:56 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <20081227180001.GS12059@titan.makhutov-it.de>
Message-ID: <alpine.DEB.2.00.0812300758390.29535@ybpnyubfg.ybpnyqbznva>
References: <20081227180001.GS12059@titan.makhutov-it.de>
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

On Sat, 27 Dec 2008, Artem Makhutov wrote:

> I would like to compile current dvb-drivers from hg for kernel 2.6.11.12.
> Has somebody experience with this?

I'm running 2.6.14 on my production machine (which may be
a snapshot during the merge window before a 15-rc1 tag was
added -- I still haven't wrapped my brane around all the
details of version numbers, git, makefiles, and all -- in
any case, some .14 checks I have had to bump to .15 to get
the source to compile).

It can be done for .14; of course I get a panic when I use
these modules, or when I try to add later hardware code to
the working .14 source, but that's likely because I've made
more hacks elsewhere that I no longer remember clearly, and
I haven't motivated myself to make things work since then.


Anyway, some time back, there was a change made which
removed support for selected earlier kernels, and you can
do a `hg diff' on your repository to see what those changes
were -- either checking out the revision before that change
and starting with that, or getting all the diffs and re-adding
them to the latest code and seeing how far you can get.

This changeset where the support was removed is 8240.

You can use `hg log' and `hg diff' on selected files to see
if earlier changesets affect support for earlier kernels.
For example, changeset 963 removed 2.4 support.


> The first problem I am running into is that 2.6.11 has no linux/mutex.h.

That's an easy one.  If you would like, I can pack up the
snapshot which I built (a few modules fail to build 'cuz
they are too new and I don't have that hardware) and see
how far you can get with it.

Whether you need special magic to get further towards 2.6.11,
I don't know -- nor can I promise anything about the diffs
I've added.  Like I say, they don't work for me, but they
compile, so hey, job done, get it out the door, ship it


thanks,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
