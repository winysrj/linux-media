Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5EDC282CB
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9E120823
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfBDKLj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 05:11:39 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:42662 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbfBDKLi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 05:11:38 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id qbDyg7eyqNR5yqbE0giMRI; Mon, 04 Feb 2019 11:11:36 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 1/3] vb2: replace bool by bitfield in vb2_buffer
Date:   Mon,  4 Feb 2019 11:11:32 +0100
Message-Id: <20190204101134.56283-2-hverkuil-cisco@xs4all.nl>
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

The bool type is not recommended for use in structs, so replace these
by bitfields.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 12 ++++++------
 include/media/videobuf2-core.h                  |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index e07b6bdb6982..35cf36686e20 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -934,7 +934,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 		/* sync buffers */
 		for (plane = 0; plane < vb->num_planes; ++plane)
 			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
-		vb->synced = false;
+		vb->synced = 0;
 	}
 
 	spin_lock_irqsave(&q->done_lock, flags);
@@ -1313,8 +1313,8 @@ static int __buf_prepare(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
 
-	vb->synced = true;
-	vb->prepared = true;
+	vb->synced = 1;
+	vb->prepared = 1;
 	vb->state = orig_state;
 
 	return 0;
@@ -1803,7 +1803,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	}
 
 	call_void_vb_qop(vb, buf_finish, vb);
-	vb->prepared = false;
+	vb->prepared = 0;
 
 	if (pindex)
 		*pindex = vb->index;
@@ -1927,12 +1927,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 			for (plane = 0; plane < vb->num_planes; ++plane)
 				call_void_memop(vb, finish,
 						vb->planes[plane].mem_priv);
-			vb->synced = false;
+			vb->synced = 0;
 		}
 
 		if (vb->prepared) {
 			call_void_vb_qop(vb, buf_finish, vb);
-			vb->prepared = false;
+			vb->prepared = 0;
 		}
 		__vb2_dqbuf(vb);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4849b865b908..2757d1902609 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -269,8 +269,8 @@ struct vb2_buffer {
 	 * vb2_plane:		per-plane information; do not change
 	 */
 	enum vb2_buffer_state	state;
-	bool			synced;
-	bool			prepared;
+	unsigned int		synced:1;
+	unsigned int		prepared:1;
 
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 	struct list_head	queued_entry;
-- 
2.20.1

