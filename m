Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-os2jpn01on0113.outbound.protection.outlook.com ([104.47.92.113]:23376
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbeKHW0z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 17:26:55 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Biju Das <biju.das@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Biju Das <biju.das@bp.renesas.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Subject: RE: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
Date: Thu, 8 Nov 2018 12:51:29 +0000
Message-ID: <TY1PR01MB17702DD6630BAC85CFEB2735C0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-3-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-3-git-send-email-biju.das@bp.renesas.com>
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

> From: linux-renesas-soc-owner@vger.kernel.org <linux-renesas-soc-owner@vg=
er.kernel.org> On Behalf Of Biju Das
> Sent: 10 September 2018 15:31
> Subject: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
>
> Add the MIPI CSI-2 driver support for RZ/G2M(r8a774a1) SoC.
> The CSI-2 module of RZ/G2M is similar to R-Car M3-W.
>
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/=
platform/rcar-vin/rcar-csi2.c
> index daef72d..65c7efb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -953,6 +953,10 @@ static const struct rcar_csi2_info rcar_csi2_info_r8=
a77970 =3D {
>
>  static const struct of_device_id rcar_csi2_of_table[] =3D {
>  {
> +.compatible =3D "renesas,r8a774a1-csi2",
> +.data =3D &rcar_csi2_info_r8a7796,
> +},
> +{
>  .compatible =3D "renesas,r8a7795-csi2",
>  .data =3D &rcar_csi2_info_r8a7795,
>  },
> --
> 2.7.4




Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
