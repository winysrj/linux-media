Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:61898 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbeC2Imn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 04:42:43 -0400
Date: Thu, 29 Mar 2018 11:42:40 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv9 PATCH 01/29] v4l2-device.h: always expose mdev
Message-ID: <20180329084239.ac5cvfq7xzjeihal@paasikivi.fi.intel.com>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
 <20180328135030.7116-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328135030.7116-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 28, 2018 at 03:50:02PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The mdev field is only present if CONFIG_MEDIA_CONTROLLER is set.
> But since we will need to pass the media_device to vb2 snd the
> control framework it is very convenient to just make this field
> available all the time. If CONFIG_MEDIA_CONTROLLER is not set,
> then it will just be NULL.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
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

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
