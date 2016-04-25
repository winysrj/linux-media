Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53241 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbcDYOUv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 10:20:51 -0400
Subject: Re: [PATCH] [media] au0828: fix double free in au0828_usb_probe()
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1461362707-6883-1-git-send-email-khoroshilov@ispras.ru>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <571E27C1.8020907@osg.samsung.com>
Date: Mon, 25 Apr 2016 08:20:49 -0600
MIME-Version: 1.0
In-Reply-To: <1461362707-6883-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2016 04:05 PM, Alexey Khoroshilov wrote:
> In case of failure au0828_v4l2_device_register() deallocates dev
> and returns error code to au0828_usb_probe(), which also
> calls kfree(dev) on a failure path.
> 
> The patch removes duplicated code from au0828_v4l2_device_register().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

I sent a fix in for this a few weeks ago:

https://lkml.org/lkml/2016/3/28/453

thanks,
-- Shuah

> ---
>  drivers/media/usb/au0828/au0828-video.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 32d7db96479c..7d0ec4cb248c 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -679,8 +679,6 @@ int au0828_v4l2_device_register(struct usb_interface *interface,
>  	if (retval) {
>  		pr_err("%s() v4l2_device_register failed\n",
>  		       __func__);
> -		mutex_unlock(&dev->lock);
> -		kfree(dev);
>  		return retval;
>  	}
>  
> @@ -691,8 +689,6 @@ int au0828_v4l2_device_register(struct usb_interface *interface,
>  	if (retval) {
>  		pr_err("%s() v4l2_ctrl_handler_init failed\n",
>  		       __func__);
> -		mutex_unlock(&dev->lock);
> -		kfree(dev);
>  		return retval;
>  	}
>  	dev->v4l2_dev.ctrl_handler = &dev->v4l2_ctrl_hdl;
> 

