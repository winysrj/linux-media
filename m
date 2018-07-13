Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:45055 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729323AbeGMHpZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 03:45:25 -0400
Date: Fri, 13 Jul 2018 09:31:59 +0200
From: Simon Horman <horms@verge.net.au>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: hverkuil@xs4all.nl, geert@linux-m68k.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND] dt-bindings: media: rcar-vin: Add R8A77995 support
Message-ID: <20180713073159.6q6xlfkpteiaj35e@verge.net.au>
References: <1530694296-6417-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1530694296-6417-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 04, 2018 at 10:51:36AM +0200, Jacopo Mondi wrote:
> Add compatible string for R-Car D3 R8A7795 to list of SoCs supported by
> rcar-vin driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> ---
> 
> Re-sending to have this collected with the following series:
> [PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3

Jacopo,

Can I pick up the related DTS patches once this one is accepted
into the media-tree? If so, please ping me once that happens.

> 
> Thanks
>   j
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index a19517e1..5c6f2a7 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -22,6 +22,7 @@ on Gen3 platforms to a CSI-2 receiver.
>     - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,vin-r8a7796" for the R8A7796 device
>     - "renesas,vin-r8a77970" for the R8A77970 device
> +   - "renesas,vin-r8a77995" for the R8A77995 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
>       device.
> 
> --
> 2.7.4
> 
