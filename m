Return-path: <mchehab@gaivota>
Received: from spectre.t3rror.net ([188.40.142.143]:44119 "EHLO
	mail.t3rror.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755423Ab0LPN3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 08:29:34 -0500
Received: from boris64.localnet (a89-183-73-207.net-htp.de [89.183.73.207])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: boris64)
	by mail.t3rror.net (Postfix) with ESMTPSA id 986142594C
	for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 14:29:29 +0100 (CET)
To: linux-media@vger.kernel.org
Subject: TeVii S470 dvb-s2 issues
From: Boris Cuber <me@boris64.net>
Reply-To: me@boris64.net
Date: Thu, 16 Dec 2010 14:29:32 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3204889.n5Q5j7mhIl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012161429.32658.me@boris64.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--nextPart3204889.n5Q5j7mhIl
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello linux-media people!

I have to problems with my dvb card ("TeVii S470"). I already
filed 2 bug reports some time ago, but no one seems to have
noticed/read them, so i'm trying it here now.

1) "TeVii S470 dvbs-2 card (cx23885) is not usable after pm-suspend/resume"
https://bugzilla.kernel.org/show_bug.cgi?id=3D16467

2) "cx23885: ds3000_writereg: writereg error on >=3Dkernel-2.6.36-rc with T=
eVii"=20
S470 dvb-s2 card
=2D> https://bugzilla.kernel.org/show_bug.cgi?id=3D18832

Are these issues known? If so, are there any fixes yet? When will these
get into mainline? Could somebody point me into the right direction.
Can i help somehow to debug these problems?
Where is the correct place to report bugs about dvb/v4l kernel stuff?

Thank you in advance.

Regards,
	Boris Cuber

=2D-=20
http://boris64.net 20xx ;)

--nextPart3204889.n5Q5j7mhIl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJNChQ8AAoJEONrv02ePEYNGqYP/2n48uZ90c9gF8Emc4IbmqCb
yHjtaG1vQtOm/9Y2y0zOiqF7fgIdRK8bFaZG2QZucMV6zJuii//ZoKb8ZS6JTYj9
hauMzdo0QZ4aSDTqaSnN1JWkwv5o0InItGrV4tE6uVKWqs4wl4YGvZKAZOwx//cg
gQWo+vZbOucMoMSb1ao0s59MbMXRkbgbjQKJPM+z87jtGuxQJTKfj6unqrdNBgJG
KQqb/QQ7f10K76H+OXzt+GEHTuKuenNSDPyj5AdEawJVvba31mIRG6nzKhMS3h8M
GlLRHuAhAK5crmAQG8v3ofXwuwVcP8+w4mIguxDFAokNOwAo7pTsQ/JEccv6Pmu+
okqUOdD5kuxJjzNnqwsMuEqNZCZpdLU9s8o1kvSorOdtnCwzMAewN3lYyPgdi9Zb
i3DZUq83lMtD/888RoU49XK0Ei6yCxHh5Pl5hZJrwD1uQxaDtUOxs9GTKJYgRWA8
jQQ6dhEjamzUhHtPjz2YtC92dMfRrJAuWZEMI4Be89MinWIlhHui3qmNRiWkWyNG
yACERMimytThUTicjDT/+cO3nqSfGgOGt/WXGzA8Ya6+u8ePYXeESY5JeCWoVL5n
7xjFzW1Tqo1ivLyyTBUmP6VBN0s7VNLXlitICHM0cZ628oK6zSiGsvHXl3dMhNQH
UQsf1iFTaEqsf6pWSTfS
=P/hg
-----END PGP SIGNATURE-----

--nextPart3204889.n5Q5j7mhIl--
