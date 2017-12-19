Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:21374 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1761795AbdLSKU1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 05:20:27 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: RE: [PATCH v2 2/4] dt-bindings: media: rcar_vin: add device tree
 support for r8a774[35]
Date: Tue, 19 Dec 2017 10:20:22 +0000
Message-ID: <TY1PR06MB0895A119ADABE34B06885F39C00F0@TY1PR06MB0895.apcprd06.prod.outlook.com>
References: <1510856571-30281-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1510856571-30281-3-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1510856571-30281-3-git-send-email-fabrizio.castro@bp.renesas.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

does this patch look ok to you?

Thanks,
Fab

> Subject: [PATCH v2 2/4] dt-bindings: media: rcar_vin: add device tree sup=
port for r8a774[35]
>
> Add compatible strings for r8a7743 and r8a7745. No driver change
> is needed as "renesas,rcar-gen2-vin" will activate the right code.
> However, it is good practice to document compatible strings for the
> specific SoC as this allows SoC specific changes to the driver if
> needed, in addition to document SoC support and therefore allow
> checkpatch.pl to validate compatible string values.
>
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das@bp.renesas.com>
> ---
> v1->v2:
> * Fixed double "change" in changelog
>
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Docum=
entation/devicetree/bindings/media/rcar_vin.txt
> index 98931f5..ff9697e 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -6,6 +6,8 @@ family of devices. The current blocks are always slaves a=
nd suppot one input
>  channel which can be either RGB, YUYV or BT656.
>
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
> +   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatibl=
e
> +     device.
>     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
>
>     When compatible with the generic version nodes must list the
> --
> 2.7.4



[https://www2.renesas.eu/media/email/unicef_2017.jpg]

This Christmas, instead of sending out cards, Renesas Electronics Europe ha=
ve decided to support Unicef with a donation. For further details click her=
e<https://www.unicef.org/> to find out about the valuable work they do, hel=
ping children all over the world.
We would like to take this opportunity to wish you a Merry Christmas and a =
prosperous New Year.



Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
