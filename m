Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63599 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2DMPsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 11:48:08 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2F00CGID7ZD4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Apr 2012 16:48:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2F005J6D83XW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Apr 2012 16:48:04 +0100 (BST)
Date: Fri, 13 Apr 2012 17:47:46 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH v4 04/14] v4l: vb: remove warnings about MEMORY_DMABUF
In-reply-to: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com
Message-id: <1334332076-28489-5-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
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

