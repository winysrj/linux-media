Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27370 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767Ab1CDPmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 10:42:05 -0500
Date: Fri, 04 Mar 2011 16:41:51 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/6] v4l: add macro for 1080p59_54 preset
In-reply-to: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com
Message-id: <1299253314-10065-4-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
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
index 940b5db..ef684f6 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -645,6 +645,7 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
 		{ 1920, 1080, "1080p@30" },	/* V4L2_DV_1080P30 */
 		{ 1920, 1080, "1080p@50" },	/* V4L2_DV_1080P50 */
 		{ 1920, 1080, "1080p@60" },	/* V4L2_DV_1080P60 */
+		{ 1920, 1080, "1080p@59.94" },	/* V4L2_DV_1080P59_94 */
 	};
 
 	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a48a42e..4a44b45 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -875,6 +875,7 @@ struct v4l2_dv_enum_preset {
 #define		V4L2_DV_1080P30		16 /* SMPTE 296M */
 #define		V4L2_DV_1080P50		17 /* BT.1120 */
 #define		V4L2_DV_1080P60		18 /* BT.1120 */
+#define		V4L2_DV_1080P59_94	19
 
 /*
  *	D V 	B T	T I M I N G S
-- 
1.7.1.569.g6f426
