Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42457 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaCMLpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 07:45:07 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 01/14] v4l: ti-vpe: Make sure in job_ready that we have the needed number of dst_bufs
Date: Thu, 13 Mar 2014 17:14:03 +0530
Message-ID: <1394711056-10878-2-git-send-email-archit@ti.com>
In-Reply-To: <1394711056-10878-1-git-send-email-archit@ti.com>
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
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
index 7a77a5b..f3143ac 100644
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

