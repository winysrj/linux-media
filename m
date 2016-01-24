Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:54284 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbcAXOnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 09:43:09 -0500
Message-ID: <1453646587.2497.73.camel@winder.org.uk>
Subject: WinTVsoloHD support
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sun, 24 Jan 2016 14:43:07 +0000
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Ez9zhGq1nAxlr8IvLvvb"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Ez9zhGq1nAxlr8IvLvvb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I see a commit=C2=A0http://git.linuxtv.org/media_tree.git/commit/?id=3D1efc=
217
01d94ed0c5b91467b042bed8b8becd5cc=C2=A0purporting to add support for
WinTVsoloHD. I am guessing this in not in the 4.3 kernel as when I plug
one of these devices in, it is unrecognized. Is there a rough ETA for
when it will be in a stock release kernel?

[91105.732017] usb 1-2.1.3: new high-speed USB device number 28 using
ehci-pci
[91105.824879] usb 1-2.1.3: New USB device found, idVendor=3D2040,
idProduct=3D0264
[91105.824883] usb 1-2.1.3: New USB device strings: Mfr=3D3, Product=3D1,
SerialNumber=3D2
[91105.824886] usb 1-2.1.3: Product: soloHD
[91105.824889] usb 1-2.1.3: Manufacturer: HCW
[91105.824891] usb 1-2.1.3: SerialNumber: 0011512731

--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder


--=-Ez9zhGq1nAxlr8IvLvvb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlak4vsACgkQ+ooS3F10Be/LzwCg3vH8gII10pUdJDWukOIinKkq
pnkAoKL1MTz4UHhGyg/s8U3AIO1Fx5UC
=pwxZ
-----END PGP SIGNATURE-----

--=-Ez9zhGq1nAxlr8IvLvvb--

