Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751700Ab0BHNqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 08:46:08 -0500
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux
 filter (Was: Videotext application crashes the kernel due to DVB-demux
 patch)
From: Chicken Shack <chicken.shack@gmx.de>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Andy Walls <awalls@radix.net>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Francesco Lavra <francescolavra@interfree.it>,
	linux-media@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, rms@gnu.org, hermann-pitton@arcor.de
In-Reply-To: <4B700287.5080900@linuxtv.org>
References: <1265546998.9356.4.camel@localhost>
	 <4B6F72E5.3040905@redhat.com>  <4B700287.5080900@linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 14:43:05 +0100
Message-ID: <1265636585.5399.47.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 08.02.2010, 13:24 +0100 schrieb Andreas Oberritter:
> Hello Mauro,
> 
> Mauro Carvalho Chehab wrote:
> > Good catch, but it seems better to initialize both the mutex and the list head
> > at dvb_dmx_dev_init. Please test if the following patch fixes the issue. If so, please
> > sign.
> 
> please apply Francesco's original patch. Yours won't work, because
> "feed" is a union. It must be initialized each time DMX_SET_PES_FILTER
> gets called, because the memory might have been overwritten by a
> previous call to DMX_SET_FILTER, which uses "feed.sec".
> 
> Regards,
> Andreas

Now if I were a cynical or ranter or another kind of dumb primitive
persona non grata I would just add "Lol" or stuff like that and turn
myself away.

But this is no fun here.

It's nothing but a big proof that one Brazilian person in Mr. Torvalds
"dream team of untouchables" needs to be URGENTLY replaced by another
real capable person.

NO IDEA ABOUT DVB ISSUES, BUT DVB MAINTAINER!

This is a SCANDAL, not fun! This is SCANDALOUS!

1. When you start to complain then this moron asks you why you are so
late.
2. Instead of organizing or really trying to win people with the
necessary skills he starts dumbest silliest thinkable flame wars with
people who are not 100 % conform with him. Thus he does not stop the
bleeding and runaway processes of real interested persons who are
urgently needed. On the contrary he accelerates those processes.
3. When the situation was in balance and no help was in sight I decided
to organize help from far outside the list.
I was lucky finding Francesco Lavra. If there hadn't been him, endless
effectless ranting would still be the way to go, and the kernel
regression of a stable kernel would persist (!).
In this situation our Brazilian counterproductive seat farter starts to
demotivate you by: "It's too late to write compat levels now, we're too
late in the release circle and blablablablahhhh Blubblubblubblub.....
Blather blather blather blather.........

4. Before the decisive patch was there our completely incapable
Brazilian spurked out some completely ineffective and silly
pseudo-patches who for each did not even touch the problem.
Thus he did de facto nothing than stealing my time, attacking my humble
nerves. The rule of our Brazilian: Even if I am a moron knowing
absolutely nothing I must PRETEND some brainless activism. So show is
everything, while manpower is being chased away.
Competitive manpower is dangerous for the Brazilian pretender.

5. And when the decisive patch is there he wastes it for a reason that
only he knows. Thanks to Andreas we all know now.

That is exactly what he did with Markus Rechbergers contributions:
He broke them by transforming them in a definitely unqualified manner.
Until Markus ran away. With the effect that the Empia stuff is being
hosted elsewhere now.
Mauro Carvalho Chehab's behaviour and policy is so goddamn dumb,
ineffective, destructive, .....
It is a secure way to put a project finally over the edge which has got
real structural problems ....

I want him to be replaced as soon as possible by a real fair, qualified
and capable person. Every second that one tolerates Mauro Carvalho
Chehab as a common V4l / DVB maintainer is a second of pain and
catastrophe.

I vote for Andy Walls, Devin Heitmueller. There are a couple of capable
candidates here who can really do that job with a better output for the
whole Linux community.
There is ABSOLUTELY NO necessity to continue with Mauro Carvalho Chehab.

I cced all relevant persons. I want Chehab away from here! It's enough
now. My tolerance is at zero. PERIOD!

CS

P. S.: If the RedHat company can afford people like MCC then there is
something wrong with the internal structures of RedHat.


