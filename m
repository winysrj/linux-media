Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:53601 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965152AbcIHRIv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 13:08:51 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] [media] ov9650: add support for asynchronous probing
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1473339940-24572-1-git-send-email-javier@osg.samsung.com>
Date: Thu, 8 Sep 2016 19:08:38 +0200
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <28493A99-C0CF-4662-B4EF-6D8A3576593D@goldelico.com>
References: <1473339940-24572-1-git-send-email-javier@osg.samsung.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 08.09.2016 um 15:05 schrieb Javier Martinez Canillas =
<javier@osg.samsung.com>:
>=20
> Allow the sub-device to be probed asynchronously so a bridge driver =
that's
> waiting for the device can be notified and its .bound callback =
executed.
>=20
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Tested-by: hns@goldelico.com

>=20
> ---
>=20
> drivers/media/i2c/ov9650.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index be5a7fd4f076..502c72238a4a 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -23,6 +23,7 @@
> #include <linux/videodev2.h>
>=20
> #include <media/media-entity.h>
> +#include <media/v4l2-async.h>
> #include <media/v4l2-ctrls.h>
> #include <media/v4l2-device.h>
> #include <media/v4l2-event.h>
> @@ -1520,6 +1521,10 @@ static int ov965x_probe(struct i2c_client =
*client,
> 	/* Update exposure time min/max to match frame format */
> 	ov965x_update_exposure_ctrl(ov965x);
>=20
> +	ret =3D v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto err_ctrls;
> +
> 	return 0;
> err_ctrls:
> 	v4l2_ctrl_handler_free(sd->ctrl_handler);
> @@ -1532,7 +1537,7 @@ static int ov965x_remove(struct i2c_client =
*client)
> {
> 	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
>=20
> -	v4l2_device_unregister_subdev(sd);
> +	v4l2_async_unregister_subdev(sd);
> 	v4l2_ctrl_handler_free(sd->ctrl_handler);
> 	media_entity_cleanup(&sd->entity);
>=20
> --=20
> 2.7.4
>=20

