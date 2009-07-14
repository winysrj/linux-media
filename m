Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:44237 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZGNFL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 01:11:58 -0400
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KMR0085OAFX9Q@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 14:11:57 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KMR00DDWAFXSA@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 14:11:57 +0900 (KST)
Date: Tue, 14 Jul 2009 14:11:57 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 3/4] radio-si470x: add disconnect check function
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com, klimov.linux@gmail.com
Message-id: <4A5C139D.3070409@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The si470x_disconnect_check is function to check disconnect state of
radio in common file. The function is implemented in each interface
file.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 .../media/radio/si470x/radio-si470x-common.c       |   40 +++++++++----------
 .../drivers/media/radio/si470x/radio-si470x-usb.c  |   17 ++++++++
 linux/drivers/media/radio/si470x/radio-si470x.h    |    1 +
 3 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/linux/drivers/media/radio/si470x/radio-si470x-common.c b/linux/drivers/media/radio/si470x/radio-si470x-common.c
index 2be22bd..84cbea3 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/linux/drivers/media/radio/si470x/radio-si470x-common.c
@@ -475,10 +475,9 @@ static int si470x_vidioc_g_ctrl(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
-	if (radio->disconnected) {
-		retval = -EIO;
+	retval = si470x_disconnect_check(radio);
+	if (retval)
 		goto done;
-	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -511,10 +510,9 @@ static int si470x_vidioc_s_ctrl(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
-	if (radio->disconnected) {
-		retval = -EIO;
+	retval = si470x_disconnect_check(radio);
+	if (retval)
 		goto done;
-	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -567,10 +565,10 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
-	if (radio->disconnected) {
-		retval = -EIO;
+	retval = si470x_disconnect_check(radio);
+	if (retval)
 		goto done;
-	}
+
 	if (tuner->index != 0) {
 		retval = -EINVAL;
 		goto done;
@@ -649,10 +647,10 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 	int retval = -EINVAL;
 
 	/* safety checks */
-	if (radio->disconnected) {
-		retval = -EIO;
+	retval = si470x_disconnect_check(radio);
+	if (retval)
 		goto done;
-	}
+
 	if (tuner->index != 0)
 		goto done;
 
@@ -688,10 +686,10 @@ static int si470x_vidioc_g_frequency(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
-	if (radio->disconnected) {
-		retval = -EIO;
+	retval = si470x_disconnect_check(radio);
+	if (retval)
 		goto done;
-	}
+
 	if (freq->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
@@ -718,10 +716,10 @@ static int si470x_vidioc_s_frequency(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
-	if (radio->disconnected) {
-		retval = -EIO;
+	retval = si470x_disconnect_check(radio);
+	if (retval)
 		goto done;
-	}
+
 	if (freq->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
@@ -747,10 +745,10 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
-	if (radio->disconnected) {
-		retval = -EIO;
+	retval = si470x_disconnect_check(radio);
+	if (retval)
 		goto done;
-	}
+
 	if (seek->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
diff --git a/linux/drivers/media/radio/si470x/radio-si470x-usb.c b/linux/drivers/media/radio/si470x/radio-si470x-usb.c
index 6508161..2f5cf6c 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/linux/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -371,6 +371,23 @@ static int si470x_get_scratch_page_versions(struct si470x_device *radio)
 
 
 /**************************************************************************
+ * General Driver Functions - DISCONNECT_CHECK
+ **************************************************************************/
+
+/*
+ * si470x_disconnect_check - check whether radio disconnects
+ */
+int si470x_disconnect_check(struct si470x_device *radio)
+{
+	if (radio->disconnected)
+		return -EIO;
+	else
+		return 0;
+}
+
+
+
+/**************************************************************************
  * RDS Driver Functions
  **************************************************************************/
 
diff --git a/linux/drivers/media/radio/si470x/radio-si470x.h b/linux/drivers/media/radio/si470x/radio-si470x.h
index 6b85315..6305f6b 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x.h
+++ b/linux/drivers/media/radio/si470x/radio-si470x.h
@@ -193,6 +193,7 @@ extern const struct v4l2_file_operations si470x_fops;
 extern struct video_device si470x_viddev_template;
 int si470x_get_register(struct si470x_device *radio, int regnr);
 int si470x_set_register(struct si470x_device *radio, int regnr);
+int si470x_disconnect_check(struct si470x_device *radio);
 int si470x_set_freq(struct si470x_device *radio, unsigned int freq);
 int si470x_start(struct si470x_device *radio);
 int si470x_stop(struct si470x_device *radio);
-- 
1.6.0.4
