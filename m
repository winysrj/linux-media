Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39343 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2EWMKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 08:10:45 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00BEL5PY8G@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:08:22 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H0033Q5TSN0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:40 +0100 (BST)
Date: Wed, 23 May 2012 14:10:18 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv6 04/13] v4l: vb: remove warnings about MEMORY_DMABUF
In-reply-to: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337775027-9489-5-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
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

