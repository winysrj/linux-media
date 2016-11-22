Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40011 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754873AbcKVKAn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 05:00:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
Subject: Re: [RFC v4 06/21] media device: Drop nop release callback
Date: Tue, 22 Nov 2016 12:01:01 +0200
Message-ID: <2283286.8W48oKEDB3@avalon>
In-Reply-To: <1478613330-24691-6-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com> <1478613330-24691-6-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 08 Nov 2016 15:55:15 Sakari Ailus wrote:
> The release callback is only used to print a debug message. Drop it. (It
> will be re-introduced later in a different form.)
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index a9d543f..a31329d 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -540,11 +540,6 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
>   * Registration/unregistration
>   */
> 
> -static void media_device_release(struct media_devnode *devnode)
> -{
> -	dev_dbg(devnode->parent, "Media device released\n");
> -}
> -
>  /**
>   * media_device_register_entity - Register an entity with a media device
>   * @mdev:	The media device
> @@ -706,7 +701,6 @@ int __must_check __media_device_register(struct
> media_device *mdev, /* Register the device node. */
>  	mdev->devnode.fops = &media_device_fops;
>  	mdev->devnode.parent = mdev->dev;
> -	mdev->devnode.release = media_device_release;
> 
>  	/* Set version 0 to indicate user-space that the graph is static */
>  	mdev->topology_version = 0;

-- 
Regards,

Laurent Pinchart

