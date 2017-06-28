Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:35925 "EHLO
        bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbdF1Ogv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 10:36:51 -0400
Date: Wed, 28 Jun 2017 07:36:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robb Glasser <rglasser@google.com>
Subject: Re: [media] uvcvideo: Prevent heap overflow in uvc driver
Message-ID: <20170628143643.GA30654@roeck-us.net>
References: <1495482484-32125-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495482484-32125-1-git-send-email-linux@roeck-us.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 22, 2017 at 12:48:04PM -0700, Guenter Roeck wrote:
> From: Robb Glasser <rglasser@google.com>
> 
> The size of uvc_control_mapping is user controlled leading to a
> potential heap overflow in the uvc driver. This adds a check to verify
> the user provided size fits within the bounds of the defined buffer
> size.
> 
> Signed-off-by: Robb Glasser <rglasser@google.com>
> [groeck: cherry picked from
>  https://source.codeaurora.org/quic/la/kernel/msm-3.10
>  commit b7b99e55bc7770187913ed092990852ea52d7892;
>  updated subject]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Fixes CVE-2017-0627.
> 
Please do not apply this patch. It is buggy.

Guenter

>  drivers/media/usb/uvc/uvc_ctrl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index c2ee6e39fd0c..252ab991396f 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1992,6 +1992,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
>  	if (!found)
>  		return -ENOENT;
>  
> +	if (ctrl->info.size < mapping->size)
> +		return -EINVAL;
> +
>  	if (mutex_lock_interruptible(&chain->ctrl_mutex))
>  		return -ERESTARTSYS;
>  
