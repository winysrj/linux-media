Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50894 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2DPN7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:03 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2K00F56S4DS7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:57:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K006TFS6AOH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:59 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:54 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 7/8] s5p-tv: Fix section mismatch warning in mixer_video.c
In-reply-to: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de
Message-id: <1334584735-12439-8-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sachin Kamat <sachin.kamat@linaro.org>

The function __devinit mxr_probe() references
a function __devexit mxr_release_video().

Since mxr_release_video() is referenced outside the exit section, the following
compilation warning is generated which is fixed here:

WARNING: drivers/media/video/s5p-tv/s5p-mixer.o(.devinit.text+0x340):
Section mismatch in reference from the function mxr_probe() to the function
devexit.text:mxr_release_video()

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-tv/mixer.h       |    2 +-
 drivers/media/video/s5p-tv/mixer_video.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
index fa3e30f..ddb422e 100644
--- a/drivers/media/video/s5p-tv/mixer.h
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -294,7 +294,7 @@ int __devinit mxr_acquire_video(struct mxr_device *mdev,
 	struct mxr_output_conf *output_cont, int output_count);
 
 /** releasing common video resources */
-void __devexit mxr_release_video(struct mxr_device *mdev);
+void mxr_release_video(struct mxr_device *mdev);
 
 struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx);
 struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx);
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 2c44a7f..6874760 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -140,7 +140,7 @@ fail:
 	return ret;
 }
 
-void __devexit mxr_release_video(struct mxr_device *mdev)
+void mxr_release_video(struct mxr_device *mdev)
 {
 	int i;
 
-- 
1.7.5.4

