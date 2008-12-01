Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1DT48o016078
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 08:29:05 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB1DSqY4030613
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 08:28:52 -0500
Date: Mon, 1 Dec 2008 14:29:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <u8wr019p0.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812011425190.3915@axis700.grange>
References: <u8wr019p0.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/2] Change device ID selection method on ov772x driver
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

On Mon, 1 Dec 2008, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Sorry, I am afraid, we have to iterate it once more, or at least you have 
to persuade me, that I am wrong:

> ---
> o this patch is based on mchehab/linux-next.git
> o this patch came from "Add ov7725 ov7720 support to ov772x driver"
> o specify code on i2c_device_id is removed
> 
> 
>  drivers/media/video/ov772x.c    |   48 +++++++++++++++++++-------------------
>  include/media/v4l2-chip-ident.h |    2 +-
>  2 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index d3b54a4..f417df1 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -346,6 +346,12 @@
>  #define OP_SWAP_RGB 0x00000002
>  
>  /*
> + * ID
> + */
> +#define OV7720  0x7720
> +#define VERSION(pid, ver) ((pid<<8)|(ver&0xFF))
> +
> +/*
>   * struct
>   */
>  struct regval_list {
> @@ -374,34 +380,22 @@ struct ov772x_priv {
>  	struct soc_camera_device          icd;
>  	const struct ov772x_color_format *fmt;
>  	const struct ov772x_win_size     *win;
> +	int                               model;
>  };
>  
>  #define ENDMARKER { 0xff, 0xff }
>  
> -static const struct regval_list ov772x_default_regs[] =
> -{
> -	{ COM3,  0x00 },
> -	{ COM4,  PLL_4x | 0x01 },
> -	{ 0x16,  0x00 }, /* Mystery */
> -	{ COM11, 0x10 }, /* Mystery */
> -	{ 0x28,  0x00 }, /* Mystery */
> -	{ HREF,  0x00 },
> -	{ COM13, 0xe2 }, /* Mystery */
> -	{ AREF0, 0xef },
> -	{ AREF2, 0x60 },
> -	{ AREF6, 0x7a },
> -	ENDMARKER,
> -};
> -
>  /*
>   * register setting for color format
>   */
>  static const struct regval_list ov772x_RGB555_regs[] = {
> +	{ COM3, 0x00 },
>  	{ COM7, FMT_RGB555 | OFMT_RGB },
>  	ENDMARKER,
>  };
>  
>  static const struct regval_list ov772x_RGB565_regs[] = {
> +	{ COM3, 0x00 },
>  	{ COM7, FMT_RGB565 | OFMT_RGB },
>  	ENDMARKER,
>  };
> @@ -413,6 +407,7 @@ static const struct regval_list ov772x_YYUV_regs[] = {
>  };
>  
>  static const struct regval_list ov772x_UVYY_regs[] = {
> +	{ COM3, 0x00 },
>  	{ COM7, OFMT_YUV },
>  	ENDMARKER,
>  };
> @@ -634,9 +629,6 @@ static int ov772x_start_capture(struct soc_camera_device *icd)
>  	 * reset hardware
>  	 */
>  	ov772x_reset(priv->client);
> -	ret = ov772x_write_array(priv->client, ov772x_default_regs);
> -	if (ret < 0)
> -		goto start_end;
>  
>  	/*
>  	 * set color format

These seem unrelated to the ID-change and extension, or am I wrong? If 
they really are unrelated, they don't seem trivial enough to me to be left 
undocumented. Could you please separate this change and explain in the 
comment why you do this?

Thanks
Guennadi

> @@ -717,7 +709,9 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
>  static int ov772x_get_chip_id(struct soc_camera_device *icd,
>  			      struct v4l2_chip_ident   *id)
>  {
> -	id->ident    = V4L2_IDENT_OV772X;
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +
> +	id->ident    = priv->model;
>  	id->revision = 0;
>  
>  	return 0;
> @@ -811,6 +805,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  {
>  	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
>  	u8                  pid, ver;
> +	const char         *devname;
>  
>  	/*
>  	 * We must have a parent by now. And it cannot be a wrong one.
> @@ -837,15 +832,21 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  	 */
>  	pid = i2c_smbus_read_byte_data(priv->client, PID);
>  	ver = i2c_smbus_read_byte_data(priv->client, VER);
> -	if (pid != 0x77 ||
> -	    ver != 0x21) {
> +
> +	switch (VERSION(pid, ver)) {
> +	case OV7720:
> +		devname     = "ov7720";
> +		priv->model = V4L2_IDENT_OV7720;
> +		break;
> +	default:
>  		dev_err(&icd->dev,
>  			"Product ID error %x:%x\n", pid, ver);
>  		return -ENODEV;
>  	}
>  
>  	dev_info(&icd->dev,
> -		 "ov772x Product ID %0x:%0x Manufacturer ID %x:%x\n",
> +		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
> +		 devname,
>  		 pid,
>  		 ver,
>  		 i2c_smbus_read_byte_data(priv->client, MIDH),
> @@ -936,7 +937,7 @@ static int ov772x_remove(struct i2c_client *client)
>  }
>  
>  static const struct i2c_device_id ov772x_id[] = {
> -	{"ov772x", 0},
> +	{ "ov772x", 0 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, ov772x_id);
> @@ -956,7 +957,6 @@ static struct i2c_driver ov772x_i2c_driver = {
>  
>  static int __init ov772x_module_init(void)
>  {
> -	printk(KERN_INFO "ov772x driver\n");
>  	return i2c_add_driver(&ov772x_i2c_driver);
>  }
>  
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index bfe5142..456ac0d 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -60,7 +60,7 @@ enum {
>  
>  	/* OmniVision sensors: reserved range 250-299 */
>  	V4L2_IDENT_OV7670 = 250,
> -	V4L2_IDENT_OV772X = 251,
> +	V4L2_IDENT_OV7720 = 251,
>  
>  	/* Conexant MPEG encoder/decoders: reserved range 410-420 */
>  	V4L2_IDENT_CX23415 = 415,
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
