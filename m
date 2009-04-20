Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:54291 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220AbZDTBjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 21:39:41 -0400
Subject: Re: [linux-dvb] [PATCH] firmware: convert av7110 driver to
	request_firmware()
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-dvb <linux-dvb@linuxtv.org>, VDR User <user.vdr@gmail.com>
In-Reply-To: <28a25ce0904191441h3adc43b3y8265a639e8c025cc@mail.gmail.com>
References: <1214127575.4974.7.camel@jaswinder.satnam>
	 <a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
	 <1240167036.3589.310.camel@macbook.infradead.org>
	 <a3ef07920904191214p7be3a0eem7f7abd91ffb374d2@mail.gmail.com>
	 <1240170449.3589.334.camel@macbook.infradead.org>
	 <a3ef07920904191340x6a4e9c5o5c51fe0169cbddab@mail.gmail.com>
	 <1240174908.3589.387.camel@macbook.infradead.org>
	 <28a25ce0904191441h3adc43b3y8265a639e8c025cc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Apr 2009 03:38:32 +0200
Message-Id: <1240191512.4168.15.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 19.04.2009, 23:41 +0200 schrieb Román: 
> 2009/4/19 David Woodhouse <dwmw2@infradead.org>:
> > On Sun, 2009-04-19 at 13:40 -0700, VDR User wrote:
> >>
> >> To be absolutely clear; users compiling dvb drivers outside of the
> >> kernel should copy v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex to
> >> /lib/firmware/av7110/bootcode.bin correct?
> >
> > Run 'objcopy -Iihex -Obinary bootcode.bin.ihex bootcode.bin' first, then
> > copy the resulting bootcode.bin file to /lib/firmware/av7110/
> >
> 
> That doesn't seem very *obvious* to me, actually.
> After ten year of using gnu/linux, I don't consider myself a newbie,
> but I didn't know what was the purpose of that command (if I ever knew
> it existed). Maybe it's just I never had the need for such a tool.
> 
> > We didn't want to put raw binary files into the kernel source tree so we
> > converted them to a simple hex form instead.
> >
> 
> IMHO that's the right direction.
> 
> > As I said, the makefiles in the kernel tree get this right, and convert
> > them to binary for you and automatically install them. It shouldn't be
> > hard to fix the v4l tree to do it too, but as I also said, I'm not
> > particularly interested in doing that myself.
> >
> > --
> > dwmw2
> >
> 
> Well, VDR *just wanted it fixed*: that's what he asked for in its
> first message on this thread.
> 
> At least, David, you gave some useful information; but I found your
> attitude -and please note I don't want to offend you personally- more
> or less annoying. I don't understand why you said so lightly he was
> trolling, specially when he is a somewhat active participant on this
> list, I know you didn't either, but if I had to say someone was
> trolling in here, you'll be my first candidate. Derek simply pointed
> out a problem on the v4l-dvb tree. I think the most of us don't have
> much time to spend on this kind of volunteer projects, so we should
> avoid wasting it on sterile arguments.
> 
> Once again, excuse me if I did offend you. That was not my intention.
> 
> Regards,
> 
> --
>   Román
> 

giving seemingly the troll then, but asking just some simple questions,
likely already answered over all this years ...

The firmware download for the tda10046 was broken for months, likely
half a year.

Technotrend changed the URL and LifeView disappeared somehow.

Now we have a "fix", Douglas had the fun to promote it.

The firmware versions still differ between revision 20 and 29.

Some OEMs, as far as i can tell, controlled on that other OS, that
firmware updates should only be made on such revisions of the chips
really in need and later ones should not be touched.

This could mean that the flashing itself inherits some known risks only.

For what I have seen so far, it also could be the other way round
sometimes, let the old chips with the old firmware and don't touch them.

How do you know about this?

Related, they get a substantial load on their servers to serve also
cards not even produced by them. Who did ask them to still tolerate this
and how sure you know they deliver the correct stuff, given that
revision 20 and 29 are around for free choice ?

Have there been any tries to ask Philips/NXP what to use on what and can
we be confident that the latest version is always suitable for all stuff
around? I just don't know and have some doubts.

Cheers,
Hermann



