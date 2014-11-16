Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaKPKJ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 05:09:57 -0500
Message-ID: <546877EF.8010906@suse.de>
Date: Sun, 16 Nov 2014 11:09:51 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	sakari.ailus@iki.fi, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141116075928.GA9763@amd>
In-Reply-To: <20141116075928.GA9763@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Am 16.11.2014 um 08:59 schrieb Pavel Machek:
> For device tree people: Yes, I know I'll have to create file in
> documentation, but does the binding below look acceptable?
[...]
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> index 739fcf2..ed0bfc1 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -553,6 +561,18 @@
>  
>  		ti,usb-charger-detection = <&isp1704>;
>  	};
> +
> +	adp1653: adp1653@30 {

This should probably be led-controller@30 (a generic description not
specific to the model). The label name is fine.

> +		compatible = "ad,adp1653";
> +		reg = <0x30>;
> +
> +		max-flash-timeout-usec = <500000>;
> +		max-flash-intensity-uA    = <320000>;
> +		max-torch-intensity-uA     = <50000>;
> +		max-indicator-intensity-uA = <17500>;
> +
> +		gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* Want 88 */

At least to me, the meaning of "Want 88" is not clear - drop or clarify?

> +	};
>  };
>  
>  &i2c3 {
[snip]

Regards,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N�rnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend�rffer; HRB 21284 AG N�rnberg
