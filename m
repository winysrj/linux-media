Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4917 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2E1LpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 07:45:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve Kconfig selection for media devices
Date: Mon, 28 May 2012 13:45:09 +0200
Cc: Andy Walls <awalls@md.metrocast.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4FC24E34.3000406@redhat.com> <201205281142.20565.hverkuil@xs4all.nl> <4FC35B8E.5060102@redhat.com>
In-Reply-To: <4FC35B8E.5060102@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205281345.09188.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 28 2012 13:03:42 Mauro Carvalho Chehab wrote:
> Em 28-05-2012 06:42, Hans Verkuil escreveu:
> > On Sun May 27 2012 22:15:08 Mauro Carvalho Chehab wrote:

...

> >> 	/dvb-core	- what is already at dvb/dvb-core
> >> 	/frontends	- what is already at dvb/frontends
> >> 	/isa		- all ISA drivers
> >> 	/parport	- all parallel port drivers
> > 
> > I propose to replace /parport with a /others directory for things of which we
> > have only a very few (parport, i2c) or are hard to classify (si470x, vivi,
> > mem2mem_testdev).
> 
> It makes sense to group those drivers that use other buses together.
> However, the term 'other' could have other meanings than "other bus"
> or "other drivers".
> 
> I think "other-bus" could be an appropriate name for that.

OK.

> > /media-core for the media*.c sources.
> 
> 
> "media-core" is a very bad name, as "media" is the name of the subsystem. maybe
> "media-ctrl-core" or something similar.

mc-core?

> 
> >>
> >> After doing that, the Kconfig options at isa, parport, pci, platform and usb
> >> can be optimized further, based on the media support "filters":
> >>
> >> <m>  Multimedia support  --->
> >>     [ ]   Webcams and video grabbers support
> >>     [ ]   Analog TV support
> >>     [ ]   Digital TV support
> >>     [ ]   AM/FM radio receivers/transmitters support
> >>     [ ]   Remote Controller support 
> > 
> > One thing wasn't clear to me: if I have a hybrid device I gathered that it be enabled
> > only if both analog and digital are set, right? But is that also true for radio and RC
> > support? So if I have a card with all of the above, will it be enabled only if I check
> > all four items?
> 
> No.
> 
> The tendency is to break drivers into RC support, analog TV support and DVB support.
> There are several requirements for that, and it actually makes sense to allow disabling
> what's not needed.
> 
> So, the idea here is that, if only analog TV is selected, only the analog part of a board
> will be enabled. For example, if you select only analog TV, this is how the USB menu will
> show, for em28xx:
> 
> --- V4L USB devices
>   *** Webcam and/or TV USB devices ***
>   < >   Empia EM28xx USB video capture support (NEW)
> 
> (em28xx has the RC part and the DTV part as separate Kconfig options)
> 
> Currently, radio will be enabled together with em28xx, but it would be easy to add a logic
> inside em28xx-video to disable radio, if RADIO_SUPPORT is disabled.
> 
> Unfortunately, all hybrid drivers currently require analog TV, although most of them
> implements the analog support on a separate file (foo-video.c). It shouldn't be hard
> and it makes sense to split hybrid drivers into a core driver, an analog driver, rc driver
> and a dvb driver. I don't think it makes sense to split radio into a separate driver,
> but it shouldn't be hard to do that too.

OK, I misunderstood your original description.

> This is actually one of the issues I want to solve: there are several em28xx devices that
> don't support analog TV at all. Yet, V4L2 is not selected, the driver won't even appear
> to the user.
> 
> Of course, just renaming the directories won't help with hybrid cards itself. A further
> work is required on each hybrid drivers.
> 
> > That doesn't really make sense to me. I think the average end-user just cares about the
> > hardware that he wants to enable, and if a hybrid device is selected, then that should
> > select all the various core configs that it needs. Not the other way around.
> 
> We can add an option for "hybrid TV support" that would enable all 4 cores, in order to
> help the average end-user, although I don't think he would have any troubles to understand
> that, if his board has analog TV, digital TV and Remote Controller, that all those 3 options
> need to be selected, for full device support.
> 
> > Another thing: I would move 'video grabber' away from webcams and to 'Analog TV/Video support'.
> > And rename 'Digital TV' to 'Digital TV/Video' as well. A video grabber driver has much more to
> > do with TV then it does with webcams.
> 
> From the Kconfig perspective, the difference between the 3 video categories is that:
> 
> - analog TV: tuner-core is required, and 10 other tuner drivers that are listed inside
>   tuner core;
> 
> - digital TV: tuners are needed, but those are either customised or auto-selected;
> 
> - camera/grabber: no tuner is needed.
> 
> Also, there are several professional camera devices at bttv, cx88, saa7134 and cx25821
> that don't require tuners, and support for them can be compiled without tuner support.
> 
> In other words, a camera driver and a grabber driver are very similar. Of course, a webcam 
> will also require a sensor (on several drivers, the sensor is internal to the driver, so
> no extra modules are needed). Of course, a platform camera driver will also require
> "media controller", "subdev API", but those features are already enabled via other config options.
> 
> So, from tuners' perspective, and from Kconfig's perspective, a video grabber is just 
> like a professional camera driver, a cellphone camera or a webcam driver.

I would never have understood that from the menu names. In particular that 'Analog TV' implies
a tuner. For me it could just as well imply a composite input video grabber.

How about this:

	[ ] Video (aka V4L2) support
	[ ] Digital TV Tuner (aka DVB) support
	[ ] Analog TV Tuner support
	[ ] Radio Tuner/Modulator support
	[ ] Remote Controller support

I didn't like the term 'Webcams and video grabbers' as that description is never 100%.
The help text can clarify this in more detail, of course.

Regards,

	Hans
