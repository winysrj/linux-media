Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:3562 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZKLOlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 09:41:15 -0500
Date: Thu, 12 Nov 2009 15:41:06 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Eric Miao <eric.y.miao@gmail.com>,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3 v3] Add camera support for A780 and A910 EZX phones
Message-Id: <20091112154106.a00bbb95.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0911111857430.4072@axis700.grange>
References: <Pine.LNX.4.64.0911101037280.5074@axis700.grange>
	<1257937317-16655-1-git-send-email-ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911111857430.4072@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_15_41_07_+0100_nA=yk7gkjC=+WM1="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Thu__12_Nov_2009_15_41_07_+0100_nA=yk7gkjC=+WM1=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Nov 2009 19:02:11 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Antonio
>=20
> Still one more nitpick:
>

Comments below.

> On Wed, 11 Nov 2009, Antonio Ospite wrote:
>=20
[...]
> > =20
> > +/* camera */
> > +static int a780_camera_init(void)
>=20
> This function returns an error but...
>=20
> > +{
> > +	int err;
> > +
> > +	/*
> > +	 * GPIO50_nCAM_EN is active low
> > +	 * GPIO19_GEN1_CAM_RST is active on rising edge
> > +	 */
> > +	err =3D gpio_request(GPIO50_nCAM_EN, "nCAM_EN");
> > +	if (err) {
> > +		pr_err("%s: Failed to request nCAM_EN\n", __func__);
> > +		goto fail;
> > +	}
[...]
> > +	return err;
> > +}
> > +
[...]
> >  static void __init a780_init(void)
> > @@ -699,6 +782,9 @@ static void __init a780_init(void)
> > =20
> >  	pxa_set_keypad_info(&a780_keypad_platform_data);
> > =20
> > +	a780_camera_init();
>=20
> ...it is not used. So, I would either make it void, or check the return=20
> code, and maybe even not register the camera since it's going to be=20
> useless anyway? Same for a910.
>

Actually I was keeping returning an error just in case there would be a
soc-camera .init() someday. But it's indeed a good idea to check the
return value once that we have it.

I am inlining here only the incremental change for a faster review,
I am going to send v4 of the patch separately for you ACK, hopefully :).

Note, now the return value of platform_device_register is ignored but
this is not grave, I guess.

Thanks for your time,
   Antonio

diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index 74423a6..1a73b7b 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -767,7 +767,6 @@ static struct platform_device a780_camera =3D {
=20
 static struct platform_device *a780_devices[] __initdata =3D {
 	&a780_gpio_keys,
-	&a780_camera,
 };
=20
 static void __init a780_init(void)
@@ -782,8 +781,10 @@ static void __init a780_init(void)
=20
 	pxa_set_keypad_info(&a780_keypad_platform_data);
=20
-	a780_camera_init();
-	pxa_set_camera_info(&a780_pxacamera_platform_data);
+	if (a780_camera_init() =3D=3D 0) {
+		pxa_set_camera_info(&a780_pxacamera_platform_data);
+		platform_device_register(&a780_camera);
+	}
=20
 	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
 	platform_add_devices(ARRAY_AND_SIZE(a780_devices));
@@ -1026,7 +1027,6 @@ static struct platform_device a910_camera =3D {
=20
 static struct platform_device *a910_devices[] __initdata =3D {
 	&a910_gpio_keys,
-	&a910_camera,
 };
=20
 static void __init a910_init(void)
@@ -1041,8 +1041,10 @@ static void __init a910_init(void)
=20
 	pxa_set_keypad_info(&a910_keypad_platform_data);
=20
-	a910_camera_init();
-	pxa_set_camera_info(&a910_pxacamera_platform_data);
+	if (a910_camera_init() =3D=3D 0) {
+		pxa_set_camera_info(&a910_pxacamera_platform_data);
+		platform_device_register(&a910_camera);
+	}
=20
 	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
 	platform_add_devices(ARRAY_AND_SIZE(a910_devices));


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Thu__12_Nov_2009_15_41_07_+0100_nA=yk7gkjC=+WM1=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr8HoMACgkQ5xr2akVTsAEOyQCdGWHaYdfiTRUcf9Jfw19O0QUw
t2EAn0cXhNu34ggQyUZOOpHC0jReQ7+N
=jYzD
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_15_41_07_+0100_nA=yk7gkjC=+WM1=--
