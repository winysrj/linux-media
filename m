Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2003 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaCJVVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 17:21:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 10/11] vb2: set v4l2_buffer.bytesused to 0 for mp buffers
Date: Mon, 10 Mar 2014 22:20:57 +0100
Message-Id: <1394486458-9836-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
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
index f68a60f..54a4150 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -583,6 +583,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * for it. The caller has already verified memory and size.
 		 */
 		b->length = vb->num_planes;
+		b->bytesused = 0;
 		memcpy(b->m.planes, vb->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
 	} else {
-- 
1.9.0

