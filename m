Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A0FC282CC
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 008C42081B
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfBDKLj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 05:11:39 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:36030 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728449AbfBDKLi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 05:11:38 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id qbDyg7eyqNR5yqbE0giMRX; Mon, 04 Feb 2019 11:11:36 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 3/3] vb2: add 'match' arg to vb2_find_buffer()
Date:   Mon,  4 Feb 2019 11:11:34 +0100
Message-Id: <20190204101134.56283-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl>
References: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfC1OsLAdqq3aBt0icglNKZhLnBKRD635orEa9uWyBL4AHKqi+8rwESeYlpema3gVNcboYst5RNf1xVZpax0YkIoBeEWd+3y9CN0OmGk0JX90vgZAhK7X
 3TwD3xRDqHJuYKOCqgJe6M1fUuYXwu9VE4p2TxSYDCXSP/f17ES5NkPYPpJ0hnfxdn4DJ8RDl1r6ZkNC0fGaNzeXrB9vb9tb4GQGk+/f0rjpYv+YHpW/+9PD
 7ZQ8MBQEm99zysKtO+T1mHvlSvKDVFpUEuwOAY884HotwYlE9peeLWhb7XmLTmSm0wqwgrfE18iLlHOC/lFD0pCtgsuj9wQqC8QzTjgfnO7DFszVb1VDCp7v
 m90YEl+t71mStNRYlLkb02U9sEjVMA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

When finding a buffer vb2_find_buffer() should also check if the
properties of the found buffer (i.e. number of planes and plane sizes)
match the properties of the 'match' buffer.

Update the cedrus driver accordingly.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c   | 15 ++++++++++++---
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c |  8 ++++----
 include/media/videobuf2-v4l2.h                    |  3 ++-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 55277370c313..0207493c8877 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -599,14 +599,23 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
 };
 
 int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
-		       unsigned int start_idx)
+		       const struct vb2_buffer *match, unsigned int start_idx)
 {
 	unsigned int i;
 
 	for (i = start_idx; i < q->num_buffers; i++)
 		if (q->bufs[i]->copied_timestamp &&
-		    q->bufs[i]->timestamp == timestamp)
-			return i;
+		    q->bufs[i]->timestamp == timestamp &&
+		    q->bufs[i]->num_planes == match->num_planes) {
+			unsigned int p;
+
+			for (p = 0; p < match->num_planes; p++)
+				if (q->bufs[i]->planes[p].length <
+				    match->planes[p].length)
+					break;
+			if (p == match->num_planes)
+				return i;
+		}
 	return -1;
 }
 EXPORT_SYMBOL_GPL(vb2_find_timestamp);
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index cb45fda9aaeb..16bc82f1cb2c 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
@@ -159,8 +159,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
 
 	/* Forward and backward prediction reference buffers. */
-	forward_idx = vb2_find_timestamp(cap_q,
-					 slice_params->forward_ref_ts, 0);
+	forward_idx = vb2_find_timestamp(cap_q, slice_params->forward_ref_ts,
+					 &run->dst->vb2_buf, 0);
 
 	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
 	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
@@ -168,8 +168,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
 
-	backward_idx = vb2_find_timestamp(cap_q,
-					  slice_params->backward_ref_ts, 0);
+	backward_idx = vb2_find_timestamp(cap_q, slice_params->backward_ref_ts,
+					  &run->dst->vb2_buf, 0);
 	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
 	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
 
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 8a10889dc2fd..b123d12424ba 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -60,6 +60,7 @@ struct vb2_v4l2_buffer {
  *
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  * @timestamp:	the timestamp to find.
+ * @match:	the properties of the buffer to find must match this buffer.
  * @start_idx:	the start index (usually 0) in the buffer array to start
  *		searching from. Note that there may be multiple buffers
  *		with the same timestamp value, so you can restart the search
@@ -69,7 +70,7 @@ struct vb2_v4l2_buffer {
  * -1 if no buffer with @timestamp was found.
  */
 int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
-		       unsigned int start_idx);
+		       const struct vb2_buffer *match, unsigned int start_idx);
 
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
-- 
2.20.1

