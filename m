Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:59357 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab3EHHRL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 03:17:11 -0400
Message-ID: <5189FBED.10704@web.de>
Date: Wed, 08 May 2013 09:17:01 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Steffen Neumann <sneumann@ipb-halle.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV HVR 930C-HD - new USB ID 2040:b130 ?
References: <assp.243108522f.1332706154.31585.245.camel@paddy.ipb-sub.ipb-halle.de> <CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com> <CAGoCfiza2FcrFETEeP_PdZvzdW0YuiKm4AP=wMTG465f9zBA9w@mail.gmail.com> <51898285.507@web.de> <CAGoCfiw3Q1d7qrrCJyZfhLpkNe7wWhsXnuXapb+MHemapHVg5A@mail.gmail.com>
In-Reply-To: <CAGoCfiw3Q1d7qrrCJyZfhLpkNe7wWhsXnuXapb+MHemapHVg5A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2JHCVWIFNIKWRDOMCMFUP"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2JHCVWIFNIKWRDOMCMFUP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-05-08 05:29, Devin Heitmueller wrote:
> On Tue, May 7, 2013 at 6:39 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
>> To pick up this old topic (as I just got the wrong 930C delivered :( )=
:
>>
>> What is blocking the development of a si2165 driver? Lacking specs (du=
e
>> to NDAs)? Or lacking interest / developer bandwidth?
>=20
> Probably a bit of both.  I've got the documentation under NDA, and
> last I checked it's not otherwise publicly available.

Does this NDA only prevent revealing the documentation itself or also
code that has been written using it? Could the vendor be motivated to
allow the latter?

>  That said, the
> chip has been around for several years and no developer has ever cared
> to do a reverse engineered driver.  The chip isn't overly complicated
> (I could probably write a driver for it in a week even without the
> datasheets), alas there has never really been any interest.

Well, the problem today is (if my recherche was correct) that there
aren't that many USB DVB-C adapters on the market with well working
mainline drivers. The old 930C used to be one of, if not the best. But
that version is not longer produced and now practically no longer
obtainable.

>=20
>> In case of the
>> latter, how much effort may it take for a kernel hacker without
>> particular experience in the DVB subsystem to get things running?
>=20
> Not rocket science, for sure.  Probably the bigger issue is
> familiarity with reverse engineering techniques and a good
> understanding of how demodulators work.  Learning the API itself is
> the easy part (given there are plenty of example drivers to use as a
> model).
>=20
> I can count on one hand the number of developers who are actively
> contributing tuner/demod drivers.  There just is very little developer
> interest in this area nowadays.

I would know how to extract the USB communication between the device and
real or virtual machine running Windows and the Hauppauge software
stack. I may also find out which bits are missing during setup compared
to what a basic cx231xx setup [1] is doing, but then it gets hairy for
me as I definitely lack domain knowledge. Ah, and time is also an issue,
of course. ;)

You worked for Hauppauge in the past, right? Do you think they could be
motivated to support you working on this?

Thanks,
Jan

[1] http://forum.ubuntu-it.org/viewtopic.php?t=3D423395



------enig2JHCVWIFNIKWRDOMCMFUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGJ+/QACgkQitSsb3rl5xQWmQCg7tGJ9uI5/amK/8sdQAQnftZ1
2TsAoOcuvETRgY1I742wmJpwkp5Q9uPP
=Tg0x
-----END PGP SIGNATURE-----

------enig2JHCVWIFNIKWRDOMCMFUP--
