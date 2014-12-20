Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53298 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaLTS4C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 13:56:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, prabhakar.csengg@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/8] media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
Date: Sat, 20 Dec 2014 20:56:03 +0200
Message-ID: <3310198.B0mlSUZJ97@avalon>
In-Reply-To: <54941849.4090608@cisco.com>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <2482917.BOOSdVSKV1@avalon> <54941849.4090608@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 19 December 2014 13:21:29 Hans Verkuil wrote:
> On 12/19/2014 01:18 PM, Laurent Pinchart wrote:
> > On Friday 19 December 2014 12:44:46 Hans Verkuil wrote:
> >> On 12/08/2014 12:38 AM, Laurent Pinchart wrote:
> >>> On Thursday 04 December 2014 10:54:56 Hans Verkuil wrote:
> >>>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> 
> >>>> These drivers depend on VIDEO_V4L2_SUBDEV_API, which in turn
> >>>> depends on MEDIA_CONTROLLER. So it is sufficient to just depend
> >>>> on VIDEO_V4L2_SUBDEV_API.
> >>> 
> >>> Shouldn't the VIDEO_V4L2_SUBDEV_API dependency be dropped from those
> >>> (and other) subdev drivers ? They don't require the userspace API, just
> >>> the kernel part.
> >> 
> >> They set V4L2_SUBDEV_FL_HAS_DEVNODE and use v4l2_subdev_get_try_format,
> >> so they do need VIDEO_V4L2_SUBDEV_API. Or am I missing something?
> > 
> > VIDEO_V4L2_SUBDEV_API was initially designed to cover both the subdev
> > userspace API and the subdev in-kernel pad-level API. Now that the latter
> > has been found useful without the former, I think we should revisit the
> > idea.
> > 
> > Does it still make sense to have a single Kconfig option to cover both
> > concepts ? Should it be kept a-is, split in two, or redefined to cover the
> > userspace API only (with the v4l2_subdev_get_try_* functions being then
> > always available) ? As the idea is to standardize on pad-level operations
> > for in- kernel communication between bridges and subdevs the
> > v4l2_subdev_get_try_* functions will get increasingly used in most (if
> > not all) subdev drivers.
>
> OK, but if you don't mind I would make such changes in a separate patch.

Sure. I sometimes think one step ahead :-) We can certainly fix that in a 
separate patch or patch series.

What's your opinion regarding repurposing or splitting 
CONFIG_VIDEO_V4L2_SUBDEV_API ?

> This patch just removes an obviously superfluous dependency and brings these
> drivers in line with the others.
> 
> Removing it altogether is a separate issue.

-- 
Regards,

Laurent Pinchart

