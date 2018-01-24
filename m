Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:17936 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933988AbeAXRCO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 12:02:14 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC: =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Fabrizio Castro" <fabrizio.castro@bp.renesas.com>
Subject: RE: [PATCH v2 1/4] dt-bindings: media: rcar_vin: Reverse SoC part
 number list
Date: Wed, 24 Jan 2018 17:02:10 +0000
Message-ID: <SG2PR06MB0886F472B3CFDE5F2255AB8DC0E20@SG2PR06MB0886.apcprd06.prod.outlook.com>
References: <1510856571-30281-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1510856571-30281-2-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1510856571-30281-2-git-send-email-fabrizio.castro@bp.renesas.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys,

I am sorry to bother you,  just wondering if this patch has any chance to e=
nd up in v4.16?

Thanks,
Fabrizio

> Subject: [PATCH v2 1/4] dt-bindings: media: rcar_vin: Reverse SoC part nu=
mber list
>
> Change the sorting of the part numbers from descending to ascending to
> match with other documentation.
>
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das@bp.renesas.com>
> ---
> v1->v2:
> * new patch triggered by Geert's comment, see the below link for details:
>   https://www.mail-archive.com/linux-media@vger.kernel.org/msg121992.html
>
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Docum=
entation/devicetree/bindings/media/rcar_vin.txt
> index 6e4ef8c..98931f5 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -6,14 +6,14 @@ family of devices. The current blocks are always slaves=
 and suppot one input
>  channel which can be either RGB, YUYV or BT656.
>
>   - compatible: Must be one or more of the following
> -   - "renesas,vin-r8a7795" for the R8A7795 device
> -   - "renesas,vin-r8a7794" for the R8A7794 device
> -   - "renesas,vin-r8a7793" for the R8A7793 device
> -   - "renesas,vin-r8a7792" for the R8A7792 device
> -   - "renesas,vin-r8a7791" for the R8A7791 device
> -   - "renesas,vin-r8a7790" for the R8A7790 device
> -   - "renesas,vin-r8a7779" for the R8A7779 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
> +   - "renesas,vin-r8a7779" for the R8A7779 device
> +   - "renesas,vin-r8a7790" for the R8A7790 device
> +   - "renesas,vin-r8a7791" for the R8A7791 device
> +   - "renesas,vin-r8a7792" for the R8A7792 device
> +   - "renesas,vin-r8a7793" for the R8A7793 device
> +   - "renesas,vin-r8a7794" for the R8A7794 device
> +   - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
>     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
>
> --
> 2.7.4




Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
