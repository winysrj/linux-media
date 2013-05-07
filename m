Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:59742 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab3EGWjI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 May 2013 18:39:08 -0400
Message-ID: <51898285.507@web.de>
Date: Wed, 08 May 2013 00:39:01 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Steffen Neumann <sneumann@ipb-halle.de>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV HVR 930C-HD - new USB ID 2040:b130 ?
References: <assp.243108522f.1332706154.31585.245.camel@paddy.ipb-sub.ipb-halle.de> <CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com> <CAGoCfiza2FcrFETEeP_PdZvzdW0YuiKm4AP=wMTG465f9zBA9w@mail.gmail.com>
In-Reply-To: <CAGoCfiza2FcrFETEeP_PdZvzdW0YuiKm4AP=wMTG465f9zBA9w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VQMXRUSXQBJJWVLAADXW"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VQMXRUSXQBJJWVLAADXW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi there,

On 2012-03-26 16:49, Devin Heitmueller wrote:
> On Mon, Mar 26, 2012 at 10:46 AM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> 2040:b130 isn't an em28xx based device.  It uses cx231xx.  That said,
>> it's not supported under Linux not because of the cx231xx driver but
>> because there is no driver for the demodulator (si2163).
>=20
> Correction:  it's an si2165 (not 2163).

To pick up this old topic (as I just got the wrong 930C delivered :( ):

What is blocking the development of a si2165 driver? Lacking specs (due
to NDAs)? Or lacking interest / developer bandwidth? In case of the
latter, how much effort may it take for a kernel hacker without
particular experience in the DVB subsystem to get things running?

Thanks,
Jan


------enig2VQMXRUSXQBJJWVLAADXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGJgokACgkQitSsb3rl5xSahwCfaHNKPuNXCs4oqJ1t1OZBmnGp
FKwAoO4//OstyYyPtnjBc5FWoYxjJHpq
=q65j
-----END PGP SIGNATURE-----

------enig2VQMXRUSXQBJJWVLAADXW--
