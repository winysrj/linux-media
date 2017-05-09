Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37148 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752576AbdEILEm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 07:04:42 -0400
Date: Tue, 9 May 2017 13:04:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [patch, libv4l]: Introduce define for lookup table size
Message-ID: <20170509110440.GC28248@amd>
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
        protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Make lookup table size configurable at compile-time.
   =20
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/lib/libv4lconvert/processing/libv4lprocessing-priv.h b/lib/lib=
v4lconvert/processing/libv4lprocessing-priv.h
index e4a29dd..55e1687 100644
--- a/lib/libv4lconvert/processing/libv4lprocessing-priv.h
+++ b/lib/libv4lconvert/processing/libv4lprocessing-priv.h
@@ -25,6 +25,8 @@
 #include "../libv4lsyscall-priv.h"
=20
 #define V4L2PROCESSING_UPDATE_RATE 10
+/* Size of lookup tables */
+#define LSIZE 256
=20
 struct v4lprocessing_data {
 	struct v4lcontrol_data *control;
@@ -32,15 +34,15 @@ struct v4lprocessing_data {
 	int do_process;
 	int controls_changed;
 	/* True if any of the lookup tables does not contain
-	   linear 0-255 */
+	   linear 0-LSIZE-1 */
 	int lookup_table_active;
 	/* Counts the number of processed frames until a
 	   V4L2PROCESSING_UPDATE_RATE overflow happens */
 	int lookup_table_update_counter;
 	/* RGB/BGR lookup tables */
-	unsigned char comp1[256];
-	unsigned char green[256];
-	unsigned char comp2[256];
+	unsigned char comp1[LSIZE];
+	unsigned char green[LSIZE];
+	unsigned char comp2[LSIZE];
 	/* Filter private data for filters which need it */
 	/* whitebalance.c data */
 	int green_avg;
@@ -48,7 +50,7 @@ struct v4lprocessing_data {
 	int comp2_avg;
 	/* gamma.c data */
 	int last_gamma;
-	unsigned char gamma_table[256];
+	unsigned char gamma_table[LSIZE];
 	/* autogain.c data */
 	int last_gain_correction;
 };
diff --git a/lib/libv4lconvert/processing/libv4lprocessing.c b/lib/libv4lco=
nvert/processing/libv4lprocessing.c
index b061f50..6d0ad20 100644
--- a/lib/libv4lconvert/processing/libv4lprocessing.c
+++ b/lib/libv4lconvert/processing/libv4lprocessing.c
@@ -74,7 +74,7 @@ static void v4lprocessing_update_lookup_tables(struct v4l=
processing_data *data,
 {
 	int i;
=20
-	for (i =3D 0; i < 256; i++) {
+	for (i =3D 0; i < LSIZE; i++) {
 		data->comp1[i] =3D i;
 		data->green[i] =3D i;
 		data->comp2[i] =3D i;
diff --git a/lib/libv4lconvert/processing/whitebalance.c b/lib/libv4lconver=
t/processing/whitebalance.c
index c74069a..2dd33c1 100644
--- a/lib/libv4lconvert/processing/whitebalance.c
+++ b/lib/libv4lconvert/processing/whitebalance.c
@@ -27,7 +27,7 @@
 #include "libv4lprocessing-priv.h"
 #include "../libv4lconvert-priv.h" /* for PIX_FMT defines */
=20
-#define CLIP256(color) (((color) > 0xff) ? 0xff : (((color) < 0) ? 0 : (co=
lor)))
+#define CLIPLSIZE(color) (((color) > LSIZE) ? LSIZE : (((color) < 0) ? 0 :=
 (color)))
 #define CLIP(color, min, max) (((color) > (max)) ? (max) : (((color) < (mi=
n)) ? (min) : (color)))
=20
 static int whitebalance_active(struct v4lprocessing_data *data)
@@ -111,10 +111,10 @@ static int whitebalance_calculate_lookup_tables_gener=
ic(
=20
 	avg_avg =3D (data->green_avg + data->comp1_avg + data->comp2_avg) / 3;
=20
-	for (i =3D 0; i < 256; i++) {
-		data->comp1[i] =3D CLIP256(data->comp1[i] * avg_avg / data->comp1_avg);
-		data->green[i] =3D CLIP256(data->green[i] * avg_avg / data->green_avg);
-		data->comp2[i] =3D CLIP256(data->comp2[i] * avg_avg / data->comp2_avg);
+	for (i =3D 0; i < LSIZE; i++) {
+		data->comp1[i] =3D CLIPLSIZE(data->comp1[i] * avg_avg / data->comp1_avg);
+		data->green[i] =3D CLIPLSIZE(data->green[i] * avg_avg / data->green_avg);
+		data->comp2[i] =3D CLIPLSIZE(data->comp2[i] * avg_avg / data->comp2_avg);
 	}
=20
 	return 1;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkRokgACgkQMOfwapXb+vLNlQCfeJKXH+WLqUF4xIrZ4vEpIS+Y
2wMAoIHS1FGmv+cs0ax3VpPEKiqTzdOx
=L9vp
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
