Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34102 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbdFPHjm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 03:39:42 -0400
Received: by mail-pf0-f196.google.com with SMTP id d5so4719604pfe.1
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 00:39:41 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH 05/12] [media] vivid: assign the specific device to the vb2_queue->dev
Date: Fri, 16 Jun 2017 16:39:08 +0900
Message-Id: <20170616073915.5027-6-gustavo@padovan.org>
In-Reply-To: <20170616073915.5027-1-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Instead of assigning the global v4l2 device, assign the specific device.
This was causing trouble when using using V4L2 events with vivid
devices. The device's queue should be the same we opened in userspace.

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
2.9.4
