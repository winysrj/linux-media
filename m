Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:33626 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932131AbdBGSUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 13:20:50 -0500
Received: by mail-pg0-f50.google.com with SMTP id 204so40755700pge.0
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 10:20:50 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/10] ARM: davinci: add pdata-quirks for da850-evm vpif display
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-11-git-send-email-bgolaszewski@baylibre.com>
Date: Tue, 07 Feb 2017 10:20:48 -0800
In-Reply-To: <1486485683-11427-11-git-send-email-bgolaszewski@baylibre.com>
        (Bartosz Golaszewski's message of "Tue, 7 Feb 2017 17:41:23 +0100")
Message-ID: <m2k291kglb.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> Similarly to vpif capture: we need to register the vpif display driver
> and the corresponding adv7343 encoder in pdata-quirks as the DT
> support is not complete.

To add a bit more detail to the changelog:  DT support is not complete
since there isn't currently a way to define the output_routing in the
V4L2 drivers (c.f. s_routing) via DT.

> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

minor nit below, otherwise

Reviewed-by: Kevin Hilman <khilman@baylibre.com>

> ---
>  arch/arm/mach-davinci/pdata-quirks.c | 86 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 85 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
> index 09f62ac..0a55546 100644
> --- a/arch/arm/mach-davinci/pdata-quirks.c
> +++ b/arch/arm/mach-davinci/pdata-quirks.c
> @@ -9,13 +9,17 @@
>   */
>  #include <linux/kernel.h>
>  #include <linux/of_platform.h>
> +#include <linux/gpio.h>
>  
>  #include <media/i2c/tvp514x.h>
> +#include <media/i2c/adv7343.h>
>  
>  #include <mach/common.h>
>  #include <mach/da8xx.h>
>  #include <mach/mux.h>
>  
> +#define DA850_EVM_UI_EXP_SEL_VPIF_DISP 5
> +
>  struct pdata_init {
>  	const char *compatible;
>  	void (*fn)(void);
> @@ -107,7 +111,78 @@ static struct vpif_capture_config da850_vpif_capture_config = {
>  	},
>  	.card_name = "DA850/OMAP-L138 Video Capture",
>  };
> +#endif /* IS_ENABLED(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE) */
> +
> +#if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)

Why not IS_ENABLED(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE) also here?

> +static void vpif_evm_display_setup(void)
> +{
> +	int gpio = DAVINCI_N_GPIO + DA850_EVM_UI_EXP_SEL_VPIF_DISP, ret;
> +
> +	ret = gpio_request(gpio, "sel_c");
> +	if (ret) {
> +		pr_warn("Cannot open UI expander pin %d\n", gpio);
> +		return;
> +	}
> +
> +	gpio_direction_output(gpio, 0);
> +}
> +
> +static struct adv7343_platform_data adv7343_pdata = {
> +	.mode_config = {
> +		.dac = { 1, 1, 1 },
> +	},
> +	.sd_config = {
> +		.sd_dac_out = { 1 },
> +	},
> +};
> +
> +static struct vpif_subdev_info da850_vpif_subdev[] = {
> +	{
> +		.name = "adv7343",
> +		.board_info = {
> +			I2C_BOARD_INFO("adv7343", 0x2a),
> +			.platform_data = &adv7343_pdata,
> +		},
> +	},
> +};
>  
> +static const struct vpif_output da850_ch0_outputs[] = {
> +	{
> +		.output = {
> +			.index = 0,
> +			.name = "Composite",
> +			.type = V4L2_OUTPUT_TYPE_ANALOG,
> +			.capabilities = V4L2_OUT_CAP_STD,
> +			.std = V4L2_STD_ALL,
> +		},
> +		.subdev_name = "adv7343",
> +		.output_route = ADV7343_COMPOSITE_ID,
> +	},
> +	{
> +		.output = {
> +			.index = 1,
> +			.name = "S-Video",
> +			.type = V4L2_OUTPUT_TYPE_ANALOG,
> +			.capabilities = V4L2_OUT_CAP_STD,
> +			.std = V4L2_STD_ALL,
> +		},
> +		.subdev_name = "adv7343",
> +		.output_route = ADV7343_SVIDEO_ID,
> +	},
> +};
> +
> +static struct vpif_display_config da850_vpif_display_config = {
> +	.subdevinfo   = da850_vpif_subdev,
> +	.subdev_count = ARRAY_SIZE(da850_vpif_subdev),
> +	.chan_config[0] = {
> +		.outputs = da850_ch0_outputs,
> +		.output_count = ARRAY_SIZE(da850_ch0_outputs),
> +	},
> +	.card_name    = "DA850/OMAP-L138 Video Display",
> +};
> +#endif /* defined(CONFIG_DA850_UI_SD_VIDEO_PORT) */
> +
> +#if IS_ENABLED(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE) || defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
>  static void __init da850_vpif_legacy_init(void)
>  {
>  	int ret;
> @@ -120,8 +195,17 @@ static void __init da850_vpif_legacy_init(void)
>  	if (ret)
>  		pr_warn("%s: VPIF capture setup failed: %d\n",
>  			__func__, ret);
> +
> +	/* LCDK doesn't support VPIF display */
> +	if (of_machine_is_compatible("ti,da850-evm")) {
> +		vpif_evm_display_setup();
> +		ret = da850_register_vpif_display(&da850_vpif_display_config);
> +		if (ret)
> +			pr_warn("%s: VPIF display setup failed: %d\n",
> +				__func__, ret);
> +	}
>  }
> -#endif
> +#endif /* IS_ENABLED(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE) || defined(CONFIG_DA850_UI_SD_VIDEO_PORT) */
>  
>  static void pdata_quirks_check(struct pdata_init *quirks)
>  {
