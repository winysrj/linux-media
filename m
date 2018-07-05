Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:44059 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753170AbeGEIZV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 04:25:21 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] videobuf2-core: check for q->error in vb2_core_qbuf()
Message-ID: <ab3d5aa7-c06b-9918-235e-ff983cb5cce7@xs4all.nl>
Date: Thu, 5 Jul 2018 10:25:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_core_qbuf() function didn't check if q->error was set. It is checked in
__buf_prepare(), but that function isn't called if the buffer was already
prepared before with VIDIOC_PREPARE_BUF.

So check it at the start of vb2_core_qbuf() as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index d3501cd604cb..5d7946ec80d8 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1484,6 +1484,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 	struct vb2_buffer *vb;
 	int ret;

+	if (q->error) {
+		dprintk(1, "fatal error occurred on queue\n");
+		return -EIO;
+	}
+
 	vb = q->bufs[index];

 	if ((req && q->uses_qbuf) ||
