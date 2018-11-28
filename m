Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60481 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbeK2Hzm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 02:55:42 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: vicodec: set state resolution from raw format
Message-ID: <e5dd5d2c-876e-dea4-d804-d25188d34b7c@xs4all.nl>
Date: Wed, 28 Nov 2018 21:52:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The state structure contains the resolution expected by the decoder
and encoder. For an encoder that resolution should be taken from the
OUTPUT format, and for a decoder from the CAPTURE format.

If the wrong format is picked, a buffer overrun can occur if there is
a mismatch between the CAPTURE and OUTPUT formats.

The real fix would be to correctly implement the stateful codec
specification, but that will take more time. For now just prevent the
buffer overrun.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 0f74fbe2e74c..e75bc263a113 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1004,11 +1004,18 @@ static int vicodec_start_streaming(struct vb2_queue *q,

 	q_data->sequence = 0;

-	if (!V4L2_TYPE_IS_OUTPUT(q->type))
+	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
+		if (!ctx->is_enc) {
+			state->width = q_data->width;
+			state->height = q_data->height;
+		}
 		return 0;
+	}

-	state->width = q_data->width;
-	state->height = q_data->height;
+	if (ctx->is_enc) {
+		state->width = q_data->width;
+		state->height = q_data->height;
+	}
 	state->ref_frame.width = state->ref_frame.height = 0;
 	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
 	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
