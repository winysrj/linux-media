Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:36624 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbeDZGNP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:13:15 -0400
Date: Wed, 25 Apr 2018 09:09:04 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: remove generic gen3 compatible string
Message-ID: <20180425070903.igvfju5o5mvvlmfd@verge.net.au>
References: <20180424234321.22367-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180424234321.22367-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 01:43:21AM +0200, Niklas Söderlund wrote:
> The compatible string "renesas,rcar-gen3-vin" was added before the
> Gen3 driver code was added but it's not possible to use. Each SoC in the
> Gen3 series require SoC specific knowledge in the driver to function.
> Remove it before it is added to any device tree descriptions.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index ba31431d4b1fbdbb..a19517e1c669eb35 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -24,7 +24,6 @@ on Gen3 platforms to a CSI-2 receiver.
>     - "renesas,vin-r8a77970" for the R8A77970 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
>       device.
> -   - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
>  
>     When compatible with the generic version nodes must list the
>     SoC-specific version corresponding to the platform first
> -- 
> 2.17.0
> 
