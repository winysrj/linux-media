Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47814 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1AJKcP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 05:32:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
Date: Mon, 10 Jan 2011 11:33:00 +0100
Cc: Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kassey Li <ygli@marvell.com>, Hans Verkuil <hverkuil@xs4all.nl>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com> <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com> <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101101133.01636.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Monday 10 January 2011 09:20:05 Guennadi Liakhovetski wrote:
> On Sun, 9 Jan 2011, Qing Xu wrote:
> > On Fri, 7 Jan 2011, Guennadi Liakhovetski wrote:
> > > On Fri, 7 Jan 2011, Qing Xu wrote:
> > > > pass VIDIOC_ENUM_FRAMESIZES down to sub device drivers. So far no
> > > > special handling in soc-camera core.
> > > 
> > > Hm, no, guess what? I don't think this can work. The parameter, that
> > > this routine gets from the user struct v4l2_frmsizeenum contains a
> > > member pixel_format, which is a fourcc code. Whereas subdevices don't
> > > deal with them, they deal with mediabus codes. It is the same problem
> > > as with old s/g/try/enum_fmt, which we replaced with respective mbus
> > > variants. So, we either have to add our own .enum_mbus_framesizes
> > > video subdevice operation, or we abuse this one, but interpret the
> > > pixel_format field as a media-bus code.
> > > 
> > > Currently I only see one subdev driver, that implements this API:
> > > ov7670.c, and it just happily ignores the pixel_format altogether...
> > > 
> > > Hans, Laurent, what do you think?
> > > 
> > > In the soc-camera case you will have to use
> > > soc_camera_xlate_by_fourcc() to convert to media-bus code from fourcc.
> > > A nit-pick: please, follow the style of the file, that you patch and
> > > don't add double empty lines between functions.
> > > 
> > > A side question: why do you need this format at all? Is it for some
> > > custom
> > > 
> > > Sorry, I meant to ask - what do you need this operation / ioctl() for?
> > 
> > Before we launch camera application, we will use enum-frame-size ioctl
> > to get all frame size that the sensor supports, and show all options in
> > UI menu, then the customers could choose a size, and tell camera driver.
> 
> And if the camera supports ranges of sizes? Or doesn't implement this
> ioctl() at all? Remember, that this is an optional ioctl(). Would your
> application just fail? Or you could provide a slider to let the user
> select a size from a range, then just issue an s_fmt and use whatever it
> returns... This is something you'd do for a generic application
> 
> > If use mbus structure pass to sensor, we need to modify the second
> > parameter definition, it will contain both mbus code information and
> > width/height ingotmation:
> > int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum
> > *fsize);
> > 
> > or use g_mbus_fmt instead:
> > int (*g_mbus_fmt)(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
> > *fmt); soc_camera_enum_framesizes()
> > {
> > 
> >         ...
> >         return v4l2_subdev_call(sd, video, g_mbus_fmt, fsize);//typo, I
> >         mean "g_mbus_fmt"
> > 
> > }
> > 
> > What do you think?
> 
> In any case therer needs to be a possibility for host drivers to override
> this routine, so, please, do something similar, to what default_g_crop() /
> default_s_crop() / default_cropcap() / default_g_parm() / default_s_parm()
> do: add a host operation and provide a default implementation for it. And
> since noone seems to care enough, I think, we can just abuse struct
> v4l2_frmsizeenum for now, just make sure to rewrite pixel_format to a
> media-bus code, and restore it before returning to the caller.

I like the .enum_mbus_framesizes better, but I could live with a hack until if 
you convert soc_camera to use subdev pad-level operations when the MC will be 
available.

-- 
Regards,

Laurent Pinchart
