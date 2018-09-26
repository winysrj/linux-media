Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36593 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbeIZWDX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 18:03:23 -0400
MIME-Version: 1.0
References: <20180926125127.2004280-1-arnd@arndb.de>
In-Reply-To: <20180926125127.2004280-1-arnd@arndb.de>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 27 Sep 2018 00:49:37 +0900
Message-ID: <CAC5umygy=BBSF_v_vVNnrZ9_1LCpJW0V212yxVqmGUUF-kOOSA@mail.gmail.com>
Subject: Re: [PATCH] media: ov9650: avoid maybe-uninitialized warnings
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        wsa+renesas@sang-engineering.com, gustavo@embeddedor.com,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B49=E6=9C=8826=E6=97=A5(=E6=B0=B4) 21:51 Arnd Bergmann <arnd@arn=
db.de>:
>
> The regmap change causes multiple warnings like
>
> drivers/media/i2c/ov9650.c: In function 'ov965x_g_volatile_ctrl':
> drivers/media/i2c/ov9650.c:889:29: error: 'reg2' may be used uninitialize=
d in this function [-Werror=3Dmaybe-uninitialized]
>    exposure =3D ((reg2 & 0x3f) << 10) | (reg1 << 2) |
>               ~~~~~~~~~~~~~~~^~~~~~
>
> It is apparently hard for the compiler to see here if ov965x_read()
> returned successfully or not. Besides, we have a v4l2_dbg() statement
> that prints an uninitialized value if regmap_read() fails.
>
> Adding an 'else' clause avoids the ambiguity.
>
> Fixes: 361f3803adfe ("media: ov9650: use SCCB regmap")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>

> ---
>  drivers/media/i2c/ov9650.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 3c9e6798d14b..77944da31de1 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -433,6 +433,8 @@ static int ov965x_read(struct ov965x *ov965x, u8 addr=
, u8 *val)
>         ret =3D regmap_read(ov965x->regmap, addr, &buf);
>         if (!ret)
>                 *val =3D buf;
> +        else
> +                *val =3D -1;
>
>         v4l2_dbg(2, debug, &ov965x->sd, "%s: 0x%02x @ 0x%02x. (%d)\n",
>                  __func__, *val, addr, ret);
> --
> 2.18.0
>
