Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B8DC43444
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7229B206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391740AbfAPMBV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:01:21 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50438 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389687AbfAPMBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 07:01:20 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jjsjgM1cgBDyIjjskg25EY; Wed, 16 Jan 2019 13:01:18 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 2/5] vim2m: add buf_out_validate callback
Date:   Wed, 16 Jan 2019 13:01:14 +0100
Message-Id: <20190116120117.115497-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116120117.115497-1-hverkuil-cisco@xs4all.nl>
References: <20190116120117.115497-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBj8lAB0oiU2KUkh3EW3EDB3KSZYkuyY+QTIamDtCj+ZAvkhTG2KB1Xvp/nnp1waQUxHrhHoSUODVOyzW/u0YuItTYVUZc9RvAiOCvigq6i18+DRjsbd
 fi5SthN7q0hxFo2l3/Hu4v7iQrI9LT6yTXbd3+HNlJbzaD432opb2xOEqOoU31iw+C6CWCIMwCj4xbL0Ea3gVcVvkD52k4JmneCRLiRlko4Qw8e/bWQjPFsr
 xhMEnqGSuutANaT0i7P2oCfbfAmYqw5jUtChmiUg5P6MgN3eupkrFAFZs3VckeeTg+5zVZN9jf7VsFZfUX0lZ9+BZcswpKYwQQn/8xgq1riW1rO3fNDhE8NB
 VV1qYebU6MifyMNtqklWQX/kzZu1iA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Validate the field for an output buffer. This ensures that the
field is validated when the buffer is queued to a request, and
not when the request itself is queued, which is too late.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vim2m.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 33397d4a1402..b2a6131469c4 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -743,25 +743,29 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int vim2m_buf_prepare(struct vb2_buffer *vb)
+static int vim2m_buf_out_validate(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	if (vbuf->field == V4L2_FIELD_ANY)
+		vbuf->field = V4L2_FIELD_NONE;
+	if (vbuf->field != V4L2_FIELD_NONE) {
+		dprintk(ctx->dev, "%s field isn't supported\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vim2m_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vim2m_q_data *q_data;
 
 	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
-	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
-		if (vbuf->field == V4L2_FIELD_ANY)
-			vbuf->field = V4L2_FIELD_NONE;
-		if (vbuf->field != V4L2_FIELD_NONE) {
-			dprintk(ctx->dev, "%s field isn't supported\n",
-					__func__);
-			return -EINVAL;
-		}
-	}
-
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
 				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
@@ -822,6 +826,7 @@ static void vim2m_buf_request_complete(struct vb2_buffer *vb)
 
 static const struct vb2_ops vim2m_qops = {
 	.queue_setup	 = vim2m_queue_setup,
+	.buf_out_validate	 = vim2m_buf_out_validate,
 	.buf_prepare	 = vim2m_buf_prepare,
 	.buf_queue	 = vim2m_buf_queue,
 	.start_streaming = vim2m_start_streaming,
-- 
2.20.1

