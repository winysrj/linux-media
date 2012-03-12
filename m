Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43032 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2CLGUe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 02:20:34 -0400
Received: by dajr28 with SMTP id r28so4733752daj.19
        for <linux-media@vger.kernel.org>; Sun, 11 Mar 2012 23:20:33 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	mchehab@infradead.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-tv: Fix section mismatch warning in mixer_video.c
Date: Mon, 12 Mar 2012 11:43:34 +0530
Message-Id: <1331532814-24403-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function __devinit mxr_probe() references
a function __devexit mxr_release_video().

Since mxr_release_video() is referenced outside the exit section, the following
compilation warning is generated which is fixed here:

WARNING: drivers/media/video/s5p-tv/s5p-mixer.o(.devinit.text+0x340): 
Section mismatch in reference from the function mxr_probe() to the function 
.devexit.text:mxr_release_video()

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Tested on for-next branch of Kukjin Kim's tree
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
---
 drivers/media/video/s5p-tv/mixer.h       |    2 +-
 drivers/media/video/s5p-tv/mixer_video.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
index 1597078..b02e55c 100644
--- a/drivers/media/video/s5p-tv/mixer.h
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -293,7 +293,7 @@ int __devinit mxr_acquire_video(struct mxr_device *mdev,
 	struct mxr_output_conf *output_cont, int output_count);
 
 /** releasing common video resources */
-void __devexit mxr_release_video(struct mxr_device *mdev);
+void mxr_release_video(struct mxr_device *mdev);
 
 struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx);
 struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx);
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 7884bae..aa5996c 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -141,7 +141,7 @@ fail:
 	return ret;
 }
 
-void __devexit mxr_release_video(struct mxr_device *mdev)
+void mxr_release_video(struct mxr_device *mdev)
 {
 	int i;
 
-- 
1.7.4.1

