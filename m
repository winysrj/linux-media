Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:55885 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726430AbeIARMf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Sep 2018 13:12:35 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: fix sparse warning
Message-ID: <093e4f49-0f80-1edd-a775-1496ce795f2a@xs4all.nl>
Date: Sat, 1 Sep 2018 15:00:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/vicodec/vicodec-core.c:160:25: warning: variable 'q_out' set but not used [-Wunused-but-set-variable]

It's indeed not used, and it can be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 47e9ad0941ab..11385d44e500 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -157,12 +157,11 @@ static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *out_vb)
 {
 	struct vicodec_dev *dev = ctx->dev;
-	struct vicodec_q_data *q_out, *q_cap;
+	struct vicodec_q_data *q_cap;
 	struct v4l2_fwht_state *state = &ctx->state;
 	u8 *p_in, *p_out;
 	int ret;

-	q_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	q_cap = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (ctx->is_enc)
 		p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
-- 
2.18.0
