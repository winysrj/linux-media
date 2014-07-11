Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45291 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaGKNyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 09:54:12 -0400
Message-id: <53BFEC80.2010307@samsung.com>
Date: Fri, 11 Jul 2014 15:54:08 +0200
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
Subject: Re: [PATCH 8/9] Documentation: devicetree: Document sclk-jpeg clock
 for exynos3250 SoC
References: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
 <1404750730-22996-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1404750730-22996-9-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/14 18:32, Jacek Anaszewski wrote:
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
> index 937b755..20cd150 100644
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
>  - clocks	: should contain the JPEG codec IP gate clock specifier, from the
> -		  common clock bindings;
> -- clock-names	: should contain "jpeg" entry.
> +		  common clock bindings; for Exynos3250 SoC special clock gate
> +		  should be defined as the second element of the clocks array

Entries in the clocks and clock-names can be in any order, the only
requirement normally is that they match. I would rephrase this to
something along the lines of:

 - clocks : should contain the JPEG codec IP gate clock specifier and
            for the Exynos3250 SoC additionally the SCLK_JPEG entry; from the
	    common clock bindings;

> +- clock-names	: should contain "jpeg" entry and additionally "sclk-jpeg" entry
> +		  for Exynos3250 SoC

--
Thanks,
Sylwester
