Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2798 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3EaKDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [PATCH 10/21] radio-tea5764: some cleanups and clamp frequency when out-of-range
Date: Fri, 31 May 2013 12:02:30 +0200
Message-Id: <1369994561-25236-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some small cleanups and when setting the frequency it is now clamped
to the valid frequency range instead of returning an error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index c22feed..036e2f5 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -60,8 +60,8 @@
 
 /* Frequency limits in MHz -- these are European values.  For Japanese
 devices, that would be 76000 and 91000.  */
-#define FREQ_MIN  87500
-#define FREQ_MAX 108000
+#define FREQ_MIN  87500U
+#define FREQ_MAX 108000U
 #define FREQ_MUL 16
 
 /* TEA5764 registers */
@@ -309,8 +309,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (v->index > 0)
 		return -EINVAL;
 
-	memset(v, 0, sizeof(*v));
-	strcpy(v->name, "FM");
+	strlcpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	tea5764_i2c_read(radio);
 	v->rangelow   = FREQ_MIN * FREQ_MUL;
@@ -343,19 +342,23 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
 	struct tea5764_device *radio = video_drvdata(file);
+	unsigned freq = f->frequency;
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
-	if (f->frequency == 0) {
+	if (freq == 0) {
 		/* We special case this as a power down control. */
 		tea5764_power_down(radio);
-	}
-	if (f->frequency < (FREQ_MIN * FREQ_MUL))
-		return -EINVAL;
-	if (f->frequency > (FREQ_MAX * FREQ_MUL))
+		/* Yes, that's what is returned in this case. This
+		   whole special case is non-compliant and should really
+		   be replaced with something better, but changing this
+		   might well break code that depends on this behavior.
+		   So we keep it as-is. */
 		return -EINVAL;
+	}
+	clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
 	tea5764_power_up(radio);
-	tea5764_tune(radio, (f->frequency * 125) / 2);
+	tea5764_tune(radio, (freq * 125) / 2);
 	return 0;
 }
 
@@ -368,7 +371,6 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (f->tuner != 0)
 		return -EINVAL;
 	tea5764_i2c_read(radio);
-	memset(f, 0, sizeof(*f));
 	f->type = V4L2_TUNER_RADIO;
 	if (r->tnctrl & TEA5764_TNCTRL_PUPD0)
 		f->frequency = (tea5764_get_freq(radio) * 2) / 125;
-- 
1.7.10.4

