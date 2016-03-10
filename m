Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:48400 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbcCJOu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 09:50:28 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix !CONFIG_MEDIA_CONTROLLER compile error for v4l_change_media_source()
Date: Thu, 10 Mar 2016 07:50:22 -0700
Message-Id: <1457621422-3187-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This error is a result of not defining v4l_change_media_source() stub
in include/media/v4l2-mc.h for !CONFIG_MEDIA_CONTROLLER case.

Fix the following compile error:

url:    https://github.com/0day-ci/linux/commits/Shuah-Khan/media-add-change_source-handler-support/20160310-131140
base:   git://linuxtv.org/media_tree.git master
config: x86_64-rhel (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64

All errors (new ones prefixed by >>):

   drivers/media/usb/au0828/au0828-video.c: In function 'vidioc_s_input':
>> drivers/media/usb/au0828/au0828-video.c:1474:2: error: implicit declaration of function 'v4l_change_media_source' [-Werror=implicit-function-declaration]
     return v4l_change_media_source(vfd);
     ^
   cc1: some warnings being treated as errors

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

This patch applies on top of:
https://lkml.org/lkml/2016/3/10/7

 include/media/v4l2-mc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 884b969..50b9348 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -237,6 +237,11 @@ static inline int v4l_enable_media_source(struct video_device *vdev)
 	return 0;
 }
 
+static inline int v4l_change_media_source(struct video_device *vdev)
+{
+	return 0;
+}
+
 static inline void v4l_disable_media_source(struct video_device *vdev)
 {
 }
-- 
2.5.0

