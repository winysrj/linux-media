Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37590 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab0GRPc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 11:32:27 -0400
Received: by bwz1 with SMTP id 1so1902746bwz.19
        for <linux-media@vger.kernel.org>; Sun, 18 Jul 2010 08:32:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Sun, 18 Jul 2010 11:32:24 -0400
Message-ID: <AANLkTik7SaoJftra3bAUlp3AJhM4KD91w9uCOUz1xG7b@mail.gmail.com>
Subject: Re: [RFC/PATCH 02/10] media: Media device
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> +++ b/Documentation/media-framework.txt
> @@ -0,0 +1,68 @@
> +Linux kernel media framework
> +============================
> +
<snip>

I felt more details needed in this media-framework.txt for information
such as which driver call this
register() /unregister() function, details on link management etc. I
have not seen other patches yet.
If it is discussed elsewhere, please ignore this. For the first part
of the question, will the v4l2 core
calls this for video devices drivers? For other drivers such as audio,
IR etc which are related to
the video devices, how this is handled. I think such details are
required in this documentation.

> +       /* If dev == NULL, then name must be filled in by the caller */
> +       if (mdev->dev == NULL && WARN_ON(!mdev->name[0]))
> +               return 0;
> +
> +       /* Set name to driver name + device name if it is empty. */
> +       if (!mdev->name[0])
> +               snprintf(mdev->name, sizeof(mdev->name), "%s %s",
> +                       mdev->dev->driver->name, dev_name(mdev->dev));
> +
> +       /* Register the device node. */
> +       mdev->devnode.fops = &media_device_fops;
> +       mdev->devnode.parent = mdev->dev;
> +       strlcpy(mdev->devnode.name, mdev->name, sizeof(mdev->devnode.name));
> +       mdev->devnode.release = media_device_release;
> +       return media_devnode_register(&mdev->devnode, MEDIA_TYPE_DEVICE);
> +}
> +EXPORT_SYMBOL_GPL(media_device_register);
> +
> +/**
> + * media_device_unregister - unregister a media device
> + * @mdev:      The media device
> + *
> + */
> +void media_device_unregister(struct media_device *mdev)
> +{
> +       media_devnode_unregister(&mdev->devnode);
> +}
> +EXPORT_SYMBOL_GPL(media_device_unregister);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> new file mode 100644
> index 0000000..6c1fc4a
> --- /dev/null
> +++ b/include/media/media-device.h
> @@ -0,0 +1,53 @@
> +/*
> + *  Media device support header.
> + *
> + *  Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
> +
> +struct media_device {
> +       /* dev->driver_data points to this struct.
> +        * Note: dev might be NULL if there is no parent device
> +        * as is the case with e.g. ISA devices.
> +        */
> +       struct device *dev;
> +       struct media_devnode devnode;
> +
> +       /* unique device name, by default the driver name + bus ID */
> +       char name[MEDIA_DEVICE_NAME_SIZE];
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
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Murali Karicheri
mkaricheri@gmail.com
