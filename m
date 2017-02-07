Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:36337 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754951AbdBGSQq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 13:16:46 -0500
Received: by mail-pg0-f47.google.com with SMTP id v184so40687549pgv.3
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 10:16:46 -0800 (PST)
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
Subject: Re: [PATCH 09/10] media: vpif: use a configurable i2c_adapter_id for vpif display
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-10-git-send-email-bgolaszewski@baylibre.com>
Date: Tue, 07 Feb 2017 10:16:44 -0800
In-Reply-To: <1486485683-11427-10-git-send-email-bgolaszewski@baylibre.com>
        (Bartosz Golaszewski's message of "Tue, 7 Feb 2017 17:41:22 +0100")
Message-ID: <m2r339kgs3.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> The vpif display driver uses a static i2c adapter ID of 1 but on the
> da850-evm board in DT boot mode the i2c adapter ID is actually 0.
>
> Make the adapter ID configurable like it already is for vpif capture.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Acked-by: Kevin Hilman <khilman@baylibre.com>

> ---
>  arch/arm/mach-davinci/board-da850-evm.c       | 1 +
>  drivers/media/platform/davinci/vpif_display.c | 2 +-
>  include/media/davinci/vpif_types.h            | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index e5d4ded..fe0bfa7 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1290,6 +1290,7 @@ static struct vpif_display_config da850_vpif_display_config = {
>  		.output_count = ARRAY_SIZE(da850_ch0_outputs),
>  	},
>  	.card_name    = "DA850/OMAP-L138 Video Display",
> +	.i2c_adapter_id = 1,
>  };
>  
>  static __init void da850_vpif_init(void)
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 50c3073..7e5cf99 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1287,7 +1287,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>  	}
>  
>  	if (!vpif_obj.config->asd_sizes) {
> -		i2c_adap = i2c_get_adapter(1);
> +		i2c_adap = i2c_get_adapter(vpif_obj.config->i2c_adapter_id);
>  		for (i = 0; i < subdev_count; i++) {
>  			vpif_obj.sd[i] =
>  				v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
> diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
> index 4282a7d..0c72b46 100644
> --- a/include/media/davinci/vpif_types.h
> +++ b/include/media/davinci/vpif_types.h
> @@ -57,6 +57,7 @@ struct vpif_display_config {
>  	int (*set_clock)(int, int);
>  	struct vpif_subdev_info *subdevinfo;
>  	int subdev_count;
> +	int i2c_adapter_id;
>  	struct vpif_display_chan_config chan_config[VPIF_DISPLAY_MAX_CHANNELS];
>  	const char *card_name;
>  	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
