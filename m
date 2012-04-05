Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30891 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2DEOAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2000A48EWGSC70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:16 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2000MXGEWTCP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:30 +0100 (BST)
Date: Thu, 05 Apr 2012 16:00:01 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 04/11] v4l: vb: remove warnings about MEMORY_DMABUF
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com
Message-id: <1333634408-4960-5-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sumit Semwal <sumit.semwal@ti.com>

Adding DMABUF memory type causes videobuf to complain about not using it
in some switch cases. This patch removes these warnings.

Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
---
 drivers/media/video/videobuf-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index de4fa4e..b457c8b 100644
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
1.7.5.4

