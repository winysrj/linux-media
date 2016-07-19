Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43609 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbcGSWQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 18:16:12 -0400
Date: Tue, 19 Jul 2016 23:16:10 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 5/7] [media] ir-lirc-codec: do not handle any buffer for
 raw transmitters
Message-ID: <20160719221610.GC24697@gofer.mess.org>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-6-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468943818-26025-6-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 20, 2016 at 12:56:56AM +0900, Andi Shyti wrote:
> Raw transmitters receive the data which need to be sent to
> receivers from userspace as stream of bits, they don't require
> any handling from the lirc framework.

No drivers of type RC_DRIVER_IR_RAW_TX should handle tx just like any
other device, so data should be provided as an array of u32 alternating
pulse-space. If your device does not handle input like that then convert
it into that format in the driver. Every other driver has to do some
sort of conversion of that kind.

Thanks

Sean


> 
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  drivers/media/rc/ir-lirc-codec.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 5effc65..80e94b6 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -121,17 +121,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  	if (!lirc)
>  		return -EFAULT;
>  
> -	if (n < sizeof(unsigned) || n % sizeof(unsigned))
> -		return -EINVAL;
> -
> -	count = n / sizeof(unsigned);
> -	if (count > LIRCBUF_SIZE || count % 2 == 0)
> -		return -EINVAL;
> -
> -	txbuf = memdup_user(buf, n);
> -	if (IS_ERR(txbuf))
> -		return PTR_ERR(txbuf);
> -
>  	dev = lirc->dev;
>  	if (!dev) {
>  		ret = -EFAULT;
> @@ -143,6 +132,25 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  		goto out;
>  	}
>  
> +	if (dev->driver_type == RC_DRIVER_IR_RAW_TX) {
> +		txbuf = memdup_user(buf, n);
> +		if (IS_ERR(txbuf))
> +			return PTR_ERR(txbuf);
> +
> +		return dev->tx_ir(dev, txbuf, n);
> +	}
> +
> +	if (n < sizeof(unsigned) || n % sizeof(unsigned))
> +		return -EINVAL;
> +
> +	count = n / sizeof(unsigned);
> +	if (count > LIRCBUF_SIZE || count % 2 == 0)
> +		return -EINVAL;
> +
> +	txbuf = memdup_user(buf, n);
> +	if (IS_ERR(txbuf))
> +		return PTR_ERR(txbuf);
> +
>  	for (i = 0; i < count; i++) {
>  		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
>  			ret = -EINVAL;
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
