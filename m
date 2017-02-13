Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:34291 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbdBMSgR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 13:36:17 -0500
Received: by mail-ot0-f169.google.com with SMTP id f9so75118002otd.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 10:36:17 -0800 (PST)
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
Subject: Re: [PATCH 07/10] ARM: davinci: fix a whitespace error
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-8-git-send-email-bgolaszewski@baylibre.com>
Date: Mon, 13 Feb 2017 10:36:10 -0800
In-Reply-To: <1486485683-11427-8-git-send-email-bgolaszewski@baylibre.com>
        (Bartosz Golaszewski's message of "Tue, 7 Feb 2017 17:41:20 +0100")
Message-ID: <m2o9y6djl1.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> There's a stray tab in da850_vpif_legacy_init(). Remove it.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Folding into the original,

Kevin

> ---
>  arch/arm/mach-davinci/pdata-quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
> index a186513..94948c1 100644
> --- a/arch/arm/mach-davinci/pdata-quirks.c
> +++ b/arch/arm/mach-davinci/pdata-quirks.c
> @@ -111,7 +111,7 @@ static struct vpif_capture_config da850_vpif_capture_config = {
>  static void __init da850_vpif_legacy_init(void)
>  {
>  	int ret;
> -	
> +
>  	/* LCDK doesn't have the 2nd TVP514x on CH1 */
>  	if (of_machine_is_compatible("ti,da850-lcdk"))
>  		da850_vpif_capture_config.subdev_count = 1;
