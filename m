Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15178 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2AMTjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 14:39:42 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LXR002GP5A4B390@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Jan 2012 19:39:40 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LXR00JST5A4W1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Jan 2012 19:39:40 +0000 (GMT)
Date: Fri, 13 Jan 2012 20:39:30 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] s5p-jpeg: adapt to recent videobuf2 changes
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1326483570-27571-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

queue_setup callback has been extended with struct v4l2_format *fmt
parameter in 2d86401c2c commit. This patch adds this parameter to
s5p-jpeg driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index f841a3e..1105a87 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -989,9 +989,10 @@ static struct v4l2_m2m_ops s5p_jpeg_m2m_ops = {
  * ============================================================================
  */
 
-static int s5p_jpeg_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned int sizes[],
-				void *alloc_ctxs[])
+static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
+			   const struct v4l2_format *fmt,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
 	struct s5p_jpeg_q_data *q_data = NULL;
-- 
1.7.1.569.g6f426

