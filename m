Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47074 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1JCVoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 17:44:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework and add video format detection
Date: Mon, 3 Oct 2011 23:44:08 +0200
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <201110031353.29910.laurent.pinchart@ideasonboard.com> <4E8A0A1D.8060501@infradead.org>
In-Reply-To: <4E8A0A1D.8060501@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110032344.08963.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 03 October 2011 21:16:45 Mauro Carvalho Chehab wrote:
> Em 03-10-2011 08:53, Laurent Pinchart escreveu:
> > On Monday 03 October 2011 11:53:44 Javier Martinez Canillas wrote:
> > 
> > [snip]
> > 
> >> Laurent, I have a few questions about MCF and the OMAP3ISP driver if
> >> you are so kind to answer.
> >> 
> >> 1- User-space programs that are not MCF aware negotiate the format
> >> with the V4L2 device (i.e: OMAP3 ISP CCDC output), which is a sink
> >> pad. But the real format is driven by the analog video format in the
> >> source pad (i.e: tvp5151).
> > 
> > That's not different from existing systems using digital sensors, where
> > the format is driven by the sensor.
> > 
> >> I modified the ISP driver to get the data format from the source pad
> >> and set the format for each pad on the pipeline accordingly but I've
> >> read from the documentation [1] that is not correct to propagate a
> >> data format from source pads to sink pads, that the correct thing is
> >> to do it from sink to source.
> >> 
> >> So, in this case an administrator has to externally configure the
> >> format for each pad and to guarantee a coherent format on the whole
> >> pipeline?.
> > 
> > That's correct (except you don't need to be an administrator to do so
> > :-)).
> 
> NACK.

Double NACK :-D

> When userspace sends a VIDIOC_S_STD ioctl to the sink node, the subdevs
> that are handling the video/audio standard should be changed, in order to
> obey the V4L2 ioctl. This is what happens with all other drivers since the
> beginning of the V4L1 API. There's no reason to change it, and such change
> would be a regression.

The same could have been told for the format API:

"When userspace sends a VIDIOC_S_FMT ioctl to the sink node, the subdevs that 
are handling the video format should be changed, in order to obey the V4L2 
ioctl. This is what happens with all other drivers since the beginning of the 
V4L1 API. There's no reason to change it, and such change would be a 
regression."

But we've introduced a pad-level format API. I don't see any reason to treat 
standard differently.

> >> Or does exist a way to do this automatic?. i.e: The output entity on the
> >> pipeline promotes the capabilities of the source pad so applications can
> >> select a data format and this format gets propagated all over the
> >> pipeline from the sink pad to the source?
> > 
> > It can be automated in userspace (through a libv4l plugin for instance),
> > but it's really not the kernel's job to do so.
> 
> It is a kernel job to handle VIDIOC_S_STD, and not a task to be left to any
> userspace plugin.

And VIDIOC_S_FMT is handled by userspace for the OMAP3 ISP today. Why are 
standards different ?

> >> [1]: http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
> >> 
> >> 2- If the application want a different format that the default
> >> provided by the tvp5151, (i.e: 720x576 for PAL), where do I have to
> >> crop the image? I thought this can be made using the CCDC, copying
> >> less lines to memory or the RESIZER if the application wants a bigger
> >> image. What is the best approach for this?
> 
> Not sure if I understood your question, but maybe you're mixing two
> different concepts here.
> 
> If the application wants a different image resolution, it will use S_FMT.
> In this case, what userspace expects is that the driver will scale,
> if supported, or return -EINVAL otherwise.

With the OMAP3 ISP, which is I believe what Javier was asking about, the 
application will set the format on the OMAP3 ISP resizer input and output pads 
to configure scaling.

> Cropping should be done via S_CROP (or, after accepted upstream, via the
> S_SELECTION ioctl).
> 
> > Cropping can be done in the resizer, and I will soon post patches that
> > add cropping support in the preview engine (although that will be
> > useless for the TVP5151, as the preview engine doesn't support YUV
> > data). The CCDC supports cropping too, but that's not implemented in the
> > driver yet.
> > 
> >> 3- When using embedded sync, CCDC doesn't have an external vertical
> >> sync signal, so we have to manually configure when we want the VD0
> >> interrupt to raise. This works for progressive frames, since each
> >> frame has the same size but in the case of interlaced video,
> >> sub-frames have different sizes (i.e: 313 and 312 vertical lines for
> >> PAL).
> >> 
> >> What I did is to reconfigure the CCDC on the VD1 interrupt handler,
> >> but I think this is more a hack than a clean solution. What do you
> >> think is the best approach to solve this?
> > 
> > I *really* wish the CCDC had an end of frame interrupt :-( I'm not sure
> > if there's a non-hackish solution to this.

-- 
Regards,

Laurent Pinchart
