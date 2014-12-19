Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52109 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaLSMSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:18:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/8] media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
Date: Fri, 19 Dec 2014 14:18:54 +0200
Message-ID: <2482917.BOOSdVSKV1@avalon>
In-Reply-To: <54940FAE.1060004@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <14053074.Xr1qj9KfnY@avalon> <54940FAE.1060004@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 19 December 2014 12:44:46 Hans Verkuil wrote:
> On 12/08/2014 12:38 AM, Laurent Pinchart wrote:
> > On Thursday 04 December 2014 10:54:56 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> These drivers depend on VIDEO_V4L2_SUBDEV_API, which in turn
> >> depends on MEDIA_CONTROLLER. So it is sufficient to just depend
> >> on VIDEO_V4L2_SUBDEV_API.
> > 
> > Shouldn't the VIDEO_V4L2_SUBDEV_API dependency be dropped from those (and
> > other) subdev drivers ? They don't require the userspace API, just the
> > kernel part.
> 
> They set V4L2_SUBDEV_FL_HAS_DEVNODE and use v4l2_subdev_get_try_format,
> so they do need VIDEO_V4L2_SUBDEV_API. Or am I missing something?

VIDEO_V4L2_SUBDEV_API was initially designed to cover both the subdev 
userspace API and the subdev in-kernel pad-level API. Now that the latter has 
been found useful without the former, I think we should revisit the idea.

Does it still make sense to have a single Kconfig option to cover both 
concepts ? Should it be kept a-is, split in two, or redefined to cover the 
userspace API only (with the v4l2_subdev_get_try_* functions being then always 
available) ? As the idea is to standardize on pad-level operations for in-
kernel communication between bridges and subdevs the v4l2_subdev_get_try_* 
functions will get increasingly used in most (if not all) subdev drivers.

-- 
Regards,

Laurent Pinchart

