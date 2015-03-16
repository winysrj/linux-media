Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43630 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbbCPAQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:16:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] arm: dts: omap3: Extend the syscon register range
Date: Mon, 16 Mar 2015 02:16:31 +0200
Message-ID: <1471279.pvvs0tPUUG@avalon>
In-Reply-To: <1426464080-29119-2-git-send-email-sakari.ailus@iki.fi>
References: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi> <1426464080-29119-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 16 March 2015 02:01:17 Sakari Ailus wrote:
> The OMAP 3630 syscon register set was missing
> OMAP3630_CONTROL_CAMERA_PHY_CTRL register at offset 0x2f0. This register
> used to be mapped directly by the omap3isp driver, which is now moving to
> use syscon instead. The omap3isp driver did not support DT so no driver
> change is needed in this patch.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm/boot/dts/omap3.dtsi |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> index 01b7111..fe0b293 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -183,7 +183,7 @@
> 
>  		omap3_scm_general: tisyscon@48002270 {
>  			compatible = "syscon";
> -			reg = <0x48002270 0x2f0>;
> +			reg = <0x48002270 0x2f4>;
>  		};
> 
>  		pbias_regulator: pbias_regulator {

-- 
Regards,

Laurent Pinchart

