Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3B2C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 12:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35BB0218AD
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 12:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfAXMu0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 07:50:26 -0500
Received: from mail.bootlin.com ([62.4.15.54]:37056 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfAXMu0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 07:50:26 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 3517520798; Thu, 24 Jan 2019 13:50:23 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id B846920654;
        Thu, 24 Jan 2019 13:50:22 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH v2] Revert "media: cedrus: Allow using the current dst buffer as reference"
Date:   Thu, 24 Jan 2019 13:49:45 +0100
Message-Id: <20190124124945.25322-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This reverts commit cf20ae1535eb690a87c29b9cc7af51881384e967.

The vb2_find_timestamp helper was modified to allow finding buffers
regardless of their current state in the queue. This means that we
no longer have to take particular care of references to the current
capture buffer.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 -------------
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 --
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++------
 3 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index 2c295286766c..443fb037e1cf 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -22,19 +22,6 @@
 #include "cedrus_dec.h"
 #include "cedrus_hw.h"
 
-int cedrus_reference_index_find(struct vb2_queue *queue,
-				struct vb2_buffer *vb2_buf, u64 timestamp)
-{
-	/*
-	 * Allow using the current capture buffer as reference, which can occur
-	 * for field-coded pictures.
-	 */
-	if (vb2_buf->timestamp == timestamp)
-		return vb2_buf->index;
-	else
-		return vb2_find_timestamp(queue, timestamp, 0);
-}
-
 void cedrus_device_run(void *priv)
 {
 	struct cedrus_ctx *ctx = priv;
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
index 8d0fc248220f..d1ae7903677b 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
@@ -16,8 +16,6 @@
 #ifndef _CEDRUS_DEC_H_
 #define _CEDRUS_DEC_H_
 
-int cedrus_reference_index_find(struct vb2_queue *queue,
-				struct vb2_buffer *vb2_buf, u64 timestamp);
 void cedrus_device_run(void *priv);
 
 #endif
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index 81c66a8aa1ac..cb45fda9aaeb 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
@@ -10,7 +10,6 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "cedrus.h"
-#include "cedrus_dec.h"
 #include "cedrus_hw.h"
 #include "cedrus_regs.h"
 
@@ -160,8 +159,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
 
 	/* Forward and backward prediction reference buffers. */
-	forward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
-						  slice_params->forward_ref_ts);
+	forward_idx = vb2_find_timestamp(cap_q,
+					 slice_params->forward_ref_ts, 0);
 
 	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
 	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
@@ -169,9 +168,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
 
-	backward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
-						   slice_params->backward_ref_ts);
-
+	backward_idx = vb2_find_timestamp(cap_q,
+					  slice_params->backward_ref_ts, 0);
 	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
 	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
 
-- 
2.20.1

