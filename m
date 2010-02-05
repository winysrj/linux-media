Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42673 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933852Ab0BEWfd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:35:33 -0500
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from
 same demux (Re: Videotext application crashes the kernel due to DVB-demux
 patch)
From: Chicken Shack <chicken.shack@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <4B6C88AD.4010708@redhat.com>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <4B6C1AF7.2090503@linuxtv.org>
	 <1265397736.6310.98.camel@palomino.walls.org>
	 <4B6C7F1B.7080100@linuxtv.org>  <4B6C88AD.4010708@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 23:32:35 +0100
Message-ID: <1265409155.2692.61.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 05.02.2010, 19:07 -0200 schrieb Mauro Carvalho Chehab:
> Andreas Oberritter wrote:
> > Andy Walls wrote:
> 
> >>> As Honza noted, these ioctls are used by enigma2 and, in general, by
> >>> software running on Dream Multimedia set top boxes.
> >> Right, so reverting the patch is not an option.
> >>
> >> It also makes implementing multiple dvr0.n nodes for a demux0 device
> >> node probably a waste of time at this point.
> > 
> > I think so, too. But I guess it's always worth discussing alternatives.
> 
> If this discussion happened before 2.6.32 release, and provided that a different
> implementation were agreed, things would be easier, as a different solution like
> your proposal could be decided and used.


You cannot expect people reacting immediately if something is wrong.
There are and do exist enormous delays between publishing a new kernel
and the decision to use it after appropriate system or distro update.
So your expectation level is simply wrong.


> Now, we have already a regression on a stable kernel, and solving it by
> creating another regression is not something smart to do.


Yes. Trivial!


> >From what I understood, the regression appeared on an old, orphan
> application with a non-official patch applied on it. Other applications with
> similar features weren't affected. On the other hand, if the patch got reverted, 
> we'll break a maintained application that is used on a great number of devices,
> and whose features depend on the new ioctls.


It's truly amazing how the filter system of your perception works, isn't
it? :)

It's not just "an old, orphaned application with a non-official patch on
it." That's nonsense!

a. As I stated already, there do exist several patched versions of
alevt-dvb. For instance the one that Herman Pitton tested here in public
causes a closed demux device error on my machine. That means that it
does not run because xine-ui is already using the demux device.
And this phenomenon has got nothing to do with the kernel headers!
I've tried all possibilities (old kernel headers and actual ones) so I
know better than Hermann Pitton does!

And my version (and obviously the ones of Thomas Voegtle and Emil Meier
whom I helped with my tip to revert that patch) cause a kernel crash
with the actual kernel.

b. As I also stated already the other teletext application called mtt
does officially not exist except for Novell / OpenSuSe distros (at least
as far as I have seen and found out). And this one
is, as I also stated, not affected by the kernel patch. It's part of a
discontinued program suite called xawtv-4.0 pre with a very complex
infrastructure behind.

Please do not ask me why this one runs without noise - I do not know.

So AFAICS alevt-dvb is the ONLY teletext application for Linux which is
available in almost all Gnu/Linux distros.

"Other applications with similar features weren't affected."

>From where do you know that the features are "similar"?

This is a 100 % phantasy product of your mind that has got nothing to do
with existing reality, man!

Just one example: alevt-dvb has got an excellent html export filter
which makes it possible to export teletext pages as graphical html
files.
I do not know any other teletext application offering that.


> We are too late in -rc cycle, so probably there's not enough time for
> writing, test, validate any new API in time for 2.6.33 and write some compat
> layer to emulate those two ioctls with a different implementation.

Who says that a new API or an overworked API must be ready for 2.6.33?
When do you think the correct starting point must be set?
When the merge window for 2.6.34 opens or when?
Absurd argument! Not valid at all!


> So, removing those two ioctls is not an option anymore.

Yes. Conclusion??? None!

So if everybody wants to close down this discussion with that output
then you must admit (if you want it or not) that you de facto bury
teletext usage in the mud for the majority of Gnu/Linux DVB users.

So the output is more than badly disappointing.
Bye bye Teletext. Nothing for future kernels, huh?

Regards

CS

P. S.: If you continue like that you make people run away.
Instead you better should try to win people, shouldn't you?

Just see how many volunteers are here to help and then reflect
why that manpower is missing, Mauro!
Your gesture being expressed above does a lot, but it is definitely NOT
motivating to change that precarious situation.



