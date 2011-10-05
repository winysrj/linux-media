Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60771 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935269Ab1JEUID (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 16:08:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework and add video format detection
Date: Wed, 5 Oct 2011 22:08:00 +0200
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <201110032344.08963.laurent.pinchart@ideasonboard.com> <4E8A2F76.4020209@infradead.org>
In-Reply-To: <4E8A2F76.4020209@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110052208.00714.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 03 October 2011 23:56:06 Mauro Carvalho Chehab wrote:
> Em 03-10-2011 18:44, Laurent Pinchart escreveu:
> > On Monday 03 October 2011 21:16:45 Mauro Carvalho Chehab wrote:
> >> Em 03-10-2011 08:53, Laurent Pinchart escreveu:
> >>> On Monday 03 October 2011 11:53:44 Javier Martinez Canillas wrote:
> >>> 
> >>> [snip]
> >>> 
> >>>> Laurent, I have a few questions about MCF and the OMAP3ISP driver if
> >>>> you are so kind to answer.
> >>>> 
> >>>> 1- User-space programs that are not MCF aware negotiate the format
> >>>> with the V4L2 device (i.e: OMAP3 ISP CCDC output), which is a sink
> >>>> pad. But the real format is driven by the analog video format in the
> >>>> source pad (i.e: tvp5151).
> >>> 
> >>> That's not different from existing systems using digital sensors, where
> >>> the format is driven by the sensor.
> >>> 
> >>>> I modified the ISP driver to get the data format from the source pad
> >>>> and set the format for each pad on the pipeline accordingly but I've
> >>>> read from the documentation [1] that is not correct to propagate a
> >>>> data format from source pads to sink pads, that the correct thing is
> >>>> to do it from sink to source.
> >>>> 
> >>>> So, in this case an administrator has to externally configure the
> >>>> format for each pad and to guarantee a coherent format on the whole
> >>>> pipeline?.
> >>> 
> >>> That's correct (except you don't need to be an administrator to do so
> >>> 
> >>> :-)).
> >> 
> >> NACK.
> > 
> > Double NACK :-D
> > 
> >> When userspace sends a VIDIOC_S_STD ioctl to the sink node, the subdevs
> >> that are handling the video/audio standard should be changed, in order
> >> to obey the V4L2 ioctl. This is what happens with all other drivers
> >> since the beginning of the V4L1 API. There's no reason to change it,
> >> and such change would be a regression.
> > 
> > The same could have been told for the format API:
> > 
> > "When userspace sends a VIDIOC_S_FMT ioctl to the sink node, the subdevs
> > that are handling the video format should be changed, in order to obey
> > the V4L2 ioctl. This is what happens with all other drivers since the
> > beginning of the V4L1 API. There's no reason to change it, and such
> > change would be a regression."
> > 
> > But we've introduced a pad-level format API. I don't see any reason to
> > treat standard differently.
> 
> Neither do I. The pad-level API should not replace the V4L2 API for
> standard, for controls and/or for format settings.

The pad-level API doesn't replace the V4L2 API, it complements it. I'm of 
course not advocating modifying any driver to replace V4L2 ioctls by direct 
subdev access. However, the pad-level API needs to be exposed to userspace, as 
some harware simply can't be configured through a video node only.

As Hans also mentionned in his reply, the pad-level API is made of two parts: 
an in-kernel API made of subdev operations, and a userspace API accessed 
through ioctls. As the userspace API is needed for some devices, the kernel 
API needs to be implemented by drivers. We should phase out the non pad-level 
format operations in favor of pad-level operations, as the former can be 
implemented using the later. That has absolutely no influence on the userspace 
API.

> >>>> Or does exist a way to do this automatic?. i.e: The output entity on
> >>>> the pipeline promotes the capabilities of the source pad so
> >>>> applications can select a data format and this format gets propagated
> >>>> all over the pipeline from the sink pad to the source?
> >>> 
> >>> It can be automated in userspace (through a libv4l plugin for
> >>> instance), but it's really not the kernel's job to do so.
> >> 
> >> It is a kernel job to handle VIDIOC_S_STD, and not a task to be left to
> >> any userspace plugin.
> > 
> > And VIDIOC_S_FMT is handled by userspace for the OMAP3 ISP today. Why are
> > standards different ?
> 
> All v4l media devices have sub-devices with either tv decoders or sensors
> connected into a sink. The sink implements the /dev/video? node.
> When an ioctl is sent to the v4l node, the sensors/decoders are controlled
> to implement whatever is requested: video standards, formats etc.

But that simply doesn't work out with the OMAP3 ISP or similar hardware. If 
applications only set the format on the video node the driver has no way to 
know how to configure the individual subdevs in the pipeline. When more than a 
handful of subdevs are involved, the approach simply doesn't scale.

On the other hand, when the TV decoder is connected to a bridge that is only 
capable of transferring the data to memory, there is no reason to require 
applications to configure subdevs directly. In that case the bridge driver can 
configure the subdevs itself.

> Changing it would be a major regression. If OMAP3 is not doing the right
> thing, it should be fixed, and not the opposite.
> 
> The MC/subdev API is there to fill the blanks, e. g. to handle cases where
> the same function could be implemented on two different places of the
> pipeline, e. g. when both the sensor and the bridge could do scaling, and
> userspace wants to explicitly use one, or the other, but it were never
> meant to replace the V4L2 functionality.

Isn't that what I've been saying ? :-)

> >>>> [1]: http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
> >>>> 
> >>>> 2- If the application want a different format that the default
> >>>> provided by the tvp5151, (i.e: 720x576 for PAL), where do I have to
> >>>> crop the image? I thought this can be made using the CCDC, copying
> >>>> less lines to memory or the RESIZER if the application wants a bigger
> >>>> image. What is the best approach for this?
> >> 
> >> Not sure if I understood your question, but maybe you're mixing two
> >> different concepts here.
> >> 
> >> If the application wants a different image resolution, it will use
> >> S_FMT. In this case, what userspace expects is that the driver will
> >> scale, if supported, or return -EINVAL otherwise.
> > 
> > With the OMAP3 ISP, which is I believe what Javier was asking about, the
> > application will set the format on the OMAP3 ISP resizer input and output
> > pads to configure scaling.
> 
> The V4L2 API doesn't tell where a function like scaler will be implemented.
> So, it is fine to implement it at tvp5151 or at the omap3 resizer, when a
> V4L2 call is sent.

By rolling a dice ? :-)

> I'm ok if you want to offer the possibility of doing scale on the other
> parts of the pipeline, as a bonus, via the MC/subdev API, but the absolute
> minimum requirement is to implement it via the V4L2 API.

The absolute minimum requirement is to make the driver usable by applications 
using the V4L2 API in a crippled mode with only a subdev of features 
available. For the OMAP3 ISP that means full-size capture, with no scaling.

-- 
Regards,

Laurent Pinchart
