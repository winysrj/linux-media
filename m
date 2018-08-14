Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:33631 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732809AbeHNRIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 18/35] videobuf2-v4l2: replace if by switch in __fill_vb2_buffer()
Date: Tue, 14 Aug 2018 16:20:30 +0200
Message-Id: <20180814142047.93856-19-hverkuil@xs4all.nl>
In-Reply-To: <20180814142047.93856-1-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace 'if' statements by a switch in __fill_vb2_buffer()
in preparation of the next patch.

No other changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 408fd7ce9c09..57848ddc584f 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -190,21 +190,25 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 	vbuf->sequence = 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		if (b->memory == VB2_MEMORY_USERPTR) {
+		switch (b->memory) {
+		case VB2_MEMORY_USERPTR:
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				planes[plane].m.userptr =
 					b->m.planes[plane].m.userptr;
 				planes[plane].length =
 					b->m.planes[plane].length;
 			}
-		}
-		if (b->memory == VB2_MEMORY_DMABUF) {
+			break;
+		case VB2_MEMORY_DMABUF:
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				planes[plane].m.fd =
 					b->m.planes[plane].m.fd;
 				planes[plane].length =
 					b->m.planes[plane].length;
 			}
+			break;
+		default:
+			break;
 		}
 
 		/* Fill in driver-provided information for OUTPUT types */
@@ -255,14 +259,17 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 		 * the driver should use the allow_zero_bytesused flag to keep
 		 * old userspace applications working.
 		 */
-		if (b->memory == VB2_MEMORY_USERPTR) {
+		switch (b->memory) {
+		case VB2_MEMORY_USERPTR:
 			planes[0].m.userptr = b->m.userptr;
 			planes[0].length = b->length;
-		}
-
-		if (b->memory == VB2_MEMORY_DMABUF) {
+			break;
+		case VB2_MEMORY_DMABUF:
 			planes[0].m.fd = b->m.fd;
 			planes[0].length = b->length;
+			break;
+		default:
+			break;
 		}
 
 		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-- 
2.18.0
