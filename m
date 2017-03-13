Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35505 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbdCMTU5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:20:57 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 05/10] [media] vivid: assign the specific device to the vb2_queue->dev
Date: Mon, 13 Mar 2017 16:20:30 -0300
Message-Id: <20170313192035.29859-6-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Instead of assign the global v4l2 device assigned the specific device,
this was causing trouble when using using V4L2 events with vivid
devices. The queue device should be the same one we opened in userspace.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/platform/vivid/vivid-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index ef344b9..8843170 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1070,7 +1070,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
-		q->dev = dev->v4l2_dev.dev;
+		q->dev = &dev->vid_cap_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1090,7 +1090,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
-		q->dev = dev->v4l2_dev.dev;
+		q->dev = &dev->vid_out_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1110,7 +1110,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
-		q->dev = dev->v4l2_dev.dev;
+		q->dev = &dev->vbi_cap_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1130,7 +1130,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
-		q->dev = dev->v4l2_dev.dev;
+		q->dev = &dev->vbi_out_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1149,7 +1149,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 8;
 		q->lock = &dev->mutex;
-		q->dev = dev->v4l2_dev.dev;
+		q->dev = &dev->sdr_cap_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
-- 
2.9.3
