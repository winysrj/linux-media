Return-path: <mchehab@pedra>
Received: from smtp205.alice.it ([82.57.200.101]:50913 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab1D2P1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 11:27:24 -0400
Date: Fri, 29 Apr 2011 17:27:15 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linuxtv-commits@linuxtv.org, Drew Fisher <drew.m.fisher@gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] gspca - kinect: move
 communications buffers out of stack
Message-Id: <20110429172715.4b71dfb6.ospite@studenti.unina.it>
In-Reply-To: <E1QFowG-0005SZ-7v@www.linuxtv.org>
References: <E1QFowG-0005SZ-7v@www.linuxtv.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Apr_2011_17_27_15_+0200_bSy=Fjiaf2kecq5C"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Fri__29_Apr_2011_17_27_15_+0200_bSy=Fjiaf2kecq5C
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Apr 2011 16:42:04 +0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> This is an automatic generated email to let you know that the following p=
atch were queued at the=20
> http://git.linuxtv.org/media_tree.git tree:
>=20
> Subject: [media] gspca - kinect: move communications buffers out of stack
> Author:  Antonio Ospite <ospite@studenti.unina.it>
> Date:    Thu Apr 21 06:51:34 2011 -0300
>

Hi Mauro, actually this one is from Drew Fisher as well, git-am should
have picked up the additional From header:
http://www.spinics.net/lists/linux-media/msg31576.html

> Move large communications buffers out of stack and into device
> structure. This prevents the frame size from being >1kB and fixes a
> compiler warning when CONFIG_FRAME_WARN=3D1024:
>=20
> drivers/media/video/gspca/kinect.c: In function =E2=80=98send_cmd.clone.0=
=E2=80=99:
> drivers/media/video/gspca/kinect.c:202: warning: the frame size of 1548 b=
ytes is larger than 1024 bytes
>=20
> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Drew Fisher <drew.m.fisher@gmail.com>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>=20
>  drivers/media/video/gspca/kinect.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__29_Apr_2011_17_27_15_+0200_bSy=Fjiaf2kecq5C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk262NMACgkQ5xr2akVTsAEgmQCdE9GOdgJXO9Uh1cvcUktBtTdc
I7gAn2nHFQ78oqQ4NJSEmN7AjaMCxppb
=txhL
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Apr_2011_17_27_15_+0200_bSy=Fjiaf2kecq5C--
