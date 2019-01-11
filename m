Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14848C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C3C20870
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbfAKMXu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 07:23:50 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:37247 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfAKMXt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 07:23:49 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hvqlgslD9NR5yhvqmgACsA; Fri, 11 Jan 2019 13:23:48 +0100
Subject: [PATCHv3 2/3] vim2m: add buf_out_validate callback
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20190107130437.23732-1-hverkuil-cisco@xs4all.nl>
 <20190107130437.23732-3-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <f201dd1a-c5ca-15f1-1e37-bb815ac28637@xs4all.nl>
Date:   Fri, 11 Jan 2019 13:23:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190107130437.23732-3-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLoHKJDbjCk3+3ivLSqw/3qLU5Ox0fSq1Me19OtdkDSkUyeuFj4IjHxLqKUOEM7z6W/P78UJZfl5aXvNhEwu6YIeGr5vw+IuF47zbSFeE9DErO/UWaOj
 ueRtcZbWqnhYvPZ3EH0RoGK0m90hnmb7ciMn1WIQwY131FDLzMKuJPUewmS+OfsbZZBobL8s/R6Zj0HiapKGxG19bnt5QWlTB6LAbFF/SFoL270RIrhA0qMC
 fWfdj0JSy6efvjbO0QUORKQINCtMiMUWb8kGrPr/H9Jv2Zzk5fWERpnb/13ByIfTemznFpMa8zqjPqSZifS+LZGOQUQj9ySVGELvyZzo+LQ=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Split off the field validation from buf_prepare into a new
buf_out_validate function. Field validation for output buffers should
be done there since buf_prepare is not guaranteed to be called at
QBUF time.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Changes since v2:
- drop test whether the queue is an output queue. This callback is only
  called for output queues, so this test is not needed anymore.
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

