Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41818
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab0E0Qku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:50 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC v2 8/8] dsbr100: simplify access to radio device
Date: Thu, 27 May 2010 12:39:16 -0400
Message-Id: <1274978356-25836-9-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replaces calls to video_drvdata with
references to struct file->private_data which is
set during usb_dsbr100_open. This value is passed
by video_ioctl2 via the *priv argument and is
accessible via file->private_data otherwise.

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 81e6aa5..a8c3d5a 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -366,7 +366,7 @@ static void usb_dsbr100_disconnect(struct usb_interface *intf)
 static int vidioc_querycap(struct file *file, void *priv,
 					struct v4l2_capability *v)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
+	struct dsbr100_device *radio = priv;
 
 	strlcpy(v->driver, "dsbr100", sizeof(v->driver));
 	strlcpy(v->card, "D-Link R-100 USB FM Radio", sizeof(v->card));
@@ -379,7 +379,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
+	struct dsbr100_device *radio = priv;
 
 	if (v->index > 0)
 		return -EINVAL;
@@ -411,7 +411,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
+	struct dsbr100_device *radio = priv;
 	int retval = dsbr100_setfreq(radio, f->frequency);
 
 	if (retval < 0)
@@ -423,7 +423,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
+	struct dsbr100_device *radio = priv;
 
 	f->type = V4L2_TUNER_RADIO;
 	f->frequency = radio->curfreq;
@@ -444,7 +444,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
+	struct dsbr100_device *radio = priv;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
@@ -457,7 +457,7 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
+	struct dsbr100_device *radio = priv;
 	int retval;
 
 	switch (ctrl->id) {
@@ -518,7 +518,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 static long usb_dsbr100_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
+	struct dsbr100_device *radio = file->private_data;
 	long retval = 0;
 
 	mutex_lock(&radio->lock);
@@ -556,6 +556,7 @@ static int usb_dsbr100_open(struct file *file)
 		radio->status |= INITIALIZED;
 	}
 
+	file->private_data = radio;
 unlock:
 	mutex_unlock(&radio->lock);
 	return retval;
-- 
1.7.1

