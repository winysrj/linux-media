Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:48787 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755273Ab1KHPYE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Nov 2011 10:24:04 -0500
Received: by mail-bw0-f41.google.com with SMTP id s6so612809bka.0
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2011 07:24:03 -0800 (PST)
Subject: RE: [PATCH] omap_vout: fix section mismatch
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Taneja, Archit" <archit@ti.com>
In-Reply-To: <79CD15C6BA57404B839C016229A409A802693C@DBDE01.ent.ti.com>
References: <1320745628-20603-1-git-send-email-tomi.valkeinen@ti.com>
	 <79CD15C6BA57404B839C016229A409A802693C@DBDE01.ent.ti.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vzZdaKn3EJO3XubdBO3A"
Date: Tue, 08 Nov 2011 17:23:59 +0200
Message-ID: <1320765839.1907.55.camel@deskari>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-vzZdaKn3EJO3XubdBO3A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-11-08 at 15:15 +0000, Hiremath, Vaibhav wrote:

> I am not sure whether you had tested it, but kernel doesn't boot with V4L=
2 display enabled in defconfig. I have patch to fix this, will submit short=
ly -
>=20
>=20
> diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/o=
map/omap_vout.c
> index 9c5c19f..9031c39 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -2140,6 +2140,8 @@ static int omap_vout_remove(struct platform_device =
*pdev)
>                 omap_vout_cleanup_device(vid_dev->vouts[k]);
>=20
>         for (k =3D 0; k < vid_dev->num_displays; k++) {
> +               if (!vid_dev->displays[k] && !vid_dev->displays[k]->drive=
r)
> +                       continue;
>                 if (vid_dev->displays[k]->state !=3D OMAP_DSS_DISPLAY_DIS=
ABLED)
>                         vid_dev->displays[k]->driver->disable(vid_dev->di=
splays[k]);
>=20
> @@ -2226,7 +2228,7 @@ static int __init omap_vout_probe(struct platform_d=
evice *pdev)
>         for (i =3D 0; i < vid_dev->num_displays; i++) {
>                 struct omap_dss_device *display =3D vid_dev->displays[i];
>=20
> -               if (display->driver->update)
> +               if (display && display->driver && display->driver->update=
)
>                         display->driver->update(display, 0, 0,
>                                         display->panel.timings.x_res,
>                                         display->panel.timings.y_res);
>=20
>=20
> Reason being,=20
>=20
> If you have enabled certain device and fail to enable in defconfig, this =
will lead to kernel crash in omap_vout driver.

Hmm, I didn't quite understand the explanation. But now that you mention
this, I did have the following patch in one of my work trees, but I seem
to have forgotten to post it.

It fixes the case where a display device defined in the board file
doesn't have a driver loaded. I guess this is the same problem you
mention? Is my patch fixing the same problem?

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/oma=
p/omap_vout.c
index 30d8896..18fe02f 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2159,6 +2159,14 @@ static int __init omap_vout_probe(struct platform_de=
vice *pdev)
        vid_dev->num_displays =3D 0;
        for_each_dss_dev(dssdev) {
                omap_dss_get_device(dssdev);
+
+               if (!dssdev->driver) {
+                       dev_warn(&pdev->dev, "no driver for display: %s\n",
+                                       dssdev->name);
+                       omap_dss_put_device(dssdev);
+                       continue;
+               }
+
                vid_dev->displays[vid_dev->num_displays++] =3D dssdev;
        }

 Tomi


--=-vzZdaKn3EJO3XubdBO3A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuUmPAAoJEPo9qoy8lh71OQAP/2uif0VgEJ4dh0jOdBQk/6ab
cvzsyTDYr+Qa5mDCg7t7cuO1lMPTtfE72gGPt2eyl/M3PAQatMlGhQ1Y5FSw57jv
KLhWfwQIT40raRdn7GXAbkBFkH+IjzmHY4ZcJnQ8kisShGPU52cqmIkH3tpmI0/s
qCwARUFHpUNsUyYh9jfBFv0qicuwk021gD0GxCykZ0zNnNR61eAQobyOBCuLaVaP
Qc7YhQQd97P1FclDJ98KlyiCeya+ugn8pw9MoEWY6C/CKKNtZMMFCkmQQDiuy2EU
o+QfR0WUiVGZy4dS5ohnml1zVC9xd35Bq9OWJz7iDtaC8cX5PsDpiwdIxSIuTRo9
gANT8nruE+FPIbFW9naTYBw20dLGdV7EEc7jKOE5ALbpqws+bKhMI8bEiuuP5xxl
GMsiyoBkQN7+NfyemlbYbrYLvBh3wXDKYzgdb+F+h9MHExFAkRxpuuPNrL8iWkio
vyRhhA+y8n1k+aoqke06UEcm6w/gUm7QFxqom1qEn3nmg0gPB16mo8xoOUk3Svdh
I8NEf5DjpizPSfDfxzw7WsMQXnshNXgDhZqgSsT0xQhUoeGE5Nr7qW2pJGEXtoOa
3Bmjy7JRayOqILFl1iqPtd7ztLhOT397tnXrk/u+YLmcs/DLrWu0rSkROR/+3EB7
2i7NdbB9mIJ30uHMf+/3
=OEFr
-----END PGP SIGNATURE-----

--=-vzZdaKn3EJO3XubdBO3A--

