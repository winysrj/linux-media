Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6EEC43444
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD4882089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbfAGNEs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:04:48 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35661 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731274AbfAGNEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 08:04:43 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gUa5gGVcvBDyIgUa9gNvH5; Mon, 07 Jan 2019 14:04:42 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 2/3] vim2m: add buf_out_validate callback
Date:   Mon,  7 Jan 2019 14:04:36 +0100
Message-Id: <20190107130437.23732-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190107130437.23732-1-hverkuil-cisco@xs4all.nl>
References: <20190107130437.23732-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfMl+v30e46w9XJsUfwZQhdbdXI0rgfk1pP/u3gtl50KHGTrrbsiT38FD5FxBm7ARRLMTX64fyq2EbL19csasj3G9mUYELdj2EI9r/wepQPw11TDvUuXh
 1gZkKlFxErab4LtJT9Qt64pfnXPD0Qm9VwjoyoYDD4cDrBxo1I7tBiW+GTS4JBuSujdCKIu99VraLZnHeG9nvCmAWBhmM92uCjAeNSkg4D7ZeI0zwonwRLbG
 D7FfS1C9tWo2SKvvgyo0kge60s1sl/h4FEcUo694CQY=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Split off the field validation from buf_prepare into a new
buf_out_validate function. Field validation for output buffers should
be done there since buf_prepare is not guaranteed to be called at
QBUF time.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vim2m.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d01821a6906a..4a16b7a6b69a 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -753,15 +753,13 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int vim2m_buf_prepare(struct vb2_buffer *vb)
+static int vim2m_buf_out_validate(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct vim2m_q_data *q_data;
 
 	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
 		if (vbuf->field == V4L2_FIELD_ANY)
 			vbuf->field = V4L2_FIELD_NONE;
@@ -772,6 +770,17 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 		}
 	}
 
+	return 0;
+}
+
+static int vim2m_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vim2m_q_data *q_data;
+
+	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+
+	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
 				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
@@ -832,6 +841,7 @@ static void vim2m_buf_request_complete(struct vb2_buffer *vb)
 
 static const struct vb2_ops vim2m_qops = {
 	.queue_setup	 = vim2m_queue_setup,
+	.buf_out_validate	 = vim2m_buf_out_validate,
 	.buf_prepare	 = vim2m_buf_prepare,
 	.buf_queue	 = vim2m_buf_queue,
 	.start_streaming = vim2m_start_streaming,
-- 
2.19.2

