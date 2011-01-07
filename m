Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:60731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AGPLP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 10:11:15 -0500
Date: Fri, 7 Jan 2011 16:11:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kassey Lee <ygli@marvell.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
In-Reply-To: <201101071550.24778.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1101071609250.32550@axis700.grange>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <Pine.LNX.4.64.1101071515410.32550@axis700.grange>
 <201101071550.24778.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 7 Jan 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Friday 07 January 2011 15:37:35 Guennadi Liakhovetski wrote:
> > On Fri, 7 Jan 2011, Qing Xu wrote:
> > > pass VIDIOC_ENUM_FRAMESIZES down to sub device drivers. So far no
> > > special handling in soc-camera core.
> > 
> > Hm, no, guess what? I don't think this can work. The parameter, that this
> > routine gets from the user struct v4l2_frmsizeenum contains a member
> > pixel_format, which is a fourcc code. Whereas subdevices don't deal with
> > them, they deal with mediabus codes. It is the same problem as with old
> > s/g/try/enum_fmt, which we replaced with respective mbus variants. So, we
> > either have to add our own .enum_mbus_framesizes video subdevice
> > operation, or we abuse this one, but interpret the pixel_format field as a
> > media-bus code.
> > 
> > Currently I only see one subdev driver, that implements this API:
> > ov7670.c, and it just happily ignores the pixel_format altogether...
> > 
> > Hans, Laurent, what do you think?
> 
> Use the pad-level subdev operations, they take a media bus code as argument 
> ;-)

Sure, but as you will appreciate, a currently mainlinable solution would 
be preferred. Even if you get MC in next soon enough for 2.6.39, we still 
will need a while to convert soc-camera to it first.

Thanks
Guennadi

> 
> > In the soc-camera case you will have to use soc_camera_xlate_by_fourcc()
> > to convert to media-bus code from fourcc. A nit-pick: please, follow the
> > style of the file, that you patch and don't add double empty lines between
> > functions.
> > 
> > A side question: why do you need this format at all? Is it for some custom
> > application? What is your use-case, that makes try_fmt / s_fmt
> > insufficient for you and how does enum_framesizes help you?
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
