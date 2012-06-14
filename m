Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13593 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2FNNiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 09:38:12 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M00LRV0KG1760@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 14:38:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00GSN0JI22@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 14:38:07 +0100 (BST)
Date: Thu, 14 Jun 2012 15:37:38 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv7 04/15] v4l: vb: remove warnings about MEMORY_DMABUF
In-reply-to: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1339681069-8483-5-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
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
index ffdf59c..3e3e55f 100644
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
@@ -411,6 +414,7 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 			break;
 		case V4L2_MEMORY_USERPTR:
 		case V4L2_MEMORY_OVERLAY:
+		case V4L2_MEMORY_DMABUF:
 			/* nothing */
 			break;
 		}
-- 
1.7.9.5

