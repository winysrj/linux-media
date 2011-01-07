Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40605 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1AGOtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 09:49:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
Date: Fri, 7 Jan 2011 15:50:24 +0100
Cc: Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kassey Lee <ygli@marvell.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com> <Pine.LNX.4.64.1101071515410.32550@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101071515410.32550@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071550.24778.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Friday 07 January 2011 15:37:35 Guennadi Liakhovetski wrote:
> On Fri, 7 Jan 2011, Qing Xu wrote:
> > pass VIDIOC_ENUM_FRAMESIZES down to sub device drivers. So far no
> > special handling in soc-camera core.
> 
> Hm, no, guess what? I don't think this can work. The parameter, that this
> routine gets from the user struct v4l2_frmsizeenum contains a member
> pixel_format, which is a fourcc code. Whereas subdevices don't deal with
> them, they deal with mediabus codes. It is the same problem as with old
> s/g/try/enum_fmt, which we replaced with respective mbus variants. So, we
> either have to add our own .enum_mbus_framesizes video subdevice
> operation, or we abuse this one, but interpret the pixel_format field as a
> media-bus code.
> 
> Currently I only see one subdev driver, that implements this API:
> ov7670.c, and it just happily ignores the pixel_format altogether...
> 
> Hans, Laurent, what do you think?

Use the pad-level subdev operations, they take a media bus code as argument 
;-)

> In the soc-camera case you will have to use soc_camera_xlate_by_fourcc()
> to convert to media-bus code from fourcc. A nit-pick: please, follow the
> style of the file, that you patch and don't add double empty lines between
> functions.
> 
> A side question: why do you need this format at all? Is it for some custom
> application? What is your use-case, that makes try_fmt / s_fmt
> insufficient for you and how does enum_framesizes help you?

-- 
Regards,

Laurent Pinchart
