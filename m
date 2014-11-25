Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40865 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaKYQ5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 11:57:52 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so887798ieb.7
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 08:57:51 -0800 (PST)
Date: Tue, 25 Nov 2014 16:57:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141125165744.GA17789@x1>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
 <1416749895-25013-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416749895-25013-4-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 23 Nov 2014, Hans de Goede wrote:

> Add a driver for mod0 clocks found in the prcm. Currently there is only
> one mod0 clocks in the prcm, the ir clock.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>  drivers/clk/sunxi/Makefile                        |  2 +-
>  drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 +++++++++++++++++++++++
>  drivers/mfd/sun6i-prcm.c                          | 14 +++++
>  4 files changed, 79 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c

[...]

> diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
> index 283ab8d..ff1254f 100644
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

I'm not overly keen on these magic numbers (and yes, I'm well aware
that I SoB'ed the patch which started them off).

It's not a show stopper, although I'd prefer if they were fixed with a
subsequent patch.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
