Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:48159
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0EERhM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 13:37:12 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC 7/7] dsbr100: simplify access to radio device
Date: Wed,  5 May 2010 13:05:30 -0400
Message-Id: <1273079130-21999-8-git-send-email-david@identd.dyndns.org>
In-Reply-To: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
References: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
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
index cd4eed7..64ba0c8 100644
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
@@ -557,6 +557,7 @@ static int usb_dsbr100_open(struct file *file)
 		radio->status |= INITIALIZED;
 	}
 
+	file->private_data = radio;
 unlock:
 	mutex_unlock(&radio->lock);
 	return retval;
-- 
1.7.1

