Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:49591 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbcLGBvI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 20:51:08 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OHS00BT6L4UIF70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2016 10:50:54 +0900 (KST)
Date: Wed, 07 Dec 2016 10:50:54 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] [media] mceusb: LIRC_SET_SEND_CARRIER returns 0 on
 success
Message-id: <20161207015054.sxzzaea5y22nmmau@gangnam.samsung>
References: <CGME20161207000515epcas4p400e7ac17bc7441d9d799d4aa523a5ef9@epcas4p4.samsung.com>
 <1480698974-9093-1-git-send-email-sean@mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1480698974-9093-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Andi Shyti <andi.shyti@samsung.com>

On Fri, Dec 02, 2016 at 05:16:07PM +0000, Sean Young wrote:
> LIRC_SET_SEND_CARRIER ioctl should not return the carrier used, it
> should return 0.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/mceusb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 9bf6917..96b0ade 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -890,7 +890,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
>  			cmdbuf[3] = MCE_IRDATA_TRAILER;
>  			dev_dbg(ir->dev, "disabling carrier modulation");
>  			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> -			return carrier;
> +			return 0;
>  		}
>  
>  		for (prescaler = 0; prescaler < 4; ++prescaler) {
> @@ -904,7 +904,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
>  
>  				/* Transmit new carrier to mce device */
>  				mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> -				return carrier;
> +				return 0;
>  			}
>  		}
>  
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
