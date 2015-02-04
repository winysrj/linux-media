Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55876 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933017AbbBDJIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 04:08:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Prashant Laddha <prladdha@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] vivid sdr: Use LUT based implementation for sin/cos()
Date: Wed,  4 Feb 2015 10:07:31 +0100
Message-Id: <1423040852-7470-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1423040852-7470-1-git-send-email-hverkuil@xs4all.nl>
References: <1423040852-7470-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Prashant Laddha <prladdha@cisco.com>

The common implementation for sin/cos in include/linux/fixp-arith.h
has been improved recently to provide higher precision.

Replacing native implementation of sin/cos in vivid sdr with common
implementation. This serves two purposes:

1. Improved accuracy: the native implementation based on the Taylor
   series is more prone to rounding errors.
2. Reuse of common function: this is better compared to maintaining
   native versions for each driver.

Suggested by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-sdr-cap.c | 66 ++++++++++++----------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 4af55f1..5e089cb 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-dv-timings.h>
+#include <linux/fixp-arith.h>
 
 #include "vivid-core.h"
 #include "vivid-ctrls.h"
@@ -423,40 +424,19 @@ int vidioc_g_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
 	return 0;
 }
 
-#define FIXP_FRAC    (1 << 15)
-#define FIXP_PI      ((int)(FIXP_FRAC * 3.141592653589))
-
-/* cos() from cx88 driver: cx88-dsp.c */
-static s32 fixp_cos(unsigned int x)
-{
-	u32 t2, t4, t6, t8;
-	u16 period = x / FIXP_PI;
-
-	if (period % 2)
-		return -fixp_cos(x - FIXP_PI);
-	x = x % FIXP_PI;
-	if (x > FIXP_PI/2)
-		return -fixp_cos(FIXP_PI/2 - (x % (FIXP_PI/2)));
-	/* Now x is between 0 and FIXP_PI/2.
-	 * To calculate cos(x) we use it's Taylor polinom. */
-	t2 = x*x/FIXP_FRAC/2;
-	t4 = t2*x/FIXP_FRAC*x/FIXP_FRAC/3/4;
-	t6 = t4*x/FIXP_FRAC*x/FIXP_FRAC/5/6;
-	t8 = t6*x/FIXP_FRAC*x/FIXP_FRAC/7/8;
-	return FIXP_FRAC-t2+t4-t6+t8;
-}
-
-static inline s32 fixp_sin(unsigned int x)
-{
-	return -fixp_cos(x + (FIXP_PI / 2));
-}
+#define FIXP_N    (15)
+#define FIXP_FRAC (1 << FIXP_N)
+#define FIXP_2PI  ((int)(2 * 3.141592653589 * FIXP_FRAC))
 
 void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
 	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned long i;
 	unsigned long plane_size = vb2_plane_size(&buf->vb, 0);
-	int fixp_src_phase_step, fixp_i, fixp_q;
+	s32 src_phase_step;
+	s32 mod_phase_step;
+	s32 fixp_i;
+	s32 fixp_q;
 
 	/*
 	 * TODO: Generated beep tone goes very crackly when sample rate is
@@ -466,28 +446,36 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 	/* calculate phase step */
 	#define BEEP_FREQ 1000 /* 1kHz beep */
-	fixp_src_phase_step = DIV_ROUND_CLOSEST(2 * FIXP_PI * BEEP_FREQ,
+	src_phase_step = DIV_ROUND_CLOSEST(FIXP_2PI * BEEP_FREQ,
 			dev->sdr_adc_freq);
 
 	for (i = 0; i < plane_size; i += 2) {
-		dev->sdr_fixp_mod_phase += fixp_cos(dev->sdr_fixp_src_phase);
-		dev->sdr_fixp_src_phase += fixp_src_phase_step;
+		mod_phase_step = fixp_cos32_rad(dev->sdr_fixp_src_phase,
+						FIXP_2PI) >> (31 - FIXP_N);
+
+		dev->sdr_fixp_src_phase += src_phase_step;
+		dev->sdr_fixp_mod_phase += mod_phase_step;
 
 		/*
 		 * Transfer phases to [0 / 2xPI] in order to avoid variable
 		 * overflow and make it suitable for cosine implementation
 		 * used, which does not support negative angles.
 		 */
-		while (dev->sdr_fixp_mod_phase < (0 * FIXP_PI))
-			dev->sdr_fixp_mod_phase += (2 * FIXP_PI);
-		while (dev->sdr_fixp_mod_phase > (2 * FIXP_PI))
-			dev->sdr_fixp_mod_phase -= (2 * FIXP_PI);
+		while (dev->sdr_fixp_mod_phase < FIXP_2PI)
+			dev->sdr_fixp_mod_phase += FIXP_2PI;
+		while (dev->sdr_fixp_mod_phase > FIXP_2PI)
+			dev->sdr_fixp_mod_phase -= FIXP_2PI;
+
+		while (dev->sdr_fixp_src_phase > FIXP_2PI)
+			dev->sdr_fixp_src_phase -= FIXP_2PI;
 
-		while (dev->sdr_fixp_src_phase > (2 * FIXP_PI))
-			dev->sdr_fixp_src_phase -= (2 * FIXP_PI);
+		fixp_i = fixp_cos32_rad(dev->sdr_fixp_mod_phase, FIXP_2PI);
+		fixp_q = fixp_sin32_rad(dev->sdr_fixp_mod_phase, FIXP_2PI);
 
-		fixp_i = fixp_cos(dev->sdr_fixp_mod_phase);
-		fixp_q = fixp_sin(dev->sdr_fixp_mod_phase);
+		/* Normalize fraction values represented with 32 bit precision
+		 * to fixed point representation with FIXP_N bits */
+		fixp_i >>= (31 - FIXP_N);
+		fixp_q >>= (31 - FIXP_N);
 
 		/* convert 'fixp float' to u8 */
 		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0] */
-- 
2.1.4

