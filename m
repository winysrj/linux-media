Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:58381 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219Ab0EXSE1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 14:04:27 -0400
Date: Mon, 24 May 2010 20:04:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] video/saa7134: change dprintk() to i2cdprintk()
Message-ID: <20100524200423.537a2895@hyperion.delvare>
In-Reply-To: <20100524155936.GZ22515@bicker>
References: <20100522201535.GI22515@bicker>
	<20100522225921.585b2d72@hyperion.delvare>
	<20100524155936.GZ22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Mon, 24 May 2010 17:59:36 +0200, Dan Carpenter wrote:
> The problem is that dprintk() dereferences "dev" which is null here.
> The i2cdprintk() uses "ir" so that's OK.
> 
> Also removed a duplicated break statement.

Mixing two unrelated fixes in the same patch is a bad idea. Here, the
replacement of dprintk() with i2cdprintk() fixes a potential NULL
pointer dereference, this might be worth backporting to stable kernel
series. The double break, OTOH, can't cause any harm, it's a simple
clean-up. So separate patches would be preferable.

> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> v2: Jean Delvare suggested that I use i2cdprintk() instead of modifying
> dprintk().
> 
> diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
> index e5565e2..7691bf2 100644
> --- a/drivers/media/video/saa7134/saa7134-input.c
> +++ b/drivers/media/video/saa7134/saa7134-input.c
> @@ -141,8 +141,8 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  	struct saa7134_dev *dev = ir->c->adapter->algo_data;
>  
>  	if (dev == NULL) {
> -		dprintk("get_key_flydvb_trio: "
> -			 "gir->c->adapter->algo_data is NULL!\n");
> +		i2cdprintk("get_key_flydvb_trio: "
> +			   "gir->c->adapter->algo_data is NULL!\n");
>  		return -EIO;
>  	}
>  
> @@ -195,8 +195,8 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
>  	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
>  	struct saa7134_dev *dev = ir->c->adapter->algo_data;
>  	if (dev == NULL) {
> -		dprintk("get_key_msi_tvanywhere_plus: "
> -			"gir->c->adapter->algo_data is NULL!\n");
> +		i2cdprintk("get_key_msi_tvanywhere_plus: "
> +			   "gir->c->adapter->algo_data is NULL!\n");
>  		return -EIO;
>  	}
>  
> @@ -815,7 +815,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  		mask_keyup   = 0x020000;
>  		polling      = 50; /* ms */
>  		break;
> -	break;
>  	}
>  	if (NULL == ir_codes) {
>  		printk("%s: Oops: IR config error [card=%d]\n",

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
