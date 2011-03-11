Return-path: <mchehab@pedra>
Received: from smtp205.alice.it ([82.57.200.101]:57825 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1CKLQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 06:16:12 -0500
Date: Fri, 11 Mar 2011 12:15:45 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 1/4] v4l: add V4L2_PIX_FMT_Y12 format
Message-Id: <20110311121545.ddd50947.ospite@studenti.unina.it>
In-Reply-To: <4D79ED80.3070508@matrix-vision.de>
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de>
	<1299830749-7269-2-git-send-email-michael.jones@matrix-vision.de>
	<20110311102100.b6faa55a.ospite@studenti.unina.it>
	<4D79ED80.3070508@matrix-vision.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Mar_2011_12_15_45_+0100_K3N5MRAncLcsZJpn"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Fri__11_Mar_2011_12_15_45_+0100_K3N5MRAncLcsZJpn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Mar 2011 10:38:08 +0100
Michael Jones <michael.jones@matrix-vision.de> wrote:

> On 03/11/2011 10:21 AM, Antonio Ospite wrote:
> > Hi Michael,
> >=20
> > are you going to release also Y12 conversion routines for libv4lconvert?
> >=20
> > Regards,
> >    Antonio
> >=20
>=20
> Hi Antonio,
>=20
> As I am neither a user nor developer of libv4lconvert, I am not planning
> on adding Y12 conversion routines there.  Hopefully somebody else will
> step up.  Maybe you?
>=20

I asked just for curiosity as I don't have any device producing this
Y12 format, however I _might_ play with it if you can provide some Y12
(or Y10) raw frames. I am playing with some compressed variant of Y10
and I am exploring different ways to add support for those formats to
libv4l.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__11_Mar_2011_12_15_45_+0100_K3N5MRAncLcsZJpn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk16BGEACgkQ5xr2akVTsAFUpQCeJYtO1lgr2QyOVWVRN/Jis1j/
zV8An0VkXzj1LaqwnCh0NIevf+JUt+C/
=m9oH
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Mar_2011_12_15_45_+0100_K3N5MRAncLcsZJpn--
