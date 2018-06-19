Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:52544 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935350AbeFSCz1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 22:55:27 -0400
Date: Tue, 19 Jun 2018 11:55:20 +0900
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
Message-ID: <20180619025519.ufw2pgxbamjqn2ir@ninjato>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
 <20180614153357.vgz4umv2aqudghm3@ninjato>
 <2528868.S4lOAQh8Yk@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vj326fhr3mwnh74g"
Content-Disposition: inline
In-Reply-To: <2528868.S4lOAQh8Yk@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vj326fhr3mwnh74g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I'd prefer this file to be in the i2c realm. Maybe
> > 'include/linux/i2c-sccb.h" or something. I will come back to this.
>=20
> And while at it, I think we also need a .c file, the functions (and espec=
ially=20
> sccb_read_byte()) should not be static inline.

Before we discuss this, we should make sure that the read-function is
complete and then we can decide further. I found some old notes based on
our previous discussions about SCCB and refactoring its access. You
mentioned there is HW supporting SCCB natively. Also, we found a device
where an SCCB device is connected to an SMBUS controller (yuck!). So,
given that, I'd think the read routine should look like this (in pseudo
code):


bool is_sccb_available(adap)
{
	u32 needed_funcs =3D I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA;

	/*
	 * sccb_xfer not needed yet, since there is no driver support currently.
	 * Just showing how it should be done if we ever need it.
	 */
	if (adap->algo->sccb_xfer)
		return true;

	if (i2c_get_functionality(adap) & needed_funcs =3D=3D needed_funcs)
		return true;

	return false;
}

sccb_get_byte()
{
	if (adap->algo->sccb_xfer)
		adap->algo->sccb_xfer(...)

	/*
	 * Prereq: __i2c_smbus_xfer needs to be created!
	 */
	i2c_lock_adapter(SEGMENT);
	__i2c_smbus_xfer(..., SEND_BYTE, ...)
	__i2c_smbus_xfer(..., GET_BYTE, ...)
	i2c_unlock_adapter(SEGMENT)
}

sccb_write_byte()
{
	return i2c_smbus_write_byte_data(...)
}

If I haven't overlooked something, this should make SCCB possible on I2C
controllers and SMBus controllers. We honor the requirement of not
having repeated start anywhere. As such, we might get even rid of the
I2C_M_STOP flag (for in-kernel users, but we sadly export it to
userspace).

About the IGNORE_NAK flag, I think this still should work where
supported as it is passed along indirectly with I2C_CLIENT_SCCB.
However, this flag handling with SCCB is really a mess and needs an
overhaul. This can be a second step, however. Most devices don't really
need it, do they?

Any further comments? Anything I missed?

Kind regards,

   Wolfram


--vj326fhr3mwnh74g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlsocJMACgkQFA3kzBSg
Kbb7Eg/+MBhmgaGf3CGuemZb2y9fJb8TzW8uWbX9whseIYZxSkbN9Oc1PnSy8k3E
TOuNJO3UbRw9/RPgnryIJPxL6DR1IrMMXJfc1YrC2fhxXNzLSTLoSzsj/Q0CqMt3
IjvHyuOMAHa9uGHTOzdkWBmmKOdvwnzgR2JsXsyIcZBnG/z318fNo3jdttl1FEAI
eYZwA55Df/cu1JuYM4Pv3TL4a7IcFS+gNW8OgkxenxFS3LwAonXO/lAwzN5D+/QJ
2P2gK7IGBdDt3G/DwcyXMWWb+XIUw20Z7n0g7a6VohYO2U4dJPYFJNGR4Yk/dC5e
FtWt6ChyCTwuDBJxSwa1KX9v1ZG0peMLh8PR+LzZT3o2BFj4wLy1KXCqbUtCu0gx
FiYAM3+GwKSDu8/KdcAA1MYolAWj5MhkPQRKu4vALz3hba+/rChoudEJ2iq9Q0g6
TN1a4+haHKfOrtYPyqwCS3ysk6eoKPu3dg1ZMnfOBcC8+mS8mgfwny0LmoV3desK
CEuZDPH7sglyKtAPIz1yp1Zhu1nM190r7K0J8YKQqi8hBhog6qolCUI4HtWNYIvz
6q9ZHoiGUPDdXLlE0x//cBuQghBiR5wO+2ycmjyd3iPUOs5XeLJxSkWyYQX1l9iV
4MrRB4tyFzsE40iTbmmKGNGCuX40C1u0newv4ekkO3sEKnFbpwQ=
=bGcL
-----END PGP SIGNATURE-----

--vj326fhr3mwnh74g--
