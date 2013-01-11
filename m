Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:57679 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3AKBT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 20:19:58 -0500
Received: by mail-we0-f180.google.com with SMTP id t57so591508wey.11
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 17:19:57 -0800 (PST)
Date: Fri, 11 Jan 2013 01:12:33 +0000
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
Message-ID: <20130111011232.GA3255@lambda.dereenigne.org>
References: <50EF0A4F.1000604@gmail.com>
 <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com>
 <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com>
 <CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com>
 <50EF2155.5060905@schinagl.nl>
 <CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com>
 <50EF256B.8030308@gmail.com>
 <CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com>
 <50EF276C.1080101@gmail.com>
 <50EF2AC0.20206@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <50EF2AC0.20206@schinagl.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jan 2013 21:55:28 +0100, Oliver Schinagl wrote:
> Actually, there's plenty of apps etc that depend on it. I know some=20
> distro's install it into /usr/share/dvb for all to use. I think actually=
=20
> only a very small handfull use their own scanfiles. Very small handfull=
=20
> I belive ;)

Indeed. I have just gone to file an Intent To Package bug for the
dtv-scan-tables package in Debian, but I noticed that the COPYING and
README files were not split out from the dvb-apps tree.

Logically it would follow that dtv-scan-tables is also licenced under
LGPL, the same as dvb-apps, but this needs to be stated explicitly.
This is especially true for distributions which be redistributing
dtv-scan-tables.

Thanks,
Jon

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Signed by Jonathan McCrohan

iQIcBAEBCAAGBQJQ72cAAAoJEBVu7Ac3rTKWcuAP/RF71KxzbaGkqo7J7agd+ED3
GqZtM7m4i641uvmZO0t/zEGVRCbaGxccFJ7sul/4CFDEjBezxk3+T8L7J42vnzO6
TzdEDjDfJSs5c47iV93FXSiGHK1Rs7Lvxab3YZI76raN/R01AmCsNwH8vMeZq4Yg
AOhJ7X7DKeNF4V6GgoXHq5L1in6SeaOQCloSCuBfgIW7DyTI1kSZxXOIB60u/mYb
zkVCzVmgkOH1pOgfYDJZT0pshc+jW8RxnRpU4A3qVwGjBf27AY3zOoOZWfQR1ZZR
7hHqYp/6vMKMNMLcGOQqlZj3z11leZOlpA/ZPowYtkVUIJRsOsoA4A5OvQhZnk5H
JT7md+cZF3t7WnwS8oEdgvkkn9WxSRMygNretnDrWBFLynep2QjnXAK67/otuzv1
ImAgwZvP78EMESw0pM84hEkfyNRCsu4865n2hdAElFhq3u+FnGs6StTDSQ4KjA/R
/KOk862cYaFkNM173wBOvYwSOXtAclxrAphU6LEaOWaiDYNmc37n83+Ju+81fOkj
OLeOC3GmbtarjUlXfTFy7r8QiN1OUpt9jMnnWFSaKrF/iRsU3KbOihM2oXZNiLqz
Yw6vf/cr04D4ECyAS4jDDzG/3u4lVoKc5XVU1d/CJIsz6S9Hko0qI9x/bA59a13S
PRthzKSrV/yK5gzlxvWR
=tbXi
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
