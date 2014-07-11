Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45720 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaGKOCG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 10:02:06 -0400
Message-id: <53BFEE5A.40306@samsung.com>
Date: Fri, 11 Jul 2014 16:02:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, linux-samsung-soc@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 9/9] ARM: dts: exynos3250: add JPEG codec device node
References: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
 <1404750730-22996-10-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1404750730-22996-10-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/14 18:32, Jacek Anaszewski wrote:
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: devicetree@vger.kernel.org
> ---
>  arch/arm/boot/dts/exynos3250.dtsi |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 3e678fa..351871a 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -206,6 +206,18 @@
>  			interrupts = <0 240 0>;
>  		};
>  
> +		jpeg-codec@11830000 {
> +			compatible = "samsung,exynos3250-jpeg";
> +			reg = <0x11830000 0x1000>;
> +			interrupts = <0 171 0>;
> +			clocks = <&cmu CLK_JPEG>, <&cmu CLK_SCLK_JPEG>;
> +			clock-names = "jpeg", "sclk-jpeg";
> +			samsung,power-domain = <&pd_cam>;
> +			assigned-clock-parents = <&cmu CLK_MOUT_CAM_BLK &cmu CLK_DIV_MPLL_PRE>,
> +						 <&cmu CLK_SCLK_JPEG &cmu>;
> +			assigned-clock-rates = <&cmu CLK_SCLK_JPEG 150000000>;

There is no support for the assigned-clock-parents/assigned-clock-rates
in mainline yet unfortunately. I would suggest removing these two properties
for now. And please send this patch to relevant maintainer, i.e. Kukjin Kim.

> +		};

Thanks,
Sylwester
