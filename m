Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60710 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbdEIIHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 04:07:54 -0400
Date: Tue, 9 May 2017 10:07:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [patch, libv4l]: fix integer overflow
Message-ID: <20170509080752.GA19912@amd>
References: <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20170508222819.GA14833@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Fix integer overflow with EXPOSURE_ABSOLUTE. This is problem for
example with Nokia N900.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index e795aee..189fc06 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1776,7 +1776,7 @@ int v4l2_set_control(int fd, int cid, int value)
 		if (qctrl.type =3D=3D V4L2_CTRL_TYPE_BOOLEAN)
 			ctrl.value =3D value ? 1 : 0;
 		else
-			ctrl.value =3D (value * (qctrl.maximum - qctrl.minimum) + 32767) / 6553=
5 +
+			ctrl.value =3D ((long long) value * (qctrl.maximum - qctrl.minimum) + 3=
2767) / 65535 +
 				qctrl.minimum;
=20
 		result =3D v4lconvert_vidioc_s_ctrl(devices[index].convert, &ctrl);
@@ -1812,7 +1812,7 @@ int v4l2_get_control(int fd, int cid)
 		if (v4l2_propagate_ioctl(index, VIDIOC_G_CTRL, &ctrl))
 			return -1;
=20
-	return ((ctrl.value - qctrl.minimum) * 65535 +
+	return (((long long) ctrl.value - qctrl.minimum) * 65535 +
 			(qctrl.maximum - qctrl.minimum) / 2) /
 		(qctrl.maximum - qctrl.minimum);
 }





--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkReNgACgkQMOfwapXb+vKXLQCfQpehIV9w6cRRd6r3kpdSnykp
UBYAoJiQGx5GD8Cl6fWwipeKmTrZDKF2
=hBrD
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
