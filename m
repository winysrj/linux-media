Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1582 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab0BMNI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 08:08:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v4 1/7] V4L: File handles
Date: Sat, 13 Feb 2010 14:10:51 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
References: <4B72C965.7040204@maxwell.research.nokia.com> <1265813889-17847-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265813889-17847-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002131410.51165.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 February 2010 15:58:03 Sakari Ailus wrote:
> This patch adds a list of v4l2_fh structures to every video_device.
> It allows using file handle related information in V4L2. The event interface
> is one example of such use.
> 
> Video device drivers should use the v4l2_fh pointer as their
> file->private_data.

See small review comment below.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/Makefile   |    3 +-
>  drivers/media/video/v4l2-dev.c |    2 +
>  drivers/media/video/v4l2-fh.c  |   65 ++++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-dev.h       |    6 ++++
>  include/media/v4l2-fh.h        |   47 +++++++++++++++++++++++++++++
>  5 files changed, 122 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-fh.c
>  create mode 100644 include/media/v4l2-fh.h
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 6e75647..b888ad1 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -10,7 +10,8 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
>  
>  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
>  
> -videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-subdev.o
> +videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-subdev.o \
> +			v4l2-fh.o
>  
>  # V4L2 core modules
>  
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 13a899d..c24c832 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -423,6 +423,8 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
>  	if (!vdev->release)
>  		return -EINVAL;
>  
> +	v4l2_fhs_init(vdev);
> +
>  	/* Part 1: check device type */
>  	switch (type) {
>  	case VFL_TYPE_GRABBER:
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> new file mode 100644
> index 0000000..3c1cea2
> --- /dev/null
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -0,0 +1,65 @@
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
> +void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
> +{
> +	fh->vdev = vdev;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_init);
> +
> +void v4l2_fh_add(struct v4l2_fh *fh)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> +	list_add(&fh->list, &fh->vdev->fh_list);
> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_add);
> +
> +void v4l2_fh_del(struct v4l2_fh *fh)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> +	list_del(&fh->list);
> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_del);
> +
> +void v4l2_fh_exit(struct v4l2_fh *fh)
> +{
> +	BUG_ON(fh->vdev == NULL);
> +	fh->vdev = NULL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_exit);
> +
> +void v4l2_fhs_init(struct video_device *vdev)
> +{
> +	spin_lock_init(&vdev->fh_lock);
> +	INIT_LIST_HEAD(&vdev->fh_list);
> +}

Move the contents of this function to __video_register_device. I do not see
any particular need to have a separate function here.

> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 26d4e79..ee3a0c9 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -18,6 +18,8 @@
>  
>  #include <media/media-entity.h>
>  
> +#include <media/v4l2-fh.h>
> +
>  #define VIDEO_MAJOR	81
>  
>  #define VFL_TYPE_GRABBER	0
> @@ -82,6 +84,10 @@ struct video_device
>  	/* attribute to differentiate multiple indices on one physical device */
>  	int index;
>  
> +	/* V4L2 file handles */
> +	spinlock_t		fh_lock; /* Lock for all v4l2_fhs */
> +	struct list_head	fh_list; /* List of struct v4l2_fh */
> +
>  	int debug;			/* Activates debug level*/
>  
>  	/* Video standard vars */
> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> new file mode 100644
> index 0000000..2e88031
> --- /dev/null
> +++ b/include/media/v4l2-fh.h
> @@ -0,0 +1,47 @@
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
> +#include <asm/atomic.h>
> +
> +struct video_device;
> +
> +struct v4l2_fh {
> +	struct list_head	list;
> +	struct video_device	*vdev;
> +};
> +
> +void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
> +void v4l2_fh_add(struct v4l2_fh *fh);
> +void v4l2_fh_del(struct v4l2_fh *fh);
> +void v4l2_fh_exit(struct v4l2_fh *fh);
> +
> +void v4l2_fhs_init(struct video_device *vdev);
> +
> +#endif /* V4L2_EVENT_H */
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
