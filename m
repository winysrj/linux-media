Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1999 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbZIJU1N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 16:27:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: RFCv2: Media controller proposal
Date: Thu, 10 Sep 2009 22:27:12 +0200
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200909100913.09065.hverkuil@xs4all.nl> <2830b427fef295eeb166dbd2065392ce.squirrel@webmail.xs4all.nl> <A69FA2915331DC488A831521EAE36FE401550D0691@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401550D0691@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909102227.12340.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 10 September 2009 21:19:25 Karicheri, Muralidharan wrote:
> Hans,
> 
> I haven't gone through the RFC, but thought will respond to the below comment.
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> new phone: 301-407-9583
> Old Phone : 301-515-3736 (will be deprecated)
> email: m-karicheri2@ti.com
> 
> >>>
> >>> I may be mistaken, but I don't believe soundcards have this same
> >>> complexity are media board.
> >>
> >> When I launch alsa-mixer I see 4 input devices where I can select 4
> >> difference sources. This gives 16 combinations which is enough for me to
> >> call it 'complex' .
> >>
> >>>> Could entities not be completely addressed (configuration ioctls)
> >>>> through
> >>>> the mc-node?
> >>>
> >>> Not sure what you mean.
> >>
> >> Instead of having a device node for each entity, the ioctls for each
> >> entities are done on the media controller-node address an entity by ID.
> >
> >I definitely don't want to go there. Use device nodes (video, fb, alsa,
> >dvb, etc) for streaming the actual media as we always did and use the
> >media controller for controlling the board. It keeps everything nicely
> >separate and clean.
> >
> 
> 
> What you mean by controlling the board?

In general: the media controller can do anything except streaming. However,
that is an extreme position and in practice all the usual ioctls should
remain supported by the video device nodes.

> We have currently ported DMxxx VPBE display drivers to 2.6.31 (Not submitted yet to mainline). In our current implementation, the output and standard/mode are controlled through sysfs because it is a common functionality affecting both v4l and FBDev framebuffer devices. Traditional applications such x-windows should be able to stream video/graphics to VPBE output. V4l2 applications should be able to stream video. Both these devices needs to know the display parameters such as frame buffer resolution, field etc that are to be configured in the video or osd layers in VPBE to output frames to the encoder that is driving the output. So to stream, first the output and mode/standard are selected using sysfs command and then the application is started. Following scenarios are supported by VPBE display drivers in our internal release:-
> 
> 1)Traditional FBDev applications (x-window) can be run using OSD device. Allows changing mode/standards at the output using fbset command.
> 
> 2)v4l2 driver doesn't provide s_output/s_std support since it is done through sysfs. 
> 
> 3)Applications that requires to stream both graphics and video to the output uses both FBDev and V4l2 devices. So these application first set the output and mode/standard using sysfs, before doing io operations with these devices.

I don't understand this approach. I'm no expert on the fb API but as far as I
know the V4L2 API allows a lot more precision over the video timings (esp. with
the new API you are working on). Furthermore, I assume it is possible to use
the DMxxx without an OSD, right?

This is very similar to the ivtv and ivtvfb drivers: if the framebuffer is in
use, then you cannot change the output standard (you'll get an EBUSY error)
through a video device node.

That's exactly what you would expect. If the framebuffer isn't used, then you
can just use the normal V4L2 API to change the output standard.

In practice, I think that you can only change the resolution in the FB API.
Not things like the framerate, let alone precise pixelclock, porch and sync
widths.

Much better to let the two cooperate: you can use both APIs, but you can't
change the resolution in the fb if streaming is going on, and you can't
change the output standard of a video device node if that changes the
resolution while the framebuffer is in used.

No need for additional sysfs entries.

> 
> There is an encoder manager to which all available encoders  registers (using internally developed interface) and based on commands received at Fbdev/sysfs interfaces, the current encoder is selected by the encoder manager and current standard is selected. The encoder manager provides API to retrieve current timing information from the current encoder. FBDev and V4L2 drivers uses this API to configure OSD/video layers for streaming.
> 
> As you can see, controlling output/mode is a common function required for both v4l2 and FBDev devices. 
> 
> One way to do this to modify the encoder manager such that it load up the encoder sub devices. This will allow our customers to migrate to this driver on GIT kernel with minimum effort. If v4l2 display bridge driver load up the sub devices, it will make FBDev driver useless unless media controller has some way to handle this scenario. Any idea if media controller RFC address this? I will go over the RFC in details, but if you have a ready answer, let me know.

I don't think this has anything to do with the media controller. It sounds
more like a driver design issue to me.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
