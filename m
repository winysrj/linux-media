Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2243 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaBQJ7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:59:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 33/35] solo6x10: fix 'dma from stack' warning.
Date: Mon, 17 Feb 2014 10:57:48 +0100
Message-Id: <1392631070-41868-34-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
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
1.8.4.rc3

