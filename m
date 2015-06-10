Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:33522 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501AbbFJJKv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 05:10:51 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [media] s5p-tv: fix wait_event_timeout return handling
Date: Wed, 10 Jun 2015 11:02:03 +0200
Message-Id: <1433926923-13092-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

event API conformance testing with coccinelle spatches are being
used to locate API usage inconsistencies this triggert with:
./drivers/media/platform/s5p-tv/mixer_reg.c:364
        incorrect check for negative return

Return type of wait_event_timeout is signed long not int and the
return type is >=0 always thus the negative check is unnecessary.
An appropriately named variable of type long is inserted and the
call fixed up aswell as the negative return check dropped.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Minor change of indentation to make checkpatch happy - not sure if 
this is much more readable though.

Patch was compile tested with exynos_defconfig + CONFIG_MEDIA_SUPPORT=m,
CONFIG_MEDIA_CAMERA_SUPPORT=y, CONFIG_MEDIA_ANALOG_TV_SUPPORT=y,
CONFIG_V4L_PLATFORM_DRIVERS=y, CONFIG_VIDEO_SAMSUNG_S5P_TV=y,
CONFIG_VIDEO_SAMSUNG_S5P_MIXER=m

Patch is against 4.1-rc7 (localversion-next is -next-20150609)

 drivers/media/platform/s5p-tv/mixer_reg.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
index b713403..5127acb 100644
--- a/drivers/media/platform/s5p-tv/mixer_reg.c
+++ b/drivers/media/platform/s5p-tv/mixer_reg.c
@@ -357,17 +357,15 @@ void mxr_reg_streamoff(struct mxr_device *mdev)
 
 int mxr_reg_wait4vsync(struct mxr_device *mdev)
 {
-	int ret;
+	long time_left;
 
 	clear_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
 	/* TODO: consider adding interruptible */
-	ret = wait_event_timeout(mdev->event_queue,
-		test_bit(MXR_EVENT_VSYNC, &mdev->event_flags),
-		msecs_to_jiffies(1000));
-	if (ret > 0)
+	time_left = wait_event_timeout(mdev->event_queue,
+			test_bit(MXR_EVENT_VSYNC, &mdev->event_flags),
+				 msecs_to_jiffies(1000));
+	if (time_left > 0)
 		return 0;
-	if (ret < 0)
-		return ret;
 	mxr_warn(mdev, "no vsync detected - timeout\n");
 	return -ETIME;
 }
-- 
1.7.10.4

