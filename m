Return-path: <mchehab@gaivota>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:57255 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab1EITyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:12 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 04/16] tm6000: vitual input enums
Date: Mon,  9 May 2011 21:53:52 +0200
Message-Id: <1304970844-20955-4-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

vitual input enums


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |  100 +++++++++++++++++++--------------
 1 files changed, 57 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index e1a7eb2..8b3bf7e 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1083,35 +1083,37 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	return 0;
 }
 
+static const char *iname [] = {
+	[TM6000_INPUT_TV] = "Television",
+	[TM6000_INPUT_COMPOSITE1] = "Composite 1",
+	[TM6000_INPUT_COMPOSITE2] = "Composite 2",
+	[TM6000_INPUT_SVIDEO] = "S-Video",
+};
+
 static int vidioc_enum_input(struct file *file, void *priv,
-				struct v4l2_input *inp)
+				struct v4l2_input *i)
 {
 	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
+	unsigned int n;
 
-	switch (inp->index) {
-	case TM6000_INPUT_TV:
-		inp->type = V4L2_INPUT_TYPE_TUNER;
-		strcpy(inp->name, "Television");
-		break;
-	case TM6000_INPUT_COMPOSITE:
-		if (dev->caps.has_input_comp) {
-			inp->type = V4L2_INPUT_TYPE_CAMERA;
-			strcpy(inp->name, "Composite");
-		} else
-			return -EINVAL;
-		break;
-	case TM6000_INPUT_SVIDEO:
-		if (dev->caps.has_input_svid) {
-			inp->type = V4L2_INPUT_TYPE_CAMERA;
-			strcpy(inp->name, "S-Video");
-		} else
-			return -EINVAL;
-		break;
-	default:
+	n = i->index;
+	if (n >= 3)
 		return -EINVAL;
-	}
-	inp->std = TM6000_STD;
+
+	if (!dev->vinput[n].type)
+		return -EINVAL;
+
+	i->index = n;
+
+	if (dev->vinput[n].type == TM6000_INPUT_TV)
+		i->type = V4L2_INPUT_TYPE_TUNER;
+	else
+		i->type = V4L2_INPUT_TYPE_CAMERA;
+
+	strcpy(i->name, iname[dev->vinput[n].type]);
+
+	i->std = TM6000_STD;
 
 	return 0;
 }
@@ -1125,33 +1127,21 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 
 	return 0;
 }
+
 static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 	int rc = 0;
-	char buf[1];
 
-	switch (i) {
-	case TM6000_INPUT_TV:
-		dev->input = i;
-		*buf = 0;
-		break;
-	case TM6000_INPUT_COMPOSITE:
-	case TM6000_INPUT_SVIDEO:
-		dev->input = i;
-		*buf = 1;
-		break;
-	default:
+	if (i >= 3)
+		return -EINVAL;
+	if (!dev->vinput[i].type)
 		return -EINVAL;
-	}
-	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
-			       REQ_03_SET_GET_MCU_PIN, 0x03, 1, buf, 1);
 
-	if (!rc) {
-		dev->input = i;
-		rc = vidioc_s_std(file, priv, &dev->vfd->current_norm);
-	}
+	dev->input = i;
+
+	rc = vidioc_s_std(file, priv, &dev->vfd->current_norm);
 
 	return rc;
 }
@@ -1379,9 +1369,15 @@ static int radio_s_tuner(struct file *file, void *priv,
 static int radio_enum_input(struct file *file, void *priv,
 					struct v4l2_input *i)
 {
+	struct tm6000_fh *fh = priv;
+	struct tm6000_core *dev = fh->dev;
+
 	if (i->index != 0)
 		return -EINVAL;
 
+	if (!dev->rinput.type)
+		return -EINVAL;
+
 	strcpy(i->name, "Radio");
 	i->type = V4L2_INPUT_TYPE_TUNER;
 
@@ -1390,7 +1386,14 @@ static int radio_enum_input(struct file *file, void *priv,
 
 static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
 {
-	*i = 0;
+	struct tm6000_fh *fh = priv;
+	struct tm6000_core *dev = fh->dev;
+
+	if (dev->input !=5)
+		return -EINVAL;
+
+	*i = dev->input -5;
+
 	return 0;
 }
 
@@ -1410,6 +1413,17 @@ static int radio_s_audio(struct file *file, void *priv,
 
 static int radio_s_input(struct file *filp, void *priv, unsigned int i)
 {
+	struct tm6000_fh *fh = priv;
+	struct tm6000_core *dev = fh->dev;
+
+	if (i)
+		return -EINVAL;
+
+	if (!dev->rinput.type)
+		return -EINVAL;
+
+	dev->input = i + 5;
+
 	return 0;
 }
 
-- 
1.7.4.2

