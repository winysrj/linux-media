Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46239 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752963AbaCAQPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:15:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [yavta PATCH 2/9] Print timestamp source (start-of-exposure or end-of-frame)
Date: Sat,  1 Mar 2014 18:18:03 +0200
Message-Id: <1393690690-5004-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/yavta.c b/yavta.c
index 0e1c921..8e43ce5 100644
--- a/yavta.c
+++ b/yavta.c
@@ -476,7 +476,7 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 
 	/* Map the buffers. */
 	for (i = 0; i < rb.count; ++i) {
-		const char *ts_type;
+		const char *ts_type, *ts_source;
 		memset(&buf, 0, sizeof buf);
 		buf.index = i;
 		buf.type = dev->type;
@@ -497,8 +497,18 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 		default:
 			ts_type = "invalid";
 		}
-		printf("length: %u offset: %u timestamp type: %s\n",
-		       buf.length, buf.m.offset, ts_type);
+		switch (buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK) {
+		case V4L2_BUF_FLAG_TSTAMP_SRC_EOF:
+			ts_source = "EoF";
+			break;
+		case V4L2_BUF_FLAG_TSTAMP_SRC_SOE:
+			ts_source = "SoE";
+			break;
+		default:
+			ts_source = "invalid";
+		}
+		printf("length: %u offset: %u timestamp type/source: %s/%s\n",
+		       buf.length, buf.m.offset, ts_type, ts_source);
 
 		switch (dev->memtype) {
 		case V4L2_MEMORY_MMAP:
-- 
1.7.10.4

