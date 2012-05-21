Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45260 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616Ab2EUN44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 09:56:56 -0400
Message-ID: <1337608600.10262.8.camel@deadeye>
Subject: Firmware blob in vs6624 driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Mon, 21 May 2012 14:56:40 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RHWkLYRp0GVnurJMKfyk"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-RHWkLYRp0GVnurJMKfyk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The array vs6624_p1 is a list of bytes to write to the VS6624's
microcontroller registers/memory, written before it starts running code:

	vs6624_writeregs(sd, vs6624_p1);
	vs6624_write(sd, VS6624_MICRO_EN, 0x2);
	vs6624_write(sd, VS6624_DIO_EN, 0x1);
	mdelay(10);

This doesn't touch any of the documented registers, so presumably it's a
patch to the firmware loaded from non-volatile memory.  Unless you can
provide source code for the patch, this should go in the linux-firmware
repository and be loaded with request_firmware() instead of embedded in
the GPL driver source.

Also, shouldn't you check the loaded firmware version first to verify
that it's safe to apply the patch?

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-RHWkLYRp0GVnurJMKfyk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7pJmOe/yOyVhhEJAQph4xAAwLfh8Zpl6x08MN5Tfgxf3Rg+Gt/+co5N
4HX9IH5Y4Q0Kkf+3Am9kRQwPwHfPWXRKn1UTRVwzqwddpXAN6iHBln9wf7gStz3W
Xt/zkG5SqYKkpB0XRNokyjl3JAiRmH97z69mjBzvUZjVyMcUqVnn6LvA5ps1UjVt
6F0vmIT07Ei0X6w5h0QwAv9858wLMZlfgX8q4DZoPtstDG18NuRgTrMNEE7kKNUt
B4rCjy2fc3hccw6WmGCqaOTbksiIiNcXRqn8udSJYt6993R4yXHxbF+0hh7uZIQq
p3o0UUEuWorB8XlTEXB2iQlt4Wq1VrKeVA3e4HrqXEisck88oXOeWUq3xFtbrehI
ZQxRVmktV3xgzbgABLYb7E9WBxadUKoxZtr9cbBMwJuR/0PWiXKh9/KTwjSofsRN
fIERuSRax3i7xCqthw6y3tlNPzOFrvi0xt5Urhtysc6NBPs+kTVINzpXB13rouGz
8lEiKWJFzzYR6f94w2CYLzH7wuHjuYyNUK63FDyd9Ate1M/SLWiXLH48rlyUX1fw
jtRwAmWABMxhl1LHdg9y0XwjcvBCIOnUr31TsHTwjYp/inEXHttSQO5qnnaWkcm0
eAXYgtYM11sXsQjaLZ0PV3RDGGnYeE94QPbfTofgBcFoJvr3arvpQ7lH6Oh3wSRg
kHteZitOVPs=
=z4d2
-----END PGP SIGNATURE-----

--=-RHWkLYRp0GVnurJMKfyk--
