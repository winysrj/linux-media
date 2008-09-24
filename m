Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KiLcB-0001ym-BC
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 06:04:37 +0200
Received: by ey-out-2122.google.com with SMTP id 25so672506eya.17
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 21:04:31 -0700 (PDT)
Date: Wed, 24 Sep 2008 06:00:45 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Kristiadi Himawan <kristiadi.himawan@gmail.com>
In-Reply-To: <8bc341120809231934i3607900dy6456edee75ccd0d7@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809240542470.27597@ybpnyubfg.ybpnyqbznva>
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<200809240236.15144.janne-dvb@grunau.be>
	<d9def9db0809231755g4f97bdc8r846e40476ca2cd99@mail.gmail.com>
	<200809240404.45959.janne-dvb@grunau.be>
	<8bc341120809231934i3607900dy6456edee75ccd0d7@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
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

On Wed, 24 Sep 2008, Kristiadi Himawan wrote:

> I want to buy DVB S2 card for my Freebsd machine, does anyone know which
> card that already supported for Freebsd.

First of all, you are likely to get a better answer to your
question from the FreeBSD mailing list dedicated to multimedia
support at <multimedia@freebsd.org>, as this list is primarily
focused on Linux (which differs greatly from FreeBSD) or the
Linux-DVB API.

The Linux-DVB and Video4Linux APIen have not, to my knowledge,
been ported to FreeBSD.  The latter API has in fact been merged
into the NetBSD-current tree, and work on the former is underway
but has not yet been merged, so that there can be in-kernel
support at some later time in at least NetBSD, with the 
possibility of merging that into the other BSDen.

Thus any FreeBSD support now will be out-of-kernel, and in fact,
there was mention on the freebsd-multimedia@ list just a few
weeks ago on support for devices based on the CX2388x cards --
search for
Message-ID: <8103ad500809070610k24a0c3c0m981a0c0a82e392d8@mail.gmail.com>
posted on 07.September of this year, for an actual list of
devices which should be supported as well as a report on the
actual status of the support (I haven't looked for any later
messages than this from that week, though).  Apart from this,
supported devices are likely to be few and far between.


If this has not answered your question, then please redirect
it to the appropriate FreeBSD mailing list(s) to get a correct
and up-to-date response that is more relevant to your OS...


thanks,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
