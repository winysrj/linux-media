Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50894 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2DPN7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:04 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2K00F4JS4EJB@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:57:50 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K00AL6S69XP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:59:00 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:48 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 1/8] media: s5p-tv: fix plane size calculation
In-reply-to: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de
Message-id: <1334584735-12439-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Fix plane size calculation.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index f7ca5cc..30a1fd1 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -853,7 +853,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	*nplanes = fmt->num_subframes;
 	for (i = 0; i < fmt->num_subframes; ++i) {
 		alloc_ctxs[i] = layer->mdev->alloc_ctx;
-		sizes[i] = PAGE_ALIGN(planes[i].sizeimage);
+		sizes[i] = planes[i].sizeimage;
 		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
 	}
 
-- 
1.7.5.4

