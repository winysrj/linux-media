Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:18125 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751718AbdJTHON (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 03:14:13 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: RE: [PATCH 2/4] media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
Date: Fri, 20 Oct 2017 07:14:09 +0000
Message-ID: <KL1PR0601MB20387F1150A7BCE3C2058C98C3430@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
 <1508430683-8674-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1508430683-8674-3-git-send-email-akinobu.mita@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mita-san,

Thank you for fixing this.

> Subject: [PATCH 2/4] media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
>=20
> The v4l2_i2c_subdev_init() sets V4L2_SUBDEV_FL_IS_I2C flag in the
> subdev->flags.  But this driver overwrites subdev->flags immediately
> subdev->after
> calling v4l2_i2c_subdev_init().  So V4L2_SUBDEV_FL_IS_I2C is not set afte=
r
> all.
>=20
> This stops breaking subdev->flags and preserves V4L2_SUBDEV_FL_IS_I2C.
>=20
> Side note: According to the comment in v4l2_device_unregister(), this is
> problematic only if the device is platform bus device.  Device tree or
> ACPI based devices are not affected.
>=20
> Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>

Thanks,
Ramesh

> ---
>  drivers/media/i2c/max2175.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
> index bf0e821..2f1966b 100644
> --- a/drivers/media/i2c/max2175.c
> +++ b/drivers/media/i2c/max2175.c
> @@ -1345,7 +1345,7 @@ static int max2175_probe(struct i2c_client *client,
>  	v4l2_i2c_subdev_init(sd, client, &max2175_ops);
>  	ctx->client =3D client;
>=20
> -	sd->flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	sd->flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
>=20
>  	/* Controls */
>  	hdl =3D &ctx->ctrl_hdl;
> --
> 2.7.4
