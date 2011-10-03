Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47043 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab1JCVjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 17:39:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework and add video format detection
Date: Mon, 3 Oct 2011 23:39:31 +0200
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <CAAwP0s0bTcUPvkVT-aB2EKskS_60CdW4P3orQLvSJMMkEWBpqw@mail.gmail.com> <4E8A07A6.3030600@infradead.org>
In-Reply-To: <4E8A07A6.3030600@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110032339.31549.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 03 October 2011 21:06:14 Mauro Carvalho Chehab wrote:
> Em 03-10-2011 06:53, Javier Martinez Canillas escreveu:
> > On Mon, Oct 3, 2011 at 10:39 AM, Laurent Pinchart wrote:
> >> On Monday 03 October 2011 08:30:25 Hans Verkuil wrote:
> >>> On Monday, October 03, 2011 04:17:06 Mauro Carvalho Chehab wrote:
> >>>> Em 02-10-2011 18:18, Javier Martinez Canillas escreveu:
> >>>>> On Sun, Oct 2, 2011 at 6:30 PM, Sakari Ailus wrote:
> >> [snip]
> >> 
> >>>>>>>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
> >>>>>>>  
> >>>>>>>       .s_routing = tvp5150_s_routing,
> >>>>>>> 
> >>>>>>> +     .s_stream = tvp515x_s_stream,
> >>>>>>> +     .enum_mbus_fmt = tvp515x_enum_mbus_fmt,
> >>>>>>> +     .g_mbus_fmt = tvp515x_mbus_fmt,
> >>>>>>> +     .try_mbus_fmt = tvp515x_mbus_fmt,
> >>>>>>> +     .s_mbus_fmt = tvp515x_mbus_fmt,
> >>>>>>> +     .g_parm = tvp515x_g_parm,
> >>>>>>> +     .s_parm = tvp515x_s_parm,
> >>>>>>> +     .s_std_output = tvp5150_s_std,
> >>>>>> 
> >>>>>> Do we really need both video and pad format ops?
> >>>>> 
> >>>>> Good question, I don't know. Can this device be used as a standalone
> >>>>> v4l2 device? Or is supposed to always be a part of a video streaming
> >>>>> pipeline as a sub-device with a source pad? Sorry if my questions are
> >>>>> silly but as I stated before, I'm a newbie with v4l2 and MCF.
> >>>> 
> >>>> The tvp5150 driver is used on some em28xx devices. It is nice to add
> >>>> auto-detection code to the driver, but converting it to the media bus
> >>>> should be done with enough care to not break support for the existing
> >>>> devices.
> >>> 
> >>> So in other words, the tvp5150 driver needs both pad and non-pad ops.
> >>> Eventually all non-pad variants in subdev drivers should be replaced by
> >>> the pad variants so you don't have duplication of ops. But that will
> >>> take a lot more work.
> >> 
> >> What about replacing direct calls to non-pad operations with core V4L2
> >> functions that would use the subdev non-pad operation if available, and
> >> emulate if with the pad operation otherwise ? I think this would ease
> >> the transition, as subdev drivers could be ported to pad operations
> >> without worrying about the bridges that use them, and bridge drivers
> >> could be switched to the new wrappers with a simple search and replace.
> > 
> > Ok, that is a good solution. I'll do that. Implement V4L2 core
> > operations as wrappers of the subdev pad operations.
> 
> As I said, I can't see _any_ reason why setting a format would be needed
> at pad level. Patches shouldn't increase driver/core and userspace
> complexity for nothing.

Sorry ? We already have format setting at the pad level, and that's used by 
drivers and applications. It's one key feature of the V4L2/MC API.

-- 
Regards,

Laurent Pinchart
