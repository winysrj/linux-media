Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38176 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbaCCHeO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 02:34:14 -0500
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 1/7] v4l: ti-vpe: Make sure in job_ready that we have the needed number of dst_bufs
Date: Mon, 3 Mar 2014 13:03:22 +0530
Message-ID: <1393832008-22174-2-git-send-email-archit@ti.com>
In-Reply-To: <1393832008-22174-1-git-send-email-archit@ti.com>
References: <1393832008-22174-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPE has a ctrl parameter which decides how many mem to mem transactions the
active job from the job queue can perform.

The driver's job_ready() made sure that the number of ready source buffers are
sufficient for the job to execute successfully. But it didn't make sure if
there are sufficient ready destination buffers in the capture queue for the
VPE output.

If the time taken by VPE to process a single frame is really slow, then it's
possible that we don't need to imply such a restriction on the dst queue, but
really fast transactions(small resolution, no de-interlacing) may cause us to
hit the condition where we don't have any free buffers for the VPE to write on.

Add the extra check in job_ready() to make sure we have the sufficient amount
of destination buffers.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 1296c53..623e59e 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -887,6 +887,9 @@ static int job_ready(void *priv)
 	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) < needed)
 		return 0;
 
+	if (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) < needed)
+		return 0;
+
 	return 1;
 }
 
-- 
1.8.3.2

