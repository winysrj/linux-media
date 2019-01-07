Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A186C43612
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 622C92089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbfAGNEr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:04:47 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:40807 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731273AbfAGNEo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 08:04:44 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gUa5gGVcvBDyIgUa9gNvGy; Mon, 07 Jan 2019 14:04:41 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 1/3] vb2: add buf_out_validate callback
Date:   Mon,  7 Jan 2019 14:04:35 +0100
Message-Id: <20190107130437.23732-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190107130437.23732-1-hverkuil-cisco@xs4all.nl>
References: <20190107130437.23732-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDCmRx3XpwoRyhsCu+I6BOjpwOPbiD9WkNw+/WsSfupulCB+iENqYf43Ic7HhaXqJoItpo/ckeEkyBGiyKgpQtT3FPCMlCXFCJ3dPj9DKtgT/skZw9TP
 Acxfif5kN3yNE5SAgVp1m8vugqREVyr9pSnb2QogCTY1cBGNcm25x31+vEegDYIrZxYMkSLIEInYpsZPiajlK5vWMGl+9PpD8/n1lJOlLgdteCSttU+7G4i2
 FtlYoMRRCaF5LO8f3zy4/F5FvkUp1vx6+7zS/DSzs3c=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Adding the request API uncovered a pre-existing problem with
validating output buffers.

The problem is that for output buffers the driver has to validate
the 'field' field of struct v4l2_buffer. This is critical when
encoding or deinterlacing interlaced video.

Drivers always did this in the buf_prepare callback, but that is
not called from VIDIOC_QBUF in two situations: when queueing a
buffer to a request and if VIDIOC_PREPARE_BUF has been called
earlier for that buffer.

As a result of this the 'field' value is not validated.

While the first case (queueing a buffer to a request) is request
API specific, the second case (VIDIOC_PREPARE_BUF has been called
earlier for that buffer) was always wrong.

This patch adds a new buf_out_validate callback to validate the
output buffer at QBUF time.

Note that PREPARE_BUF doesn't need to validate this: it just
locks the buffer memory and doesn't need nor want to know about
how this buffer is actually going to be used. It's the QBUF ioctl
that determines this.

This issue was found by v4l2-compliance since it failed to replace
V4L2_FIELD_ANY by a proper field value when testing the vivid video
output in combination with requests.

There never was a test before for the PREPARE_BUF/QBUF case, so even
though this bug has been present for quite some time, it was never
noticed.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 14 +++++++++++---
 include/media/videobuf2-core.h                  |  5 +++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c3366f9c..653e933db854 100644
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
@@ -1510,6 +1510,14 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		return -EBUSY;
 	}
 
+	if (q->is_output) {
+		ret = call_vb_qop(vb, buf_out_validate, vb);
+		if (ret) {
+			dprintk(1, "buffer validation failed\n");
+			return ret;
+		}
+	}
+
 	if (req) {
 		int ret;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4a737b2c610b..91f1e66aacc6 100644
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
+ * @buf_out_validate:	called every time the output buffer is queued from
+ *			userspace; drivers can use this to validate
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
2.19.2

