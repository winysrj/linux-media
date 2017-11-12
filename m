Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44639 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdKLO1V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Nov 2017 09:27:21 -0500
Date: Sun, 12 Nov 2017 15:27:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        hverkuil@xs4all.nl
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, sre@kernel.org, ivo.g.dimitrov.75@gmail.com,
        linux-media@vger.kernel.org
Subject: [rfc] libv4l2: better auto-gain
Message-ID: <20171112142719.GA24519@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Add support for better autogain. Old code had average brightness as a
target. New code has number of bright pixels as a target.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

I see I need to implement histogram for bayer8 and rgb24. Any other
comments?

Best regards,
								Pavel

diff --git a/lib/libv4lconvert/processing/autogain.c b/lib/libv4lconvert/pr=
ocessing/autogain.c
index c6866d6..a2c69f4 100644
--- a/lib/libv4lconvert/processing/autogain.c
+++ b/lib/libv4lconvert/processing/autogain.c
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <math.h>
=20
 #include "libv4lprocessing.h"
 #include "libv4lprocessing-priv.h"
@@ -40,179 +41,136 @@ static int autogain_active(struct v4lprocessing_data =
*data)
 	return autogain;
 }
=20
-/* Adjust ctrl value with steps steps, while not crossing limit */
-static void autogain_adjust(struct v4l2_queryctrl *ctrl, int *value,
-		int steps, int limit, int accel)
+#define BUCKETS 20
+
+static void v4l2_histogram_bayer10(unsigned short *buf, int cdf[], const s=
truct v4l2_format *fmt)
 {
-	int ctrl_range =3D (ctrl->maximum - ctrl->minimum) / ctrl->step;
-
-	/* If we are of 3 * deadzone or more, and we have a fine grained
-	   control, take larger steps, otherwise we take ages to get to the
-	   right setting point. We use 256 as tripping point for determining
-	   fine grained controls here, as avg_lum has a range of 0 - 255. */
-	if (accel && abs(steps) >=3D 3 && ctrl_range > 256)
-		*value +=3D steps * ctrl->step * (ctrl_range / 256);
-        /* If we are of by less then 3, but have a very finegrained control
-           still speed things up a bit */
-	else if (accel && ctrl_range > 1024)
-		*value +=3D steps * ctrl->step * (ctrl_range / 1024);
-	else
-		*value +=3D steps * ctrl->step;
-
-	if (steps > 0) {
-		if (*value > limit)
-			*value =3D limit;
-	} else {
-		if (*value < limit)
-			*value =3D limit;
-	}
+	for (int y =3D 0; y < fmt->fmt.pix.height; y+=3D19)
+		for (int x =3D 0; x < fmt->fmt.pix.width; x+=3D19) {
+			int b;
+			b =3D buf[fmt->fmt.pix.width*y + x];
+			b =3D (b * BUCKETS)/(1024);
+			cdf[b]++;
+		}
 }
