Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25605C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 13:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A3B21906
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 13:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390536AbeLUNA2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 08:00:28 -0500
Received: from mail.bootlin.com ([62.4.15.54]:58820 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390437AbeLUNA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 08:00:28 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 9C429207D4; Fri, 21 Dec 2018 14:00:25 +0100 (CET)
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.bootlin.com (Postfix) with ESMTPSA id 6B9FC207AD;
        Fri, 21 Dec 2018 14:00:25 +0100 (CET)
Date:   Fri, 21 Dec 2018 14:00:25 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: Re: [PATCH v5 2/6] media: sun6i: Add mod_rate quirk
Message-ID: <20181221130025.lbvw7yvy74brf3jn@flea>
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
 <20181220125438.11700-3-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20181220125438.11700-3-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 20, 2018 at 06:24:34PM +0530, Jagan Teki wrote:
> Unfortunately default CSI_SCLK rate cannot work properly to
> drive the connected sensor interface, particularly on few
> Allwinner SoC's like A64.
> 
> So, add mod_rate quirk via driver data so-that the respective
> SoC's which require to alter the default mod clock rate can assign
> the operating clock rate.
> 
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> ---
>  .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 34 +++++++++++++++----
>  1 file changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> index ee882b66a5ea..fe002beae09c 100644
> --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> @@ -15,6 +15,7 @@
>  #include <linux/ioctl.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/regmap.h>
> @@ -28,8 +29,13 @@
>  
>  #define MODULE_NAME	"sun6i-csi"
>  
> +struct sun6i_csi_variant {
> +	unsigned long			mod_rate;
> +};
> +
>  struct sun6i_csi_dev {
>  	struct sun6i_csi		csi;
> +	const struct sun6i_csi_variant	*variant;
>  	struct device			*dev;
>  
>  	struct regmap			*regmap;
> @@ -822,33 +828,43 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
>  		return PTR_ERR(sdev->clk_mod);
>  	}
>  
> +	if (sdev->variant->mod_rate)
> +		clk_set_rate_exclusive(sdev->clk_mod, sdev->variant->mod_rate);
> +

It still doesn't make any sense to do it in the probe function...

We discussed this in the previous iteration already.

What we didn't discuss is the variant function that you introduce,
while the previous approach was enough.

Maxime

-- 
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
