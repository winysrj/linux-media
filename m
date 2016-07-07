Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36414 "EHLO
	mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbcGGPEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:04:38 -0400
Received: by mail-it0-f43.google.com with SMTP id g4so93388857ith.1
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 08:04:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-4-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com> <1467846004-12731-4-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 08:04:36 -0700
Message-ID: <CAJ+vNU3mRy8P_efiVPYk=LqgGfAf4WJB+z-PsxVm9CCy2J+BFQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] media: adv7180: add power pin control
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 3:59 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Some targets control the ADV7180 power pin via a gpio, so add
> support for "pwdn-gpio" pin control.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/i2c/Kconfig   |  2 +-
>  drivers/media/i2c/adv7180.c | 37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 993dc50..80d39f6 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -187,7 +187,7 @@ comment "Video decoders"
>
>  config VIDEO_ADV7180
>         tristate "Analog Devices ADV7180 decoder"
> -       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +       depends on GPIOLIB && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>         ---help---
>           Support for the Analog Devices ADV7180 video decoder.
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 967303a..38e5161 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -26,6 +26,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
> +#include <linux/gpio/consumer.h>
>  #include <media/v4l2-ioctl.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
> @@ -191,6 +192,7 @@ struct adv7180_state {
>         struct media_pad        pad;
>         struct mutex            mutex; /* mutual excl. when accessing chip */
>         int                     irq;
> +       struct gpio_desc        *pwdn_gpio;
>         v4l2_std_id             curr_norm;
>         bool                    autodetect;
>         bool                    powered;
> @@ -443,6 +445,19 @@ static int adv7180_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
>         return 0;
>  }
>
> +static void adv7180_set_power_pin(struct adv7180_state *state, bool on)
> +{
> +       if (!state->pwdn_gpio)
> +               return;
> +
> +       if (on) {
> +               gpiod_set_value_cansleep(state->pwdn_gpio, 0);
> +               usleep_range(5000, 10000);
> +       } else {
> +               gpiod_set_value_cansleep(state->pwdn_gpio, 1);
> +       }
> +}
> +
>  static int adv7180_set_power(struct adv7180_state *state, bool on)
>  {
>         u8 val;
> @@ -1143,6 +1158,8 @@ static int init_device(struct adv7180_state *state)
>
>         mutex_lock(&state->mutex);
>
> +       adv7180_set_power_pin(state, true);
> +
>         adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
>         usleep_range(5000, 10000);
>
> @@ -1190,6 +1207,20 @@ out_unlock:
>         return ret;
>  }
>
> +static int adv7180_of_parse(struct adv7180_state *state)
> +{
> +       struct i2c_client *client = state->client;
> +
> +       state->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
> +                                                  GPIOD_OUT_HIGH);
> +       if (IS_ERR(state->pwdn_gpio)) {
> +               v4l_err(client, "request for power pin failed\n");
> +               return PTR_ERR(state->pwdn_gpio);
> +       }
> +
> +       return 0;
> +}
> +
>  static int adv7180_probe(struct i2c_client *client,
>                          const struct i2c_device_id *id)
>  {
> @@ -1212,6 +1243,10 @@ static int adv7180_probe(struct i2c_client *client,
>         state->field = V4L2_FIELD_INTERLACED;
>         state->chip_info = (struct adv7180_chip_info *)id->driver_data;
>
> +       ret = adv7180_of_parse(state);
> +       if (ret)
> +               return ret;
> +
>         if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
>                 state->csi_client = i2c_new_dummy(client->adapter,
>                                 ADV7180_DEFAULT_CSI_I2C_ADDR);
> @@ -1303,6 +1338,8 @@ static int adv7180_remove(struct i2c_client *client)
>         if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
>                 i2c_unregister_device(state->csi_client);
>
> +       adv7180_set_power_pin(state, false);
> +
>         mutex_destroy(&state->mutex);
>
>         return 0;
> --

Steve,

For completeness, you also need to provide a patch to
Documentation/devicetree/bindings/media/i2c/adv7180.txt adding the
Optional property.

Tested on an IMX6 Gateworks Ventana with IMX6 capture drivers [1].
Verified that adv7180_set_power_pin() gets called properly.

Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>

Added to Cc:
Cc: Lars-Peter Clausen <lars@metafoo.de>

Regards,

Tim

[1] - http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/102914
