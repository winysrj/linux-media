Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40320 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932994AbeGIVXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 17:23:11 -0400
Date: Mon, 9 Jul 2018 23:23:06 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 2/2] media: ov772x: use SCCB helpers
Message-ID: <20180709212306.47xsduu3b5qpq72h@earth.universe>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
 <1531150874-4595-3-git-send-email-akinobu.mita@gmail.com>
 <20180709161443.ubxu4el6bp6zgerj@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ymylls6cogp4km77"
Content-Disposition: inline
In-Reply-To: <20180709161443.ubxu4el6bp6zgerj@ninjato>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ymylls6cogp4km77
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 09, 2018 at 06:14:43PM +0200, Wolfram Sang wrote:
> >  static int ov772x_read(struct i2c_client *client, u8 addr)
> >  {
> > -	int ret;
> > -	u8 val;
> > -
> > -	ret =3D i2c_master_send(client, &addr, 1);
> > -	if (ret < 0)
> > -		return ret;
> > -	ret =3D i2c_master_recv(client, &val, 1);
> > -	if (ret < 0)
> > -		return ret;
> > -
> > -	return val;
> > +	return sccb_read_byte(client, addr);
> >  }
> > =20
> >  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 =
value)
> >  {
> > -	return i2c_smbus_write_byte_data(client, addr, value);
> > +	return sccb_write_byte(client, addr, value);
> >  }

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

> Minor nit: I'd rather drop these two functions and use the
> sccb-accessors directly.
>=20
> However, I really like how this looks here: It is totally clear we are
> doing SCCB and hide away all the details.

I think it would be even better to introduce a SSCB regmap layer
and use that.

-- Sebastian

--ymylls6cogp4km77
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAltD0jcACgkQ2O7X88g7
+prVKA/+O4PdWFFtXqfzDrzg/seb4to9SN7OH/IaFtNIXadp2dco0isjla3cqBr6
nJ+1lAkOk53RwdJK/mUaqkep8JwNw6ZSMIHKQg4zDmAK3eoSgwgKgk2H3LO1y/t/
ZTr1BeQ22M+wIsU75xxdx2zltrxOMnAo00es1Slv+uijGiccpgX02rSDKDzj5kA+
CF1Te06HMzQTffE4K790rWDWQIx11i+0pU77KwOlNmAWt3UbXaAAPX73j4/e8Z1+
f1dX6BjwenX+3qfm551Khv8lLXyu3IPEozriQGOmDo6/wMzITnWvf2secTxI1lu3
iXPR3JtfrnE0sTkUAcATpHi7dRTJ+V9Jx9+n0eUJLKQnxrH9TZU/oAfW+XlSApGZ
tAUkISVg5X7gH8Od3dkVe4ztmerYmhFgxlKkvpA1Zt8Mq8sx0maQLZKXO4Fno0ga
60Sl6mkzpclYQ5dhJw4UXYyPj0QRTeno8zKAE/lDHPhjdCrsWYzBu3WgLOGhwiff
W/OQMnbi3zOwusZhi2HGQDUt9+BmAak8NcVvrSgBHSoDRZhRxWHpDO1aca425uLo
t3/OIcMNeD4vXlBtqEl1sqaH7u5Aq7QmJhxiGJo+Fr59Bm9MaRg5oY/T4DliHWmx
iL2MLBUeWafXbOKJE/fQVzFeV5IH6rDJzrT00+Y5Kxs+zi26DPc=
=QNBu
-----END PGP SIGNATURE-----

--ymylls6cogp4km77--
