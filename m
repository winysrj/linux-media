Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:33118 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726736AbeHVKW7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 06:22:59 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] media: i2c: max2175: convert to SPDX identifiers
Date: Wed, 22 Aug 2018 06:59:20 +0000
Message-ID: <TY2PR01MB1962DBC547EC829ACB04D22BC3300@TY2PR01MB1962.jpnprd01.prod.outlook.com>
References: <87bm9vf9p8.wl-kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87bm9vf9p8.wl-kuninori.morimoto.gx@renesas.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

Thank you for the patch.

> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> This patch updates license to use SPDX-License-Identifier
> instead of verbose license text.
>=20
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Acked-by: Ramesh Shanmugasundaram <Ramesh.shanmugasundaram@bp.renesas.com>

Thanks,
Ramesh

> ---
>  drivers/media/i2c/max2175.c | 10 +---------
>  drivers/media/i2c/max2175.h | 12 ++----------
>  2 files changed, 3 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
> index 008a082..85a3fdf 100644
> --- a/drivers/media/i2c/max2175.c
> +++ b/drivers/media/i2c/max2175.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Maxim Integrated MAX2175 RF to Bits tuner driver
>   *
> @@ -6,15 +7,6 @@
>   *
>   * Copyright (C) 2016 Maxim Integrated Products
>   * Copyright (C) 2017 Renesas Electronics Corporation
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2
> - * as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> - * GNU General Public License for more details.
>   */
>=20
>  #include <linux/clk.h>
> diff --git a/drivers/media/i2c/max2175.h b/drivers/media/i2c/max2175.h
> index eb43373..1ece587 100644
> --- a/drivers/media/i2c/max2175.h
> +++ b/drivers/media/i2c/max2175.h
> @@ -1,4 +1,5 @@
> -/*
> +/* SPDX-License-Identifier: GPL-2.0
> + *
>   * Maxim Integrated MAX2175 RF to Bits tuner driver
>   *
>   * This driver & most of the hard coded values are based on the referenc=
e
> @@ -6,15 +7,6 @@
>   *
>   * Copyright (C) 2016 Maxim Integrated Products
>   * Copyright (C) 2017 Renesas Electronics Corporation
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2
> - * as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> - * GNU General Public License for more details.
>   */
>=20
>  #ifndef __MAX2175_H__
> --
> 2.7.4
