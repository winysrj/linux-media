Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4199 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3A3OyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 09:54:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/6] radio-miropcm20: fix querycap.
Date: Wed, 30 Jan 2013 15:53:59 +0100
Message-Id: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
In-Reply-To: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
References: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't set version (done by the v4l2 core), fill in bus_info, set correct
driver name and add device_caps support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-miropcm20.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 11f76ed..3a89e50 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -79,11 +79,13 @@ static const struct v4l2_file_operations pcm20_fops = {
 static int vidioc_querycap(struct file *file, void *priv,
 				struct v4l2_capability *v)
 {
+	struct pcm20 *dev = video_drvdata(file);
+
 	strlcpy(v->driver, "Miro PCM20", sizeof(v->driver));
 	strlcpy(v->card, "Miro PCM20", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->version = 0x1;
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", dev->v4l2_dev.name);
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -229,7 +231,7 @@ static int __init pcm20_init(void)
 			 "you must load the snd-miro driver first!\n");
 		return -ENODEV;
 	}
-	strlcpy(v4l2_dev->name, "miropcm20", sizeof(v4l2_dev->name));
+	strlcpy(v4l2_dev->name, "radio-miropcm20", sizeof(v4l2_dev->name));
 	mutex_init(&dev->lock);
 
 	res = v4l2_device_register(NULL, v4l2_dev);
-- 
1.7.10.4

