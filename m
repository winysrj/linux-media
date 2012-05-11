Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1290 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2EKHz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 01/16] tda9840: fix setting of the audio mode.
Date: Fri, 11 May 2012 09:54:55 +0200
Message-Id: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

You have to first detect the current rxsubchans (mono, stereo or bilingual),
and depending on that you can set the audio mode. It does not automatically
switch when the audio channels change.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tda9840.c |   75 ++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
index 465d708..3d7ddd9 100644
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -66,29 +66,53 @@ static void tda9840_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 				val, reg);
 }
 
+static int tda9840_status(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u8 byte;
+
+	if (1 != i2c_master_recv(client, &byte, 1)) {
+		v4l2_dbg(1, debug, sd,
+			"i2c_master_recv() failed\n");
+		return -EIO;
+	}
+
+	if (byte & 0x80) {
+		v4l2_dbg(1, debug, sd,
+			"TDA9840_DETECT: register contents invalid\n");
+		return -EINVAL;
+	}
+
+	v4l2_dbg(1, debug, sd, "TDA9840_DETECT: byte: 0x%02x\n", byte);
+	return byte & 0x60;
+}
+
 static int tda9840_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *t)
 {
+	int stat = tda9840_status(sd);
 	int byte;
 
 	if (t->index)
 		return -EINVAL;
 
-	switch (t->audmode) {
-	case V4L2_TUNER_MODE_STEREO:
-		byte = TDA9840_SET_STEREO;
-		break;
-	case V4L2_TUNER_MODE_LANG1_LANG2:
-		byte = TDA9840_SET_BOTH;
-		break;
-	case V4L2_TUNER_MODE_LANG1:
-		byte = TDA9840_SET_LANG1;
-		break;
-	case V4L2_TUNER_MODE_LANG2:
-		byte = TDA9840_SET_LANG2;
-		break;
-	default:
+	stat = stat < 0 ? 0 : stat;
+	if (stat == 0 || stat == 0x60) /* mono input */
 		byte = TDA9840_SET_MONO;
-		break;
+	else if (stat == 0x40) /* stereo input */
+		byte = (t->audmode == V4L2_TUNER_MODE_MONO) ?
+			TDA9840_SET_MONO : TDA9840_SET_STEREO;
+	else { /* bilingual */
+		switch (t->audmode) {
+		case V4L2_TUNER_MODE_LANG1_LANG2:
+			byte = TDA9840_SET_BOTH;
+			break;
+		case V4L2_TUNER_MODE_LANG2:
+			byte = TDA9840_SET_LANG2;
+			break;
+		default:
+			byte = TDA9840_SET_LANG1;
+			break;
+		}
 	}
 	v4l2_dbg(1, debug, sd, "TDA9840_SWITCH: 0x%02x\n", byte);
 	tda9840_write(sd, SWITCH, byte);
@@ -97,25 +121,14 @@ static int tda9840_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *t)
 
 static int tda9840_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *t)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	u8 byte;
-
-	t->rxsubchans = V4L2_TUNER_SUB_MONO;
-	if (1 != i2c_master_recv(client, &byte, 1)) {
-		v4l2_dbg(1, debug, sd,
-			"i2c_master_recv() failed\n");
-		return -EIO;
-	}
+	int stat = tda9840_status(sd);
 
-	if (byte & 0x80) {
-		v4l2_dbg(1, debug, sd,
-			"TDA9840_DETECT: register contents invalid\n");
-		return -EINVAL;
-	}
+	if (stat < 0)
+		return stat;
 
-	v4l2_dbg(1, debug, sd, "TDA9840_DETECT: byte: 0x%02x\n", byte);
+	t->rxsubchans = V4L2_TUNER_SUB_MONO;
 
-	switch (byte & 0x60) {
+	switch (stat & 0x60) {
 	case 0x00:
 		t->rxsubchans = V4L2_TUNER_SUB_MONO;
 		break;
-- 
1.7.10

