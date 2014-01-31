Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3862 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaAaPhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 10:37:40 -0500
Message-ID: <52EBC33C.6050902@xs4all.nl>
Date: Fri, 31 Jan 2014 16:37:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: subdev: Allow 32-bit compat IOCTLs
References: <1391182129-5234-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1391182129-5234-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Sorry, this isn't right.

It should go through v4l2_compat_ioctl32, otherwise ioctls for e.g. extended controls
won't be converted correctly.

In addition, v4l2_compat_ioctl32 needs to list all the subdev-specific ioctls.

I'd have sworn I did that once, but I've no idea what happened to that patch...

Regards,

	Hans

On 01/31/2014 04:28 PM, Sakari Ailus wrote:
> I thought this was already working but apparently not. Allow 32-bit compat
> IOCTLs on 64-bit systems.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 996c248..99c54f4 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -389,6 +389,9 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
>  	.owner = THIS_MODULE,
>  	.open = subdev_open,
>  	.unlocked_ioctl = subdev_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl32 = subdev_ioctl,
> +#endif /* CONFIG_COMPAT */
>  	.release = subdev_close,
>  	.poll = subdev_poll,
>  };
> 
