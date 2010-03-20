Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1091 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0CTMh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 08:37:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Chicken Shack <chicken.shack@gmx.de>
Subject: Re: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert apps.
Date: Sat, 20 Mar 2010 13:37:03 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <201003201021.05426.hverkuil@xs4all.nl> <1269087435.2568.14.camel@brian.bconsult.de>
In-Reply-To: <1269087435.2568.14.camel@brian.bconsult.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003201337.03741.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 March 2010 13:17:15 Chicken Shack wrote:
> Am Samstag, den 20.03.2010, 10:21 +0100 schrieb Hans Verkuil:
> > Hi all!
> > 
> > The second phase that needs to be done to remove the v4l1 support from the
> > kernel is that libv4l1 should replace the v4l1-compat code from the kernel.
> > 
> > I do not know how complete the libv4l1 code is right now. I would like to
> > know in particular whether the VIDIOCGMBUF/mmap behavior can be faked in
> > libv4l1 if drivers do not support the cgmbuf vidioc call.
> > 
> > In principle libv4l1 should allow V4L1 apps to run fine with V4L2 drivers.
> > That will also solve the problem of embedded device vendors running new
> > kernels with old V4L1 applications. They just need to use libv4l1.
> > 
> > The third phase that can be done in parallel is to convert V4L1-only apps.
> > I strongly suspect that any apps that are V4L1-only are also unmaintained.
> > We have discussed before that we should set up git repositories for such
> > tools (xawtv being one of the more prominent apps since it contains several
> > v4l1-only console apps). Once we have maintainership, then we can convert
> > these tools to v4l2 and distros and other interested parties have a place
> > to send patches to.
> > 
> > I'm afraid that it is unlikely that anyone will do that work for us, so it's
> > probably best just to bite the bullet and do it ourselves.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> 
> Hello Hans,
> 
> I haven't followed your discussion so far (sorry!).
> I got a trivial question:
> 
> I run a Miro PCTV pro (stereo) on one of my machines.
> It needs "simple tuner transport" / "TDA 9885/6/7 analog IF
> demodulator", Micronas msp3400 for Stereo tone PLUS v4l1 compat layer as
> kernel options to run / to be usable at all.

That's the V4L2 bttv driver. What app are you using with this card?

> 
> Can you make sure that this card will still be usable after your v4l1
> removal activities are finished?

You can easily test this by turning off the compat layer in the kernel
config. You should still be able to use your v4l1 app by using LD_PRELOAD=/usr/lib/v4l1compat.so.

> 
> In other words: What happens to this v4l1 compat code which is obviously
> necessary for this (and other) card(s) to run?
> 
> That's it what I haven't understood right now, so could you please be
> kind enough to explain that with a couple of words?
> 
> Thanks!
> 
> CS
> 
> P. S.: If you make your decision to host xawtv and other apps please do
> not merge hybrid applications (i. e. apps made for DVB and analogue
> devices) as you can find them in the xawtv 4.0 pre alpha code for
> example in analogue trees.
> Rather establish extra trees for hybrid applications please.

These apps will each get their own tree.

Regards,

	Hans

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
