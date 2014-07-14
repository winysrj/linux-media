Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36116 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbaGNJ46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 05:56:58 -0400
Date: Mon, 14 Jul 2014 10:56:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
	"andrzej.p@samsung.com" <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] Documentation: devicetree: Document sclk-jpeg
 clock for exynos3250 SoC
Message-ID: <20140714095640.GC4980@leverpostej>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
 <1405091990-28567-9-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405091990-28567-9-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 11, 2014 at 04:19:49PM +0100, Jacek Anaszewski wrote:
> JPEG IP on Exynos3250 SoC requires enabling two clock
> gates for its operation. This patch documents this
> requirement.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: devicetree@vger.kernel.org
> ---
>  .../bindings/media/exynos-jpeg-codec.txt           |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> index 937b755..3142745 100644
> --- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> +++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> @@ -3,9 +3,12 @@ Samsung S5P/EXYNOS SoC series JPEG codec
>  Required properties:
>  
>  - compatible	: should be one of:
> -		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg";
> +		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
> +		  "samsung,exynos3250-jpeg";
>  - reg		: address and length of the JPEG codec IP register set;
>  - interrupts	: specifies the JPEG codec IP interrupt;
> -- clocks	: should contain the JPEG codec IP gate clock specifier, from the
> +- clocks	: should contain the JPEG codec IP gate clock specifier and
> +		  for the Exynos3250 SoC additionally the SCLK_JPEG entry; from the
>  		  common clock bindings;
> -- clock-names	: should contain "jpeg" entry.
> +- clock-names	: should contain "jpeg" entry and additionally "sclk-jpeg" entry
> +		  for Exynos3250 SoC

Please turn this into a list for easier reading, e.g.

- clock-names: should contain:
  * "jpeg" for the gate clock.
  * "sclk-jpeg" for the SCLK_JPEG clock (only for Exynos3250).

You could also define clocks in terms of clock-names to avoid
redundancy.

The SCLK_JPEG name sounds like a global name for the clock. Is there a
name for the input line on the JPEG block this is plugged into?

Thanks,
Mark.
