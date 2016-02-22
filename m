Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35699 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbcBVWnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 17:43:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, shuahkh@osg.samsung.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 4/4] media: Move media_get_uptr() macro out of the media.h user space header
Date: Tue, 23 Feb 2016 00:43:46 +0200
Message-ID: <6252005.bajM1HM2dx@avalon>
In-Reply-To: <1456174024-11389-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com> <1456174024-11389-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 22 February 2016 22:47:04 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The media_get_uptr() macro is mostly useful only for the IOCTL handling
> code in media-device.c so move it there.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 5 +++++
>  include/uapi/linux/media.h   | 5 -----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index f001c27..39afba0 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -38,6 +38,11 @@
>   * Userspace API
>   */
> 
> +static inline void __user *media_get_uptr(__u64 arg)
> +{
> +	return (void __user *)(uintptr_t)arg;
> +}
> +
>  static int media_device_open(struct file *filp)
>  {
>  	return 0;
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 65991df..b989494 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -353,11 +353,6 @@ struct media_v2_topology {
>  	__u32 reserved[18];
>  };
> 
> -static inline void __user *media_get_uptr(__u64 arg)
> -{
> -	return (void __user *)(uintptr_t)arg;
> -}
> -
>  /* ioctls */
> 
>  #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct 
media_device_info)

-- 
Regards,

Laurent Pinchart

