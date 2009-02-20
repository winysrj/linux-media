Return-path: <linux-media-owner@vger.kernel.org>
Received: from nef2.ens.fr ([129.199.96.40]:3953 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbZBTXrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 18:47:10 -0500
Date: Sat, 21 Feb 2009 00:47:06 +0100
From: Nicolas George <nicolas.george@normalesup.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy T USB XXS: remote does not work with 1.20
	firmware
Message-ID: <20090220234706.GA24454@phare.normalesup.org>
References: <20090220225042.GA19663@phare.normalesup.org> <412bdbff0902201520p6fbe68d0oaf53d76744184487@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <412bdbff0902201520p6fbe68d0oaf53d76744184487@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi. Thanks for your reply.

Le duodi 2 vent=F4se, an CCXVII, Devin Heitmueller a =E9crit=A0:
> I would have to look at the code, but if I recall, the code is
> designed to return -ETIMEDOUT during normal operation when no key
> press is detected.

That is what I thought it was supposed to do.

> Are there any cases where it returns something *other* than
> -ETIMEDOUT?  Because if so, then the keypress is probably being
> received but not processed properly.

I just re-did it:

	if(status !=3D -ETIMEDOUT)
		printk("dib0700_rc_query_v1_20: status =3D %d\n", status);

just after usb_bulk_msg. Then I press keys on the remote: I see mostly
nothing, but once in a while, I get:

[  800.589349] dib0700_rc_query_v1_20: status =3D 0
[  800.589366] dib0700: Unknown remote controller key: 00 13 36 c9

I did not manage to find any pattern in the keys that come through: that
seems completely random.

If I do use the 1.10 firmware and do the same in dib0700_rc_query_legacy
just after the test against 0.0.0.0, I get a diagnosis line (or several)
each time I press a key on the remote, without any loss.

I fear this means the problem is in the firmware itself. I am willing to do
further tests, but I have no competence at all regarding firmwares for such
devices.

Regards,

--=20
  Nicolas George

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmfQPoACgkQsGPZlzblTJN2UQCgldNRPLK38T7VTxgJgM5AHQOI
rZkAnjCYK1RuaNI25rT0r059etFYXMC5
=u1uv
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
