Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:53255 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbZHMNrb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 09:47:31 -0400
Message-ID: <4A841969.9050209@zerezo.com>
Date: Thu, 13 Aug 2009 15:47:21 +0200
From: Antoine Jacquet <royale@zerezo.com>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] zr364: wrong indexes
References: <4A8151A1.2020103@gmail.com>
In-Reply-To: <4A8151A1.2020103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

You are right, thanks for fixing this bug.
I have pushed your patch to my tree.

Best regards,

Antoine


Roel Kluin wrote:
> The order of indexes is reversed
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Right?
> 
> diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
> index fc976f4..2622a6e 100644
> --- a/drivers/media/video/zr364xx.c
> +++ b/drivers/media/video/zr364xx.c
> @@ -695,7 +695,7 @@ static int zr364xx_release(struct file *file)
>  	for (i = 0; i < 2; i++) {
>  		err =
>  		    send_control_msg(udev, 1, init[cam->method][i].value,
> -				     0, init[i][cam->method].bytes,
> +				     0, init[cam->method][i].bytes,
>  				     init[cam->method][i].size);
>  		if (err < 0) {
>  			dev_err(&udev->dev, "error during release sequence\n");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

