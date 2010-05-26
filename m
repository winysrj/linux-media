Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:56122 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0EZMnR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 08:43:17 -0400
Date: Wed, 26 May 2010 14:43:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v3 1/2] video/saa7134: change dprintk() to i2cdprintk()
Message-ID: <20100526144313.1d15222f@hyperion.delvare>
In-Reply-To: <20100525091816.GA13034@bicker>
References: <20100525091816.GA13034@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Tue, 25 May 2010 11:19:53 +0200, Dan Carpenter wrote:
> The problem is that dprintk() dereferences "dev" which is null here.
> The i2cdprintk() uses "ir" so that's OK.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> v2: Jean Delvare suggested that I use i2cdprintk() instead of modifying
> dprintk().
> v3: V2 had a bonus cleanup that I removed from v3
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

Sorry for noticing only now, but "gir->" in the comment is odd. As seen
in the code above, it's actually "ir->". Maybe you want to fix this, as
you are already touching that line anyway.


Other than this, this patch is:

Acked-by: Jean Delvare <khali@linux-fr.org>

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
> 


-- 
Jean Delvare
