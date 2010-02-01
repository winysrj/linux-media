Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50120 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754538Ab0BAOBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 09:01:24 -0500
Subject: Re: Videotext application crashes the kernel due to DVB-demux patch
From: Chicken Shack <chicken.shack@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, Andreas Oberritter <obi@linuxtv.org>
In-Reply-To: <4B66D0D1.5000207@redhat.com>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <4B66D0D1.5000207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 14:59:47 +0100
Message-ID: <1265032787.2143.47.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 01.02.2010, 11:02 -0200 schrieb Mauro Carvalho Chehab:
> Chicken Shack wrote:
> > Hi,
> > 
> > here is a link to a patch which breaks backwards compatibility for a
> > teletext software called alevt-dvb.
> > 
> > http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg04638.html
> > 
> > The kernel patch was introduced with kernel 2.6.32-rc1.
> > It was Signed-off-by Brandon Philips, Mauro Carvalho Chehab and its
> > author, Andreas Oberritter.
> > 
> > Previous help calls, not only on this list, have been ignored for
> > reasons that I do not know.
> > Even distro maintainers have given up and removed the DVB implementation
> > of alevt from their distro list.
> > 
> > Is that really what things are up to?
> > To pull through an API update by kernel patch, but simply dive off with
> > the usual "Sorry, but I don't have no time" when objections or problems
> > arise?
> > 
> > What the hell is going on in those peoples' minds?
> > 
> > It seems to me that the following disclaimer is worth nothing:
> > 
> > "If anyone has any objections, please let us know by sending a message
> > to: Linux Media Mailing List <linux-me...@vger.kernel.org>"
> > 
> > Volunteers welcome! Who please consacres some time and DVB competence to
> > give the appropriate hints please?

Hello Mauro,

> 
> This is the first time I've seen an email about this subject from you
> at the linux-media ML.

A few days ago there has been some Emil Meyer mentioning the same thing
using alevt-dvb in connection with two Hauppauge DVB-T cards.

But you are highly under charge, so you cannot receive anything.

>  Also, I didn't notice any report or patches from distro 
> packagers about a driver issue related to videotext.

I got no answer from Andreas Rottmann yet. He is the Debian maintainer
of the "official" alevt-1.6.2. He spreaded a DVB-patched version under
the roof of Debian.

Concerning Gentoo I read somewhere in the Internet that the Gentoo
maintainer withdrew all DVB patches of alevt with the consequence that
you can only use this "classic" teletext app with analogue cards.

So I do neither exaggerate nor do I lie, OK?

>  Also, there were no reply 
> to the announcement that the patch would be sent upstream (the email you're 
> pointing). Maybe I missed something.

I know that I am a bit late - one point for you, mea culpa. Sorry!

> If you found a bug on a patch that were already applied upstream, the
> better procedure is to fill a bug report at kernel.bugzilla.org. Please
> enclose there the full dmesg output and any other descriptions that may
> help the developers to know what card/driver/application you're using, and
> how to reproduce the bug. The application logs may also be useful, but please
> don't mix it together with the dmesg.

This is too bureaucratic and too official - I prefer the inofficial way,
directly contacting relevant people in relevant forums.
I've been practising that for years now.

> Before reporting the bug, please test the latest stable kernel version (currently 
> 2.6.32.7) first, to be sure that this regression weren't correct yet, or, even
> better, the latest development kernel, since the bug may already be solved.

Peanuts!
I tested the latest v4l HG, and as a kind of normality, I am using the
latest rc candidate being published by Linus.

Normally that "system of early warning" works well, but sometimes you're
missing some things. That's the way it is. Shit happens.

But if too many people dive off with that typical "I do not have any
time left-gesture" then this is sonmething that really frustrates you.

> The latest development kernel is found at the -git tree:
> 	http://git.linuxtv.org/v4l-dvb.git
> 

Guess I will supply the necessary info to Andy. We will see what
happens.

Publically I want to mention the following points:

1. Within the first call of alevt-dvb you do see the printout that I
already integrated in my mail.
2. If you call alevt a second time from the command line after that it
will hang your system so that nothing goes without hard reset.
3. Having a look at the code of alevt-dvb I would say that its
DVB-implementation looks a bit crude to me.
This crudeness shows up in so far that alevt-dvb does not continue
working and does not follow if the DVB channel is being switched by some
external application like kaffeine, xine-ui, mplayer etc.

Instead alevt-dvb hangs and does not accept a normal quit (or call it
normal exit or whatever).
The only ways to get it finished then are:
a. killall -9 alevt	or
b. CTRL-C if you started alevt-dvb from the command line before.

So basically there are two problems to solve:

a. the channel change problem (i. e. NOT accepting a quit if channel is
being changed)
b. the kernel oops due to the new demux design

If both problems are solved I can publish a completely freshed up and
cleaned up version of the protagonist of all teletext programs.
The whole Linux community will be the winner of that.
There will be full analogue and DVB compatibility.

If this is no motivation, then what else is a motivation please?

Regards

CS


