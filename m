Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:39688 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZFVNaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 09:30:20 -0400
Received: by ewy6 with SMTP id 6so4698891ewy.37
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 06:30:21 -0700 (PDT)
Message-ID: <4A3FA3AC.1010703@gmail.com>
Date: Mon, 22 Jun 2009 17:30:52 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: hverkuil@xs4all.nl, mchehab@infradead.org
CC: linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] media: remove redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

input, inp and i are unsigned. When negative they are wrapped and caught by the
other test.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index ce64c62..8986d96 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -490,7 +490,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	if (!av7110->analog_tuner_flags)
 		return 0;
 
-	if (input < 0 || input >= 4)
+	if (input >= 4)
 		return -EINVAL;
 
 	av7110->current_input = input;
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index d7b1921..fc76e4d 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -605,7 +605,7 @@ int cx18_s_input(struct file *file, void *fh, unsigned int inp)
 	if (ret)
 		return ret;
 
-	if (inp < 0 || inp >= cx->nof_inputs)
+	if (inp >= cx->nof_inputs)
 		return -EINVAL;
 
 	if (inp == cx->active_input) {
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index e305c16..103096b 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1797,7 +1797,7 @@ static int saa7134_s_input(struct file *file, void *priv, unsigned int i)
 	if (0 != err)
 		return err;
 
-	if (i < 0  ||  i >= SAA7134_INPUT_MAX)
+	if (i >= SAA7134_INPUT_MAX)
 		return -EINVAL;
 	if (NULL == card_in(dev, i).name)
 		return -EINVAL;
