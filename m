Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:51421 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425298AbcBSA2w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 19:28:52 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	inki.dae@samsung.com, sw0312.kim@samsung.com,
	jh1009.sung@samsung.com, chehabrafael@gmail.com,
	prabhakar.csengg@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 enable the right media source when input changes
Date: Thu, 18 Feb 2016 17:28:48 -0700
Message-Id: <1455841728-7062-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change vidioc_s_input() to enable the media source
for the newly selected input. v4l2-core enables
source before calling au0828's vidioc_s_input()
handler. Hence, when input selection changes,
media source for the newly selected input needs
to be enabled.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 20696a4..678074d 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1381,6 +1381,7 @@ static void au0828_s_input(struct au0828_dev *dev, int index)
 static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 {
 	struct au0828_dev *dev = video_drvdata(file);
+	struct video_device *vfd = video_devdata(file);
 
 	dprintk(1, "VIDIOC_S_INPUT in function %s, input=%d\n", __func__,
 		index);
@@ -1393,7 +1394,14 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 		return 0;
 
 	au0828_s_input(dev, index);
-	return 0;
+
+	/*
+	 * Input has been changed. Disable the media source
+	 * associated with the old input and enable source
+	 * for the newly set input
+	 */
+	v4l_disable_media_source(vfd);
+	return v4l_enable_media_source(vfd);
 }
 
 static int vidioc_enumaudio(struct file *file, void *priv, struct v4l2_audio *a)
-- 
2.5.0

