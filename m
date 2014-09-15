Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40959 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbaIOXTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 19:19:24 -0400
Received: by mail-wi0-f179.google.com with SMTP id q5so3144534wiv.6
        for <linux-media@vger.kernel.org>; Mon, 15 Sep 2014 16:19:22 -0700 (PDT)
Date: Tue, 16 Sep 2014 00:19:19 +0100
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Olliver Schinagl <oliver@schinagl.nl>, linux-media@vger.kernel.org
Subject: Re: Added channel parsers for DVB-S2 and DVB-T2 at libdvbv5 and
 found some issues at dtv-scan-tables
Message-ID: <20140915231919.GB11669@lambda.dereenigne.org>
References: <20140904235603.31973b7f.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <20140904235603.31973b7f.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Thu, Sep 04, 2014 at 11:56:03PM -0300, Mauro Carvalho Chehab wrote:
> I added some improvements at libdvbv5 to parse the DVB-T2 and DVB-S2 lines
> at dtv-scan-tables.
>=20
> It can now successully parse all correct files there. The patches for
> it are already merged upstream at:
> 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/
>=20
> I also added there the Makefile from Jonathan that adds support
> for converting from DVBv3 to DVBv5, and added myself some logic
> there to convert back from DVBv5 into DVBv3 format.

I've been away from my mail for a few days; many thanks for this work. I
hope to upload a new version of dtv-scan-tables which incorporates these
changes to Debian soon. Gregor has already uploaded the new version of
v4l-utils [1].

Jon

[1] https://packages.qa.debian.org/v/v4l-utils/news/20140909T180008Z.html

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Signed by Jonathan McCrohan

iQIcBAABCgAGBQJUF3P3AAoJEBVu7Ac3rTKWvRwQAJ0m9ajy7CZWl7x94WAsjTgv
dnmZPugV0HqF5dsKSCt7UCfx5G+XdMxxc/x5gJzBLBAFHL7NjYuDx+pNUUHk/VU7
UTh9iaWEji67hCy81RmXmQg50XVH77Ok+0HKi39EGLZWh0ZVEGJAbyfmkMH4+60T
Miyft3h0VOejQWPc/+SQUQ4/twI8FA+0hFSHGDevEsLt52iYAjxmvYSzWikhZRoH
VkzCJErMqqskbyLeWm8P2wto6uHs2xk2Zj6pn6zcAB/q8hyHlpKw3S/vlH4NLRYM
zZnqm3il5d0vNJ5bkBDC051xj7//w6Hfpav/BncnFMhGTx3L11kuW3mirlEM2Wai
LokaUIlIa48b2SFG9fQXRhH5irN9mzlFvvPiOPH5SSvqeOiB1tYcvW08ttIdDf3V
r5ANNvBHdfgBjuVVoZA45xUbWAa6jtOg/3wddv8eZJsu1X8NHbbtz8QN9q6rDbZI
bv57Mt5KA0qmOvhZtfC5b7voxcpkdkXqFhoiPQvSyx/BeSvGGhfDospUcM3kOHdb
yCPKznQ00H4IqBmLuMY5SIs7dguBpKXFaCwAHpw+jd5EOyATy0IhnQ/LIBICJ56J
rW2ihNle36ABuKW3UOChgxuKYvQQMxGusoxiy4yM295of/mI4lfJZ4vujoSL+plp
qd7NR+6ZEz0pobVYFiRQ
=T//1
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
