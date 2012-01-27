Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54533 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2A0Kbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 05:31:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] videobuf2: Use buffer length for DMABUF in non-planar mode
Date: Fri, 27 Jan 2012 11:31:53 +0100
Message-Id: <1327660313-8964-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using DMABUF streaming in non-planar mode, the v4l2_buffer::length
field holds the length of the buffer as required by userspace. Copy it
to the length of the first plane at QBUF time, as the plane length is
later checked against the dma-buf size.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 29cf6ed..8eb4d08 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -927,6 +927,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 		}
 		if (b->memory == V4L2_MEMORY_DMABUF) {
 			v4l2_planes[0].m.fd = b->m.fd;
+			v4l2_planes[0].length = b->length;
 		}
 
 	}
-- 
1.7.3.4

