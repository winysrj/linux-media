Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:47050 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbbCNCS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 22:18:56 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH] media: au0828 - add vidq busy checks to s_std and s_input
Date: Fri, 13 Mar 2015 20:18:43 -0600
Message-Id: <1426299523-14718-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828 s_std and s_input are missing queue busy checks. Add
vb2_is_busy() calls to s_std and s_input and return -EBUSY
if found busy.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index f47ee90..42c49c2 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1214,6 +1214,11 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	if (norm == dev->std)
 		return 0;
 
+	if (vb2_is_busy(&dev->vb_vidq)) {
+		pr_info("%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
 	if (dev->streaming_users > 0)
 		return -EBUSY;
 
@@ -1364,6 +1369,14 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 		return -EINVAL;
 	if (AUVI_INPUT(index).type == 0)
 		return -EINVAL;
+	/*
+	 * Changing the input implies a format change, which is not allowed
+	 * while buffers for use with streaming have already been allocated.
+	*/
+	if (vb2_is_busy(&dev->vb_vidq)) {
+		pr_info("%s queue busy\n", __func__);
+		return -EBUSY;
+	}
 	dev->ctrl_input = index;
 	au0828_s_input(dev, index);
 	return 0;
-- 
2.1.0

