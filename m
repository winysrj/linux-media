Return-path: <linux-media-owner@vger.kernel.org>
Received: from nef2.ens.fr ([129.199.96.40]:2636 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZBZPqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 10:46:21 -0500
Date: Thu, 26 Feb 2009 16:46:16 +0100
From: Nicolas George <nicolas.george@normalesup.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy T USB XXS: remote does not work with 1.20
	firmware
Message-ID: <20090226154616.GA4222@phare.normalesup.org>
References: <20090220225042.GA19663@phare.normalesup.org> <412bdbff0902201520p6fbe68d0oaf53d76744184487@mail.gmail.com> <20090220234706.GA24454@phare.normalesup.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20090220234706.GA24454@phare.normalesup.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Le tridi 3 vent=F4se, an CCXVII, Nicolas George a =E9crit=A0:
> I just re-did it:
>=20
> 	if(status !=3D -ETIMEDOUT)
> 		printk("dib0700_rc_query_v1_20: status =3D %d\n", status);
>=20
> just after usb_bulk_msg. Then I press keys on the remote: I see mostly
> nothing, but once in a while, I get:
>=20
> [  800.589349] dib0700_rc_query_v1_20: status =3D 0
> [  800.589366] dib0700: Unknown remote controller key: 00 13 36 c9
>=20
> I did not manage to find any pattern in the keys that come through: that
> seems completely random.
>=20
> If I do use the 1.10 firmware and do the same in dib0700_rc_query_legacy
> just after the test against 0.0.0.0, I get a diagnosis line (or several)
> each time I press a key on the remote, without any loss.

Excuse-me to insist, but isn't there anything at all I can do to help get
this remote controller working?

Regards,

--=20
  Nicolas George

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmmuUgACgkQsGPZlzblTJNGRgCfUw89XSYfBB4VE0v9GN/If+fW
JMAAnjhyqU4YQ+IrzXjwun8Wv/hWTX1q
=TjjB
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
