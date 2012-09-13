Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34356 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab2IMTwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 15:52:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Antoine Reversat <a.reversat@gmail.com>, sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Use monotonic timestamps for statistics buffers
Date: Thu, 13 Sep 2012 21:53:23 +0200
Message-Id: <1347566003-14500-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 buffers use the monotonic clock, while statistics buffers use wall
time. This makes it difficult to correlate video frames and statistics.

Switch statistics buffers to the monotonic clock to fix this.

Reported-by: Antoine Reversat <a.reversat@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index b8640be..52263cc 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -253,10 +253,14 @@ isp_stat_buf_find_oldest_or_empty(struct ispstat *stat)
 
 static int isp_stat_buf_queue(struct ispstat *stat)
 {
+	struct timespec ts;
+
 	if (!stat->active_buf)
 		return STAT_NO_BUF;
 
-	do_gettimeofday(&stat->active_buf->ts);
+	ktime_get_ts(&ts);
+	stat->active_buf->ts.tv_sec = ts.tv_sec;
+	stat->active_buf->ts.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 	stat->active_buf->buf_size = stat->buf_size;
 	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
-- 
Regards,

Laurent Pinchart

