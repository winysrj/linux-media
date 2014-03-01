Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46253 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752963AbaCAQPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:15:20 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [yavta PATCH 9/9] Set timestamp for output buffers if the timestamp type is copy
Date: Sat,  1 Mar 2014 18:18:10 +0200
Message-Id: <1393690690-5004-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copy timestamp type will mean the timestamp is be copied from the source to
the destination buffer on mem-to-mem devices.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/yavta.c b/yavta.c
index 5171024..50bc6c2 100644
--- a/yavta.c
+++ b/yavta.c
@@ -74,6 +74,7 @@ struct device
 	unsigned int bytesperline;
 	unsigned int imagesize;
 	uint32_t buffer_output_flags;
+	uint32_t timestamp_type;
 
 	void *pattern;
 	unsigned int patternsize;
@@ -549,6 +550,7 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 		}
 	}
 
+	dev->timestamp_type = buf.flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
 	dev->buffers = buffers;
 	dev->nbufs = rb.count;
 	return 0;
@@ -623,6 +625,13 @@ static int video_queue_buffer(struct device *dev, int index, enum buffer_fill_mo
 		buf.flags = dev->buffer_output_flags;
 		buf.bytesused = dev->patternsize;
 		memcpy(dev->buffers[buf.index].mem, dev->pattern, dev->patternsize);
+		if (dev->timestamp_type == V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+			struct timespec ts;
+			
+			clock_gettime(CLOCK_MONOTONIC, &ts);
+			buf.timestamp.tv_sec = ts.tv_sec;
+			buf.timestamp.tv_usec = ts.tv_nsec / 1000;
+		}
 	} else {
 		if (fill & BUFFER_FILL_FRAME)
 			memset(dev->buffers[buf.index].mem, 0x55, dev->buffers[index].size);
-- 
1.7.10.4

