Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53226 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaDYTkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 15:40:23 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so3056217eek.39
        for <linux-media@vger.kernel.org>; Fri, 25 Apr 2014 12:40:21 -0700 (PDT)
Message-ID: <535ABA1B.8010701@dragonslave.de>
Date: Fri, 25 Apr 2014 21:40:11 +0200
From: Daniel Exner <dex@dragonslave.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: dex@dragonslave.de
Subject: Re: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
References: <535823E6.8020802@dragonslave.de> <CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com> <5358279C.5060108@dragonslave.de> <20140424082919.66f7eab1@samsung.com> <20140424210930.592ec21c@Mycroft> <CAGoCfiwp1q1nLbStR-htsq=PdLpHPvkhy0CsGO=_1SRX_O-Pdg@mail.gmail.com> <20140424182626.47f5f01e@samsung.com>
In-Reply-To: <20140424182626.47f5f01e@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="hmhrf0OTg0jFtOcvmPr8MgLwLQ8d6lMal"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hmhrf0OTg0jFtOcvmPr8MgLwLQ8d6lMal
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Am 24.04.2014 23:26, schrieb Mauro Carvalho Chehab:
> Em Thu, 24 Apr 2014 15:24:20 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
[...]

> What can do, instead, is to sniff the traffic at the USB port, and get
> the proper GPIO, XCLK and I2C speed settings for this device.
>=20
> My suggestion is to either run it on a QEMU VM machine, redirecting
> the USB device to the VM and sniffing the traffic on Linux, or to
> use some USB snoop software.
>=20
> Take a look at: http://linuxtv.org/wiki/index.php/Bus_snooping/sniffing=

>=20
> We have a script that parses em28xx traffic, converting them into
> register writes. All you need to do is to sniff the traffic and check
> what GPIO registers are needed to reset the device.
>=20
> Then, add the corresponding data at em28xx-cards.c.


Ok, I managed to setup a VBox with "TheOtherOS" and usbmon and sniffed
some traffic when I (virtually) plugged in the device.

The file is (compressed) about ~620 KiB.

I am honest: I have no clue what I sniffed or how I should read GPIO
registers from there.

If anyone is interested in helping me I would send the file directly.

Greetings
Daniel
--=20
Daniel Exner
Public-Key: https://www.dragonslave.de/pub_key.asc


--hmhrf0OTg0jFtOcvmPr8MgLwLQ8d6lMal
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTWroiAAoJEJzUMd6kHcEpYF8P+wWEHRn0R+PJdG+ylU65MF0W
A25Zq0jRp1M00QyfCGIT/9zvVqBgw5SWrOsi8vIEd+Y3XtcoKDKLnGaAyU6VshdB
yRfLhVbRVzz1Bo8h5zvv9Q6Jt4CfC4k4eU2HDZnpLyYt/55L2hhBkcQBHEZF9NDx
3N0aigrU+ZoQGyCC14+fUxfxJxENrcuiSlRCfcSJ+QdItuV/bhSd9UTBgIZFfvhm
9tl79grznPIVEE9afKaZ6pNEUu7y5moYUq1+s/YO+ZUYb7pp3Pi+eodUvfaLR29i
Ut8e3YeW6/qBpv7qkWWl9fz9z0sQkSUmZRmcQMLo1p0QG0S7xct6xqSi2a5cefWg
WSWMJnZ6WcomStenPRKAgtxTOcc8aO0ni1HmjFv+iLoP5g3ZpUg8uwxAIwPsXJgP
KkTQHOzjzH3RJ31LhWPalPGDQK7gAxv5dxmSv01A6+d3ncMq0qrfKGjgVNrSNQpP
rHwP2PR4C0jYerL8VejPeSqYFuuiLhYnj/5eeEPprZn4kdOZ1kLdFh4Uhjrh9SUk
y4CWGMd1C6SYuX0l7cI85gDieIjzxz2HrAB132zdUL2dE/P+6j7jg71TBUC+6Dah
9AKeiVkS+FicsiYDOL32QXpr5rEZkVhPcKRrnVqO6baZSJJ5ieaOsZtdLXInKU7J
aEuoBfORMUCTsft9EU6J
=KNY2
-----END PGP SIGNATURE-----

--hmhrf0OTg0jFtOcvmPr8MgLwLQ8d6lMal--
