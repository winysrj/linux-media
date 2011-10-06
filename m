Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9709 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1JFOpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 10:45:44 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LSN00B3LFO6LH@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Oct 2011 15:45:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSN009C8FO61P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Oct 2011 15:45:42 +0100 (BST)
Date: Thu, 06 Oct 2011 16:45:38 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] v4l: s5p-mfc: fix reported capabilities
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1317912338-9693-1-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC uses the multi-plane API, but it reported single-plane
when querying capabilities.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Hi,

This patch fixes capabilites reported by the MFC driver. It uses the multi-plane API
instead of the reported single-plane.

Best wishes,
Kamil Debski
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index bfbe084..3d54a57 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -220,8 +220,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
 	cap->version = KERNEL_VERSION(1, 0, 0);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
-						    | V4L2_CAP_STREAMING;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+			V4L2_CAP_VIDEO_OUTPUT_MPLANE | V4L2_CAP_STREAMING;
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 4c90e53..0dbb220 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -785,8 +785,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
 	cap->version = KERNEL_VERSION(1, 0, 0);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
-			  | V4L2_CAP_VIDEO_OUTPUT
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE_MPLANE
+			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE
 			  | V4L2_CAP_STREAMING;
 	return 0;
 }
-- 
1.6.3.3

