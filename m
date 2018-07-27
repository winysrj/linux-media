Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:59232 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729445AbeG0KVU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 06:21:20 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?Windows-1252?Q?=22Niklas_S=F6derlund=22?=
        <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 04/11] media: rcar_drif: convert to SPDX identifiers
Date: Fri, 27 Jul 2018 09:00:18 +0000
Message-ID: <TY2PR01MB1962C868735DBDBE8C4AAF7CC32A0@TY2PR01MB1962.jpnprd01.prod.outlook.com>
References: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com>
 <87bmaud8zy.wl-kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87bmaud8zy.wl-kuninori.morimoto.gx@renesas.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

Thank you for the patch and the information on MODULE_LICENSE.

> -----Original Message-----
> From: Kuninori Morimoto
> Sent: Thursday, July 26, 2018 3:36 AM
> To: Mauro Carvalho Chehab <mchehab@kernel.org>; Hans Verkuil
> <hans.verkuil@cisco.com>
> Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>;
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>; "Niklas S=F6derlund=
"
> <niklas.soderlund@ragnatech.se>; Kieran Bingham <kieran@bingham.xyz>;
> Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>; Gustavo A. R. Silva
> <gustavo@embeddedor.com>; Al Viro <viro@zeniv.linux.org.uk>; Charles
> Keepax <ckeepax@opensource.wolfsonmicro.com>; Jacopo Mondi
> <jacopo+renesas@jmondi.org>; linux-media@vger.kernel.org; linux-renesas-
> soc@vger.kernel.org
> Subject: [PATCH 04/11] media: rcar_drif: convert to SPDX identifiers
>=20
>=20
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> As original license mentioned, it is GPL-2.0+ in SPDX.
> Then, MODULE_LICENSE() should be "GPL" instead of "GPL v2".
> See ${LINUX}/include/linux/module.h
>=20
> 	"GPL"		[GNU Public License v2 or later]
> 	"GPL v2"	[GNU Public License v2]
>=20
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Acked-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>

> ---
>  drivers/media/platform/rcar_drif.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar_drif.c
> b/drivers/media/platform/rcar_drif.c
> index dc7e280..81413ab 100644
> --- a/drivers/media/platform/rcar_drif.c
> +++ b/drivers/media/platform/rcar_drif.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * R-Car Gen3 Digital Radio Interface (DRIF) driver
>   *
>   * Copyright (C) 2017 Renesas Electronics Corporation
>   *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> @@ -1499,5 +1495,5 @@ module_platform_driver(rcar_drif_driver);
>=20
>  MODULE_DESCRIPTION("Renesas R-Car Gen3 DRIF driver");
>  MODULE_ALIAS("platform:" RCAR_DRIF_DRV_NAME);
> -MODULE_LICENSE("GPL v2");
> +MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com>");
> --
> 2.7.4

Thanks,
Ramesh
