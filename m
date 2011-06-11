Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4302 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab1FKNez (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:34:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/7] tuner-core: change return type of set_mode_freq to bool
Date: Sat, 11 Jun 2011 15:34:38 +0200
Message-Id: <bc50de0678f248e158b78194e6179ab867dee636.1307798213.git.hans.verkuil@cisco.com>
In-Reply-To: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
References: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

set_mode_freq currently returns 0 or -EINVAL. But -EINVAL does not
indicate a error that should be passed on, it just indicates that the
tuner does not support the requested mode. So change the return type to
bool.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 083b9f1..ee43e0a 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -746,11 +746,11 @@ static bool supported_mode(struct tuner *t, enum v4l2_tuner_type mode)
  * @freq:	frequency to set (0 means to use the previous one)
  *
  * If tuner doesn't support the needed mode (radio or TV), prints a
- * debug message and returns -EINVAL, changing its state to standby.
- * Otherwise, changes the state and sets frequency to the last value, if
- * the tuner can sleep or if it supports both Radio and TV.
+ * debug message and returns false, changing its state to standby.
+ * Otherwise, changes the state and sets frequency to the last value
+ * and returns true.
  */
-static int set_mode_freq(struct i2c_client *client, struct tuner *t,
+static bool set_mode_freq(struct i2c_client *client, struct tuner *t,
 			 enum v4l2_tuner_type mode, unsigned int freq)
 {
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
@@ -762,7 +762,7 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
 			t->standby = true;
 			if (analog_ops->standby)
 				analog_ops->standby(&t->fe);
-			return -EINVAL;
+			return false;
 		}
 		t->mode = mode;
 		tuner_dbg("Changing to mode %d\n", mode);
@@ -777,7 +777,7 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
 		set_tv_freq(client, t->tv_freq);
 	}
 
-	return 0;
+	return true;
 }
 
 /*
@@ -1075,8 +1075,7 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode_freq(client, t, V4L2_TUNER_RADIO, 0) == -EINVAL)
-		return 0;
+	set_mode_freq(client, t, V4L2_TUNER_RADIO, 0);
 	return 0;
 }
 
@@ -1110,7 +1109,7 @@ static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode_freq(client, t, V4L2_TUNER_ANALOG_TV, 0) == -EINVAL)
+	if (!set_mode_freq(client, t, V4L2_TUNER_ANALOG_TV, 0))
 		return 0;
 
 	t->std = std;
@@ -1124,9 +1123,7 @@ static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode_freq(client, t, f->type, f->frequency) == -EINVAL)
-		return 0;
-
+	set_mode_freq(client, t, f->type, f->frequency);
 	return 0;
 }
 
@@ -1197,7 +1194,7 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (set_mode_freq(client, t, vt->type, 0) == -EINVAL)
+	if (!set_mode_freq(client, t, vt->type, 0))
 		return 0;
 
 	if (t->mode == V4L2_TUNER_RADIO)
-- 
1.7.1

