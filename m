Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56590 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1DKM3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 08:29:37 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJH008HSMPCJO@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Apr 2011 13:29:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJH0087MMPBIJ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Apr 2011 13:29:35 +0100 (BST)
Date: Mon, 11 Apr 2011 14:29:22 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/3] v4l: add macro for 1080p59_54 preset
In-reply-to: <1302524964-31407-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1302524964-31407-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1302524964-31407-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The 1080p59_94 is supported in latest Samusng SoC.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-common.c |    1 +
 include/linux/videodev2.h         |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 06b9f9f..003e648 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -582,6 +582,7 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
 		{ 1920, 1080, "1080p@30" },	/* V4L2_DV_1080P30 */
 		{ 1920, 1080, "1080p@50" },	/* V4L2_DV_1080P50 */
 		{ 1920, 1080, "1080p@60" },	/* V4L2_DV_1080P60 */
+		{ 1920, 1080, "1080p@59.94" },	/* V4L2_DV_1080P59_94 */
 	};
 
 	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index aa6c393..cb0393a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -867,6 +867,7 @@ struct v4l2_dv_enum_preset {
 #define		V4L2_DV_1080P30		16 /* SMPTE 296M */
 #define		V4L2_DV_1080P50		17 /* BT.1120 */
 #define		V4L2_DV_1080P60		18 /* BT.1120 */
+#define		V4L2_DV_1080P59_94	19
 
 /*
  *	D V 	B T	T I M I N G S
-- 
1.7.4.3
