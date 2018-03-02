Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52247 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425094AbeCBJ06 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 04:26:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: Re: [PATCH v11 02/32] dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
Date: Fri, 02 Mar 2018 11:27:46 +0200
Message-ID: <1719311.F07ah6zKn5@avalon>
In-Reply-To: <20180302015751.25596-3-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se> <20180302015751.25596-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 March 2018 03:57:21 EET Niklas S=F6derlund wrote:
> From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
>=20
> Add compatible strings for r8a7743 and r8a7745. No driver change
> is needed as "renesas,rcar-gen2-vin" will activate the right code.
> However, it is good practice to document compatible strings for the
> specific SoC as this allows SoC specific changes to the driver if
> needed, in addition to document SoC support and therefore allow
> checkpatch.pl to validate compatible string values.
>=20
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> Acked-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt
> b/Documentation/devicetree/bindings/media/rcar_vin.txt index
> 0ac715a5c331bc26..c60e6b0a89b67a8c 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -6,6 +6,8 @@ family of devices. The current blocks are always slaves a=
nd
> suppot one input channel which can be either RGB, YUYV or BT656.
>=20
>   - compatible: Must be one or more of the following
> +   - "renesas,vin-r8a7743" for the R8A7743 device
> +   - "renesas,vin-r8a7745" for the R8A7745 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
>     - "renesas,vin-r8a7790" for the R8A7790 device
> @@ -14,7 +16,8 @@ channel which can be either RGB, YUYV or BT656.
>     - "renesas,vin-r8a7793" for the R8A7793 device
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7795" for the R8A7795 device
> -   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
> +   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
> +     device.
>     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
>=20
>     When compatible with the generic version nodes must list the

=2D-=20
Regards,

Laurent Pinchart
