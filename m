Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34514 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbcLGBsU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 20:48:20 -0500
Date: Wed, 07 Dec 2016 10:48:18 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] [media] lirc_dev: LIRC_{G,S}ET_REC_MODE do not work
Message-id: <20161207014818.255ksprmirgadosv@gangnam.samsung>
References: <CGME20161202171619epcas2p223889fd525634a4a5436ba9cf99906a7@epcas2p2.samsung.com>
 <1480698974-9093-2-git-send-email-sean@mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1480698974-9093-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Since "273b902 [media] lirc_dev: use LIRC_CAN_REC() define" these
> ioctls no longer work.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> Cc: Andi Shyti <andi.shyti@samsung.com>
> Cc: <stable@vger.kernel.org> # v4.8+

mmhhh... yes, right! :)

Reviewed-by: Andi Shyti <andi.shyti@samsung.com>

Thanks,
Andi

> ---
>  drivers/media/rc/lirc_dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 3854809..7f5d109 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -582,7 +582,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		result = put_user(ir->d.features, (__u32 __user *)arg);
>  		break;
>  	case LIRC_GET_REC_MODE:
> -		if (LIRC_CAN_REC(ir->d.features)) {
> +		if (!LIRC_CAN_REC(ir->d.features)) {
>  			result = -ENOTTY;
>  			break;
>  		}
> @@ -592,7 +592,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  				  (__u32 __user *)arg);
>  		break;
>  	case LIRC_SET_REC_MODE:
> -		if (LIRC_CAN_REC(ir->d.features)) {
> +		if (!LIRC_CAN_REC(ir->d.features)) {
>  			result = -ENOTTY;
>  			break;
>  		}
> -- 
> 2.9.3
> 
> 
