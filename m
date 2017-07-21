Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46565 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdGUSWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 14:22:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 5/5] media-device: remove driver_version
Date: Fri, 21 Jul 2017 21:22:32 +0300
Message-ID: <3175888.CNfFgnaNvG@avalon>
In-Reply-To: <20170721105706.40703-6-hverkuil@xs4all.nl>
References: <20170721105706.40703-1-hverkuil@xs4all.nl> <20170721105706.40703-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 21 Jul 2017 12:57:06 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Since the driver_version field in struct media_device is no longer
> used, just remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 3 ---
>  include/media/media-device.h | 2 --
>  2 files changed, 5 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 7ff8e2d5bb07..979e4307d248 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -833,8 +833,6 @@ void media_device_pci_init(struct media_device *mdev,
>  	mdev->hw_revision = (pci_dev->subsystem_vendor << 16)
> 
>  			    | pci_dev->subsystem_device;
> 
> -	mdev->driver_version = LINUX_VERSION_CODE;
> -
>  	media_device_init(mdev);
>  }
>  EXPORT_SYMBOL_GPL(media_device_pci_init);
> @@ -862,7 +860,6 @@ void __media_device_usb_init(struct media_device *mdev,
>  		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
>  	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
>  	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
> -	mdev->driver_version = LINUX_VERSION_CODE;
> 
>  	media_device_init(mdev);
>  }
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 6896266031b9..7d268802cc2e 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -68,7 +68,6 @@ struct media_device_ops {
>   * @serial:	Device serial number (optional)
>   * @bus_info:	Unique and stable device location identifier
>   * @hw_revision: Hardware device revision
> - * @driver_version: Device driver version
>   * @topology_version: Monotonic counter for storing the version of the
> graph *		topology. Should be incremented each time the topology 
changes. *
> @id:		Unique ID used on the last registered graph object
> @@ -134,7 +133,6 @@ struct media_device {
>  	char serial[40];
>  	char bus_info[32];
>  	u32 hw_revision;
> -	u32 driver_version;
> 
>  	u64 topology_version;

-- 
Regards,

Laurent Pinchart
