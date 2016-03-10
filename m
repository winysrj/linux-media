Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:33743 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbcCJFHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 00:07:17 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	sakari.ailus@linux.intel.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] media: au0828 change vidioc_s_input() to call v4l_change_media_source()
Date: Wed,  9 Mar 2016 22:07:10 -0700
Message-Id: <37c0717b00fdbde343089324fdf642fbcab69f29.1457585839.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1457585839.git.shuahkh@osg.samsung.com>
References: <cover.1457585839.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1457585839.git.shuahkh@osg.samsung.com>
References: <cover.1457585839.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change vidioc_s_input() to call v4l_change_media_source() to disable
current source and enable new source when user switches input.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index aeaf27e..020c9d5 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1545,12 +1545,10 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 	au0828_s_input(dev, index);
 
 	/*
-	 * Input has been changed. Disable the media source
-	 * associated with the old input and enable source
-	 * for the newly set input
+	 * Input has been changed. Change to media source
+	 * associated with the for the newly set input.
 	 */
-	v4l_disable_media_source(vfd);
-	return v4l_enable_media_source(vfd);
+	return v4l_change_media_source(vfd);
 }
 
 static int vidioc_enumaudio(struct file *file, void *priv, struct v4l2_audio *a)
-- 
2.5.0

