Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38761 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918Ab2KOWJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 17:09:47 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 2/2] Print v4l2_buffer timestamp type
Date: Fri, 16 Nov 2012 00:09:44 +0200
Message-Id: <1353017384-472-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121115220932.GC29863@valkosipuli.retiisi.org.uk>
References: <20121115220932.GC29863@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/yavta.c b/yavta.c
index bf3e096..a50f11e 100644
--- a/yavta.c
+++ b/yavta.c
@@ -464,6 +464,7 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 
 	/* Map the buffers. */
 	for (i = 0; i < rb.count; ++i) {
+		const char *ts_type = "invalid";
 		memset(&buf, 0, sizeof buf);
 		buf.index = i;
 		buf.type = dev->type;
@@ -474,7 +475,16 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 				strerror(errno), errno);
 			return ret;
 		}
-		printf("length: %u offset: %u\n", buf.length, buf.m.offset);
+		switch (buf.flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) {
+		case V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN:
+			ts_type = "unknown";
+			break;
+		case V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC:
+			ts_type = "monotonic";
+			break;
+		}
+		printf("length: %u offset: %u timestamp type: %s\n",
+		       buf.length, buf.m.offset, ts_type);
 
 		switch (dev->memtype) {
 		case V4L2_MEMORY_MMAP:
-- 
1.7.2.5

