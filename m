Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:56924 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753259AbdJTVus (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:48 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 07/17] [media] vivid: assign the specific device to the vb2_queue->dev
Date: Fri, 20 Oct 2017 19:50:02 -0200
Message-Id: <20171020215012.20646-8-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Instead of assigning the global v4l2 device, assign the specific device.
This was causing trouble when using V4L2 events with vivid devices.
The device's queue should be the same we opened in userspace.

This is needed for the upcoming V4L2_EVENT_OUT_FENCE support. The current
vivid code isn't wrong, it just needs to be changed so V4L2_EVENT_OUT_FENCE
can be supported. The change doesn't affect any other behaviour of vivid.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 5f316a5e38db..608bcceed463 100644
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
2.13.6
