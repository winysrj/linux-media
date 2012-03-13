Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60009 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2CMNfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 09:35:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0T00GJ4SEWQQ90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Mar 2012 13:35:20 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0T00CCSSEVM8@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Mar 2012 13:35:19 +0000 (GMT)
Date: Tue, 13 Mar 2012 14:35:14 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 6/6] s5p-tv: Fix section mismatch warning in mixer_video.c
In-reply-to: <1331645714-24535-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: sachin.kamat@linaro.org, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Message-id: <1331645714-24535-7-git-send-email-t.stanislaws@samsung.com>
References: <1331645714-24535-1-git-send-email-t.stanislaws@samsung.com>
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

