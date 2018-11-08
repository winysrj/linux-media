Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-os2jpn01on0090.outbound.protection.outlook.com ([104.47.92.90]:5088
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbeKHW2x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 17:28:53 -0500
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
Subject: RE: [PATCH 4/5] media: rcar-vin: Enable support for r8a774a1
Date: Thu, 8 Nov 2018 12:53:27 +0000
Message-ID: <TY1PR01MB1770B05BF0650AF58E35659AC0C50@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-5-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-5-git-send-email-biju.das@bp.renesas.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear All,

Who is the best person to take this patch?

Cheers,
Fab

> From: Biju Das <biju.das@bp.renesas.com>
> Sent: 10 September 2018 15:31
> Subject: [PATCH 4/5] media: rcar-vin: Enable support for r8a774a1
>
> Add the SoC specific information for RZ/G2M(r8a774a1) SoC.
> The VIN module of RZ/G2M is similar to R-Car M3-W.
>
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/=
platform/rcar-vin/rcar-core.c
> index d3072e1..c0c84d1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -995,6 +995,10 @@ static const struct rvin_info rcar_info_r8a77970 =3D=
 {
>
>  static const struct of_device_id rvin_of_id_table[] =3D {
>  {
> +.compatible =3D "renesas,vin-r8a774a1",
> +.data =3D &rcar_info_r8a7796,
> +},
> +{
>  .compatible =3D "renesas,vin-r8a7778",
>  .data =3D &rcar_info_m1,
>  },
> --
> 2.7.4




Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
