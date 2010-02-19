Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44395 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab0BSWaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 17:30:06 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"iivanov@mm-sol.com" <iivanov@mm-sol.com>,
	"gururaj.nagendra@intel.com" <gururaj.nagendra@intel.com>,
	"david.cohen@nokia.com" <david.cohen@nokia.com>
Date: Fri, 19 Feb 2010 16:29:54 -0600
Subject: RE: [PATCH v5 1/6] V4L: File handles
Message-ID: <A24693684029E5489D1D202277BE894453691587@dlee02.ent.ti.com>
References: <4B7EE4A4.3080202@maxwell.research.nokia.com>
 <1266607320-9974-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1266607320-9974-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heippa!

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Friday, February 19, 2010 1:22 PM
> To: linux-media@vger.kernel.org
> Cc: hverkuil@xs4all.nl; laurent.pinchart@ideasonboard.com; iivanov@mm-
> sol.com; gururaj.nagendra@intel.com; david.cohen@nokia.com; Sakari Ailus
> Subject: [PATCH v5 1/6] V4L: File handles
> 
> This patch adds a list of v4l2_fh structures to every video_device.
> It allows using file handle related information in V4L2. The event
> interface
> is one example of such use.
> 
> Video device drivers should use the v4l2_fh pointer as their
> file->private_data.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/Makefile   |    2 +-
>  drivers/media/video/v4l2-dev.c |    4 ++
>  drivers/media/video/v4l2-fh.c  |   64
> ++++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-dev.h       |    5 +++
>  include/media/v4l2-fh.h        |   42 ++++++++++++++++++++++++++
>  5 files changed, 116 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-fh.c
>  create mode 100644 include/media/v4l2-fh.h
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 5163289..14bf69a 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
> 
>  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
> 
> -videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
> +videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o
> 
>  # V4L2 core modules
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-
> dev.c
> index 7090699..65a7b30 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -421,6 +421,10 @@ static int __video_register_device(struct
> video_device *vdev, int type, int nr,
>  	if (!vdev->release)
>  		return -EINVAL;
> 
> +	/* v4l2_fh support */
> +	spin_lock_init(&vdev->fh_lock);
> +	INIT_LIST_HEAD(&vdev->fh_list);
> +
>  	/* Part 1: check device type */
>  	switch (type) {
>  	case VFL_TYPE_GRABBER:
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> new file mode 100644
> index 0000000..c707930
> --- /dev/null
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -0,0 +1,64 @@
> +/*
> + * drivers/media/video/v4l2-fh.c

[1] AFAIK, putting file paths is frowned upon.

Makes maintenance harder if in the future, this files get moved somewhere else.

> + *
> + * V4L2 file handles.
> + *
> + * Copyright (C) 2009 Nokia Corporation.

[2] Shouldn't it be "(C) 2010" already? :)

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
> +#include <linux/bitops.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +
> +void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
> +{
> +	fh->vdev = vdev;
> +	INIT_LIST_HEAD(&fh->list);
> +	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
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
> +	list_del_init(&fh->list);
> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_del);
> +
> +void v4l2_fh_exit(struct v4l2_fh *fh)
> +{
> +	if (fh->vdev == NULL)
> +		return;
> +
> +	fh->vdev = NULL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fh_exit);
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 2dee938..bebe44b 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -32,6 +32,7 @@ struct v4l2_device;
>     Drivers can clear this flag if they want to block all future
>     device access. It is cleared by video_unregister_device. */
>  #define V4L2_FL_REGISTERED	(0)
> +#define V4L2_FL_USES_V4L2_FH	(1)
> 
>  struct v4l2_file_operations {
>  	struct module *owner;
> @@ -77,6 +78,10 @@ struct video_device
>  	/* attribute to differentiate multiple indices on one physical
> device */
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
> index 0000000..6b486aa
> --- /dev/null
> +++ b/include/media/v4l2-fh.h
> @@ -0,0 +1,42 @@
> +/*
> + * include/media/v4l2-fh.h

Same as [1]

> + *
> + * V4L2 file handle.
> + *
> + * Copyright (C) 2009 Nokia Corporation.

Same as [2]

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
> +#include <linux/list.h>

Shouldn't you add one more header here?:

#include <media/v4l2-dev.h>

(for struct video_device)

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
> +#endif /* V4L2_EVENT_H */

Wrong comment, must have been:

	/* V4L2_FH_H */

Regards,
Sergio
> --
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
