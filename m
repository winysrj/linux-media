Return-path: <linux-media-owner@vger.kernel.org>
Received: from conssluserg-01.nifty.com ([210.131.2.80]:52675 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbeFBMCQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 08:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <20180530090946.1635-8-suzuki.katsuhiro@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com> <20180530090946.1635-8-suzuki.katsuhiro@socionext.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Sat, 2 Jun 2018 21:01:28 +0900
Message-ID: <CAK7LNATXNQJsHAtxQG5o0S6aatTt9ZR5--fG+sNaqF_jr2Ab_g@mail.gmail.com>
Subject: Re: [PATCH 7/8] media: uniphier: add LD11 adapter driver for ISDB
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-30 18:09 GMT+09:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>:
> diff --git a/drivers/media/platform/uniphier/ld11-mn884433-helene.c b/drivers/media/platform/uniphier/ld11-mn884433-helene.c
> new file mode 100644
> index 000000000000..f4f48b6a0211
> --- /dev/null
> +++ b/drivers/media/platform/uniphier/ld11-mn884433-helene.c
> @@ -0,0 +1,265 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//
> +// Socionext UniPhier LD11 adapter driver for ISDB.
> +// Using Socionext MN884433 ISDB-S/ISDB-T demodulator and
> +// SONY HELENE tuner.
> +//
> +// Copyright (c) 2018 Socionext Inc.
> +
> +#include <linux/clk.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/reset.h>
> +
> +#include "sc1501a.h"


"sc1501a.h" is not included in this patch series.


It took some time to notice that
this series actually depends on the following:
https://patchwork.kernel.org/patch/10434159/

Otherwise, this cause a build error.


scripts/kconfig/conf  --syncconfig Kconfig
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     scripts/mod/devicetable-offsets.h
  CHK     include/generated/utsrelease.h
  CHK     include/generated/bounds.h
  CHK     include/generated/timeconst.h
  CHK     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/media/platform/uniphier/ld11-mn884433-helene.o
drivers/media/platform/uniphier/ld11-mn884433-helene.c:16:10: fatal
error: sc1501a.h: No such file or directory
 #include "sc1501a.h"
          ^~~~~~~~~~~
compilation terminated.
make[2]: *** [scripts/Makefile.build:313:
drivers/media/platform/uniphier/ld11-mn884433-helene.o] Error 1
make[1]: *** [scripts/Makefile.build:559:
drivers/media/platform/uniphier] Error 2
make: *** [Makefile:1746: drivers/media/platform/] Error 2




I applied that patch, but still fail to build this series.


  CC [M]  drivers/media/platform/uniphier/hsc-core.o
  CC [M]  drivers/media/platform/uniphier/hsc-ucode.o
  CC [M]  drivers/media/platform/uniphier/hsc-css.o
  CC [M]  drivers/media/platform/uniphier/hsc-ts.o
  CC [M]  drivers/media/platform/uniphier/hsc-dma.o
  CC [M]  drivers/media/platform/uniphier/hsc-ld11.o
  CC [M]  drivers/media/platform/uniphier/uniphier-adapter.o
  CC [M]  drivers/media/platform/uniphier/ld11-mn884433-helene.o
drivers/media/platform/uniphier/ld11-mn884433-helene.c:17:10: fatal
error: cxd2858.h: No such file or directory
 #include "cxd2858.h"
          ^~~~~~~~~~~
compilation terminated.
make[1]: *** [scripts/Makefile.build:312:
drivers/media/platform/uniphier/ld11-mn884433-helene.o] Error 1
make: *** [Makefile:1665: drivers/media/platform/uniphier/] Error 2





I give up searching pre-requisite patches.


You need to describe this information under '---'
if your series needs pre-requisite patches that have not been applied yet.






> +#include "cxd2858.h"
> +#include "helene.h"
> +#include "hsc.h"
> +#include "uniphier-adapter.h"
> +
> +static struct sc1501a_config mn884433_conf[] = {
> +       { .if_freq = LOW_IF_4MHZ, },
> +};
> +
> +static int uniphier_adapter_demod_probe(struct uniphier_adapter_priv *priv)
> +{
> +       const struct uniphier_adapter_spec *spec = priv->spec;
> +       struct device *dev = &priv->pdev->dev;
> +       struct device_node *node;
> +       int ret, i;
> +
> +       priv->demod_mclk = devm_clk_get(dev, "demod-mclk");
> +       if (IS_ERR(priv->demod_mclk)) {
> +               dev_err(dev, "Failed to request demod-mclk: %ld\n",
> +                       PTR_ERR(priv->demod_mclk));
> +               return PTR_ERR(priv->demod_mclk);
> +       }
> +
> +       priv->demod_gpio = devm_gpiod_get_optional(dev, "reset-demod",
> +                                                  GPIOD_OUT_HIGH);
> +       if (IS_ERR(priv->demod_gpio)) {
> +               dev_err(dev, "Failed to request demod_gpio: %ld\n",
> +                       PTR_ERR(priv->demod_gpio));
> +               return PTR_ERR(priv->demod_gpio);
> +       }
> +
> +       node = of_parse_phandle(dev->of_node, "demod-i2c-bus", 0);
> +       if (!node) {
> +               dev_err(dev, "Failed to parse demod-i2c-bus\n");
> +               return -ENODEV;
> +       }
> +
> +       priv->demod_i2c_adapter = of_find_i2c_adapter_by_node(node);
> +       if (!priv->demod_i2c_adapter) {
> +               dev_err(dev, "Failed to find demod i2c adapter\n");
> +               of_node_put(node);
> +               return -ENODEV;
> +       }
> +       of_node_put(node);
> +
> +       mn884433_conf[0].reset_gpio = priv->demod_gpio;
> +       for (i = 0; i < spec->adapters; i++) {
> +               struct i2c_client *c;
> +
> +               mn884433_conf[i].mclk = priv->demod_mclk;
> +               mn884433_conf[i].fe = &priv->fe[i].fe;
> +
> +               c = dvb_module_probe(spec->demod_i2c_info[i].type, NULL,
> +                                    priv->demod_i2c_adapter,
> +                                    spec->demod_i2c_info[i].addr,
> +                                    &mn884433_conf[i]);
> +               if (!c) {
> +                       dev_err(dev, "Failed to probe demod\n");
> +                       ret = -ENODEV;
> +                       goto err_out;
> +               }
> +               priv->fe[i].demod_i2c = c;
> +       }
> +
> +       return 0;
> +
> +err_out:
> +       for (i = 0; i < spec->adapters; i++)
> +               dvb_module_release(priv->fe[i].demod_i2c);
> +
> +       return ret;
> +}
> +
> +static struct helene_config helene_conf[] = {
> +       { .xtal = SONY_HELENE_XTAL_16000, },
> +       { .xtal = SONY_HELENE_XTAL_16000, },
> +};
> +
> +static int uniphier_adapter_tuner_probe(struct uniphier_adapter_priv *priv)
> +{
> +       const struct uniphier_adapter_spec *spec = priv->spec;
> +       struct device *dev = &priv->pdev->dev;
> +       struct device_node *node;
> +       int ret, i;
> +
> +       priv->tuner_gpio = devm_gpiod_get_optional(dev, "reset-tuner",
> +                                                  GPIOD_OUT_HIGH);
> +       if (IS_ERR(priv->tuner_gpio)) {
> +               dev_err(dev, "Failed to request tuner_gpio: %ld\n",
> +                       PTR_ERR(priv->tuner_gpio));
> +               return PTR_ERR(priv->tuner_gpio);
> +       }
> +       gpiod_set_value_cansleep(priv->tuner_gpio, 0);
> +
> +       node = of_parse_phandle(dev->of_node, "tuner-i2c-bus", 0);
> +       if (!node) {
> +               dev_err(dev, "Failed to parse tuner-i2c-bus\n");
> +               return -ENODEV;
> +       }
> +
> +       priv->tuner_i2c_adapter = of_find_i2c_adapter_by_node(node);
> +       if (!priv->tuner_i2c_adapter) {
> +               dev_err(dev, "Failed to find tuner i2c adapter\n");
> +               of_node_put(node);
> +               return -ENODEV;
> +       }
> +       of_node_put(node);
> +
> +       for (i = 0; i < priv->spec->adapters; i++) {
> +               struct i2c_client *c;
> +
> +               helene_conf[i].fe = priv->fe[i].fe;
> +
> +               c = dvb_module_probe(spec->tuner_i2c_info[i].type, NULL,
> +                                    priv->tuner_i2c_adapter,
> +                                    spec->tuner_i2c_info[i].addr,
> +                                    &helene_conf[i]);
> +               if (!c) {
> +                       dev_err(dev, "Failed to probe tuner\n");
> +                       ret = -ENODEV;
> +                       goto err_out;
> +               }
> +               priv->fe[i].tuner_i2c = c;
> +       }
> +
> +       return 0;
> +
> +err_out:
> +       for (i = 0; i < spec->adapters; i++)
> +               dvb_module_release(priv->fe[i].tuner_i2c);
> +
> +       return ret;
> +}
> +
> +static int uniphier_adapter_probe(struct platform_device *pdev)
> +{
> +       struct uniphier_adapter_priv *priv;
> +       struct device *dev = &pdev->dev;
> +       int i, ret;
> +
> +       priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +       priv->pdev = pdev;
> +
> +       priv->spec = of_device_get_match_data(dev);
> +       if (!priv->spec)
> +               return -EINVAL;
> +
> +       priv->fe = devm_kzalloc(dev, sizeof(*priv->fe) * priv->spec->adapters,
> +                               GFP_KERNEL);
> +       if (!priv->fe)
> +               return -ENOMEM;
> +
> +       ret = uniphier_adapter_demux_probe(priv);
> +       if (ret)
> +               return ret;
> +
> +       ret = uniphier_adapter_demod_probe(priv);
> +       if (ret)
> +               return ret;
> +
> +       ret = uniphier_adapter_tuner_probe(priv);
> +       if (ret)
> +               return ret;
> +
> +       platform_set_drvdata(pdev, priv);
> +
> +       for (i = 0; i < priv->spec->adapters; i++) {
> +               priv->chip->tsif[i].fe = priv->fe[i].fe;
> +
> +               ret = hsc_register_dvb(&priv->chip->tsif[i]);
> +               if (ret) {
> +                       dev_err(dev, "Failed to register adapter\n");
> +                       goto err_out_if;
> +               }
> +       }
> +
> +       return 0;
> +
> +err_out_if:
> +       for (i = 0; i < priv->spec->adapters; i++)
> +               hsc_unregister_dvb(&priv->chip->tsif[i]);
> +
> +       return ret;
> +}
> +
> +static int uniphier_adapter_remove(struct platform_device *pdev)
> +{
> +       struct uniphier_adapter_priv *priv = platform_get_drvdata(pdev);
> +       int i;
> +
> +       for (i = 0; i < priv->spec->adapters; i++) {
> +               hsc_dmaif_release(&priv->chip->dmaif[i]);
> +               hsc_tsif_release(&priv->chip->tsif[i]);
> +               hsc_unregister_dvb(&priv->chip->tsif[i]);
> +               dvb_module_release(priv->fe[i].tuner_i2c);
> +               dvb_module_release(priv->fe[i].demod_i2c);
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct hsc_conf ld11_hsc_conf[] = {
> +       {
> +               .css_in = HSC_CSS_IN_SRLTS0,
> +               .css_out = HSC_CSS_OUT_TSI0,
> +               .dpll = HSC_DPLL0,
> +               .dma_out = HSC_DMA_OUT0,
> +       },
> +};
> +
> +static const struct i2c_board_info mn884433_i2c_info[] = {
> +       { .type = "mn884433", .addr = 0x68, },
> +};
> +
> +static const struct i2c_board_info helene_i2c_info[] = {
> +       { .type = "helene", .addr = 0x61, },
> +};
> +
> +static const struct uniphier_adapter_spec ld11_mn884433_helene_spec = {
> +       .adapters = 1,
> +       .hsc_conf = ld11_hsc_conf,
> +       .demod_i2c_info = mn884433_i2c_info,
> +       .tuner_i2c_info = helene_i2c_info,
> +};
> +
> +static const struct of_device_id uniphier_hsc_adapter_of_match[] = {
> +       {
> +               .compatible = "socionext,uniphier-ld11-mn884433-helene",
> +               .data = &ld11_mn884433_helene_spec,
> +       },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, uniphier_hsc_adapter_of_match);
> +
> +static struct platform_driver uniphier_hsc_adapter_driver = {
> +       .driver = {
> +               .name = "uniphier-ld11-isdb",
> +               .of_match_table = of_match_ptr(uniphier_hsc_adapter_of_match),
> +       },
> +       .probe  = uniphier_adapter_probe,
> +       .remove = uniphier_adapter_remove,
> +};
> +module_platform_driver(uniphier_hsc_adapter_driver);
> +
> +MODULE_AUTHOR("Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>");
> +MODULE_DESCRIPTION("UniPhier LD11 adapter driver for ISDB.");
> +MODULE_LICENSE("GPL v2");
> --
> 2.17.0
>



-- 
Best Regards
Masahiro Yamada
