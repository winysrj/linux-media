Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3893 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab1FKNez (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:34:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/7] tuner-core: rename check_mode to supported_mode
Date: Sat, 11 Jun 2011 15:34:37 +0200
Message-Id: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
In-Reply-To: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The check_mode function checks whether a mode is supported. So calling it
supported_mode is more appropriate. In addition it returned either 0 or
-EINVAL which suggests that the -EINVAL error should be passed on. However,
that's not the case so change the return type to bool.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5748d04..083b9f1 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -723,22 +723,19 @@ static int tuner_remove(struct i2c_client *client)
  */
 
 /**
- * check_mode - Verify if tuner supports the requested mode
+ * supported_mode - Verify if tuner supports the requested mode
  * @t: a pointer to the module's internal struct_tuner
  *
  * This function checks if the tuner is capable of tuning analog TV,
  * digital TV or radio, depending on what the caller wants. If the
- * tuner can't support that mode, it returns -EINVAL. Otherwise, it
- * returns 0.
+ * tuner can't support that mode, it returns false. Otherwise, it
+ * returns true.
  * This function is needed for boards that have a separate tuner for
  * radio (like devices with tea5767).
  */
-static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
+static bool supported_mode(struct tuner *t, enum v4l2_tuner_type mode)
 {
-	if ((1 << mode & t->mode_mask) == 0)
-		return -EINVAL;
-
-	return 0;
+	return 1 << mode & t->mode_mask;
 }
 
 /**
@@ -759,7 +756,7 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
 	if (mode != t->mode) {
-		if (check_mode(t, mode) == -EINVAL) {
+		if (!supported_mode(t, mode)) {
 			tuner_dbg("Tuner doesn't support mode %d. "
 				  "Putting tuner to sleep\n", mode);
 			t->standby = true;
@@ -1138,7 +1135,7 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct tuner *t = to_tuner(sd);
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (check_mode(t, f->type) == -EINVAL)
+	if (!supported_mode(t, f->type))
 		return 0;
 	f->type = t->mode;
 	if (fe_tuner_ops->get_frequency && !t->standby) {
@@ -1161,7 +1158,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (check_mode(t, vt->type) == -EINVAL)
+	if (!supported_mode(t, vt->type))
 		return 0;
 	vt->type = t->mode;
 	if (analog_ops->get_afc)
-- 
1.7.1