=20
-/* auto gain and exposure algorithm based on the knee algorithm described =
here:
-http://ytse.tricolour.net/docs/LowLightOptimization.html */
-static int autogain_calculate_lookup_tables(
-		struct v4lprocessing_data *data,
-		unsigned char *buf, const struct v4l2_format *fmt)
+static int v4l2_s_ctrl(int fd, long id, long value)
 {
-	int x, y, target, steps, avg_lum =3D 0;
-	int gain, exposure, orig_gain, orig_exposure, exposure_low;
+        int res;
 	struct v4l2_control ctrl;
-	struct v4l2_queryctrl gainctrl, expoctrl;
-	const int deadzone =3D 6;
-
-	ctrl.id =3D V4L2_CID_EXPOSURE;
-	expoctrl.id =3D V4L2_CID_EXPOSURE;
-	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &expoctrl) ||
-			SYS_IOCTL(data->fd, VIDIOC_G_CTRL, &ctrl))
-		return 0;
-
-	exposure =3D orig_exposure =3D ctrl.value;
-	/* Determine a value below which we try to not lower the exposure,
-	   as most exposure controls tend to jump with big steps in the low
-	   range, causing oscilation, so we prefer to use gain when exposure
-	   has hit this value */
-	exposure_low =3D (expoctrl.maximum - expoctrl.minimum) / 10;
-	/* If we have a fine grained exposure control only avoid the last 10 step=
s */
-	steps =3D exposure_low / expoctrl.step;
-	if (steps > 10)
-		steps =3D 10;
-	exposure_low =3D steps * expoctrl.step + expoctrl.minimum;
-
-	ctrl.id =3D V4L2_CID_GAIN;
-	gainctrl.id =3D V4L2_CID_GAIN;
-	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &gainctrl) ||
-			SYS_IOCTL(data->fd, VIDIOC_G_CTRL, &ctrl))
-		return 0;
-	gain =3D orig_gain =3D ctrl.value;
-
-	switch (fmt->fmt.pix.pixelformat) {
-	case V4L2_PIX_FMT_SGBRG8:
-	case V4L2_PIX_FMT_SGRBG8:
-	case V4L2_PIX_FMT_SBGGR8:
-	case V4L2_PIX_FMT_SRGGB8:
-		buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
-			fmt->fmt.pix.width / 4;
-
-		for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
-			for (x =3D 0; x < fmt->fmt.pix.width / 2; x++)
-				avg_lum +=3D *buf++;
-			buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width / 2;
-		}
-		avg_lum /=3D fmt->fmt.pix.height * fmt->fmt.pix.width / 4;
-		break;
-
-	case V4L2_PIX_FMT_RGB24:
-	case V4L2_PIX_FMT_BGR24:
-		buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
-			fmt->fmt.pix.width * 3 / 4;
-
-		for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
-			for (x =3D 0; x < fmt->fmt.pix.width / 2; x++) {
-				avg_lum +=3D *buf++;
-				avg_lum +=3D *buf++;
-				avg_lum +=3D *buf++;
-			}
-			buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width * 3 / 2;
-		}
-		avg_lum /=3D fmt->fmt.pix.height * fmt->fmt.pix.width * 3 / 4;
-		break;
-	}
+        ctrl.id =3D id;
+	ctrl.value =3D value;
+	/* FIXME: we'd like to do v4l2_ioctl here, but headers
+	   prevent that */
+        res =3D SYS_IOCTL(fd, VIDIOC_S_CTRL, &ctrl);
+        if (res < 0)
+                printf("Set control %lx %ld failed\n", id, value);
+        return res;
+}
=20
-	/* If we are off a multiple of deadzone, do multiple steps to reach the
-	   desired lumination fast (with the risc of a slight overshoot) */
-	target =3D v4lcontrol_get_ctrl(data->control, V4LCONTROL_AUTOGAIN_TARGET);
-	steps =3D (target - avg_lum) / deadzone;
-
-	/* If we were decreasing and are now increasing, or vica versa, half the
-	   number of steps to avoid overshooting and oscilating */
-	if ((steps > 0 && data->last_gain_correction < 0) ||
-			(steps < 0 && data->last_gain_correction > 0))
-		steps /=3D 2;
-
-	if (steps =3D=3D 0)
-		return 0; /* Nothing to do */
-
-	if (steps < 0) {
-		if (exposure > expoctrl.default_value)
-			autogain_adjust(&expoctrl, &exposure, steps,
-			                expoctrl.default_value, 1);
-		else if (gain > gainctrl.default_value)
-			autogain_adjust(&gainctrl, &gain, steps,
-			                gainctrl.default_value, 1);
-		else if (exposure > exposure_low)
-			autogain_adjust(&expoctrl, &exposure, steps,
-			                exposure_low, 1);
-		else if (gain > gainctrl.minimum)
-			autogain_adjust(&gainctrl, &gain, steps,
-			                gainctrl.minimum, 1);
-		else if (exposure > expoctrl.minimum)
-			autogain_adjust(&expoctrl, &exposure, steps,
-			                expoctrl.minimum, 0);
-		else
-			steps =3D 0;
-	} else {
-		if (exposure < exposure_low)
-			autogain_adjust(&expoctrl, &exposure, steps,
-			                exposure_low, 0);
-		else if (gain < gainctrl.default_value)
-			autogain_adjust(&gainctrl, &gain, steps,
-			                gainctrl.default_value, 1);
-		else if (exposure < expoctrl.default_value)
-			autogain_adjust(&expoctrl, &exposure, steps,
-			                expoctrl.default_value, 1);
-		else if (gain < gainctrl.maximum)
-			autogain_adjust(&gainctrl, &gain, steps,
-			                gainctrl.maximum, 1);
-		else if (exposure < expoctrl.maximum)
-			autogain_adjust(&expoctrl, &exposure, steps,
-			                expoctrl.maximum, 1);
-		else
-			steps =3D 0;
+static int v4l2_set_exposure(struct v4lprocessing_data *data, double expos=
ure)
+{
+	double exp, gain; /* microseconds */
+	int exp_, gain_;
+	int fd =3D data->fd;
+
+	gain =3D 1;
+	exp =3D exposure / gain;
+	if (exp > 10000) {
+		exp =3D 10000;
+		gain =3D exposure / exp;
 	}
-
-	if (steps) {
-		data->last_gain_correction =3D steps;
-		/* We are still settling down, force the next update sooner. Note we
-		   skip the next frame as that is still captured with the old settings,
-		   and another one just to be sure (because if we re-adjust based
-		   on the old settings we might overshoot). */
-		data->lookup_table_update_counter =3D V4L2PROCESSING_UPDATE_RATE - 2;
+	if (gain > 16) {
+		gain =3D 16;
+		exp =3D exposure / gain;
 	}
=20
-	if (gain !=3D orig_gain) {
-		ctrl.id =3D V4L2_CID_GAIN;
-		ctrl.value =3D gain;
-		SYS_IOCTL(data->fd, VIDIOC_S_CTRL, &ctrl);
+	exp_ =3D exp;
+	gain_ =3D 10*log(gain)/log(2);=20
+	printf("Exposure %f %d, gain %f %d\n", exp, exp_, gain, gain_);
+
+	/* gain | ISO | gain_
+	 * 1.   | 100 | 0
+	 * 2.   | 200 | 10
+	 * ...
+         * 16.   | 1600 | 40
+	 */
+		=09
+	if (v4l2_s_ctrl(fd, V4L2_CID_GAIN, gain_) < 0) {
+		printf("Could not set gain\n");
 	}
-	if (exposure !=3D orig_exposure) {
-		ctrl.id =3D V4L2_CID_EXPOSURE;
-		ctrl.value =3D exposure;
-		SYS_IOCTL(data->fd, VIDIOC_S_CTRL, &ctrl);
+	if (v4l2_s_ctrl(fd, V4L2_CID_EXPOSURE_ABSOLUTE, exp_) < 0) {
+		printf("Could not set exposure\n");
 	}
+	return 0;
+}
+
+struct exposure_data {
+	double exposure;
+};
=20
+static int autogain_calculate_lookup_tables_exp(
+		struct v4lprocessing_data *data,
+		unsigned char *buf, const struct v4l2_format *fmt)
+{
+	int cdf[BUCKETS] =3D { 0, };
+	static struct exposure_data e_data;
+	static struct exposure_data *exp =3D &e_data;
+
+	v4l2_histogram_bayer10((void *) buf, cdf, fmt);
+
+	for (int i=3D1; i<BUCKETS; i++)
+		cdf[i] +=3D cdf[i-1];
+
+	int b =3D BUCKETS;
+	int brightPixels =3D cdf[b-1] - cdf[b-8];
+	int targetBrightPixels =3D cdf[b-1]/50;
+	int maxSaturatedPixels =3D cdf[b-1]/200;
+	int saturatedPixels =3D cdf[b-1] - cdf[b-2];
+	/* how much should I change brightness by */
+	float adjustment =3D 1.0f;
+	 =20
+	if (saturatedPixels > maxSaturatedPixels) {
+		/* first don't let things saturate too much */
+		adjustment =3D 1.0f - ((float)(saturatedPixels - maxSaturatedPixels))/cd=
f[b-1];
+	} else if (brightPixels < (targetBrightPixels - (saturatedPixels * 4))) {
+		/* increase brightness to try and hit the desired
+		   number of well exposed pixels
+		 */
+		int l =3D b-6;
+		while (brightPixels < targetBrightPixels && l > 0) {
+			brightPixels +=3D cdf[l];
+			brightPixels -=3D cdf[l-1];
+			l--;
+		}
+
+		adjustment =3D ((float) (b-6+1))/(l+1);
+	}
+	/* else  we're not oversaturated, and we have enough bright pixels.
+	         Do nothing.
+	 */
+
+	float limit =3D 4;
+	if (adjustment > limit) { adjustment =3D limit; }
+	if (adjustment < 1/limit) { adjustment =3D 1/limit; }
+
+	exp->exposure *=3D adjustment;
+	if (exp->exposure < 1)
+		exp->exposure =3D 1;
+
+	float elimit =3D 64000000;
+	if (exp->exposure > elimit)
+		exp->exposure =3D elimit;
+=09
+	if (adjustment !=3D 1.)
+		printf("AutoExposure: adjustment: %f exposure %f\n",
+		       adjustment, exp->exposure);
+
+	v4l2_set_exposure(data, exp->exposure);
 	return 0;
 }
=20
 struct v4lprocessing_filter autogain_filter =3D {
-	autogain_active, autogain_calculate_lookup_tables
+	autogain_active, autogain_calculate_lookup_tables_exp
 };
+


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloIWkcACgkQMOfwapXb+vLd6gCfR7ncMRIZX5Y5n4il1Re1wJXr
93gAnAtBKiVriU/Yf+UvRHROdFMRnL7N
=eFAt
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
