Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48582 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdEHW2W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 18:28:22 -0400
Date: Tue, 9 May 2017 00:28:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [patch, libv4l]: fix integer overflow
Message-ID: <20170508222819.GA14833@amd>
References: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

This bit me while trying to use absolute exposure time on Nokia N900:

Can someone apply it to libv4l2 tree? Could I get some feedback on the
other patches? Is this the way to submit patches to libv4l2?

Thanks,
								Pavel

commit 0484e39ec05fdc644191e7c334a7ebfff9cb2ec5
Author: Pavel <pavel@ucw.cz>
Date:   Mon May 8 21:52:02 2017 +0200

    Fix integer overflow with EXPOSURE_ABSOLUTE.

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

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkQ8QMACgkQMOfwapXb+vJ6BACdEHP3nn75PjVNJHxLqOmIW/GL
/xkAoIdbLSolcavTBhEMPm7SZP1niZaZ
=Ti75
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
