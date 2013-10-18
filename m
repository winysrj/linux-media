Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58322 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3JRJOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 05:14:10 -0400
Message-id: <5260FBDD.4020205@samsung.com>
Date: Fri, 18 Oct 2013 11:14:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, 'Arun Kumar K' <arun.kk@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, posciak@google.com,
	inki.dae@samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v4 4/4] [media] exynos-scaler: Add DT bindings for SCALER
 driver
References: <1380889594-10448-1-git-send-email-shaik.ameer@samsung.com>
 <1380889594-10448-5-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1380889594-10448-5-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/13 14:26, Shaik Ameer Basha wrote:
> This patch adds the DT binding documentation for the
> Exynos5420/5410 based SCALER device driver.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  .../devicetree/bindings/media/exynos5-scaler.txt   |   22 ++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
> new file mode 100644
> index 0000000..f620baf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
> @@ -0,0 +1,22 @@
> +* Samsung Exynos5 SCALER device
> +
> +SCALER is used for scaling, blending, color fill and color space
> +conversion on EXYNOS[5420/5410] SoCs.
> +
> +Required properties:
> +- compatible: should be "samsung,exynos5420-scaler" or
> +			"samsung,exynos5410-scaler"
> +- reg: should contain SCALER physical address location and length.

nit: the dot should be probably removed for consistency.

> +- interrupts: should contain SCALER interrupt number
> +- clocks: should contain the SCALER clock specifier, from the
> +			common clock bindings
> +- clock-names: should be "scaler"
> +
> +Example:
> +	scaler_0: scaler@0x12800000 {

There should be no '0x' in node name.

> +		compatible = "samsung,exynos5420-scaler";
> +		reg = <0x12800000 0x1000>;
> +		interrupts = <0 220 0>;
> +		clocks = <&clock 381>;
> +		clock-names = "scaler";
> +	};
> 

Thanks,
Sylwester

