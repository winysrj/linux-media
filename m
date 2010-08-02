Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:55690 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0HBOgC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 10:36:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v3 06/10] media: Entities, pads and links enumeration
Date: Mon, 2 Aug 2010 16:35:54 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <1280419616-7658-7-git-send-email-laurent.pinchart@ideasonboard.com> <201008011358.20459.hverkuil@xs4all.nl>
In-Reply-To: <201008011358.20459.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008021635.57216.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 01 August 2010 13:58:20 Hans Verkuil wrote:
> On Thursday 29 July 2010 18:06:39 Laurent Pinchart wrote:

[snip]

> > diff --git a/Documentation/media-framework.txt
> > b/Documentation/media-framework.txt index 6d680c6..1192feb 100644
> > --- a/Documentation/media-framework.txt
> > +++ b/Documentation/media-framework.txt
> > @@ -273,3 +273,134 @@ required, drivers don't need to provide a set_power

[snip]

> > +- struct media_entity_desc
> > +
> > +__u32	id		Entity id, set by the application. When the id is
> > +			or'ed with MEDIA_ENTITY_ID_FLAG_NEXT, the driver
> > +			clears the flag and returns the first entity with a
> > +			larger id.
> > +char	name[32]	Entity name. UTF-8 NULL-terminated string.
> > +__u32	type		Entity type.
> > +__u8	pads		Number of pads.
> 
> Should be u16.

Thanks. Will fix.

[snip]

> > diff --git a/include/linux/media.h b/include/linux/media.h
> > new file mode 100644
> > index 0000000..9b8acc0
> > --- /dev/null
> > +++ b/include/linux/media.h
> > @@ -0,0 +1,77 @@

[snip]

> > +struct media_entity_desc {
> > +	__u32 id;
> > +	char name[32];
> > +	__u32 type;
> > +	__u8 pads;
> 
> u16.

Thanks. Will fix.

[snip]

> 
> > +	__u32 links;
> > +
> > +	__u32 reserved[4];
> > +
> > +	union {
> > +		/* Node specifications */
> > +		struct {
> > +			__u32 major;
> > +			__u32 minor;
> > +		} v4l;
> > +		struct {
> > +			__u32 major;
> > +			__u32 minor;
> > +		} fb;
> > +		int alsa;
> > +		int dvb;
> > +
> > +		/* Sub-device specifications */
> > +		/* Nothing needed yet */
> > +		__u8 raw[64];
> > +	};
> > +};
> 
> Would there be anything else that we want to describe with these pad_desc
> and entity_desc structs?

Definitely. Thanks for reminding me :-)

> For subdevs you want to return a chip ident and revision field (same as
> VIDIOC_DBG_G_CHIP_IDENT does).

Do we still need a chip ID when we now have a name ? Keeping the chip ID 
registry updated is painful, it would be nice if we could do away with it.

A revision field is a very good idea, I'll add it.

> Should we allow (possibly optional) names for pads? Or 'tooltip'-type
> descriptions that can be a lot longer than 32 chars? (Just brainstorming
> here).
>
> I am of course thinking of apps where the user can setup the media flow
> using a GUI. If the driver can provide more extensive descriptions of the
> various entities/pads, then that would make it much easier for the user to
> experiment.

It would be nice to have, yes. Some kind of pad capabilities would be 
interesting too.

> Note that I also think that obtaining such detailed information might be
> better done through separate ioctls (e.g. MEDIA_IOC_G_PAD_INFO, etc.).

I agree. So we can leave the additional pad information out for now and add it 
later if needed :-)
 
> What is definitely missing and *must* be added is a QUERYCAP type ioctl
> that provides driver/versioning info.

I'll create one.

> Another thing that we need to figure out is how to tell the application
> which audio and video nodes belong together.

What about adding a group ID field in media_entity ?

> Not only that, but we need to be able to inform the driver how audio is
> hooked up: through an audio loopback cable, an alsa device,

Doesn't the loopback cable connect the audio signal to audio hardware that 
exposes an ALSA device ? How will drivers be able to tell if the user has 
connected a loopback cable and what he has connected it to ?

> part of an mpeg stream,

In that case there will be no audio device.

> or as a V4L2 audio device (ivtv can do that, and I think pvrusb2 does the
> same for radio). I'm not entirely sure we want to expose that last option as
> it is not really spec compliant.

I'm not sure either :-) Why doesn't ivtv use an ALSA device ?

> Other things we may want to expose: is the video stream raw or compressed?

I think that belongs to V4L2.

> What are the default video/audio/vbi streams? (That allows an app to find
> the default video device node if a driver has lots of them).

What about adding a __u32 flags field to media_entity, and defining a 
MEDIA_ENTITY_FLAG_DEFAULT bit ?

> Some of this information should perhaps be exposed through the v4l2 API,
> but other parts definitely belong here.
> 
> I've not thought about this in detail, but we need to set some time aside
> to brainstorm on how to provide this information in a logical and
> consistent manner.

IRC ? A real meeting would be better, but the next scheduled one is in 
November and that's a bit too far away.

-- 
Regards,

Laurent Pinchart
