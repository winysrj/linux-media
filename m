Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:59810 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751425Ab2GaKHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 06:07:16 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 31 Jul 2012 13:07:26 +0300
Subject: RE: [PATCH] mt9v022: Add support for mt9v024
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2E31A0CA1A@MEP-EXCH.meprolight.com>
References: <1343660457-7238-1-git-send-email-alexg@meprolight.com>,<Pine.LNX.4.64.1207310937170.27888@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207310937170.27888@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>> Thanks for the patch, comments below.

Thanks for you comments.

>> On Mon, 30 Jul 2012, Alex Gershgorin wrote:

> This patch has been successfully tested
>
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  drivers/media/video/Kconfig   |    2 +-
>  drivers/media/video/mt9v022.c |   28 ++++++++++++++++++----------
>  2 files changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 99937c9..38d6944 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1013,7 +1013,7 @@ config SOC_CAMERA_MT9T112
>         This driver supports MT9T112 cameras from Aptina.
>
>  config SOC_CAMERA_MT9V022
> -     tristate "mt9v022 support"
> +     tristate "mt9v022 and mt9v024 support"
>       depends on SOC_CAMERA && I2C
>       select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
>       help
> diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> index bf63417..d2c1ab1 100644
> --- a/drivers/media/video/mt9v022.c
> +++ b/drivers/media/video/mt9v022.c
> @@ -26,7 +26,7 @@
>   * The platform has to define ctruct i2c_board_info objects and link to them
>   * from struct soc_camera_link
>   */
> -
> +static s32 chip_id;

 >> No, this should be per instance. Please, add it to struct mt9v022.

>  static char *sensor_type;
>  module_param(sensor_type, charp, S_IRUGO);
>  MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
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
> @@ -185,7 +189,9 @@ static int mt9v022_init(struct i2c_client *client)
>       if (!ret)
>               ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH, 480);
>       if (!ret)
> -             ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
> +             ret = reg_write(client, (chip_id == 0x1324) ?

>> I would use a macro something like

>> #define is_mt9v024(p) (p->chip_id == 0x1324)

>> same everywhere below

> +                             MT9V024_MAX_TOTAL_SHUTTER_WIDTH :
> +                             MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);

>> Hm, with just 2 registers different it almost isn't worth it, but still...

There is little more than two registers and also added new registers
if you're interested I can send you the document.

>> (1) if someone uses this driver as a template, or (2) if we add more
>> sensors or more registers, whose addresses also are different, I think, we
>> better do it properly. How about

/* only registers with different addresses on different mt9v02x sensors */
>> struct mt9v02x_register {
>>   u8      max_total_shutter_width;
>>   u8      pixclk_fv_lv;
>>};

>> static const struct mt9v02x_register mt9v022_register = {
>>    .max_total_shutter_width        = MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
>>    .pixclk_fv_lv                   = MT9V022_PIXCLK_FV_LV,
>>};

>> static const struct mt9v02x_register mt9v024_register = {
>> .max_total_shutter_width        = MT9V024_MAX_TOTAL_SHUTTER_WIDTH,
>> .pixclk_fv_lv                   = MT9V024_PIXCLK_FV_LV,
>>};

>> struct mt9v022 {
>>        ...
>>        const struct mt9v02x_register *reg;
>>        ...
>>};

>> and then in this case just do

>> +               ret = reg_write(client, mt9v022->reg->max_total_shutter_width, 480);

>> etc.?

I accept your corrections and suggestions in the near future 
I will send an updated version of this patch.

Regards,

Alex

>       if (!ret)
>               /* default - auto */
>               ret = reg_clear(client, MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
> @@ -238,8 +244,10 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>       ret = reg_read(client, MT9V022_AEC_AGC_ENABLE);
>       if (ret >= 0) {
>               if (ret & 1) /* Autoexposure */
> -                     ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
> -                                     rect.height + mt9v022->y_skip_top + 43);
> +                     ret = reg_write(client, (chip_id == 0x1324) ?
> +                             MT9V024_MAX_TOTAL_SHUTTER_WIDTH :
> +                             MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
> +                             rect.height + mt9v022->y_skip_top + 43);
>               else
>                       ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
>                                       rect.height + mt9v022->y_skip_top + 43);
> @@ -566,18 +574,17 @@ static int mt9v022_video_probe(struct i2c_client *client)
>  {
>       struct mt9v022 *mt9v022 = to_mt9v022(client);
>       struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> -     s32 data;
>       int ret;
>       unsigned long flags;
>
>       /* Read out the chip version register */
> -     data = reg_read(client, MT9V022_CHIP_VERSION);
> +     chip_id = reg_read(client, MT9V022_CHIP_VERSION);
>
>       /* must be 0x1311 or 0x1313 */
> -     if (data != 0x1311 && data != 0x1313) {
> +     if (chip_id != 0x1311 && chip_id != 0x1313 && chip_id != 0x1324) {
>               ret = -ENODEV;
>               dev_info(&client->dev, "No MT9V022 found, ID register 0x%x\n",
> -                      data);
> +                      chip_id);
>               goto ei2c;
>       }
>
> @@ -632,7 +639,7 @@ static int mt9v022_video_probe(struct i2c_client *client)
>       mt9v022->fmt = &mt9v022->fmts[0];
>
>       dev_info(&client->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
> -              data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
> +              chip_id, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
>                "monochrome" : "colour");
>
>       ret = mt9v022_init(client);
> @@ -728,7 +735,8 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
>       if (!(flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH))
>               pixclk |= 0x2;
>
> -     ret = reg_write(client, MT9V022_PIXCLK_FV_LV, pixclk);
> +     ret = reg_write(client, (chip_id == 0x1324) ? MT9V024_PIXCLK_FV_LV :
> +                     MT9V022_PIXCLK_FV_LV, pixclk);
>       if (ret < 0)
>               return ret;
>
> --
> 1.7.0.4

 