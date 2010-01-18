Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4240 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0ARMc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 07:32:29 -0500
Date: Mon, 18 Jan 2010 13:32:18 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com
Subject: Re: [RFC v2 1/7] V4L: File handles
In-Reply-To: <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Message-ID: <alpine.LNX.2.01.1001181330300.31857@alastor>
References: <4B30F713.8070004@maxwell.research.nokia.com> <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I should have reviewed this weeks ago, but better late than never...

On Tue, 22 Dec 2009, Sakari Ailus wrote:

> This patch adds a list of v4l2_fh structures to every video_device.
> It allows using file handle related information in V4L2. The event interface
> is one example of such use.
>
> Video device drivers should use the v4l2_fh pointer as their
> file->private_data.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
> drivers/media/video/Makefile   |    2 +-
> drivers/media/video/v4l2-dev.c |    2 +
> drivers/media/video/v4l2-fh.c  |   57 ++++++++++++++++++++++++++++++++++++++++
> include/media/v4l2-dev.h       |    4 +++
> include/media/v4l2-fh.h        |   41 ++++++++++++++++++++++++++++
> 5 files changed, 105 insertions(+), 1 deletions(-)
> create mode 100644 drivers/media/video/v4l2-fh.c
> create mode 100644 include/media/v4l2-fh.h
>
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index a61e3f3..1947146 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
>
> omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
>
> -videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
> +videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o
>
> # V4L2 core modules
>
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 7090699..15b2ac8 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -421,6 +421,8 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
> 	if (!vdev->release)
> 		return -EINVAL;
>
> +	v4l2_fh_init(vdev);
> +
> 	/* Part 1: check device type */
> 	switch (type) {
> 	case VFL_TYPE_GRABBER:
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> new file mode 100644
> index 0000000..406e4ac
> --- /dev/null
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -0,0 +1,57 @@
> +/*
> + * drivers/media/video/v4l2-fh.c
> + *
> + * V4L2 file handles.
> + *
> + * Copyright (C) 2009 Nokia Corporation.
> + *
> + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +
> +#include <linux/sched.h>
> +#include <linux/vmalloc.h>

Weird includes. I would expect to see only spinlock.h and list.h to be included
here.

Regards,

         Hans

> +
> +int v4l2_fh_add(struct video_device *vdev, struct v4l2_fh *fh)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vdev->fh_lock, flags);
> +	list_add(&fh->list, &vdev->fh);
> +	spin_unlock_irqrestore(&vdev->fh_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_add);
> +
> +void v4l2_fh_del(struct video_device *vdev, struct v4l2_fh *fh)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vdev->fh_lock, flags);
> +	list_del(&fh->list);
> +	spin_unlock_irqrestore(&vdev->fh_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_del);
> +
> +void v4l2_fh_init(struct video_device *vdev)
> +{
> +	spin_lock_init(&vdev->fh_lock);
> +	INIT_LIST_HEAD(&vdev->fh);
> +}
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 2dee938..8eac93d 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -16,6 +16,8 @@
> #include <linux/mutex.h>
> #include <linux/videodev2.h>
>
> +#include <media/v4l2-fh.h>
> +
> #define VIDEO_MAJOR	81
>
> #define VFL_TYPE_GRABBER	0
> @@ -77,6 +79,8 @@ struct video_device
> 	/* attribute to differentiate multiple indices on one physical device */
> 	int index;
>
> +	spinlock_t fh_lock;		/* Lock for file handle list */
> +	struct list_head fh;		/* File handle list */
> 	int debug;			/* Activates debug level*/
>
> 	/* Video standard vars */
> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> new file mode 100644
> index 0000000..1efa916
> --- /dev/null
> +++ b/include/media/v4l2-fh.h
> @@ -0,0 +1,41 @@
> +/*
> + * include/media/v4l2-fh.h
> + *
> + * V4L2 file handle.
> + *
> + * Copyright (C) 2009 Nokia Corporation.
> + *
> + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#ifndef V4L2_FH_H
> +#define V4L2_FH_H
> +
> +#include <linux/types.h>
> +#include <linux/list.h>
> +
> +struct v4l2_fh {
> +	struct list_head	list;
> +};
> +
> +struct video_device;
> +
> +int v4l2_fh_add(struct video_device *vdev, struct v4l2_fh *fh);
> +void v4l2_fh_del(struct video_device *vdev, struct v4l2_fh *fh);
> +void v4l2_fh_init(struct video_device *vdev);
> +
> +#endif /* V4L2_EVENT_H */
> -- 
> 1.5.6.5
>
