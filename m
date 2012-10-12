Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42011 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934192Ab2JLSMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 14:12:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Antoine Reversat <a.reversat@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3] omap3isp: Use monotonic timestamps for statistics buffers
Date: Fri, 12 Oct 2012 20:13:37 +0200
Message-Id: <1350065617-17136-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 buffers use the monotonic clock, while statistics buffers use wall
time. This makes it difficult to correlate video frames and statistics.

Switch statistics buffers to the monotonic clock to fix this.

Reported-by: Antoine Reversat <a.reversat@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c |    5 +++--
 drivers/media/platform/omap3isp/ispstat.h |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

Given the hard NACK on the switch to timespec for the public API in v2, v3 goes
back to the same approach as v1.

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index d7ac76b..600d610 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -256,7 +256,7 @@ static int isp_stat_buf_queue(struct ispstat *stat)
 	if (!stat->active_buf)
 		return STAT_NO_BUF;
 
-	do_gettimeofday(&stat->active_buf->ts);
+	ktime_get_ts(&stat->active_buf->ts);
 
 	stat->active_buf->buf_size = stat->buf_size;
 	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
@@ -536,7 +536,8 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
 		return PTR_ERR(buf);
 	}
 
-	data->ts = buf->ts;
+	data->ts.tv_sec = buf->ts.tv_sec;
+	data->ts.tv_usec = buf->ts.tv_nsec / NSEC_PER_USEC;
 	data->config_counter = buf->config_counter;
 	data->frame_number = buf->frame_number;
 	data->buf_size = buf->buf_size;
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index a6fe653..253e61e 100644
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
-- 
Regards,

Laurent Pinchart

