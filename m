Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2566 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759665AbaGYJKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 05:10:23 -0400
Message-ID: <53D21ED1.1040003@xs4all.nl>
Date: Fri, 25 Jul 2014 11:09:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] vb2: fix multiplanar read() with non-zero data_offset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If this is a multiplanar buf_type and the plane we want to read has a
non-zero data_offset, then that data_offset was not taken into account.

Note that read() or write() for formats with more than one plane is currently
not allowed, hence the use of 'planes[0]' since this is only relevant for a
single-plane format.

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c359006..0e3d927 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2959,6 +2959,12 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
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
