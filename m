Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41902 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbdIUOPa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:15:30 -0400
Date: Thu, 21 Sep 2017 16:15:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v5 2/6] i2c: add helpers to ease DMA handling
Message-ID: <20170921141528.xre53zpxwk355uih@ninjato>
References: <20170920185956.13874-1-wsa+renesas@sang-engineering.com>
 <20170920185956.13874-3-wsa+renesas@sang-engineering.com>
 <20170921145922.000017b5@huawei.com>
 <20170921150554.0000273b@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w6ftkolbg5vznbjm"
Content-Disposition: inline
In-Reply-To: <20170921150554.0000273b@huawei.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--w6ftkolbg5vznbjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > +/**
> > > + * i2c_release_dma_safe_msg_buf - release DMA safe buffer and sync w=
ith i2c_msg
> > > + * @msg: the message to be synced with
> > > + * @buf: the buffer obtained from i2c_get_dma_safe_msg_buf(). May be=
 NULL.
> > > + */
> > > +void i2c_release_dma_safe_msg_buf(struct i2c_msg *msg, u8 *buf)
> > > +{
> > > +	if (!buf || buf =3D=3D msg->buf)
> > > +		return;
> > > +
> > > +	if (msg->flags & I2C_M_RD)
> > > +		memcpy(msg->buf, buf, msg->len);
> > > +
> > > +	kfree(buf);
>=20
> Only free when you actually allocated it.  Seems to me like you need
> to check if (!(msg->flags & I2C_M_DMA_SAFE)) before kfree.
>=20
> Otherwise the logic to do this will be needed in every driver
> which will get irritating fast.

Well, I return early if (buf =3D=3D msg->buf) which is only true for
I2C_M_DMA_SAFE. If not, I allocated the buffer. Am I missing something?
It would be very strange to call this function if the caller allocated
the buffer manually.

Thanks for the review!


--w6ftkolbg5vznbjm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlnDyX8ACgkQFA3kzBSg
KbZ6vQ/8DVnICg6Y7oVJJjW+2tRs1msMuxWdFFhK8lX4eN2JvlcOadjG3mXdj0y9
np+aAoD48LRnuQkdxXrwwtm4VE526CRrYYgB7VUs3G6utB5JbiU+vOXIbEzwRhcm
ZKCvUZ03c5C2nJN+t53xoa7s31OfpwqvrznbatrnSzm1o9G1jVuE+JGYNico0rsB
8JhDZdomU8qBpTh/BgvnUrFh6IipiNR089wuk5zxzXRYoz0YTcDSigcCFs8AAzoR
247o80FDa76SdYIPaz4lyuRNvNJLjtmk4n3VB5AyTYDkNfVjMoeJhAiccuJUeo4C
5tPNGGy1m8PW8YGc6Mo3BtKHvcxhaDqYUg1JXbCVbTVVZ8f8OfaA+hvtJl23yBko
6DxippV4Z0XPAboW6vc7J9DKBrxw91wgKCBIyeErFpFku63MPfJBaKwGZvMIO0lQ
txYtXYIsT3utP0IDOiv8+OWeDk4MwxNlExSf7YaZD1hWkFxwa2egrZVrNBzeoJJJ
D1CxYugt3JBfs7mFHwjoBEOdebKklMH1dgAuRqwv8qrI+CnV4oHeXG0dCC3IWaEi
78rs/WfgasuwW5NJrhzu16JiXfA5C799P/CLPgmbeeblIQF3reF5CjsHPfgHCy45
ZKzbQcKBRWlurSzOKiAOB9bZ/f5cxI1zit/ZVev6Qv32hKK/EW0=
=MaaV
-----END PGP SIGNATURE-----

--w6ftkolbg5vznbjm--
