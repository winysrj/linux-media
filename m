Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4942 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1E1PYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 11:24:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
Date: Sat, 28 May 2011 17:24:25 +0200
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4DDAC0C2.7090508@redhat.com> <201105260853.31065.hverkuil@xs4all.nl> <4DE0E7D5.9070000@redhat.com>
In-Reply-To: <4DE0E7D5.9070000@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281724.25433.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, May 28, 2011 14:17:25 Mauro Carvalho Chehab wrote:
> Em 26-05-2011 03:53, Hans Verkuil escreveu:
> > On Tuesday, May 24, 2011 16:57:22 Devin Heitmueller wrote:
> >> On Tue, May 24, 2011 at 2:50 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>> On Monday, May 23, 2011 22:17:06 Mauro Carvalho Chehab wrote:
> >>>> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
> >>>> during the weekend, I decided to add alsa support also on xawtv3, basically
> >>>> to provide a real usecase example. Of course, for it to work, it needs the
> >>>> very latest v4l2-utils version from the git tree.
> >>>
> >>> Please, please add at the very least some very big disclaimer in libv4l2util
> >>> that the API/ABI is likely to change. As mentioned earlier, this library is
> >>> undocumented, has not gone through any peer-review, and I am very unhappy with
> >>> it and with the decision (without discussion it seems) to install it.
> >>>
> >>> Once you install it on systems it becomes much harder to change.
> > 
> > I wanted to do a review of this library, but Devin did it for me in his
> > comments below.
> > 
> > I completely agree with his comments.
> > 
> > Once I have all the control framework stuff that is in my queue done, then
> > I want to go through as many drivers as I can and bring them all up to
> > the latest V4L2 standards (using v4l2-compliance to verify correctness).
> > 
> > It is my intention to create some helper functions to implement a MC node for
> > these simple legacy drivers. Eventually all V4L drivers should have a MC node.
> 
> Converting all devices to use MC won't help, as the alsa device is implemented
> on some cases by independent drivers (snd-usb-alsa). As I said before, forcing
> all drivers to implement MC is silly. They just don't need it. Let's focus the MC
> stuff where it really belongs: SoC designs and very complex devices, were you
> should need to know and to change the internal routes and V4L2 API is not enough
> for it.

In general I hate inconsistent behavior between drivers (frankly, it's always
been a significant problem within V4L in particular). So I don't think it is
silly at all to roll out the MC with the V4L subsystem.

> > Writing a library like the one proposed here would then be much easier and
> > it would function as a front-end for the MC.
> 
> The design of the library methods should be independent of MC or sysfs.
> That's what I did: the methods there provide the basic information about
> the media devices without exporting sysfs struct to it.
> 
> Once we have the library stable, it can be extended to also implement
> device discovery via MC (or even using both).

Good.

> Yet, MC is an optional feature, and still not ready to handle inter-subsystem 
> dependencies. 
> 
> As there isn't even a single patch adding MC API for sound or dvb, it is
> clear that it will take at least 2 development kernel cycles (e. g. about
> 6 months) for this to start happening.
> 
> In other words, you're arguing against using what's currently provided by
> the Kernel, on a standard way, in favour of something that will take at
> least 6 months having the basic API added for the other subsystems to be able
> to report their device trees, plus the time to port all drivers to use it.
> This doesn't sound like a good plan to me.

I agree with that.

But I would really like to see an RFC with a proposal of the API and how
it is to be used. Then after an agreement has been reached the library can
be modified accordingly and we can release it.

We want the same thing, but this needs a proper design review if we want
to have applications use this effectively and if it is to be extended to use
the MC.

Regards,

	Hans

> Once having MC completed, an optional extension to the library may allow
> its usage also for MC device info methods, where available at the driver(s).
> 
> > The last few months I wasn't able to really spend the time on V4L that I
> > wanted, but that is changing for the better.
> > 
> > Regards,
> > 
> > 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
