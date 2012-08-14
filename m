Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:53252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2HNPfr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:35:47 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R000ED4NM3Z20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:35:46 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:35:46 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 04/26] v4l: vb: remove warnings about MEMORY_DMABUF
Date: Tue, 14 Aug 2012 17:34:34 +0200
Message-id: <1344958496-9373-5-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sumit Semwal <sumit.semwal@ti.com>

Adding DMABUF memory type causes videobuf to complain about not using it
in some switch cases. This patch removes these warnings.

Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index bf7a326..5449e8a 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -335,6 +335,9 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 	case V4L2_MEMORY_OVERLAY:
 		b->m.offset  = vb->boff;
 		break;
+	case V4L2_MEMORY_DMABUF:
+		/* DMABUF is not handled in videobuf framework */
+		break;
 	}
 
 	b->flags    = 0;
@@ -405,6 +408,7 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 			break;
 		case V4L2_MEMORY_USERPTR:
 		case V4L2_MEMORY_OVERLAY:
+		case V4L2_MEMORY_DMABUF:
 			/* nothing */
 			break;
 		}
-- 
1.7.9.5

