Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4738 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1FNHOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 08/10] tuner-core/v4l2-subdev: document that the type field has to be filled in.
Date: Tue, 14 Jun 2011 09:14:40 +0200
Message-Id: <1ab3bf37c5bc0adcde938ec13b05b2f6b76f6df6.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
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
index a5aaf25..8dffe50 100644
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

