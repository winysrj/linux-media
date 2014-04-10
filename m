Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44122 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758938AbaDJWGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 9/9] Set timestamp for output buffers if the timestamp type is copy
Date: Fri, 11 Apr 2014 01:06:45 +0300
Message-Id: <1397167605-29956-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
References: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copy timestamp type will mean the timestamp is be copied from the source to
the destination buffer on mem-to-mem devices.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/yavta.c b/yavta.c
index 124dd1d..251fe40 100644
--- a/yavta.c
+++ b/yavta.c
@@ -73,6 +73,7 @@ struct device
 	unsigned int width;
 	unsigned int height;
 	uint32_t buffer_output_flags;
+	uint32_t timestamp_type;
 
 	unsigned char num_planes;
 	struct v4l2_plane_pix_format plane_fmt[VIDEO_MAX_PLANES];
@@ -756,6 +757,7 @@ static int video_alloc_buffers(struct device *dev, int nbufs,
 			return ret;
 	}
 
+	dev->timestamp_type = buf.flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
 	dev->buffers = buffers;
 	dev->nbufs = rb.count;
 	return 0;
@@ -818,8 +820,16 @@ static int video_queue_buffer(struct device *dev, int index, enum buffer_fill_mo
 	buf.type = dev->type;
 	buf.memory = dev->memtype;
 
-	if (dev->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (dev->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		buf.flags = dev->buffer_output_flags;
+		if (dev->timestamp_type == V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+			struct timespec ts;
+			
+			clock_gettime(CLOCK_MONOTONIC, &ts);
+			buf.timestamp.tv_sec = ts.tv_sec;
+			buf.timestamp.tv_usec = ts.tv_nsec / 1000;
+		}
+	}
 
 	if (video_is_mplane(dev)) {
 		buf.m.planes = planes;
-- 
1.7.10.4

