Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37666 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1CJM3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 07:29:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LHU008CWDCVKP80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LHU000J2DCUHB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:18 +0000 (GMT)
Date: Thu, 10 Mar 2011 13:28:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/3] v4l2: vb2: one more fix for REQBUFS()
In-reply-to: <1299760122-29493-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	andrzej.p@samsung.com, pawel@osciak.com
Message-id: <1299760122-29493-2-git-send-email-m.szyprowski@samsung.com>
References: <1299760122-29493-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Return immedietely if the target number of buffers is the same as
the current one and memory access type doesn't change.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index c5f99c7..9df484d 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -488,6 +488,13 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EINVAL;
 	}
 
+	/*
+	 * If the same number of buffers and memory access method is requested
+	 * then return immedietely.
+	 */
+	if (q->memory == req->memory && req->count == q->num_buffers)
+		return 0;
+
 	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
-- 
1.7.1.569.g6f426
