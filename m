Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20065 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2DPN7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2K007W2S5MPS10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:34 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K00AL7S69XP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:58 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:49 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 2/8] v4l: s5p-tv: mixer: fix compilation warning
In-reply-to: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de
Message-id: <1334584735-12439-3-git-send-email-t.stanislaws@samsung.com>
References: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes compilation warning in debug message.  The warning is caused
by incorrect 'unsigned' to 'unsigned long' conversion in dev_dbg.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 30a1fd1..2c44a7f 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -854,7 +854,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	for (i = 0; i < fmt->num_subframes; ++i) {
 		alloc_ctxs[i] = layer->mdev->alloc_ctx;
 		sizes[i] = planes[i].sizeimage;
-		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
+		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
 	}
 
 	if (*nbuffers == 0)
-- 
1.7.5.4

