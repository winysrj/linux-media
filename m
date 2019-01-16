Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA01AC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9420E206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391786AbfAPMBW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:01:22 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33603 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390001AbfAPMBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 07:01:20 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jjsjgM1cgBDyIjjskg25EO; Wed, 16 Jan 2019 13:01:18 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 1/5] vb2: add buf_out_validate callback
Date:   Wed, 16 Jan 2019 13:01:13 +0100
Message-Id: <20190116120117.115497-2-hverkuil-cisco@xs4all.nl>
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

When queueing a buffer to a request the 'field' value is not validated.
That field is only validated when the _buf_prepare() is called,
which happens when the request is queued.

However, this validation should happen at QBUF time, since you want
to know about this as soon as possible. Also, the spec requires that
the 'field' value is validated at QBUF time.

This patch adds a new buf_out_validate callback to validate the
output buffer at buf_prepare time or when QBUF queues an unprepared
buffer to a request. This callback is mandatory for output queues
that support requests.

This issue was found by v4l2-compliance since it failed to replace
V4L2_FIELD_ANY by a proper field value when testing the vivid video
output in combination with requests.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/common/videobuf2/videobuf2-core.c   | 22 ++++++++++++++++---
 include/media/videobuf2-core.h                |  5 +++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c3366f9c..607c13caca92 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -499,9 +499,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 			pr_info("     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
 				vb->cnt_buf_init, vb->cnt_buf_cleanup,
 				vb->cnt_buf_prepare, vb->cnt_buf_finish);
-			pr_info("     buf_queue: %u buf_done: %u buf_request_complete: %u\n",
-				vb->cnt_buf_queue, vb->cnt_buf_done,
-				vb->cnt_buf_request_complete);
+			pr_info("     buf_out_validate: %u buf_queue: %u buf_done: %u buf_request_complete: %u\n",
+				vb->cnt_buf_out_validate, vb->cnt_buf_queue,
+				vb->cnt_buf_done, vb->cnt_buf_request_complete);
 			pr_info("     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
 				vb->cnt_mem_alloc, vb->cnt_mem_put,
 				vb->cnt_mem_prepare, vb->cnt_mem_finish,
@@ -1274,6 +1274,14 @@ static int __buf_prepare(struct vb2_buffer *vb)
 		return 0;
 	WARN_ON(vb->synced);
 
+	if (q->is_output) {
+		ret = call_vb_qop(vb, buf_out_validate, vb);
+		if (ret) {
+			dprintk(1, "buffer validation failed\n");
+			return ret;
+		}
+	}
+
 	vb->state = VB2_BUF_STATE_PREPARING;
 
 	switch (q->memory) {
@@ -1520,6 +1528,14 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 			return -EINVAL;
 		}
 
+		if (q->is_output && !vb->prepared) {
+			ret = call_vb_qop(vb, buf_out_validate, vb);
+			if (ret) {
+				dprintk(1, "buffer validation failed\n");
+				return ret;
+			}
+		}
+
 		media_request_object_init(&vb->req_obj);
 
 		/* Make sure the request is in a safe state for updating. */
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4a737b2c610b..4849b865b908 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -296,6 +296,7 @@ struct vb2_buffer {
 	u32		cnt_mem_num_users;
 	u32		cnt_mem_mmap;
 
+	u32		cnt_buf_out_validate;
 	u32		cnt_buf_init;
 	u32		cnt_buf_prepare;
 	u32		cnt_buf_finish;
@@ -342,6 +343,9 @@ struct vb2_buffer {
  * @wait_finish:	reacquire all locks released in the previous callback;
  *			required to continue operation after sleeping while
  *			waiting for a new buffer to arrive.
+ * @buf_out_validate:	called when the output buffer is prepared or queued
+ *			to a request; drivers can use this to validate
+ *			userspace-provided information; optional.
  * @buf_init:		called once after allocating a buffer (in MMAP case)
  *			or after acquiring a new USERPTR buffer; drivers may
  *			perform additional buffer-related initialization;
@@ -409,6 +413,7 @@ struct vb2_ops {
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
 
+	int (*buf_out_validate)(struct vb2_buffer *vb);
 	int (*buf_init)(struct vb2_buffer *vb);
 	int (*buf_prepare)(struct vb2_buffer *vb);
 	void (*buf_finish)(struct vb2_buffer *vb);
-- 
2.20.1

