Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2CEC282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 295482081B
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfBDKLj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 05:11:39 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:48593 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728438AbfBDKLi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 05:11:38 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id qbDyg7eyqNR5yqbE0giMRP; Mon, 04 Feb 2019 11:11:36 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 2/3] vb2: keep track of timestamp status
Date:   Mon,  4 Feb 2019 11:11:33 +0100
Message-Id: <20190204101134.56283-3-hverkuil-cisco@xs4all.nl>
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

If a stream is stopped, or if a USERPTR/DMABUF buffer is queued
backed by a different user address or dmabuf fd, then the timestamp
should be skipped by vb2_find_timestamp since the memory it refers
to is no longer valid.

So keep track of a 'copied_timestamp' state: it is set when the
timestamp is copied from an output to a capture buffer, and is
cleared when it is no longer valid.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 3 +++
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 3 ++-
 drivers/media/v4l2-core/v4l2-mem2mem.c          | 1 +
 include/media/videobuf2-core.h                  | 3 +++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 35cf36686e20..dc29bd01d6c5 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1041,6 +1041,7 @@ static int __prepare_userptr(struct vb2_buffer *vb)
 		if (vb->planes[plane].mem_priv) {
 			if (!reacquired) {
 				reacquired = true;
+				vb->copied_timestamp = 0;
 				call_void_vb_qop(vb, buf_cleanup, vb);
 			}
 			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
@@ -1165,6 +1166,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
 
 		if (!reacquired) {
 			reacquired = true;
+			vb->copied_timestamp = 0;
 			call_void_vb_qop(vb, buf_cleanup, vb);
 		}
 
@@ -1943,6 +1945,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		if (vb->request)
 			media_request_put(vb->request);
 		vb->request = NULL;
+		vb->copied_timestamp = 0;
 	}
 }
 
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 3aeaea3af42a..55277370c313 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -604,7 +604,8 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
 	unsigned int i;
 
 	for (i = start_idx; i < q->num_buffers; i++)
-		if (q->bufs[i]->timestamp == timestamp)
+		if (q->bufs[i]->copied_timestamp &&
+		    q->bufs[i]->timestamp == timestamp)
 			return i;
 	return -1;
 }
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 631f4e2aa942..64b19ee1c847 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -992,6 +992,7 @@ void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
 	cap_vb->field = out_vb->field;
 	cap_vb->flags &= ~mask;
 	cap_vb->flags |= out_vb->flags & mask;
+	cap_vb->vb2_buf.copied_timestamp = 1;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_copy_data);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 2757d1902609..62488d901747 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -262,6 +262,8 @@ struct vb2_buffer {
 	 * prepared:		this buffer has been prepared, i.e. the
 	 *			buf_prepare op was called. It is cleared again
 	 *			after the 'buf_finish' op is called.
+	 * copied_timestamp:	the timestamp of this capture buffer was copied
+	 *			from an output buffer.
 	 * queued_entry:	entry on the queued buffers list, which holds
 	 *			all buffers queued from userspace
 	 * done_entry:		entry on the list that stores all buffers ready
@@ -271,6 +273,7 @@ struct vb2_buffer {
 	enum vb2_buffer_state	state;
 	unsigned int		synced:1;
 	unsigned int		prepared:1;
+	unsigned int		copied_timestamp:1;
 
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 	struct list_head	queued_entry;
-- 
2.20.1

