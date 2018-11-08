Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43812 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbeKHV64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 16:58:56 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vb2: check memory model for VIDIOC_CREATE_BUFS
Message-ID: <edb80bbd-7076-8fc1-cfbe-9e9f156793eb@xs4all.nl>
Date: Thu, 8 Nov 2018 13:23:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_core_create_bufs did not check if the memory model for newly added
buffers is the same as for already existing buffers. It should return an
error if they aren't the same.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: syzbot+e1fb118a2ebb88031d21@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>      # for v4.16 and up
---
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 975ff5669f72..c49c67473408 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -812,6 +812,9 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 		q->memory = memory;
 		q->waiting_for_buffers = !q->is_output;
+	} else if (q->memory != memory) {
+		dprintk(1, "memory model mismatch\n");
+		return -EINVAL;
 	}

 	num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
