Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15621 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab1LNKrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 05:47:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW600F81WMSB240@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 10:47:16 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW600CRIWMRCH@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 10:47:16 +0000 (GMT)
Date: Wed, 14 Dec 2011 11:47:10 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] v4l: s5p-tv: mixer: fix setup of VP scaling
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1323859630-15819-1-git-send-email-m.szyprowski@samsung.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

Adjusting of Video Processor's scaling factors was flawed. It bounded scaling
to range 1/16 to 1/1. The correct range should be 1/4 to 4/1. This patch fixes
this bug.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_vp_layer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/video/s5p-tv/mixer_vp_layer.c
index e41ec2e..3d13a63 100644
--- a/drivers/media/video/s5p-tv/mixer_vp_layer.c
+++ b/drivers/media/video/s5p-tv/mixer_vp_layer.c
@@ -172,10 +172,10 @@ static void mxr_vp_fix_geometry(struct mxr_layer *layer,
 		y_center = src->y_offset + src->height / 2;
 
 		/* ensure scaling is between 0.25x .. 16x */
-		src->width = clamp(src->width, round_up(dst->width, 4),
-			dst->width * 16);
-		src->height = clamp(src->height, round_up(dst->height, 4),
-			dst->height * 16);
+		src->width = clamp(src->width, round_up(dst->width / 16, 4),
+			dst->width * 4);
+		src->height = clamp(src->height, round_up(dst->height / 16, 4),
+			dst->height * 4);
 
 		/* hardware limits */
 		src->width = clamp(src->width, 32U, 2047U);
-- 
1.7.1.569.g6f426

