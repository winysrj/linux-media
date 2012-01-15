Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2876 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2AONdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 08:33:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [regression] v4l: Add custom compat_ioctl32 operation
Date: Sun, 15 Jan 2012 14:32:52 +0100
Cc: "Oleksij Rempel (Alexey Fisher)" <bug-track@fisher-privat.net>,
	linux-uvc-devel@lists.sourceforge.net,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <4F1297E2.7@fisher-privat.net> <201201151414.14060.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201151414.14060.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201151432.52853.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday, January 15, 2012 14:14:13 Laurent Pinchart wrote:
> Hi Alexey,
> 
> On Sunday 15 January 2012 10:09:54 Oleksij Rempel (Alexey Fisher) wrote:
> > hi Laurent,
> > 
> > this patch seem to create circular module dependency. I get this error:
> > WARNING: Module
> > /lib/modules/3.2.0-00660-g1801bbe-dirty/kernel/drivers/media/video/videodev
> > .ko ignored, due to loop
> > WARNING: Loop detected:
> > /lib/modules/3.2.0-00660-g1801bbe-dirty/kernel/drivers/media/video/v4l2-com
> > pat-ioctl32.ko needs videodev.ko which needs v4l2-compat-ioctl32.ko again!
> 
> Thanks for the report.
> 
> Hans, what do you think about the patch below ?
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 3541388..8c4a94d 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -17,7 +17,7 @@ videodev-objs :=      v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>  
>  obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
>  ifeq ($(CONFIG_COMPAT),y)
> -  obj-$(CONFIG_VIDEO_DEV) += v4l2-compat-ioctl32.o
> +  videodev-objs += v4l2-compat-ioctl32.o
>  endif
>  
>  obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
> 
> I don't see a very compelling reason to put v4l2_compat_ioctl32() in a
> separate module. If that fine with you, I'll also remove the #ifdef
> CONFIG_COMPAT from v4l2-compat-ioctl32.c.

Seems reasonable. Although I suggest that you move up the 'ifeq - endif' part
to right after the 'videodev-objs := ...' line in the makefile. That's more
logical in this case.

Regards,

	Hans

> 
> > commit bf5aa456853816f807a46c0d944efb997142ffaf
> > Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Date:   Mon Dec 19 00:41:19 2011 +0100
> > 
> >     v4l: Add custom compat_ioctl32 operation
> > 
> >     Drivers implementing custom ioctls need to handle 32-bit/64-bit
> >     compatibility themselves. Provide them with a way to do so.
> > 
> >     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >     Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> 
