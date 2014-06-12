Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3435 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293AbaFLLys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 32/34] solo6x10: fix 'dma from stack' warning.
Date: Thu, 12 Jun 2014 13:53:04 +0200
Message-Id: <8b48fc59f6220e08aeb6780cf6d14f7fb8a344e8.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-disp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-disp.c b/drivers/staging/media/solo6x10/solo6x10-disp.c
index 44d98b8..b529a96 100644
--- a/drivers/staging/media/solo6x10/solo6x10-disp.c
+++ b/drivers/staging/media/solo6x10/solo6x10-disp.c
@@ -213,19 +213,21 @@ int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
 int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 		const u16 *thresholds)
 {
+	const unsigned size = sizeof(u16) * 64;
 	u32 off = SOLO_MOT_FLAG_AREA + ch * SOLO_MOT_THRESH_SIZE * 2;
-	u16 buf[64];
+	u16 *buf;
 	int x, y;
 	int ret = 0;
 
-	memset(buf, 0, sizeof(buf));
+	buf = kzalloc(size, GFP_KERNEL);
 	for (y = 0; y < SOLO_MOTION_SZ; y++) {
 		for (x = 0; x < SOLO_MOTION_SZ; x++)
 			buf[x] = cpu_to_le16(thresholds[y * SOLO_MOTION_SZ + x]);
 		ret |= solo_p2m_dma(solo_dev, 1, buf,
-			SOLO_MOTION_EXT_ADDR(solo_dev) + off + y * sizeof(buf),
-			sizeof(buf), 0, 0);
+			SOLO_MOTION_EXT_ADDR(solo_dev) + off + y * size,
+			size, 0, 0);
 	}
+	kfree(buf);
 	return ret;
 }
 
-- 
2.0.0.rc0

