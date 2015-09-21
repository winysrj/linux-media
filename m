Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45939 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbbIUJuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 05:50:21 -0400
Subject: Re: [PATCH 4/4] ARM64: dts: exynos5433: add jpeg node
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <1442586060-23657-5-git-send-email-andrzej.p@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <55FFD2D2.1010508@xs4all.nl>
Date: Mon, 21 Sep 2015 11:50:10 +0200
MIME-Version: 1.0
In-Reply-To: <1442586060-23657-5-git-send-email-andrzej.p@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18-09-15 16:21, Andrzej Pietrasiewicz wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Add Exynos 5433 jpeg h/w codec node.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> ---
>  arch/arm64/boot/dts/exynos/exynos5433.dtsi | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi

This dtsi file doesn't exist in the media-git tree. What is the story here?

Should this go through a different subsystem?

I think the media subsystem can take patches 1-3 and whoever does DT patches can
take this patch, right?

Regards,

	Hans

> index 59e21b6..5cb489f 100644
> --- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> @@ -916,6 +916,27 @@
>  			io-channel-ranges;
>  			status = "disabled";
>  		};
> +		jpeg: jpeg@15020000 {
> +			compatible = "samsung,exynos5433-jpeg";
> +			reg = <0x15020000 0x10000>;
> +			interrupts = <0 411 0>;
> +			clock-names = "pclk",
> +				      "aclk",
> +				      "aclk_xiu",
> +				      "sclk";
> +			clocks = <&cmu_mscl CLK_PCLK_JPEG>,
> +				 <&cmu_mscl CLK_ACLK_JPEG>,
> +				 <&cmu_mscl CLK_ACLK_XIU_MSCLX>,
> +				 <&cmu_mscl CLK_SCLK_JPEG>;
> +			assigned-clocks = <&cmu_mscl CLK_MOUT_ACLK_MSCL_400_USER>,
> +					  <&cmu_mscl CLK_MOUT_SCLK_JPEG_USER>,
> +					  <&cmu_mscl CLK_MOUT_SCLK_JPEG>,
> +					  <&cmu_top CLK_MOUT_SCLK_JPEG_A>;
> +			assigned-clock-parents = <&cmu_top CLK_ACLK_MSCL_400>,
> +						 <&cmu_top CLK_SCLK_JPEG_MSCL>,
> +						 <&cmu_mscl CLK_MOUT_SCLK_JPEG_USER>,
> +						 <&cmu_top CLK_MOUT_BUS_PLL_USER>;
> +		};
>  	};
>  
>  	timer {
> 
