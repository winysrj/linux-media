Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaLOP1s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 10:27:48 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] yavta: Set plane size for mplane buffers in qbuf
Date: Mon, 15 Dec 2014 17:27:44 +0200
Message-Id: <1418657264-20388-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plane size was left zero for mplane buffers when queueing a buffer. Fix
this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 yavta.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/yavta.c b/yavta.c
index 7f9e814..77e5a41 100644
--- a/yavta.c
+++ b/yavta.c
@@ -979,8 +979,12 @@ static int video_queue_buffer(struct device *dev, int index, enum buffer_fill_mo
 
 	if (dev->memtype == V4L2_MEMORY_USERPTR) {
 		if (video_is_mplane(dev)) {
-			for (i = 0; i < dev->num_planes; i++)
-				buf.m.planes[i].m.userptr = (unsigned long)dev->buffers[index].mem[i];
+			for (i = 0; i < dev->num_planes; i++) {
+				buf.m.planes[i].m.userptr = (unsigned long)
+					dev->buffers[index].mem[i];
+				buf.m.planes[i].length =
+					dev->buffers[index].size[i];
+			}
 		} else {
 			buf.m.userptr = (unsigned long)dev->buffers[index].mem[0];
 		}
-- 
2.1.0.231.g7484e3b

