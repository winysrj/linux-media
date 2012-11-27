Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43898 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753143Ab2K0V5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 16:57:37 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: [yavta PATCH v1.1 2/2] Print v4l2_buffer timestamp type
Date: Tue, 27 Nov 2012 23:57:34 +0200
Message-Id: <1354053454-18347-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1389859.pZ9IpEcYuE@avalon>
References: <1389859.pZ9IpEcYuE@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Fixed.

 yavta.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/yavta.c b/yavta.c
index bf3e096..b4d1df6 100644
--- a/yavta.c
+++ b/yavta.c
@@ -464,6 +464,7 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 
 	/* Map the buffers. */
 	for (i = 0; i < rb.count; ++i) {
+		const char *ts_type;
 		memset(&buf, 0, sizeof buf);
 		buf.index = i;
 		buf.type = dev->type;
@@ -474,7 +475,18 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
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
+		default:
+			ts_type = "invalid";
+		}
+		printf("length: %u offset: %u timestamp type: %s\n",
+		       buf.length, buf.m.offset, ts_type);
 
 		switch (dev->memtype) {
 		case V4L2_MEMORY_MMAP:
-- 
1.7.2.5

