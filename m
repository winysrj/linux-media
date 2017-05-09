Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36990 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbdEIK7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 06:59:50 -0400
Date: Tue, 9 May 2017 12:59:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [patch, libv4l]: fix typos
Message-ID: <20170509105947.GA28248@amd>
References: <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Fix random typos. (I searched, and the ALSA define does not seem to be
used anywhere, so this should not break anything.)
   =20
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 0ba0a88..1b06b6f 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -789,7 +789,7 @@ no_capture:
=20
 	/* Note we always tell v4lconvert to optimize src fmt selection for
 	   our default fps, the only exception is the app explicitly selecting
-	   a fram erate using the S_PARM ioctl after a S_FMT */
+	   a frame rate using the S_PARM ioctl after a S_FMT */
 	if (devices[index].convert)
 		v4lconvert_set_fps(devices[index].convert, V4L2_DEFAULT_FPS);
 	v4l2_update_fps(index, &parm);
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index bf8b85a..d1c89da 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -17,7 +17,7 @@
  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-13=
01, USA.
  */
=20
-#ifdef ENABLE_ASLA
+#ifdef ENABLE_ALSA
 extern "C" {
 #include "alsa_stream.h"
 }

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlkRoSMACgkQMOfwapXb+vIOoACdGSWmjIIQYDQkonMtyROsImWS
urUAmM6ti+5NJONerVzAdIj/nSDtrzs=
=M4dK
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
