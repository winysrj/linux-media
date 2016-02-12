Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:36719 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcBLXSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 18:18:07 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, hans.verkuil@cisco.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 set ctrl_input in au0828_s_input()
Date: Fri, 12 Feb 2016 16:18:03 -0700
Message-Id: <1455319083-7184-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev->ctrl_input is set in vidioc_s_input() and
doesn't get set in au0828_s_input(). As a result,
dev->ctrl_input is left uninitialized until user
space calls s_input. It works correctly because
the default input value is 0 and which is what
dev->ctrl_input gets initialized via kzalloc().

Change to set dev->ctrl_input in au0828_s_input().
Also optimize vidioc_s_input() to return if the
new input value is same as the current.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 9304f96..20696a4 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1345,9 +1345,11 @@ static void au0828_s_input(struct au0828_dev *dev, int index)
 	default:
 		dprintk(1, "unknown input type set [%d]\n",
 			AUVI_INPUT(index).type);
-		break;
+		return;
 	}
 
+	dev->ctrl_input = index;
+
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
 			AUVI_INPUT(index).vmux, 0, 0);
 
@@ -1386,7 +1388,10 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 		return -EINVAL;
 	if (AUVI_INPUT(index).type == 0)
 		return -EINVAL;
-	dev->ctrl_input = index;
+
+	if (dev->ctrl_input == index)
+		return 0;
+
 	au0828_s_input(dev, index);
 	return 0;
 }
@@ -1901,6 +1906,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->ctrl_ainput = 0;
 	dev->ctrl_freq = 960;
 	dev->std = V4L2_STD_NTSC_M;
+	/* Default input is TV Tuner */
 	au0828_s_input(dev, 0);
 
 	mutex_init(&dev->vb_queue_lock);
-- 
2.5.0

