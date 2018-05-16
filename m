Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55986 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751859AbeEPDkY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 23:40:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 01/28] v4l2-device.h: always expose mdev
Date: Wed, 16 May 2018 06:40:43 +0300
Message-ID: <8283804.eRl6xko2oE@avalon>
In-Reply-To: <20180503145318.128315-2-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl> <20180503145318.128315-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday, 3 May 2018 17:52:51 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The mdev field is only present if CONFIG_MEDIA_CONTROLLER is set.
> But since we will need to pass the media_device to vb2 and the
> control framework it is very convenient to just make this field
> available all the time. If CONFIG_MEDIA_CONTROLLER is not set,
> then it will just be NULL.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/media/v4l2-device.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 0c9e4da55499..b330e4a08a6b 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -33,7 +33,7 @@ struct v4l2_ctrl_handler;
>   * struct v4l2_device - main struct to for V4L2 device drivers
>   *
>   * @dev: pointer to struct device.
> - * @mdev: pointer to struct media_device
> + * @mdev: pointer to struct media_device, may be NULL.
>   * @subdevs: used to keep track of the registered subdevs
>   * @lock: lock this struct; can be used by the driver as well
>   *	if this struct is embedded into a larger struct.
> @@ -58,9 +58,7 @@ struct v4l2_ctrl_handler;
>   */
>  struct v4l2_device {
>  	struct device *dev;
> -#if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_device *mdev;
> -#endif
>  	struct list_head subdevs;
>  	spinlock_t lock;
>  	char name[V4L2_DEVICE_NAME_SIZE];


-- 
Regards,

Laurent Pinchart
