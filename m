Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46750 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbbCIJpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 05:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <1425822349-19218-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425822349-19218-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Mon, 9 Mar 2015 10:45:31 +0100
Message-ID: <CAPW4HR1WJPWg64GwitxCPK2jop0CntS1UtsOu_0VjCz0BEke6A@mail.gmail.com>
Subject: Re: [PATCH] v4l: mt9v032: Add OF support
From: =?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Looks good. One question, why not deprecate the platform data? I can't
see any device using the mt9v032 pdata, I was making a similar patch
but deprecating pdata.
Some more comment:

2015-03-08 14:45 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Parse DT properties into a platform data structure when a DT node is
> available.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  .../devicetree/bindings/media/i2c/mt9v032.txt      | 41 ++++++++++++++
>  MAINTAINERS                                        |  1 +
>  drivers/media/i2c/mt9v032.c                        | 66 +++++++++++++++++++++-
>  3 files changed, 107 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9v032.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> new file mode 100644
> index 0000000..75c97de
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> @@ -0,0 +1,41 @@
> +* Aptina 1/3-Inch WVGA CMOS Digital Image Sensor
> +
> +The Aptina MT9V032 is a 1/3-inch CMOS active pixel digital image sensor with
> +an active array size of 752H x 480V. It is programmable through a simple
> +two-wire serial interface.
> +
> +Required Properties:
> +
> +- compatible: value should be either one among the following
> +       (a) "aptina,mt9v032" for MT9V032 color sensor
> +       (b) "aptina,mt9v032m" for MT9V032 monochrome sensor
> +       (c) "aptina,mt9v034" for MT9V034 color sensor
> +       (d) "aptina,mt9v034m" for MT9V034 monochrome sensor
> +
> +Optional Properties:
> +
> +- link-frequencies: List of allowed link frequencies in Hz. Each frequency is
> +       expressed as a 64-bit big-endian integer.
> +
> +For further reading on port node refer to
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +       i2c0@1c22000 {
> +               ...
> +               ...
> +               mt9v032@5c {
> +                       compatible = "aptina,mt9v032";
> +                       reg = <0x5c>;
> +
> +                       port {
> +                               mt9v032_1: endpoint {
> +                                       link-frequencies =
> +                                               <0 13000000>, <0 26600000>,
> +                                               <0 27000000>;
> +                               };
> +                       };
> +               };
> +               ...
> +       };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ddc5a8c..180f6fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6535,6 +6535,7 @@ M:        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:     linux-media@vger.kernel.org
>  T:     git git://linuxtv.org/media_tree.git
>  S:     Maintained
> +F:     Documentation/devicetree/bindings/media/i2c/mt9v032.txt
>  F:     drivers/media/i2c/mt9v032.c
>  F:     include/media/mt9v032.h
>
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 3267c18..a6ea091 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -17,6 +17,8 @@
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
>  #include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> @@ -26,6 +28,7 @@
>  #include <media/mt9v032.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-subdev.h>
>
>  /* The first four rows are black rows. The active area spans 753x481 pixels. */
> @@ -876,10 +879,59 @@ static const struct regmap_config mt9v032_regmap_config = {
>   * Driver initialization and probing
>   */
>
> +static struct mt9v032_platform_data *
> +mt9v032_get_pdata(struct i2c_client *client)
> +{
> +       struct mt9v032_platform_data *pdata;
> +       struct v4l2_of_endpoint endpoint;
> +       struct device_node *np;
> +       struct property *prop;
> +
> +       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +               return client->dev.platform_data;
> +
> +       np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +       if (!np)
> +               return NULL;
> +
> +       if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> +               goto done;

Here I have one little testing:

if (endpoint.bus_type != V4L2_MBUS_PARALLEL) {
        dev_err(dev, "invalid bus type, must be parallel\n");
        goto done;
}

> +
> +       pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata)
> +               goto done;
> +
> +       prop = of_find_property(np, "link-freqs", NULL);
> +       if (prop) {
> +               size_t size = prop->length / 8;
> +               u64 *link_freqs;
> +
> +               link_freqs = devm_kzalloc(&client->dev,
> +                                         size * sizeof(*link_freqs),
> +                                         GFP_KERNEL);
> +               if (!link_freqs)
> +                       goto done;
> +
> +               if (of_property_read_u64_array(np, "link-frequencies",
> +                                              link_freqs, size) < 0)
> +                       goto done;
> +
> +               pdata->link_freqs = link_freqs;
> +               pdata->link_def_freq = link_freqs[0];
> +       }
> +
> +       pdata->clk_pol = !!(endpoint.bus.parallel.flags &
> +                           V4L2_MBUS_PCLK_SAMPLE_RISING);
> +
> +done:
> +       of_node_put(np);
> +       return pdata;
> +}
> +
>  static int mt9v032_probe(struct i2c_client *client,
>                 const struct i2c_device_id *did)
>  {
> -       struct mt9v032_platform_data *pdata = client->dev.platform_data;
> +       struct mt9v032_platform_data *pdata = mt9v032_get_pdata(client);
>         struct mt9v032 *mt9v032;
>         unsigned int i;
>         int ret;
> @@ -1034,9 +1086,21 @@ static const struct i2c_device_id mt9v032_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, mt9v032_id);
>
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id mt9v032_of_match[] = {
> +       { .compatible = "mt9v032" },
> +       { .compatible = "mt9v032m" },
> +       { .compatible = "mt9v034" },
> +       { .compatible = "mt9v034m" },
> +       { /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mt9v032_of_match);
> +#endif

I have this:
#if IS_ENABLED(CONFIG_OF)
static const struct of_device_id mt9v032_of_match[] = {
    { .compatible = "aptina,mt9v022", },
    { .compatible = "aptina,mt9v022m", },
    { .compatible = "aptina,mt9v024", },
    { .compatible = "aptina,mt9v024m", },
    { .compatible = "aptina,mt9v032", },
    { .compatible = "aptina,mt9v032m", },
    { .compatible = "aptina,mt9v034", },
    { .compatible = "aptina,mt9v034m", },
    { /* sentinel */ },
};

MODULE_DEVICE_TABLE(of, mt9v032_of_match);
#endi
> +
>  static struct i2c_driver mt9v032_driver = {
>         .driver = {
>                 .name = "mt9v032",
> +               .of_match_table = of_match_ptr(mt9v032_of_match),
>         },
>         .probe          = mt9v032_probe,
>         .remove         = mt9v032_remove,
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,

Carlos Sanmartín
