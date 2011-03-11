Return-path: <mchehab@pedra>
Received: from smtp209.alice.it ([82.57.200.105]:46323 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab1CKJ1D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 04:27:03 -0500
Date: Fri, 11 Mar 2011 10:21:00 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 1/4] v4l: add V4L2_PIX_FMT_Y12 format
Message-Id: <20110311102100.b6faa55a.ospite@studenti.unina.it>
In-Reply-To: <1299830749-7269-2-git-send-email-michael.jones@matrix-vision.de>
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de>
	<1299830749-7269-2-git-send-email-michael.jones@matrix-vision.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Mar_2011_10_21_00_+0100_9IzGKcnvk3SEIl=2"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Fri__11_Mar_2011_10_21_00_+0100_9IzGKcnvk3SEIl=2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Mar 2011 09:05:46 +0100
Michael Jones <michael.jones@matrix-vision.de> wrote:

> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  Documentation/DocBook/v4l/pixfmt-y12.xml |   79 ++++++++++++++++++++++++=
++++++
>  include/linux/videodev2.h                |    1 +
>  2 files changed, 80 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml
>

Hi Michael,

are you going to release also Y12 conversion routines for libv4lconvert?

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__11_Mar_2011_10_21_00_+0100_9IzGKcnvk3SEIl=2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk156XwACgkQ5xr2akVTsAFWEQCfbRfcuOThOiL2sqHDdhk+qoh4
ZcAAnAr/rYkhBaMyS8MtJv6T8Z/etY/z
=PuAv
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Mar_2011_10_21_00_+0100_9IzGKcnvk3SEIl=2--
