Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ty1jpn01on0130.outbound.protection.outlook.com ([104.47.93.130]:5488
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726684AbeKHWZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 17:25:48 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Biju Das <biju.das@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: Biju Das <biju.das@bp.renesas.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Subject: RE: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Date: Thu, 8 Nov 2018 12:50:22 +0000
Message-ID: <TY1PR01MB17709220C776F7617FAF36AAC0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear All,

Who is the best person to take this patch?

Thanks,
Fab

> From: Biju Das <biju.das@bp.renesas.com>
> Sent: 10 September 2018 15:31
> Subject: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1 s=
upport
>
> Document RZ/G2M (R8A774A1) SoC bindings.
>
> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
>
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.tx=
t
> b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> index 2d385b6..12fe685 100644
> --- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> @@ -2,12 +2,13 @@ Renesas R-Car MIPI CSI-2
>  ------------------------
>
>  The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for the
> -Renesas R-Car family of devices. It is used in conjunction with the
> -R-Car VIN module, which provides the video capture capabilities.
> +Renesas R-Car Gen3 and RZ/G2 family of devices. It is used in conjunctio=
n
> +with the R-Car VIN module, which provides the video capture capabilities=
.
>
>  Mandatory properties
>  --------------------
>   - compatible: Must be one or more of the following
> +   - "renesas,r8a774a1-csi2" for the R8A774A1 device.
>     - "renesas,r8a7795-csi2" for the R8A7795 device.
>     - "renesas,r8a7796-csi2" for the R8A7796 device.
>     - "renesas,r8a77965-csi2" for the R8A77965 device.
> --
> 2.7.4




Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
