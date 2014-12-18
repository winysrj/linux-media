Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:57668 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaLRIlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:41:35 -0500
Received: by mail-oi0-f52.google.com with SMTP id h136so88042oig.11
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 00:41:34 -0800 (PST)
Date: Thu, 18 Dec 2014 08:41:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 07/13] mfd: sun6i-prcm: Add support for the ir-clk
Message-ID: <20141218084129.GT13885@x1>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-8-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418836704-15689-8-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 17 Dec 2014, Hans de Goede wrote:

> Add support for the ir-clk which is part of the sun6i SoC prcm module.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/mfd/sun6i-prcm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Pretty standard stuff (

> diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
> index 2f2e9f0..1911731 100644
> --- a/drivers/mfd/sun6i-prcm.c
> +++ b/drivers/mfd/sun6i-prcm.c
> @@ -41,6 +41,14 @@ static const struct resource sun6i_a31_apb0_gates_clk_res[] = {
>  	},
>  };
>  
> +static const struct resource sun6i_a31_ir_clk_res[] = {
> +	{
> +		.start = 0x54,
> +		.end = 0x57,
> +		.flags = IORESOURCE_MEM,
> +	},
> +};

I'm still unkeen on this registers not being defined -- but whateveer!

>  static const struct resource sun6i_a31_apb0_rstc_res[] = {
>  	{
>  		.start = 0xb0,
> @@ -69,6 +77,12 @@ static const struct mfd_cell sun6i_a31_prcm_subdevs[] = {
>  		.resources = sun6i_a31_apb0_gates_clk_res,
>  	},
>  	{
> +		.name = "sun6i-a31-ir-clk",
> +		.of_compatible = "allwinner,sun4i-a10-mod0-clk",
> +		.num_resources = ARRAY_SIZE(sun6i_a31_ir_clk_res),
> +		.resources = sun6i_a31_ir_clk_res,
> +	},
> +	{
>  		.name = "sun6i-a31-apb0-clock-reset",
>  		.of_compatible = "allwinner,sun6i-a31-clock-reset",
>  		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_rstc_res),

This is all pretty standard stuff:

For my own reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

Do you do  you expect this patch to be handled?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
