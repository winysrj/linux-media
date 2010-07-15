Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:49121 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab0GOOWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 10:22:18 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Thu, 15 Jul 2010 09:22:06 -0500
Subject: RE: [RFC/PATCH 02/10] media: Media device
Message-ID: <A24693684029E5489D1D202277BE894456775DB7@dlee02.ent.ti.com>
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

Other comment I missed to mention...

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

> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> new file mode 100644
> index 0000000..a4d3db5
> --- /dev/null
> +++ b/drivers/media/media-device.c
> @@ -0,0 +1,77 @@
> +/*
> + *  Media device support.
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
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#include <media/media-device.h>
> +#include <media/media-devnode.h>
> +
> +static const struct media_file_operations media_device_fops = {
> +	.owner = THIS_MODULE,
> +};
> +
> +static void media_device_release(struct media_devnode *mdev)
> +{
> +}
> +
> +/**
> + * media_device_register - register a media device
> + * @mdev:	The media device
> + *
> + * The caller is responsible for initializing the media device before
> + * registration. The following fields must be set:
> + *
> + * - dev should point to the parent device. The field can be NULL when no
> + *   parent device is available (for instance with ISA devices).
> + * - name should be set to the device name. If the name is empty a parent
> + *   device must be set. In that case the name will be set to the parent
> + *   device driver name followed by a space and the parent device name.
> + */
> +int __must_check media_device_register(struct media_device *mdev)
> +{
> +	/* If dev == NULL, then name must be filled in by the caller */
> +	if (mdev->dev == NULL && WARN_ON(!mdev->name[0]))

If mdev == NULL, you'll have a kernel panic here.

Regards,
Sergio

