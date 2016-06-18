Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35212 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcFRPhg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 11:37:36 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v3 1/2] media: Driver for Toshiba et8ek8 5MP sensor
Date: Sat, 18 Jun 2016 17:37:33 +0200
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	sre@kernel.org, linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	mchehab@osg.samsung.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <1465659593-16858-2-git-send-email-ivo.g.dimitrov.75@gmail.com> <20160618152259.GC8392@amd>
In-Reply-To: <20160618152259.GC8392@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1907418.FpRz28yNSr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201606181737.33116@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1907418.FpRz28yNSr
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 18 June 2016 17:22:59 Pavel Machek wrote:
> > +/*
> > + *
> > + * Stingray sensor mode settings for Scooby
> > + *
> > + *
> > + */
>=20
> I'd fix it to normal comment style... and possibly remove it. Can you
> understand what it says?
>=20
> > +	},
> > +	.regs =3D {
> > +		{ ET8EK8_REG_8BIT, 0x1239, 0x4F },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x123A, 0x05 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x121B, 0x63 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x1220, 0x85 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x1222, 0x58 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x121D, 0x63 },	/*        */
> > +		{ ET8EK8_REG_8BIT, 0x125D, 0x83 },	/*        */
> > +		{ ET8EK8_REG_TERM, 0, 0}
> > +	}
>=20
> I'd remove the empty comments...
>=20
> > +struct et8ek8_meta_reglist meta_reglist =3D {
> > +	.version =3D "V14 03-June-2008",
>=20
> Do we need the version?
>=20
> > +	.reglist =3D {
> > +		{ .ptr =3D &mode1_poweron_mode2_16vga_2592x1968_12_07fps },
> > +		{ .ptr =3D &mode1_16vga_2592x1968_13_12fps_dpcm10_8 },
> > +		{ .ptr =3D &mode3_4vga_1296x984_29_99fps_dpcm10_8 },
> > +		{ .ptr =3D &mode4_svga_864x656_29_88fps },
> > +		{ .ptr =3D &mode5_vga_648x492_29_93fps },
> > +		{ .ptr =3D &mode2_16vga_2592x1968_3_99fps },
> > +		{ .ptr =3D &mode_648x492_5fps },
> > +		{ .ptr =3D &mode3_4vga_1296x984_5fps },
> > +		{ .ptr =3D &mode_4vga_1296x984_25fps_dpcm10_8 },
> > +		{ .ptr =3D 0 }
> > +	}
> > +};
>=20
> I'd say .ptr =3D NULL.
>=20

Anyway, this code was generated from configuration ini files and perl=20
script available from: https://gitorious.org/omap3camera/camera-firmware

Originally in Maemo above C structure is compiled into binary file and=20
via request_firmware() loaded from userspace to kernel driver.

=46or me this sounds like a big overkill, so I included above reglist code=
=20
direcly into et8ek8 kernel driver to avoid request_firmware() and=20
separate userspace storage...

And for smia-sensor (front webcam) in that gitorious repository is also=20
reglist structure. It is not needed? Can somebody investigate why it is=20
not needed?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1907418.FpRz28yNSr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAldlar0ACgkQi/DJPQPkQ1KBuQCgu0c8x2fgI4qL1B2Nonw/pp3M
QvkAoICf974NbSL1ZYOSgt7FA3PBtA3p
=GWhf
-----END PGP SIGNATURE-----

--nextPart1907418.FpRz28yNSr--
