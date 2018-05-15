Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33773 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752448AbeEOO22 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 10:28:28 -0400
Subject: Re: [PATCH] [Patch v2] usbtv: Fix refcounting mixup
To: Oliver Neukum <oneukum@suse.com>, mchehab@s-opensource.com,
        ben.hutchings@codethink.co.uk, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20180515130744.19342-1-oneukum@suse.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <85dd974b-c251-47a5-600d-77b009e2dfcd@xs4all.nl>
Date: Tue, 15 May 2018 16:28:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180515130744.19342-1-oneukum@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/18 15:07, Oliver Neukum wrote:
> The premature free in the error path is blocked by V4L
> refcounting, not USB refcounting. Thanks to
> Ben Hutchings for review.
> 
> [v2] corrected attributions
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Fixes: 50e704453553 ("media: usbtv: prevent double free in error case")
> CC: stable@vger.kernel.org
> Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
> ---
>  drivers/media/usb/usbtv/usbtv-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
> index 5095c380b2c1..4a03c4d66314 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -113,7 +113,8 @@ static int usbtv_probe(struct usb_interface *intf,
>  
>  usbtv_audio_fail:
>  	/* we must not free at this point */
> -	usb_get_dev(usbtv->udev);
> +	v4l2_device_get(&usbtv->v4l2_dev);

This is very confusing. I think it is much better to move the
v4l2_device_register() call from usbtv_video_init to this probe function.

The extra v4l2_device_get in the probe() can just be dropped and
usbtv_video_free() no longer needs to call v4l2_device_put().

The only place you need a v4l2_device_put() is in the disconnect()
function at the end.

Regards,

	Hans

> +	/* this will undo the v4l2_device_get() */
>  	usbtv_video_free(usbtv);
>  
>  usbtv_video_fail:
> 
