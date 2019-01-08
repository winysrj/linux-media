Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325CDC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7BFA206A3
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfAHRUr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:20:47 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53009 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfAHRUr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 12:20:47 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ggv3V-0005T8-Th; Tue, 08 Jan 2019 18:20:45 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     kernel@pengutronix.de
Subject: [PATCH] media: coda: fix decoder capture buffer payload
Date:   Tue,  8 Jan 2019 18:20:43 +0100
Message-Id: <20190108172043.22849-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is not correct to calculate decoder capture payload dynamically from
the decoded frame width and height reported by the firmware. These tell
us what the decoder wrote into the internal framebuffers. The rotator or
VDOA always write the full sizeimage when copying the previously decoded
frame from the internal framebuffers into the capture queue.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 8e0194993a52..402b344eaa09 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2020,7 +2020,6 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct coda_q_data *q_data_dst;
 	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_buffer_meta *meta;
-	unsigned long payload;
 	int width, height;
 	int decoded_idx;
 	int display_idx;
@@ -2226,21 +2225,8 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 
 		trace_coda_dec_rot_done(ctx, dst_buf, meta);
 
-		switch (q_data_dst->fourcc) {
-		case V4L2_PIX_FMT_YUYV:
-			payload = width * height * 2;
-			break;
-		case V4L2_PIX_FMT_YUV420:
-		case V4L2_PIX_FMT_YVU420:
-		case V4L2_PIX_FMT_NV12:
-		default:
-			payload = width * height * 3 / 2;
-			break;
-		case V4L2_PIX_FMT_YUV422P:
-			payload = width * height * 2;
-			break;
-		}
-		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+				      q_data_dst->sizeimage);
 
 		if (ctx->frame_errors[ctx->display_idx] || err_vdoa)
 			coda_m2m_buf_done(ctx, dst_buf, VB2_BUF_STATE_ERROR);
-- 
2.20.1

