Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out13.alice.it ([85.33.2.18]:3147 "EHLO
	smtp-out13.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZKJMtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 07:49:32 -0500
Date: Tue, 10 Nov 2009 13:48:37 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX
 phones
Message-Id: <20091110134837.207bb92a.ospite@studenti.unina.it>
In-Reply-To: <f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
	<f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Nov_2009_13_48_37_+0100_IkvK5DuMu0Z7RAQ8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__10_Nov_2009_13_48_37_+0100_IkvK5DuMu0Z7RAQ8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Nov 2009 14:38:40 +0800
Eric Miao <eric.y.miao@gmail.com> wrote:

> Hi Antonio,
>=20
> Patch looks generally OK except for the MFP/GPIO usage...

Eric,

while I was at it I also checked the original code Motorola released.

It has:
     PGSR(GPIO_CAM_EN) |=3D GPIO_bit(GPIO_CAM_EN);
     PGSR(GPIO_CAM_RST)|=3D GPIO_bit(GPIO_CAM_RST);

After checking PXA manual and arch/arm/mach-pxa/mfp-pxa2xx.c,
I'd translate this to:

diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index 77286a2..6a47a9d 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -281,8 +281,8 @@ static unsigned long gen1_pin_config[] __initdata =3D {
        GPIO94_CIF_DD_5,
        GPIO17_CIF_DD_6,
        GPIO108_CIF_DD_7,
-       GPIO50_GPIO,                            /* CAM_EN */
-       GPIO19_GPIO,                            /* CAM_RST */
+       GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_EN */
+       GPIO19_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_RST */

        /* EMU */
        GPIO120_GPIO,                           /* EMU_MUX1 */
@@ -338,8 +338,8 @@ static unsigned long gen2_pin_config[] __initdata =3D {
        GPIO48_CIF_DD_5,
        GPIO93_CIF_DD_6,
        GPIO12_CIF_DD_7,
-       GPIO50_GPIO,                            /* CAM_EN */
-       GPIO28_GPIO,                            /* CAM_RST */
+       GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_EN */
+       GPIO28_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_RST */
        GPIO17_GPIO,                            /* CAM_FLASH */
 };
 #endif


Is that right?
I am putting also this into the next version I am going to send for
submission, if you don't object.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__10_Nov_2009_13_48_37_+0100_IkvK5DuMu0Z7RAQ8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr5YSUACgkQ5xr2akVTsAFWJwCfTvAyQfMpCR0+m3qiLjIyLQTe
UXgAn3O22pauc+JMBJiygEAu64x3WU+t
=4sHx
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Nov_2009_13_48_37_+0100_IkvK5DuMu0Z7RAQ8--
