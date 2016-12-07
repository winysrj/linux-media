Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50673 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbcLGBvY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 20:51:24 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OHS0319FL5DR260@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2016 10:51:17 +0900 (KST)
Date: Wed, 07 Dec 2016 10:51:17 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] [media] lirc: LIRC_{G,S}ET_SEND_MODE fail if device
 cannot transmit
Message-id: <20161207015117.i2zpy32kqpnpiy4n@gangnam.samsung>
References: <CGME20161207000525epcas1p134509c8dd60d0280bf17a1ebfd86e9e6@epcas1p1.samsung.com>
 <1480698974-9093-3-git-send-email-sean@mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1480698974-9093-3-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Andi Shyti <andi.shyti@samsung.com>

On Fri, Dec 02, 2016 at 05:16:09PM +0000, Sean Young wrote:
> These ioctls should not succeed if the device cannot send. Also make it
> clear that these ioctls should return the lirc mode, although the actual
> value does not change.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/ir-lirc-codec.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index c327730..9e41305 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -204,11 +204,17 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  
>  	/* legacy support */
>  	case LIRC_GET_SEND_MODE:
> -		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
> +		if (!dev->tx_ir)
> +			return -ENOTTY;
> +
> +		val = LIRC_MODE_PULSE;
>  		break;
>  
>  	case LIRC_SET_SEND_MODE:
> -		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
> +		if (!dev->tx_ir)
> +			return -ENOTTY;
> +
> +		if (val != LIRC_MODE_PULSE)
>  			return -EINVAL;
>  		return 0;
>  
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
