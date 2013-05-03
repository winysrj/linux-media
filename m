Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f176.google.com ([209.85.160.176]:62662 "EHLO
	mail-gh0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934217Ab3ECTzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 15:55:32 -0400
Received: by mail-gh0-f176.google.com with SMTP id z17so342852ghb.21
        for <linux-media@vger.kernel.org>; Fri, 03 May 2013 12:55:32 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [PATCH v2] solo6x10: Approximate frame intervals with non-standard denominator
Date: Fri,  3 May 2013 16:54:57 -0300
Message-Id: <1367610897-29942-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of falling back to 1/25 (PAL) or 1/30 (NTSC).

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 38 +++++++++-------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 98e2902..a4c5896 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -996,12 +996,11 @@ static int solo_g_parm(struct file *file, void *priv,
 		       struct v4l2_streamparm *sp)
 {
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
 	cp->timeperframe.numerator = solo_enc->interval;
-	cp->timeperframe.denominator = solo_dev->fps;
+	cp->timeperframe.denominator = solo_enc->solo_dev->fps;
 	cp->capturemode = 0;
 	/* XXX: Shouldn't we be able to get/set this from videobuf? */
 	cp->readbuffers = 2;
@@ -1009,36 +1008,29 @@ static int solo_g_parm(struct file *file, void *priv,
 	return 0;
 }
 
+static inline int calc_interval(u8 fps, u32 n, u32 d)
+{
+	if (!n || !d)
+		return 1;
+	if (d == fps)
+		return n;
+	n *= fps;
+	return min(15U, n / d + (n % d >= (fps >> 1)));
+}
+
 static int solo_s_parm(struct file *file, void *priv,
 		       struct v4l2_streamparm *sp)
 {
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct v4l2_captureparm *cp = &sp->parm.capture;
+	struct v4l2_fract *t = &sp->parm.capture.timeperframe;
+	u8 fps = solo_enc->solo_dev->fps;
 
 	if (vb2_is_streaming(&solo_enc->vidq))
 		return -EBUSY;
 
-	if ((cp->timeperframe.numerator == 0) ||
-	    (cp->timeperframe.denominator == 0)) {
-		/* reset framerate */
-		cp->timeperframe.numerator = 1;
-		cp->timeperframe.denominator = solo_dev->fps;
-	}
-
-	if (cp->timeperframe.denominator != solo_dev->fps)
-		cp->timeperframe.denominator = solo_dev->fps;
-
-	if (cp->timeperframe.numerator > 15)
-		cp->timeperframe.numerator = 15;
-
-	solo_enc->interval = cp->timeperframe.numerator;
-
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
-	cp->readbuffers = 2;
-
+	solo_enc->interval = calc_interval(fps, t->numerator, t->denominator);
 	solo_update_mode(solo_enc);
-	return 0;
+	return solo_g_parm(file, priv, sp);
 }
 
 static long solo_enc_default(struct file *file, void *fh,
-- 
1.8.2.1

