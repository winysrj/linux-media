Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:42300 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbeD3HkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 03:40:21 -0400
Date: Mon, 30 Apr 2018 09:40:17 +0200
From: Simon Horman <horms@verge.net.au>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: geert@linux-m68k.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: media: renesas-ceu: Add R-Mobile
 R8A7740
Message-ID: <20180430074017.sl2uav7hxc4rjsqe@verge.net.au>
References: <1524767083-19862-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524767083-19862-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524767083-19862-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 08:24:42PM +0200, Jacopo Mondi wrote:
> Add R-Mobile A1 R8A7740 SoC to the list of compatible values for the CEU
> unit.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  Documentation/devicetree/bindings/media/renesas,ceu.txt | 7 ++++---
>  drivers/media/platform/renesas-ceu.c                    | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> index 3fc66df..8a7a616 100644
> --- a/Documentation/devicetree/bindings/media/renesas,ceu.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> @@ -2,14 +2,15 @@ Renesas Capture Engine Unit (CEU)
>  ----------------------------------------------
>  
>  The Capture Engine Unit is the image capture interface found in the Renesas
> -SH Mobile and RZ SoCs.
> +SH Mobile, R-Mobile and RZ SoCs.
>  
>  The interface supports a single parallel input with data bus width of 8 or 16
>  bits.
>  
>  Required properties:
> -- compatible: Shall be "renesas,r7s72100-ceu" for CEU units found in RZ/A1H
> -  and RZ/A1M SoCs.
> +- compatible: Shall be one of the following values:
> +	"renesas,r7s72100-ceu" for CEU units found in RZ/A1H and RZ/A1M SoCs
> +	"renesas,r8a7740-ceu" for CEU units found in R-Mobile A1 R8A7740 SoCs

Nit: I think you can drop R8A7740 as I believe that by adding it to
R-Mobile A1 you have constructed a tautology (I mean "R-Mobile A1" =
"R8A7740" as far as I know).

>  - reg: Registers address base and size.
>  - interrupts: The interrupt specifier.
>  
> diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
> index 6599dba..c964a56 100644
> --- a/drivers/media/platform/renesas-ceu.c
> +++ b/drivers/media/platform/renesas-ceu.c
> @@ -1545,6 +1545,7 @@ static const struct ceu_data ceu_data_sh4 = {
>  #if IS_ENABLED(CONFIG_OF)
>  static const struct of_device_id ceu_of_match[] = {
>  	{ .compatible = "renesas,r7s72100-ceu", .data = &ceu_data_rz },
> +	{ .compatible = "renesas,r8a7740-ceu", .data = &ceu_data_rz },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, ceu_of_match);
> -- 
> 2.7.4
> 
