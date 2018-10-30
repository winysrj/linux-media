Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38234 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbeJaIgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 04:36:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        sakari.ailus@linux.intel.com, afshin.nasser@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/9] media: tvp5150: fix irq_request error path during probe
Date: Wed, 31 Oct 2018 01:21:20 +0200
Message-ID: <1822001.PqOh1AofYR@avalon>
In-Reply-To: <20180918131453.21031-3-m.felsch@pengutronix.de>
References: <20180918131453.21031-1-m.felsch@pengutronix.de> <20180918131453.21031-3-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco,

Thank you for the patch.

On Tuesday, 18 September 2018 16:14:46 EEST Marco Felsch wrote:
> Commit 37c65802e76a ("media: tvp5150: Add sync lock interrupt handling")
> introduced the interrupt handling. But we have to free the
> v4l2_ctrl_handler before we can return the error code.
> 
> Fixes: 37c65802e76a ("media: tvp5150: Add sync lock interrupt handling")
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/tvp5150.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 133073518744..40aaa8ca0b63 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1650,7 +1650,7 @@ static int tvp5150_probe(struct i2c_client *c,
>  						tvp5150_isr, IRQF_TRIGGER_HIGH |
>  						IRQF_ONESHOT, "tvp5150", core);
>  		if (res)
> -			return res;
> +			goto err;
>  	}
> 
>  	res = v4l2_async_register_subdev(sd);

-- 
Regards,

Laurent Pinchart
