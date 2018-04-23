Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:48494 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932393AbeDWULZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 16:11:25 -0400
Date: Mon, 23 Apr 2018 22:11:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v3 02/11] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180423201121.cgcg6isobtku7swy@ninjato>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <4036479.nT1QDtF4Ij@avalon>
 <CAC5umyiBvBK3QpaszSx0XuMKyj66gCNyKfX8apEh2mk6xG5vtQ@mail.gmail.com>
 <3172940.h9isB0x1K9@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mgvg4derk4imnofd"
Content-Disposition: inline
In-Reply-To: <3172940.h9isB0x1K9@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mgvg4derk4imnofd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> How about i2c_smbus_xfer_emulated() ? The tricky part will be to handle t=
he=20
> I2C adapters that implement .smbus_xfer(), as those won't go through=20
> i2c_smbus_xfer_emulated(). i2c_smbus_xfer_emulated() relies on i2c_transf=
er(),=20
> which itself relies on the I2C adapter's .master_xfer() operation. We're =
thus=20
> only concerned about the drivers that implement both .smbus_xfer() and=20
> master_xfer(), and there's only 4 of them (i2c-opal, i2c-pasemi, i2c-powe=
rmac=20
> and i2c-zx2967). Maybe the simplest solution would be to force the emulat=
ion=20
> path if I2C_CLIENT_SCCB && !I2C_FUNC_PROTOCOL_MANGLING && ->master_xfer !=
=3D=20
> NULL ?
>=20
> Wolfram, what do you think ?

I think it is a mess :)

Further: I don't think we will ever see an SMBus controller which allows
mangling. SMBus is way more precisely defined than I2C, so HW can then
do much more things automatically. They will always do a REP_START, so I
don't think you can connect SCCB devices to SMBus.

As a result, we shouldn't do SMBus calls for SCCB. Maybe we should
introduce sccb_byte_read? SCCB didn't specify much more than byte read
IIRC, or? The implementation here with two seperate messages makes much
sense to me then.

I could argue that the sccb_* helpers should live in drivers/media since
it is probably only Omnivision trying to work around I2C licensing here?

But if it is not too heavy, maybe we could take it into i2c as well.

Makes sense or did I miss something?


--mgvg4derk4imnofd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlrePeQACgkQFA3kzBSg
KbZQxA//XVbGH3BiXXGq5x2XKuN0UD84wZBtS8CqzlNgCfvJR07kpNUE3RHgRd2L
5E002zJmqOaCgq1CtSuo4CXPL4zKj1HnqPSXuowj/xJY3+PlsB3BIdqENubOif72
d0O9i13zB94NkaKt0AHZzvOVmpKIhZGvuheGw1ZTvUQyPnKdkqCdbDOChkbzpHAQ
tbGooKwW9aEdXkb58m6wcb1Yylt/UNLzt55RfWd/uyOqE6v0PyJc7O4EcvecJXAV
hmXfGo9co0dMRTua+whCEay+YrFeLqFN84LMznZ99zKx8LH2L/1zVNwLqDa1KiNn
OoG+VRcTGOpuaJ0q1RZU5oVMurmqUsGtziFUHZzscXsaRtRsK/n+zNYwGS4GhHie
yQcrG5RpYFejXccduK9D2GaUUgpMMZwBp4u0HNf1P+zYh13kGSIrTUiEkYhUxWRn
TBprHxYn++yP/bleytCp858UpZlAECeqHImT0MdOWYmQi/jEg0nXFa/6ajdcqATN
TNTh1s25goKTT3GsIBMVltKywZmeBpASQ69+zRBVTJ18+23ecG6kAM1eB2MfF/06
NKKB/XXwhVgnT2EmREbyrYi43edvOBPGpyVIDzMkY0oIEFRyzfu/tLHWTG14mP3t
vtjCW0zFOoUkwN7RhnlZk2xwVhgP7+QC5UGQvF6szmkC88F9EBM=
=o9j6
-----END PGP SIGNATURE-----

--mgvg4derk4imnofd--
