Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2334 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaHYLas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 07:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 01/12] vb2: fix multiplanar read() with non-zero data_offset
Date: Mon, 25 Aug 2014 13:30:12 +0200
Message-Id: <1408966223-5221-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
References: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If this is a multiplanar buf_type and the plane we want to read has a
non-zero data_offset, then that data_offset was not taken into account.

Note that read() or write() for formats with more than one plane is currently
not allowed, hence the use of 'planes[0]' since this is only relevant for a
single-plane format.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5b808e2..7e6aff6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2955,6 +2955,12 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		buf->queued = 0;
 		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
 				 : vb2_plane_size(q->bufs[index], 0);
+		/* Compensate for data_offset on read in the multiplanar case. */
+		if (is_multiplanar && read &&
+		    fileio->b.m.planes[0].data_offset < buf->size) {
+			buf->pos = fileio->b.m.planes[0].data_offset;
+			buf->size -= buf->pos;
+		}
 	} else {
 		buf = &fileio->bufs[index];
 	}
-- 
2.0.1

