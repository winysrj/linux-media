Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA2AdtAU011244
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 05:39:55 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nA2AdgFf025911
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 05:39:43 -0500
Date: Mon, 2 Nov 2009 11:39:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ud441wrdl.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911021128160.19246@axis700.grange>
References: <ud441wrdl.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 2/4] soc-camera: tw9910: Add power control
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, 2 Nov 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |   31 +++++++++++++++++++++++++++----
>  1 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index a0b5bbe..8debcd6 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -152,7 +152,9 @@
>  			 /* 1 : non-auto */
>  #define VSCTL       0x08 /* 1 : Vertical out ctrl by DVALID */
>  			 /* 0 : Vertical out ctrl by HACTIVE and DVALID */
> -#define OEN         0x04 /* Output Enable together with TRI_SEL. */
> +#define OEN_TRI_SEL_ALL_ON 0x00 /* Enable output */
> +#define OEN_TRI_SEL_CLK_ON 0x04 /* TRI_SEL output */

You don't seem to use the OEN_TRI_SEL_CLK_ON macro. Didn't you want to 
tristate pins when inactive?

> +

Why an extra empty line?

>  
>  /* OUTCTR1 */
>  #define VSP_LO      0x00 /* 0 : VS pin output polarity is active low */
> @@ -178,6 +180,12 @@
>  			  * but all register content remain unchanged.
>  			  * This bit is self-resetting.
>  			  */
> +#define CLK_PDN    0x08 /* clock power down */

Hopefully, switching clock off doesn't destroy register content?

> +#define Y_PDN      0x04 /* Luma ADC power down */
> +#define C_PDN      0x02 /* Chroma ADC power down */
> +
> +/* ACNTL2 */
> +#define PLL_PDN    0x40 /* PLL power down */
>  
>  /* VBICNTL */
>  
> @@ -236,7 +244,6 @@ struct tw9910_priv {
>  
>  static const struct regval_list tw9910_default_regs[] =
>  {
> -	{ OPFORM,  0x00 },
>  	{ OUTCTR1, VSP_LO | VSSL_VVALID | HSP_HI | HSSL_HSYNC },
>  	ENDMARKER,
>  };
> @@ -471,10 +478,24 @@ static int tw9910_mask_set(struct i2c_client *client, u8 command,
>  
>  static void tw9910_reset(struct i2c_client *client)
>  {
> -	i2c_smbus_write_byte_data(client, ACNTL1, SRESET);
> +	tw9910_mask_set(client, ACNTL1, SRESET, SRESET);
>  	msleep(1);
>  }
>  
> +static void tw9910_power(struct i2c_client *client, int enable)
> +{
> +	u8 acntl1 = 0;
> +	u8 acntl2 = 0;
> +
> +	if (!enable) {
> +		acntl1 = CLK_PDN | Y_PDN | C_PDN;
> +		acntl2 = PLL_PDN;
> +	}
> +
> +	tw9910_mask_set(client, ACNTL1, 0x0e, acntl1);
> +	tw9910_mask_set(client, ACNTL2, 0x40, acntl2);
> +}
> +
>  static const struct tw9910_scale_ctrl*
>  tw9910_select_norm(struct soc_camera_device *icd, u32 width, u32 height)
>  {
> @@ -514,6 +535,8 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
>  	struct i2c_client *client = sd->priv;
>  	struct tw9910_priv *priv = to_tw9910(client);
>  
> +	tw9910_power(client, enable);
> +

I think you should check the return code here, at least for the stream-on 
case. You shouldn't return success if register accesses failed.

>  	if (!enable)
>  		return 0;
>  
> @@ -527,7 +550,7 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
>  		 priv->scale->width,
>  		 priv->scale->height);
>  
> -	return 0;
> +	return tw9910_mask_set(client, OPFORM, 0x7, OEN_TRI_SEL_ALL_ON);
>  }
>  
>  static int tw9910_set_bus_param(struct soc_camera_device *icd,
> -- 
> 1.6.0.4
> 

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
