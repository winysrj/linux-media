Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:47186 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753554Ab2HBMkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 08:40:12 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 2 Aug 2012 15:40:29 +0300
Subject: RE: [PATCH v2] mt9v022: Add support for mt9v024
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2E31A0CA1F@MEP-EXCH.meprolight.com>
References: <1343900052-29934-1-git-send-email-alexg@meprolight.com>,<Pine.LNX.4.64.1208021150430.11412@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1208021150430.11412@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for your very detailed comment.

> Hi Alex

> Yes, this looks much better to me now. Still, I'd like to ask you to
> make a couple more changes. First - there are different opinions about how
> really important a patch description is, whether there are at all cases,
> when an empty description is acceptable. I do sometimes myself provide no
> description and accept the same from others, but only in really trivial
> cases, where the single patch subject line perfectly tells it all.
> However, I don't think this is the case here. It would be nice to have a
> couple of words in the patch description, saying, that "mt9v024 is a
> camera sensor, very similar to mt9v022 with just a few differences, namely
> its sensor matrix size is now ... instead of ..., some register locations
> have changed,..."

No problem, I'll add descriptions.

> While at it, please, also change one more thing. Yes, it was my request to
> move chip_id into the private struct, but now with the addition of "struct
> mt9v02x_register" it is not needed anymore. The chip_id is only used in
> the probe function, so, you don't have to save it. Please, if I'm not
> mistaken and I haven't missed some additional uses of chip_id, remove it
> again and just leave the local "data" variable without change.
> Respectively, your is_mt9v024 macro will change to

> #define is_mt9v024(id) (id == 0x1324)

I only have a few doubts about this:
mt9v024 camera sensor has about 20 additional registers that are not supported in mt9v022 camera sensor.
What should be happened if someone wants to add this registers?
I guess, that in this case we will need to use the chip_id outside of the probe function.
What do you think?

Regards,
Alex

 
 > Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  drivers/media/video/Kconfig   |    2 +-
