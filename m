Return-path: <mchehab@pedra>
Received: from dakia2.marvell.com ([65.219.4.35]:38737 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1FNGwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 02:52:37 -0400
From: Kassey Lee <ygli@marvell.com>
To: g.liakhovetski@gmx.de, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Cc: Kassey Lee <ygli@marvell.com>
Subject: [PATCH] V4L/DVB: videobuf: mmap.prot checking for IN and OUT device
Date: Tue, 14 Jun 2011 22:51:58 +0800
Message-Id: <1308063118-3527-1-git-send-email-ygli@marvell.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

for OUTPUT device, it will map the page as VM_WRITE
and for INPUT device, it will map the page as
VM_READ. mmap will check the if the prot
is matched with the device type, but not only
check VM_WRITE.

This is actually synced from videobuf2.

Signed-off-by: Kassey Lee <ygli@marvell.com>

hi, Guennadi:

how about sync this enhencement from videbuf2 to videbuf when MMAP is used ?

---
 drivers/media/video/videobuf-core.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index de4fa4e..202dd5d 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -1182,10 +1182,24 @@ int videobuf_mmap_mapper(struct videobuf_queue *q, struct vm_area_struct *vma)
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED)) {
-		dprintk(1, "mmap appl bug: PROT_WRITE and MAP_SHARED are required\n");
+	/*
+	 * Check memory area access mode.
+	 */
+	if (!(vma->vm_flags & VM_SHARED)) {
+		dprintk(1, "Invalid vma flags, VM_SHARED needed\n");
 		return -EINVAL;
 	}
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		if (!(vma->vm_flags & VM_WRITE)) {
+			dprintk(1, "Invalid vma flags, VM_WRITE needed\n");
+			return -EINVAL;
+		}
+	} else {
+		if (!(vma->vm_flags & VM_READ)) {
+			dprintk(1, "Invalid vma flags, VM_READ needed\n");
+			return -EINVAL;
+		}
+	}
 
 	videobuf_queue_lock(q);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-- 
1.7.4.1

