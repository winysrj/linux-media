Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42323 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728127AbeIJTzP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:55:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] vicodec: set state->info before calling the encode/decode funcs
Date: Mon, 10 Sep 2018 17:00:40 +0200
Message-Id: <20180910150040.39265-2-hverkuil@xs4all.nl>
In-Reply-To: <20180910150040.39265-1-hverkuil@xs4all.nl>
References: <20180910150040.39265-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

state->info was NULL since I completely forgot to set state->info.
Oops.

Reported-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index fdd77441a47b..5d42a8414283 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -176,12 +176,15 @@ static int device_process(struct vicodec_ctx *ctx,
 	}
 
 	if (ctx->is_enc) {
-		unsigned int size = v4l2_fwht_encode(state, p_in, p_out);
-
-		vb2_set_plane_payload(&out_vb->vb2_buf, 0, size);
+		state->info = q_out->info;
+		ret = v4l2_fwht_encode(state, p_in, p_out);
+		if (ret < 0)
+			return ret;
+		vb2_set_plane_payload(&out_vb->vb2_buf, 0, ret);
 	} else {
+		state->info = q_cap->info;
 		ret = v4l2_fwht_decode(state, p_in, p_out);
-		if (ret)
+		if (ret < 0)
 			return ret;
 		vb2_set_plane_payload(&out_vb->vb2_buf, 0, q_cap->sizeimage);
 	}
-- 
2.18.0
