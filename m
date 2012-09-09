Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50553 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919Ab2IIWBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 18:01:11 -0400
Message-ID: <1347228041.7709.128.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [patch v2] [media] rc-core: prevent divide by zero bug in
 s_tx_carrier()
From: Ben Hutchings <ben@decadent.org.uk>
To: wharms@bfs.de
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Sean Young <sean@mess.org>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 09 Sep 2012 23:00:41 +0100
In-Reply-To: <504D03BD.8010203@bfs.de>
References: <20120909203142.GA12296@elgon.mountain>
	 <504D03BD.8010203@bfs.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iXa/u8d20Akdlw2R2AQg"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-iXa/u8d20Akdlw2R2AQg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-09-09 at 23:01 +0200, walter harms wrote:
> Hi all,
> I am not sure if that is a good idea.
> it should be in the hands of the driver who to use these 'val'
>
> some driver may need a higher value like this one:

I doubt that any driver can actually work with the full range of
positive values, but at least they're less likely to crash.

> static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
> {
> 	struct iguanair *ir =3D dev->priv;
>=20
> 	if (carrier < 25000 || carrier > 150000)
> 		return -EINVAL;
>=20
> There are also examples where 0 has a special meaning (to be fair not
> with this function). Example:
>   cfsetospeed() ...  The zero baud rate, B0, is used to terminate the con=
nection.
>
> I have no clue who will use the 0 but ...
[...]

If an ioctl is defined for a whole class of devices then it is perfectly
valid for the core code for that class to do (some) parameter validation
for the ioctl.  As I'm not really familiar with LIRC I can't say for
sure that 0 is invalid, but if it is then driver writers should not
expect to be able to assign a driver-specific meaning to it.  Consider
what would happen if the LIRC developers wanted to assign a generic
meaning to a value of 0 some time later.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-iXa/u8d20Akdlw2R2AQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUE0Riee/yOyVhhEJAQq8/A/9EM/BQmm14dCe0JETW6A62dxzlQr+0Qpq
P8nSZOetjXs+EcKh//n0bZvqFPXyu+N5UHjZT3GeI3g+NVkPqmPEuFERtM4qlQS7
1huJ/em8TfZ7MfeEDLtD5qCEyN9YzkQOFwRl/+SGMuGHYIfToKd5JfGUpueyF7rL
Wa1A/dCGdwkGhemDaT8GyJxHizvrAGIZAMwzpKKQbiAZ5i3Z9PMWVLfOBR0avtb1
bKl8fS5TsbHfHz8q9ORaO8mGOcFBlTVXA2aBfXlM/ZWj8xjbVMvPxOwN/GiVsYOx
SWih4D408/loNbyAj8flIMKFR3RFr/qiyYQMms69bbKaqhzAcOq+ZiytGIA1ACDU
ofpOwAfSa+1ITv8y0a9Abl+A0cHI9TLVZu/a41OjitpzfGZs2yp8wD2TlrVS2v1x
ItOahFLMLA5UpivHxwslJkppUXEJGaHmrv7IvHipjAyabGsLc+cqScHLF3UAT4Wb
OccrJAcHFw71LC9nR6HDXMLBqhnyPvgs8e+U/XguB2ABx8oXMNX6smobOAFQyHFP
uG2J6fn1RapE2HGll+QQGWUM05CTuVW109z8M1KJiHyMQvH0SQjHOIDN9IOdY2N5
OnPHuR/JlNaY3SF2Zbex/5K8lgw6ES5CvYjqjwl+ouLRfammX7ruguzpyIm5tH27
6A7wgGUiNUw=
=5wfN
-----END PGP SIGNATURE-----

--=-iXa/u8d20Akdlw2R2AQg--
