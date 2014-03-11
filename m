Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45776 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaCKIfc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:32 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 14/14] v4l: ti-vpe: retain v4l2_buffer flags for captured buffers
Date: Tue, 11 Mar 2014 14:03:53 +0530
Message-ID: <1394526833-24805-15-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dequed CAPTURE_MPLANE type buffers don't contain the flags that the
originally queued OUTPUT_MPLANE type buffers have. This breaks compliance.

Copy the source v4l2_buffer flags to the destination v4l2_buffer flags before
they are dequed.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index c884910..f7759e8 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1288,13 +1288,12 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	s_buf = &s_vb->v4l2_buf;
 	d_buf = &d_vb->v4l2_buf;
 
+	d_buf->flags = s_buf->flags;
+
 	d_buf->timestamp = s_buf->timestamp;
-	d_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	d_buf->flags |= s_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	if (s_buf->flags & V4L2_BUF_FLAG_TIMECODE) {
-		d_buf->flags |= V4L2_BUF_FLAG_TIMECODE;
+	if (s_buf->flags & V4L2_BUF_FLAG_TIMECODE)
 		d_buf->timecode = s_buf->timecode;
-	}
+
 	d_buf->sequence = ctx->sequence;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
-- 
1.8.3.2

