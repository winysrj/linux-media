Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:56907 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754261AbeEWIvR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 04:51:17 -0400
Date: Wed, 23 May 2018 10:51:12 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: dt-bindings: media: rcar_vin: add support for
 r8a77965
Message-ID: <20180523085111.gud5b2652vkvbgoq@verge.net.au>
References: <20180513185818.15359-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180513185818.15359-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 13, 2018 at 08:58:18PM +0200, Niklas Söderlund wrote:
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index a19517e1c669eb35..c2c57dcf73f4851b 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -21,6 +21,7 @@ on Gen3 platforms to a CSI-2 receiver.
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,vin-r8a7796" for the R8A7796 device
> +   - "renesas,vin-r8a77965" for the R8A77965 device
>     - "renesas,vin-r8a77970" for the R8A77970 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
>       device.
> -- 
> 2.17.0
> 
