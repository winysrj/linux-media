Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:54492 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729164AbeIRIti (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 04:49:38 -0400
Received: by mail-it0-f66.google.com with SMTP id f14-v6so1216314ita.4
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 20:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com> <1537200191-17956-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1537200191-17956-3-git-send-email-akinobu.mita@gmail.com>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Mon, 17 Sep 2018 20:18:55 -0700
Message-ID: <CAJCx=gnoQz5Ks9oKKs3mgB58iHp0aTLpS1yM92o1nTKhwmoctg@mail.gmail.com>
Subject: Re: [PATCH 2/5] media: video-i2c: use i2c regmap
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        Hans Verkuil <hansverk@cisco.com>, mchehab@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2018 at 9:03 AM Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> Use regmap for i2c register access.  This simplifies register accesses and
> chooses suitable access commands based on the functionality that the
> adapter supports.
>
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/video-i2c.c | 54 ++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
> index b7a2af9..90d389b 100644
> --- a/drivers/media/i2c/video-i2c.c
> +++ b/drivers/media/i2c/video-i2c.c
> @@ -17,6 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/of_device.h>
> +#include <linux/regmap.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> @@ -38,7 +39,7 @@ struct video_i2c_buffer {
>  };
>
>  struct video_i2c_data {
> -       struct i2c_client *client;
> +       struct regmap *regmap;
>         const struct video_i2c_chip *chip;
>         struct mutex lock;
>         spinlock_t slock;
> @@ -62,6 +63,12 @@ static const struct v4l2_frmsize_discrete amg88xx_size = {
>         .height = 8,
>  };
>
> +static const struct regmap_config amg88xx_regmap_config = {
> +       .reg_bits = 8,
> +       .val_bits = 8,
> +       .max_register = 0xff
> +};
> +
>  struct video_i2c_chip {
>         /* video dimensions */
>         const struct v4l2_fmtdesc *format;
> @@ -76,6 +83,8 @@ struct video_i2c_chip {
>         /* pixel size in bits */
>         unsigned int bpp;
>
> +       const struct regmap_config *regmap_config;
> +
>         /* xfer function */
>         int (*xfer)(struct video_i2c_data *data, char *buf);
>
> @@ -85,24 +94,8 @@ struct video_i2c_chip {
>
>  static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
>  {
> -       struct i2c_client *client = data->client;
> -       struct i2c_msg msg[2];
> -       u8 reg = 0x80;
> -       int ret;
> -
> -       msg[0].addr = client->addr;
> -       msg[0].flags = 0;
> -       msg[0].len = 1;
> -       msg[0].buf  = (char *)&reg;
> -
> -       msg[1].addr = client->addr;
> -       msg[1].flags = I2C_M_RD;
> -       msg[1].len = data->chip->buffer_size;
> -       msg[1].buf = (char *)buf;
> -
> -       ret = i2c_transfer(client->adapter, msg, 2);
> -
> -       return (ret == 2) ? 0 : -EIO;
> +       return regmap_bulk_read(data->regmap, 0x80, buf,
> +                               data->chip->buffer_size);

May as well make 0x80 into a AMG88XX_REG_* define as in the later
patch in this series

>  }
>
>  #if IS_ENABLED(CONFIG_HWMON)
> @@ -133,12 +126,15 @@ static int amg88xx_read(struct device *dev, enum hwmon_sensor_types type,
>                         u32 attr, int channel, long *val)
>  {
>         struct video_i2c_data *data = dev_get_drvdata(dev);
> -       struct i2c_client *client = data->client;
> -       int tmp = i2c_smbus_read_word_data(client, 0x0e);
> +       __le16 buf;
> +       int tmp;
>
> -       if (tmp < 0)
> +       tmp = regmap_bulk_read(data->regmap, 0x0e, &buf, 2);

Same with 0x0e

- Matt

> +       if (tmp)
>                 return tmp;
>
> +       tmp = le16_to_cpu(buf);
> +
>         /*
>          * Check for sign bit, this isn't a two's complement value but an
>          * absolute temperature that needs to be inverted in the case of being
> @@ -164,8 +160,9 @@ static const struct hwmon_chip_info amg88xx_chip_info = {
>
>  static int amg88xx_hwmon_init(struct video_i2c_data *data)
>  {
> -       void *hwmon = devm_hwmon_device_register_with_info(&data->client->dev,
> -                               "amg88xx", data, &amg88xx_chip_info, NULL);
> +       struct device *dev = regmap_get_device(data->regmap);
> +       void *hwmon = devm_hwmon_device_register_with_info(dev, "amg88xx", data,
> +                                               &amg88xx_chip_info, NULL);
>
>         return PTR_ERR_OR_ZERO(hwmon);
>  }
> @@ -182,6 +179,7 @@ static const struct video_i2c_chip video_i2c_chip[] = {
>                 .max_fps        = 10,
>                 .buffer_size    = 128,
>                 .bpp            = 16,
> +               .regmap_config  = &amg88xx_regmap_config,
>                 .xfer           = &amg88xx_xfer,
>                 .hwmon_init     = amg88xx_hwmon_init,
>         },
> @@ -350,7 +348,8 @@ static int video_i2c_querycap(struct file *file, void  *priv,
>                                 struct v4l2_capability *vcap)
>  {
>         struct video_i2c_data *data = video_drvdata(file);
> -       struct i2c_client *client = data->client;
> +       struct device *dev = regmap_get_device(data->regmap);
> +       struct i2c_client *client = to_i2c_client(dev);
>
>         strlcpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
>         strlcpy(vcap->card, data->vdev.name, sizeof(vcap->card));
> @@ -527,7 +526,10 @@ static int video_i2c_probe(struct i2c_client *client,
>         else
>                 return -ENODEV;
>
> -       data->client = client;
> +       data->regmap = devm_regmap_init_i2c(client, data->chip->regmap_config);
> +       if (IS_ERR(data->regmap))
> +               return PTR_ERR(data->regmap);
> +
>         v4l2_dev = &data->v4l2_dev;
>         strlcpy(v4l2_dev->name, VIDEO_I2C_DRIVER, sizeof(v4l2_dev->name));
>
> --
> 2.7.4
>
