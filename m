Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35105 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbcFRQLT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 12:11:19 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, sakari.ailus@iki.fi
Subject: Re: [PATCH v3 1/2] media: Driver for Toshiba et8ek8 5MP sensor
Date: Sat, 18 Jun 2016 18:11:10 +0200
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
	linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	mchehab@osg.samsung.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <201606181737.33116@pali> <20160618160423.GB16792@amd>
In-Reply-To: <20160618160423.GB16792@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6194889.uIyB03IYbj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201606181811.10233@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart6194889.uIyB03IYbj
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 18 June 2016 18:04:23 Pavel Machek wrote:
> Hi!
>=20
> > > > +	.reglist =3D {
> > > > +		{ .ptr =3D &mode1_poweron_mode2_16vga_2592x1968_12_07fps },
> > > > +		{ .ptr =3D &mode1_16vga_2592x1968_13_12fps_dpcm10_8 },
> > > > +		{ .ptr =3D &mode3_4vga_1296x984_29_99fps_dpcm10_8 },
> > > > +		{ .ptr =3D &mode4_svga_864x656_29_88fps },
> > > > +		{ .ptr =3D &mode5_vga_648x492_29_93fps },
> > > > +		{ .ptr =3D &mode2_16vga_2592x1968_3_99fps },
> > > > +		{ .ptr =3D &mode_648x492_5fps },
> > > > +		{ .ptr =3D &mode3_4vga_1296x984_5fps },
> > > > +		{ .ptr =3D &mode_4vga_1296x984_25fps_dpcm10_8 },
> > > > +		{ .ptr =3D 0 }
> > > > +	}
> > > > +};
> > >=20
> > > I'd say .ptr =3D NULL.
> >=20
> > Anyway, this code was generated from configuration ini files and
> > perl script available from:
> > https://gitorious.org/omap3camera/camera-firmware
> >=20
> > Originally in Maemo above C structure is compiled into binary file
> > and via request_firmware() loaded from userspace to kernel driver.
> >=20
> > For me this sounds like a big overkill, so I included above reglist
> > code direcly into et8ek8 kernel driver to avoid request_firmware()
> > and separate userspace storage...
>=20
> Yep, that makes sense, thanks for explanation. I guess that means
> that we should put a comment on top of the file explaining what is
> going on.
>=20
> Best regards,
> 									Pavel

Here is that original stingraytsb_v14_simple.ini file:

https://gitorious.org/omap3camera/camera-firmware?p=3Domap3camera:camera-fi=
rmware.git;a=3Dtree;f=3Dini

Looks like are are some "non simple" stingraytsb_v14 files too, but I
have no idea which modes defines...

Sakari, any idea?
Which we should include into kernel et8ek8 kernel driver?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6194889.uIyB03IYbj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAldlcp4ACgkQi/DJPQPkQ1L5HwCgr7HP4/6vTTmSMKOANyjuk0bE
NG4An0r9jCqrBo4xzuUh8BX44aELhATK
=LlkO
-----END PGP SIGNATURE-----

--nextPart6194889.uIyB03IYbj--
