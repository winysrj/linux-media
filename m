Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaFKF4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 01:56:18 -0400
Date: Wed, 11 Jun 2014 07:56:16 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>
Subject: Re: [PATCH 30/43] ARM: dts: imx6: add pin groups for imx6q/dl for
 IPU1 CSI0
Message-ID: <20140611055616.GB664@pengutronix.de>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
 <1402178205-22697-31-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402178205-22697-31-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 07, 2014 at 02:56:32PM -0700, Steve Longerbeam wrote:
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
> ---
>  arch/arm/boot/dts/imx6qdl.dtsi |   52 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index 04c978c..d793cd6 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -664,6 +664,58 @@
>  			iomuxc: iomuxc@020e0000 {
>  				compatible = "fsl,imx6dl-iomuxc", "fsl,imx6q-iomuxc";
>  				reg = <0x020e0000 0x4000>;
> +
> +				ipu1 {
> +					pinctrl_ipu1_csi0_d4_d7: ipu1-csi0-d4-d7 {
> +						fsl,pins = <
> +							MX6QDL_PAD_CSI0_DAT4__IPU1_CSI0_DATA04 0x80000000
> +							MX6QDL_PAD_CSI0_DAT5__IPU1_CSI0_DATA05 0x80000000
> +							MX6QDL_PAD_CSI0_DAT6__IPU1_CSI0_DATA06 0x80000000
> +							MX6QDL_PAD_CSI0_DAT7__IPU1_CSI0_DATA07 0x80000000
> +						>;
> +					};

We no longer have the pinctrl groups in the SoC dts files. Please put
them into the boards instead.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
