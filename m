Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34367 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282Ab0GOOQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 10:16:51 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Thu, 15 Jul 2010 09:16:44 -0500
Subject: RE: [RFC/PATCH 02/10] media: Media device
Message-ID: <A24693684029E5489D1D202277BE894456775DA5@dlee02.ent.ti.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Very minor comment below.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, July 14, 2010 8:30 AM
> To: linux-media@vger.kernel.org
> Cc: sakari.ailus@maxwell.research.nokia.com
> Subject: [RFC/PATCH 02/10] media: Media device
> 
> The media_device structure abstracts functions common to all kind of
> media devices (v4l2, dvb, alsa, ...). It manages media entities and
> offers a userspace API to discover and configure the media device
> internal topology.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/media-framework.txt |   68 ++++++++++++++++++++++++++++++++
>  drivers/media/Makefile            |    2 +-
>  drivers/media/media-device.c      |   77
> +++++++++++++++++++++++++++++++++++++
>  include/media/media-device.h      |   53 +++++++++++++++++++++++++
>  4 files changed, 199 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/media-framework.txt
>  create mode 100644 drivers/media/media-device.c
>  create mode 100644 include/media/media-device.h
>

<snip>

> diff --git a/include/media/media-device.h b/include/media/media-device.h
> new file mode 100644
> index 0000000..6c1fc4a
> --- /dev/null
> +++ b/include/media/media-device.h
> @@ -0,0 +1,53 @@
> +/*
> + *  Media device support header.
> + *
> + *  Copyright (C) 2010  Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> USA
> + */
> +
> +#ifndef _MEDIA_DEVICE_H
> +#define _MEDIA_DEVICE_H
> +
> +#include <linux/device.h>
> +#include <linux/list.h>
> +
> +#include <media/media-devnode.h>
> +
> +/* Each instance of a media device should create the media_device struct,
> + * either stand-alone or embedded in a larger struct.
> + *
> + * It allows easy access to sub-devices (see v4l2-subdev.h) and provides
> + * basic media device-level support.
> + */
> +
> +#define MEDIA_DEVICE_NAME_SIZE (20 + 16)

Where does above numbers come from ??

Regards,
Sergio

> +
> +struct media_device {
> +	/* dev->driver_data points to this struct.
> +	 * Note: dev might be NULL if there is no parent device
> +	 * as is the case with e.g. ISA devices.
> +	 */
> +	struct device *dev;
> +	struct media_devnode devnode;
> +
> +	/* unique device name, by default the driver name + bus ID */
> +	char name[MEDIA_DEVICE_NAME_SIZE];
> +};
> +
> +int __must_check media_device_register(struct media_device *mdev);
> +void media_device_unregister(struct media_device *mdev);
> +
> +#endif
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
