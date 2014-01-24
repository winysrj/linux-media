Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41427 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAXQKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 11:10:11 -0500
Message-id: <52E29051.3070906@samsung.com>
Date: Fri, 24 Jan 2014 17:09:53 +0100
From: Tomasz Figa <t.figa@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.nawrocki@samsung.com, posciak@google.com, hverkuil@xs4all.nl,
	m.chehab@samsung.com
Subject: Re: [PATCH v5 4/4] [media] exynos-scaler: Add DT bindings for SCALER
 driver
References: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
 <1389238094-19386-5-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1389238094-19386-5-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 09.01.2014 04:28, Shaik Ameer Basha wrote:
> This patch adds the DT binding documentation for the
> Exynos5420/5410 based SCALER device driver.
>
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>   .../devicetree/bindings/media/exynos5-scaler.txt   |   22 ++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
> new file mode 100644
> index 0000000..9328e7d
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
> +- reg: should contain SCALER physical address location and length
> +- interrupts: should contain SCALER interrupt number

s/number/specifier/

> +- clocks: should contain the SCALER clock specifier, from the
> +			common clock bindings

s/specifier/phandle and specifier pair for each clock listed in 
clock-names property/

s/from/according to/

> +- clock-names: should be "scaler"

should contain exactly one entry:
  - "scaler" - IP bus clock.

Also this patch should be first in the series to let the driver added in 
further patches use already present bindings.

Best regards,
Tomasz
