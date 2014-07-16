Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54549 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaGPA3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 20:29:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: set 'ti,set-rate-parent' for dpll4_m5x2 clock
Date: Wed, 16 Jul 2014 02:29:41 +0200
Message-ID: <3350943.lsAUHoxgP5@avalon>
In-Reply-To: <1405418556-7030-1-git-send-email-stefan@herbrechtsmeier.net>
References: <1405418556-7030-1-git-send-email-stefan@herbrechtsmeier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Thank you for the patch.

On Tuesday 15 July 2014 12:02:35 Stefan Herbrechtsmeier wrote:
> Set 'ti,set-rate-parent' property for the dpll4_m5x2_ck clock, which
> is used for the ISP functional clock. This fixes the OMAP3 ISP driver's
> clock rate configuration on OMAP34xx, which needs the rate to be
> propagated properly to the divider node (dpll4_m5_ck).
> 
> Signed-off-by: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: <linux-media@vger.kernel.org>
> Cc: <linux-omap@vger.kernel.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Tero, could you please process it for v3.17 if time still permits ?

> ---
>  arch/arm/boot/dts/omap3xxx-clocks.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/omap3xxx-clocks.dtsi
> b/arch/arm/boot/dts/omap3xxx-clocks.dtsi index e47ff69..5c37500 100644
> --- a/arch/arm/boot/dts/omap3xxx-clocks.dtsi
> +++ b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
> @@ -467,6 +467,7 @@
>  		ti,bit-shift = <0x1e>;
>  		reg = <0x0d00>;
>  		ti,set-bit-to-disable;
> +		ti,set-rate-parent;
>  	};
> 
>  	dpll4_m6_ck: dpll4_m6_ck {

-- 
Regards,

Laurent Pinchart

