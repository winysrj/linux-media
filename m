Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57828 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2INV5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 17:57:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Antoine Reversat <a.reversat@gmail.com>, sakari.ailus@iki.fi
Subject: [PATCH v2] omap3isp: Use monotonic timestamps for statistics buffers
Date: Fri, 14 Sep 2012 23:57:48 +0200
Message-Id: <1347659868-17398-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 buffers use the monotonic clock, while statistics buffers use wall
time. This makes it difficult to correlate video frames and statistics.

Switch statistics buffers to the monotonic clock to fix this, and
replace struct timeval with struct timespec.

Reported-by: Antoine Reversat <a.reversat@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c |    2 +-
 drivers/media/platform/omap3isp/ispstat.h |    2 +-
 include/linux/omap3isp.h                  |    7 ++++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index b8640be..bb21c4e 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -256,7 +256,7 @@ static int isp_stat_buf_queue(struct ispstat *stat)
 	if (!stat->active_buf)
 		return STAT_NO_BUF;
 
-	do_gettimeofday(&stat->active_buf->ts);
+	ktime_get_ts(&stat->active_buf->ts);
 
 	stat->active_buf->buf_size = stat->buf_size;
 	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 9b7c865..8221d0c 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -50,7 +50,7 @@ struct ispstat_buffer {
 	struct iovm_struct *iovm;
 	void *virt_addr;
 	dma_addr_t dma_addr;
-	struct timeval ts;
+	struct timespec ts;
 	u32 buf_size;
 	u32 frame_number;
 	u16 config_counter;
diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
index c090cf9..263a0c0 100644
--- a/include/linux/omap3isp.h
+++ b/include/linux/omap3isp.h
@@ -27,6 +27,11 @@
 #ifndef OMAP3_ISP_USER_H
 #define OMAP3_ISP_USER_H
 
+#ifdef __KERNEL__
+#include <linux/time.h>     /* need struct timespec */
+#else
+#include <sys/time.h>
+#endif
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
@@ -164,7 +169,7 @@ struct omap3isp_h3a_aewb_config {
  * @config_counter: Number of the configuration associated with the data.
  */
 struct omap3isp_stat_data {
-	struct timeval ts;
+	struct timespec ts;
 	void __user *buf;
 	__u32 buf_size;
 	__u16 frame_number;
-- 
Regards,

Laurent Pinchart

