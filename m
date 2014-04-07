Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3142 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbaDGNLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:11:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 10/13] vb2: set v4l2_buffer.bytesused to 0 for mp buffers
Date: Mon,  7 Apr 2014 15:11:09 +0200
Message-Id: <1396876272-18222-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The bytesused field of struct v4l2_buffer is not used for multiplanar
formats, so just zero it to prevent it from having some random value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 08152dd..ef7ef82 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -582,6 +582,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * for it. The caller has already verified memory and size.
 		 */
 		b->length = vb->num_planes;
+		b->bytesused = 0;
 		memcpy(b->m.planes, vb->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
 	} else {
-- 
1.9.1