>  drivers/media/video/mt9v022.c |   45 ++++++++++++++++++++++++++++++++--------
>  2 files changed, 37 insertions(+), 10 deletions(-)
>
> Changes for v2:
>         Fixed comment from Guennadi.
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index c128fac..3ce905c 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1058,7 +1058,7 @@ config SOC_CAMERA_MT9T112
>         This driver supports MT9T112 cameras from Aptina.
>
>  config SOC_CAMERA_MT9V022
> -     tristate "mt9v022 support"
> +     tristate "mt9v022 and mt9v024 support"
>       depends on SOC_CAMERA && I2C
>       select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
>       help
> diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> index 7247924..d46727b 100644
> --- a/drivers/media/video/mt9v022.c
> +++ b/drivers/media/video/mt9v022.c
> @@ -57,6 +57,10 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
>  #define MT9V022_AEC_AGC_ENABLE               0xAF
>  #define MT9V022_MAX_TOTAL_SHUTTER_WIDTH      0xBD
>
> +/* mt9v024 partial list register addresses changes with respect to mt9v022 */
> +#define MT9V024_PIXCLK_FV_LV         0x72
> +#define MT9V024_MAX_TOTAL_SHUTTER_WIDTH      0xAD
> +
>  /* Progressive scan, master, defaults */
>  #define MT9V022_CHIP_CONTROL_DEFAULT 0x188
>
> @@ -67,6 +71,8 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
>  #define MT9V022_COLUMN_SKIP          1
>  #define MT9V022_ROW_SKIP             4
>
> +#define is_mt9v024(p) (p->chip_id == 0x1324)
> +
>  /* MT9V022 has only one fixed colorspace per pixelcode */
>  struct mt9v022_datafmt {
>       enum v4l2_mbus_pixelcode        code;
> @@ -101,6 +107,22 @@ static const struct mt9v022_datafmt mt9v022_monochrome_fmts[] = {
>       {V4L2_MBUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
>  };
>
> +/* only registers with different addresses on different mt9v02x sensors */
> +struct mt9v02x_register {
> +     u8      max_total_shutter_width;
> +     u8      pixclk_fv_lv;
> +};
> +
> +static const struct mt9v02x_register mt9v022_register = {
> +     .max_total_shutter_width        = MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
> +     .pixclk_fv_lv                   = MT9V022_PIXCLK_FV_LV,
> +};
> +
> +static const struct mt9v02x_register mt9v024_register = {
> +     .max_total_shutter_width        = MT9V024_MAX_TOTAL_SHUTTER_WIDTH,
> +     .pixclk_fv_lv                   = MT9V024_PIXCLK_FV_LV,
> +};
> +
>  struct mt9v022 {
>       struct v4l2_subdev subdev;
>       struct v4l2_ctrl_handler hdl;
> @@ -117,10 +139,12 @@ struct mt9v022 {
>       struct v4l2_rect rect;  /* Sensor window */
>       const struct mt9v022_datafmt *fmt;
>       const struct mt9v022_datafmt *fmts;
> +     const struct mt9v02x_register *reg;
>       int num_fmts;
>       int model;      /* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
>       u16 chip_control;
>       unsigned short y_skip_top;      /* Lines to skip at the top */
> +     s32 chip_id;
>  };
>
>  static struct mt9v022 *to_mt9v022(const struct i2c_client *client)
> @@ -185,7 +209,7 @@ static int mt9v022_init(struct i2c_client *client)
>       if (!ret)
>               ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH, 480);
>       if (!ret)
> -             ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
> +             ret = reg_write(client, mt9v022->reg->max_total_shutter_width, 480);
>       if (!ret)
>               /* default - auto */
>               ret = reg_clear(client, MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
> @@ -238,7 +262,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>       ret = reg_read(client, MT9V022_AEC_AGC_ENABLE);
>       if (ret >= 0) {
>               if (ret & 1) /* Autoexposure */
> -                     ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
> +                     ret = reg_write(client, mt9v022->reg->max_total_shutter_width,
>                                       rect.height + mt9v022->y_skip_top + 43);
>               else
>                       ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
> @@ -566,21 +590,24 @@ static int mt9v022_video_probe(struct i2c_client *client)
>  {
>       struct mt9v022 *mt9v022 = to_mt9v022(client);
>       struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> -     s32 data;
>       int ret;
>       unsigned long flags;
>
>       /* Read out the chip version register */
> -     data = reg_read(client, MT9V022_CHIP_VERSION);
> +     mt9v022->chip_id = reg_read(client, MT9V022_CHIP_VERSION);
>
> -     /* must be 0x1311 or 0x1313 */
> -     if (data != 0x1311 && data != 0x1313) {
> +     /* must be 0x1311, 0x1313 or 0x1324 */
> +     if (mt9v022->chip_id != 0x1311 && mt9v022->chip_id != 0x1313 &&
> +             mt9v022->chip_id != 0x1324) {
>               ret = -ENODEV;
>               dev_info(&client->dev, "No MT9V022 found, ID register 0x%x\n",
> -                      data);
> +                      mt9v022->chip_id);
>               goto ei2c;
>       }
>
> +     mt9v022->reg = is_mt9v024(mt9v022) ? &mt9v024_register :
> +                     &mt9v022_register;
> +
>       /* Soft reset */
>       ret = reg_write(client, MT9V022_RESET, 1);
>       if (ret < 0)
> @@ -632,7 +659,7 @@ static int mt9v022_video_probe(struct i2c_client *client)
>       mt9v022->fmt = &mt9v022->fmts[0];
>
>       dev_info(&client->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
> -              data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
> +              mt9v022->chip_id, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
>                "monochrome" : "colour");
>
>       ret = mt9v022_init(client);
> @@ -728,7 +755,7 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
>       if (!(flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH))
>               pixclk |= 0x2;
>
> -     ret = reg_write(client, MT9V022_PIXCLK_FV_LV, pixclk);
> +     ret = reg_write(client, mt9v022->reg->pixclk_fv_lv, pixclk);
>       if (ret < 0)
>               return ret;
>
> --
> 1.7.0.4
>

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/