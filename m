Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53972 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbeEDUHm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 16:07:42 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v9 01/15] xilinx: regroup caps on querycap
Date: Fri,  4 May 2018 17:05:58 -0300
Message-Id: <20180504200612.8763-2-ezequiel@collabora.com>
In-Reply-To: <20180504200612.8763-1-ezequiel@collabora.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

To better organize the code we concentrate the setting of
V4L2_CAP_STREAMING in one place.

v2: move cap->capabilities assignment down (Hans Verkuil)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 522cdfdd3345..d041f94be832 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -494,13 +494,15 @@ xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	struct v4l2_fh *vfh = file->private_data;
 	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
 
-	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
-			  | dma->xdev->v4l2_caps;
+	cap->device_caps = V4L2_CAP_STREAMING;
 
 	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
 	else
-		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		cap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
+
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS
+			  | dma->xdev->v4l2_caps;
 
 	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
 	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
-- 
2.16.3
