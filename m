Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34063 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938685AbcKOOw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 09:52:29 -0500
Date: Tue, 15 Nov 2016 15:52:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        geert+renesas@glider.be, akpm@linux-foundation.org,
        hverkuil@xs4all.nl, dheitmueller@kernellabs.com,
        slongerbeam@gmail.com, lars@metafoo.de, robert.jarzmik@free.fr,
        pali.rohar@gmail.com, sakari.ailus@linux.intel.com,
        mark.rutland@arm.com, CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v4 2/2] Add support for OV5647 sensor
Message-ID: <20161115145225.GA7746@amd>
References: <cover.1479129004.git.roliveir@synopsys.com>
 <36447f1f102f648057eb9038a693941794a6c344.1479129004.git.roliveir@synopsys.com>
 <20161115121032.GB7018@amd>
 <3b6863c4-e239-7b66-1d96-7f0326f507c5@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <3b6863c4-e239-7b66-1d96-7f0326f507c5@roeck-us.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2016-11-15 05:50:32, Guenter Roeck wrote:
> On 11/15/2016 04:10 AM, Pavel Machek wrote:
> >Hi!
> >
> >>Add support for OV5647 sensor.
> >>
> >
> >>+static int ov5647_write(struct v4l2_subdev *sd, u16 reg, u8 val)
> >>+{
> >>+	int ret;
> >>+	unsigned char data[3] =3D { reg >> 8, reg & 0xff, val};
> >>+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> >>+
> >>+	ret =3D i2c_master_send(client, data, 3);
> >>+	if (ret !=3D 3) {
> >>+		dev_dbg(&client->dev, "%s: i2c write error, reg: %x\n",
> >>+				__func__, reg);
> >>+		return ret < 0 ? ret : -EIO;
> >>+	}
> >>+	return 0;
> >>+}
> >
> >Sorry, this is wrong. It should something <0 any time error is detected.
> >
>=20
> It seems to me that it does return a value < 0 each time an error is dete=
cted.

Yep, you are right, sorry, I misparsed the code.

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgrISkACgkQMOfwapXb+vKuygCeLdkwDem4GhGA3D0QH6ipdj6T
P4gAn3hB/BjOzzahMfPEcuIDwrA6PEoX
=Oihm
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
