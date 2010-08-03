Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57850 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab0HCJWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 05:22:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v3 06/10] media: Entities, pads and links enumeration
Date: Tue, 3 Aug 2010 11:22:54 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008021635.57216.laurent.pinchart@ideasonboard.com> <201008022301.55396.hverkuil@xs4all.nl>
In-Reply-To: <201008022301.55396.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008031122.55036.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 02 August 2010 23:01:55 Hans Verkuil wrote:
> On Monday 02 August 2010 16:35:54 Laurent Pinchart wrote:
> > On Sunday 01 August 2010 13:58:20 Hans Verkuil wrote:
> > > On Thursday 29 July 2010 18:06:39 Laurent Pinchart wrote:
> > [snip]
> > 
> > > For subdevs you want to return a chip ident and revision field (same as
> > > VIDIOC_DBG_G_CHIP_IDENT does).
> > 
> > Do we still need a chip ID when we now have a name ? Keeping the chip ID
> > registry updated is painful, it would be nice if we could do away with
> > it.
> 
> It's not that easy I think. The name of the subdev entity is set by the
> host (bridge) driver

Is it ? It should be set by the subdev driver.

> and that doesn't know the exact chip ID. E.g. the audio msp3400 subdev
> driver actually supports dozens of msp variants. Knowing which variant it is
> may actually be important information on an embedded system.
> 
> Note also that the chip ID is optional: it is only required when using the
> debug ioctls to get/set registers and to obtain the chip ident.
> 
> > A revision field is a very good idea, I'll add it.
> > 
> > > Should we allow (possibly optional) names for pads? Or 'tooltip'-type
> > > descriptions that can be a lot longer than 32 chars? (Just
> > > brainstorming here).
> > > 
> > > I am of course thinking of apps where the user can setup the media flow
> > > using a GUI. If the driver can provide more extensive descriptions of
> > > the various entities/pads, then that would make it much easier for the
> > > user to experiment.
> > 
> > It would be nice to have, yes. Some kind of pad capabilities would be
> > interesting too.
> 
> What sort of caps do you have in mind?

I'm not sure yet. Maybe the kind of media streams the pad supports, things 
like that.

> > > Note that I also think that obtaining such detailed information might
> > > be better done through separate ioctls (e.g. MEDIA_IOC_G_PAD_INFO,
> > > etc.).
> > 
> > I agree. So we can leave the additional pad information out for now and
> > add it later if needed :-)
> > 
> > > What is definitely missing and *must* be added is a QUERYCAP type ioctl
> > > that provides driver/versioning info.
> > 
> > I'll create one.
> > 
> > > Another thing that we need to figure out is how to tell the application
> > > which audio and video nodes belong together.
> > 
> > What about adding a group ID field in media_entity ?
> 
> It's a possibility, but it's always a bit of a hassle in an application to
> work with group IDs. I wonder if there is a more elegant method.

The problem is a bit broader than just showing relationships between video 
nodes and ALSA devices. We also need to show relationships between lens/flash 
controllers and sensors for instance. Group IDs sound easy, but I'm open to 
suggestions.

> > > Not only that, but we need to be able to inform the driver how audio is
> > > hooked up: through an audio loopback cable, an alsa device,
> > 
> > Doesn't the loopback cable connect the audio signal to audio hardware
> > that exposes an ALSA device ? How will drivers be able to tell if the
> > user has connected a loopback cable and what he has connected it to ?
> 
> If the audio is passed out from the card through a loopback cable, then the
> application knows that it has to ask the user for the alsa device. It is
> obviously impossible to know in advance which alsa device the card is
> hooked up to.
> 
> > > part of an mpeg stream,
> > 
> > In that case there will be no audio device.
> > 
> > > or as a V4L2 audio device (ivtv can do that, and I think pvrusb2 does
> > > the same for radio). I'm not entirely sure we want to expose that last
> > > option as it is not really spec compliant.
> > 
> > I'm not sure either :-) Why doesn't ivtv use an ALSA device ?
> 
> With earlier firmwares the audio was out of sync with the video so you
> needed timestamps to sync them up. And alsa didn't (and doesn't) support
> this.

Still not ? :-S

> > > Other things we may want to expose: is the video stream raw or
> > > compressed?
> > 
> > I think that belongs to V4L2.
> 
> V4L2 has something along these lines: VIDIOC_ENUM_FMT can set a COMPRESSED
> flag when enumerating formats. After thinking about this a bit more I've
> come to the conclusion that for now at least we should keep this in V4L2.

OK.

> > > What are the default video/audio/vbi streams? (That allows an app to
> > > find the default video device node if a driver has lots of them).
> > 
> > What about adding a __u32 flags field to media_entity, and defining a
> > MEDIA_ENTITY_FLAG_DEFAULT bit ?
> 
> I had the same idea. Not just useful for alsa, v4l and dvb nodes, but also
> for IR inputs. We should look at IR as well: it is nice if you can easily
> discover the IR input associated with the board.

So a default flag sounds good.

> > > Some of this information should perhaps be exposed through the v4l2
> > > API, but other parts definitely belong here.
> > > 
> > > I've not thought about this in detail, but we need to set some time
> > > aside to brainstorm on how to provide this information in a logical
> > > and consistent manner.
> > 
> > IRC ? A real meeting would be better, but the next scheduled one is in
> > November and that's a bit too far away.
> 
> If there is enough to discuss, then an interim meeting might well be
> useful.

Anther crazy idea: reporting physical location information for subdevs, such 
as "this sensor is located on the back of the case" or "this sensor faces the 
user".

Some brainstorming is indeed needed.

-- 
Regards,

Laurent Pinchart
