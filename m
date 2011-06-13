Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4042 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1FMMxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 08:53:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 7/9] tuner-core/v4l2-subdev: document that the type field has to be filled in.
Date: Mon, 13 Jun 2011 14:53:18 +0200
Message-Id: <626b719da313cde86fe7fa1248c112f0feb2e269.1307969319.git.hans.verkuil@cisco.com>
In-Reply-To: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
References: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
References: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The tuner ops g_frequency, g_tuner and s_tuner require that the tuner type
field is filled in. Document this.

The tuner-core doc is based on a patch from Mauro Carvalho Chehab <mchehab@redhat.com>.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |   29 +++++++++++++++++++++++++++++
 include/media/v4l2-subdev.h      |    7 +++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 3b30d80..cb007d3 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1135,6 +1135,16 @@ static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	return 0;
 }
 
+/**
+ * tuner_g_frequency - Get the tuned frequency for the tuner
+ * @sd: pointer to struct v4l2_subdev
+ * @f: pointer to struct v4l2_frequency
+ *
+ * At return, the structure f will be filled with tuner frequency
+ * if the tuner matches the f->type.
+ * Note: f->type should be initialized before calling it.
+ * This is done by either video_ioctl2 or by the bridge driver.
+ */
 static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 {
 	struct tuner *t = to_tuner(sd);
@@ -1157,6 +1167,16 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	return 0;
 }
 
+/**
+ * tuner_g_tuner - Fill in tuner information
+ * @sd: pointer to struct v4l2_subdev
+ * @vt: pointer to struct v4l2_tuner
+ *
+ * At return, the structure vt will be filled with tuner information
+ * if the tuner matches vt->type.
+ * Note: vt->type should be initialized before calling it.
+ * This is done by either video_ioctl2 or by the bridge driver.
+ */
 static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct tuner *t = to_tuner(sd);
@@ -1197,6 +1217,15 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
+/**
+ * tuner_s_tuner - Set the tuner's audio mode
+ * @sd: pointer to struct v4l2_subdev
+ * @vt: pointer to struct v4l2_tuner
+ *
+ * Sets the audio mode if the tuner matches vt->type.
+ * Note: vt->type should be initialized before calling it.
+ * This is done by either video_ioctl2 or by the bridge driver.
+ */
 static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct tuner *t = to_tuner(sd);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2245020..2884e3e 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -175,6 +175,13 @@ struct v4l2_subdev_core_ops {
 
 /* s_radio: v4l device was opened in radio mode.
 
+   g_frequency: freq->type must be filled in. Normally done by video_ioctl2
+	or the bridge driver.
+
+   g_tuner:
+   s_tuner: vt->type must be filled in. Normally done by video_ioctl2 or the
+	bridge driver.
+
    s_type_addr: sets tuner type and its I2C addr.
 
    s_config: sets tda9887 specific stuff, like port1, port2 and qss
-- 
1.7.1

