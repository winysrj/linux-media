Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35313 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754498AbdBGSVX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 13:21:23 -0500
Received: by mail-pg0-f47.google.com with SMTP id 194so40767341pgd.2
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 10:21:21 -0800 (PST)
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
Subject: Re: [PATCH 08/10] ARM: davinci: fix the DT boot on da850-evm
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-9-git-send-email-bgolaszewski@baylibre.com>
Date: Tue, 07 Feb 2017 10:21:19 -0800
In-Reply-To: <1486485683-11427-9-git-send-email-bgolaszewski@baylibre.com>
        (Bartosz Golaszewski's message of "Tue, 7 Feb 2017 17:41:21 +0100")
Message-ID: <m2fujpkgkg.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> When we enable vpif capture on the da850-evm we hit a BUG_ON() because
> the i2c adapter can't be found. The board file boot uses i2c adapter 1
> but in the DT mode it's actually adapter 0. Drop the problematic lines.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  arch/arm/mach-davinci/pdata-quirks.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
> index 94948c1..09f62ac 100644
> --- a/arch/arm/mach-davinci/pdata-quirks.c
> +++ b/arch/arm/mach-davinci/pdata-quirks.c
> @@ -116,10 +116,6 @@ static void __init da850_vpif_legacy_init(void)
>  	if (of_machine_is_compatible("ti,da850-lcdk"))
>  		da850_vpif_capture_config.subdev_count = 1;
>  
> -	/* EVM (UI card) uses i2c adapter 1 (not default: zero) */
> -	if (of_machine_is_compatible("ti,da850-evm"))
> -		da850_vpif_capture_config.i2c_adapter_id = 1;
> -

oops, my bad.

Acked-by: Kevin Hilman <khilman@baylibre.com>

>  	ret = da850_register_vpif_capture(&da850_vpif_capture_config);
>  	if (ret)
>  		pr_warn("%s: VPIF capture setup failed: %d\n",
