Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53939 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757588AbZJMHiJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 03:38:09 -0400
Date: Tue, 13 Oct 2009 09:37:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] soc-camera: tw9910: Add output signal control
In-Reply-To: <ufx9nkfmj.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0910130834230.5089@axis700.grange>
References: <ufx9nkfmj.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Oct 2009, Kuninori Morimoto wrote:

> tw9910 can control output signal.
> This patch will stop all signal when video was stopped.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |   35 ++++++++++++++++++++++++-----------
>  1 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 5152d56..8bda689 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -152,7 +152,8 @@
>  			 /* 1 : non-auto */
>  #define VSCTL       0x08 /* 1 : Vertical out ctrl by DVALID */
>  			 /* 0 : Vertical out ctrl by HACTIVE and DVALID */
> -#define OEN         0x04 /* Output Enable together with TRI_SEL. */
> +#define OEN         0x00 /* Enable output */
> +#define EN_TRI_SEL  0x04 /* TRI_SEL output */

Is this to tri-state the output? Ok, from the datasheet it tri-states all 
outputs except clocks. My copy of the datasheet is funny at this point. It 
first describes OEN = bit 2 of OPFORM, and then the TRI_SEL field, which 
is said to occupy bits 1-0, but is documented together with bit 2 with 
values 0-7... And you cannot really say that values 0-3 have a feature 
distinguishing them from values 4-7. So, I wouldn't separate OEN and just 
use the bits 2-0 as a single field. And call the required values like

#define OEN_TRI_SEL_ALL_ON	0
#define OEN_TRI_SEL_CLK_ON	4

>  
>  /* OUTCTR1 */
>  #define VSP_LO      0x00 /* 0 : VS pin output polarity is active low */
> @@ -236,7 +237,6 @@ struct tw9910_priv {
>  
>  static const struct regval_list tw9910_default_regs[] =
>  {
> -	{ OPFORM,  0x00 },
>  	{ OUTCTR1, VSP_LO | VSSL_VVALID | HSP_HI | HSSL_HSYNC },
>  	ENDMARKER,
>  };
> @@ -513,19 +513,32 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct tw9910_priv *priv = to_tw9910(client);
> +	u8 val;
>  
> -	if (!enable)
> +	if (!enable) {
> +		switch (priv->rev) {
> +		case 0:
> +			val = EN_TRI_SEL | 0x2;
> +			break;
> +		case 1:
> +			val = EN_TRI_SEL | 0x3;
> +			break;
> +		}
>  		return 0;
> +	} else {

Ok, it's 8:30 here, so, I might be still not quite awake... but I fail to 
understand, why you bother calculating val above if you anyway just return 
immediately without using it? And if that return is misplaced - what are 
those 2 and 3 constants doing?

>  
> -	if (!priv->scale) {
> -		dev_err(&client->dev, "norm select error\n");
> -		return -EPERM;
> +		if (!priv->scale) {
> +			dev_err(&client->dev, "norm select error\n");
> +			return -EPERM;
> +		}
> +
> +		dev_dbg(&client->dev, "%s %dx%d\n",
> +			priv->scale->name,
> +			priv->scale->width,
> +			priv->scale->height);
>  	}
>  
> -	dev_dbg(&client->dev, "%s %dx%d\n",
> -		 priv->scale->name,
> -		 priv->scale->width,
> -		 priv->scale->height);
> +	tw9910_mask_set(client, OPFORM, 0x7, val);

...and you don't get an "uninitialised variable" warning here? I don't see 
where val gets set in the enable case... Please, wake me up if I'm 
dreaming. Oh, I see, you fix it in the next patch. Please, don't do that! 
Don't introduce bugs to fix them in a later patch. Do it here.

>  
>  	return 0;

Yes, tri-stating outputs for switched off streaming is better than doing 
nothing at all, but isn't there anything else that can be safely powered 
down? What about CLK_PDN, Y_PDN and C_PDN in ACNTL? YSV, CSV and PLL_PDN 
in Analog Control II? I would also expect, that we can at least tristate 
all outputs without any problem, we shouldn't need pixel clock running 
with disabled streaming.

>  }
> -- 
> 1.6.0.4

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
