Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50894 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab2DPN7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:01 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2K00F56S4DS7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:57:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K006TES6AOH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:59 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:53 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 6/8] v4l: s5p-tv: mixer: fix handling of interlaced modes
In-reply-to: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de
Message-id: <1334584735-12439-7-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The next frame was fetched by Mixer at every VSYNC event.  This caused tearing
when Mixer's output in interlaced mode.  This patch fixes this bug by fetching
new frame every second VSYNC when working in interlaced mode.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/mixer.h     |    1 +
 drivers/media/video/s5p-tv/mixer_reg.c |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
index 1597078..fa3e30f 100644
--- a/drivers/media/video/s5p-tv/mixer.h
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -226,6 +226,7 @@ struct mxr_resources {
 /* event flags used  */
 enum mxr_devide_flags {
 	MXR_EVENT_VSYNC = 0,
+	MXR_EVENT_TOP = 1,
 };
 
 /** drivers instance */
diff --git a/drivers/media/video/s5p-tv/mixer_reg.c b/drivers/media/video/s5p-tv/mixer_reg.c
index 4800a3c..3b1670a 100644
--- a/drivers/media/video/s5p-tv/mixer_reg.c
+++ b/drivers/media/video/s5p-tv/mixer_reg.c
@@ -296,21 +296,25 @@ irqreturn_t mxr_irq_handler(int irq, void *dev_data)
 	/* wake up process waiting for VSYNC */
 	if (val & MXR_INT_STATUS_VSYNC) {
 		set_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
+		/* toggle TOP field event if working in interlaced mode */
+		if (~mxr_read(mdev, MXR_CFG) & MXR_CFG_SCAN_PROGRASSIVE)
+			change_bit(MXR_EVENT_TOP, &mdev->event_flags);
 		wake_up(&mdev->event_queue);
-	}
-
-	/* clear interrupts */
-	if (~val & MXR_INT_EN_VSYNC) {
 		/* vsync interrupt use different bit for read and clear */
-		val &= ~MXR_INT_EN_VSYNC;
+		val &= ~MXR_INT_STATUS_VSYNC;
 		val |= MXR_INT_CLEAR_VSYNC;
 	}
+
+	/* clear interrupts */
 	mxr_write(mdev, MXR_INT_STATUS, val);
 
 	spin_unlock(&mdev->reg_slock);
 	/* leave on non-vsync event */
 	if (~val & MXR_INT_CLEAR_VSYNC)
 		return IRQ_HANDLED;
+	/* skip layer update on bottom field */
+	if (!test_bit(MXR_EVENT_TOP, &mdev->event_flags))
+		return IRQ_HANDLED;
 	for (i = 0; i < MXR_MAX_LAYERS; ++i)
 		mxr_irq_layer_handle(mdev->layer[i]);
 	return IRQ_HANDLED;
@@ -333,6 +337,7 @@ void mxr_reg_streamon(struct mxr_device *mdev)
 
 	/* start MIXER */
 	mxr_write_mask(mdev, MXR_STATUS, ~0, MXR_STATUS_REG_RUN);
+	set_bit(MXR_EVENT_TOP, &mdev->event_flags);
 
 	spin_unlock_irqrestore(&mdev->reg_slock, flags);
 }
-- 
1.7.5.4

