Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:55656 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab1FPUOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 16:14:20 -0400
From: <hvaibhav@ti.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@redhat.com>, <hverkuil@xs4all.nl>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] omap_vout: Added check in reqbuf & mmap for buf_size allocation
Date: Fri, 17 Jun 2011 01:44:09 +0530
Message-ID: <1308255249-18762-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Vaibhav Hiremath <hvaibhav@ti.com>

The usecase where, user allocates small size of buffer
through bootargs (video1_bufsize/video2_bufsize) and later from application
tries to set the format which requires larger buffer size, driver doesn't
check for insufficient buffer size and allows application to map extra buffer.
This leads to kernel crash, when user application tries to access memory
beyond the allocation size.

Added check in both mmap and reqbuf call back function,
and return error if the size of the buffer allocated by user through
bootargs is less than the S_FMT size.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/omap_vout.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 3bc909a..343b50c 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -678,6 +678,14 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	startindex = (vout->vid == OMAP_VIDEO1) ?
 		video1_numbuffers : video2_numbuffers;

+	/* Check the size of the buffer */
+	if (*size > vout->buffer_size) {
+		v4l2_err(&vout->vid_dev->v4l2_dev,
+				"buffer allocation mismatch [%u] [%u]\n",
+				*size, vout->buffer_size);
+		return -ENOMEM;
+	}
+
 	for (i = startindex; i < *count; i++) {
 		vout->buffer_size = *size;

@@ -856,6 +864,14 @@ static int omap_vout_mmap(struct file *file, struct vm_area_struct *vma)
 				(vma->vm_pgoff << PAGE_SHIFT));
 		return -EINVAL;
 	}
+	/* Check the size of the buffer */
+	if (size > vout->buffer_size) {
+		v4l2_err(&vout->vid_dev->v4l2_dev,
+				"insufficient memory [%lu] [%u]\n",
+				size, vout->buffer_size);
+		return -ENOMEM;
+	}
+
 	q->bufs[i]->baddr = vma->vm_start;

 	vma->vm_flags |= VM_RESERVED;
--
1.6.2.4

