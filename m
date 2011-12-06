Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30384 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176Ab1LFLAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 06:00:55 -0500
Date: Tue, 6 Dec 2011 14:00:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Olivier Grenie <Olivier.Grenie@dibcom.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [media] dib7090: add the reference board TFE7090E
Message-ID: <20111206110055.GF3374@mwanda>
References: <20111129072150.GA12145@elgon.mountain>
 <57C38DA176A0A34A9B9F3CCCE33D3C4A01686D86AB9F@FRPAR1CL009.coe.adi.dibcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Content-Disposition: inline
In-Reply-To: <57C38DA176A0A34A9B9F3CCCE33D3C4A01686D86AB9F@FRPAR1CL009.coe.adi.dibcom.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2011 at 11:13:19AM +0100, Olivier Grenie wrote:
> Dear Dan,
> Indeed, after the "if (state->rf_ramp =3D=3D NULL)" test, the function
> dib0090_set_rframp_pwm will set the state->rf_ramp. So after this
> line, state->rf_ramp can not be NULL.
>=20

Ah right.  I should have seen that myself.

> But I can make a patch in order to make sure that this code will
> not be detected as an error.

Don't do that if you don't want to.  This is fixable on the static
checker side of things.

regards,
dan carpenter



--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3fXnAAoJEOnZkXI/YHqR2SUP/iFGKjNX2ogET9WcGY2UgigG
XWU97t/HP12XevvwJc5NHCiahwRCUqBadxBlgsbsElpR+MbYfEfl/WRp9ylshlAK
5ZJLQVj2ZhPhBPw5/HQT9F7Y6+NxiOHRxt2HzJC+d1vyjgbhkHnhrCz85BGOpkx4
wghHWMzMM+1R7z1slp3lzYpZoMjNpnu1+OCRsF3z8kWcuRKqDR/UNrBGoDADzlxY
BvbJQ0wpgD4FnpBK1gz3Gd5OnwWAhEME2D3xH7koOIhNQGdD+nPi0gllRjn0K2Vs
3JxYjGLgqEctXrmeyK5ujOjE30py4/Ch5cZefe2cC7CeFsojGiEjlxhLBsS8j8EO
/an5FKNjOGARulieZHl7kYdJquzdB7uhmZF44lBTGLChLbUK+oTmT/xxJxSP7p3q
8+iD2VWPfY16799m/gepo7uhHSuhWIYQkwhd4WUT17ClEWcddTQEbTiHOg1oqKVj
7newAIe/Zeh5BRqt7uC3dFTFIyjCDFhPQdn+5IqfIj1IDFN5gTf016aPNsyp56QM
BMAX9odo0ZpWkqQ1Lvz87UQBh/DPifLi8qU9yVNyxNwSpcpmOA2UH+V6B/mbhri9
eSK2+d0GkM6txdVhoP/yeiQ+W1St0lvylxXhFfVw+oQIXaZ/PMSSlre3le54ZFQg
mYD6kBgCdN3wAE/ssiKy
=x/W7
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
