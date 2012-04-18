Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:56900 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2DRNms (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 09:42:48 -0400
Date: Wed, 18 Apr 2012 15:37:20 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Subject: gspca V4L2_CID_EXPOSURE_AUTO and VIDIOC_G/S/TRY_EXT_CTRLS
Message-Id: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Apr_2012_15_37_20_+0200_RFp_SXMUR09l7XVe"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__18_Apr_2012_15_37_20_+0200_RFp_SXMUR09l7XVe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed that AEC (Automatic Exposure Control, or
V4L2_CID_EXPOSURE_AUTO) does not work in the ov534 gspca driver, either
from guvcview or qv4l2.

=46rom what I can see (but I do not have a deep knowledge of v4l2) this
happens because:
  - V4L2_CID_EXPOSURE_AUTO is of class V4L2_CTRL_CLASS_CAMERA which is
    greater than V4L2_CTRL_CLASS_USER
  - some programs use VIDIOC_G_EXT_CTRLS with this class of controls;
    for instance v4l2-ctrl does more or less this:

	if (V4L2_CTRL_ID2CLASS(qctrl.id) !=3D V4L2_CTRL_CLASS_USER)
		test_ioctl(fd, VIDIOC_G_EXT_CTRLS, &ctrls)
	else
		test_ioctl(fd, VIDIOC_G_CTRL, &ctrl)

  - gspca does not handle the _EXT_CTRLS ioclts

So in ov534, but I think in m5602 too, V4L2_CID_EXPOSURE_AUTO does not
work from guvcview, qv4l2, or v4l2-ctrl, for instance the latter fails
with the message:

	error 25 getting ext_ctrl Auto Exposure

I tried adding an hackish implementation of vidioc_g_ext_ctrls and
vidioc_s_ext_ctrls to gspca, and with these V4L2_CID_EXPOSURE_AUTO seems
to work, but I need to learn more about this kind of controls before
I can propose a decent implementation for mainline inclusion myself, so
if anyone wants to anticipate me I'd be glad to test :)

Unrelated, but maybe worth mentioning is that V4L2_CID_EXPOSURE_AUTO is
of type MENU, while some drivers are treating it as a boolean, I think
I can fix this one if needed.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__18_Apr_2012_15_37_20_+0200_RFp_SXMUR09l7XVe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+Ow5AACgkQ5xr2akVTsAE9VACfdrl64kAWvBEwoIrwuozGDfT+
+tMAn0Wd7GDFIy3bsJXjHIm8vXUDPaYT
=GHLw
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Apr_2012_15_37_20_+0200_RFp_SXMUR09l7XVe--
