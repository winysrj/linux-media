Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42148 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1DKTNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 15:13:00 -0400
Received: by vws1 with SMTP id 1so4404406vws.19
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 12:12:58 -0700 (PDT)
Date: Mon, 11 Apr 2011 15:12:52 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
Message-ID: <20110411191252.GB4324@mgebm.net>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
 <1301922737.5317.7.camel@morgan.silverblock.net>
 <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
 <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
 <1302015521.4529.17.camel@morgan.silverblock.net>
 <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
 <1302481535.2282.61.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <1302481535.2282.61.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Apr 2011, Andy Walls wrote:

> > >
> > > 3. Please provide the relevant portion of the mythbackend log where
> > > where the digital scanner starts and then fails.
> >=20
> > So the Digital scanner doesn't fail per se, it just doesn't pick up
> > most of the digital channels available.  The same is true of scan, it
> > seems to find only 1 channel when I know that I have access to 18.
>=20
> Make sure it's not a signal integrity problem:
>=20
> 	http://ivtvdriver.org/index.php/Howto:Improve_signal_quality
>=20
> wild speculation: If the analog tuner driver init failed, maybe that is
> having some bad EMI efect on the digital tuner
>=20
> I'm assumiong you got more than the 1 channel before trying to enable
> analog tuning.

I don't think there is a digital problem after all, the scanner doesn't seem
to be picking up all the channels (meaning there were entries for most, but
much off the data about the channel was missing in channels.conf).  When I =
hand
add the 2 that were missing and fill in the rest of the missing data, all o=
f it
works.  I can tune to any of the listed channels and watch them with mplaye=
r.
I am going to take the digital TV side up with the MythTV folks.

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNo1K0AAoJEH65iIruGRnNkQsH/jewFevqAJt2uSElzcD7ok6G
Tu1ibiHuknb2YfhhkCtHzsXMm2DAC3CtWtxozP3AgDZ/YvXw1g4/zFSJqI7kTYC5
Jdd58aLmnK91iK0DPRhYQWMWiNW8OZwn4nTY/WYEa7vdoA8WYajhNPB7hUaVIQ6q
BDmfYhwUY1Mv1YxJ8GbXbz5/6FxdjES9ZaZpbZwJqADJtSwRIl8D3zcmZEZxP3tB
9+xFeNNtz7bZh9lF7ZHe/HXxEblNcYSoTELNPzlOlZP/lVKf0Ma3g/KAPOOey1R3
XsB/fC395MzMYfkQ/e9UWK7fvOWxT2d3Q5wfJLobUiDtqU2K28IcyEV774qdAAI=
=t8Bh
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
