Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10031 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2FNHFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 03:05:08 -0400
Received: from euspt2 (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5L00B1XIDM1C90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 08:05:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5L00GFFICF22@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 08:05:03 +0100 (BST)
Date: Thu, 14 Jun 2012 09:04:06 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] v4l/s5p-mfc: corrected encoder v4l control definitions
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1339657446-21916-1-git-send-email-a.hajda@samsung.com>
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch corrects definition of H264 level control and
changes bare numbers to enums in two other cases.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index acedb20..9c19aa8 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -243,12 +243,6 @@ static struct mfc_control controls[] = {
 		.minimum = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
 		.maximum = V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
 		.default_value = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
-		.menu_skip_mask = ~(
-				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_1) |
-				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_2) |
-				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_5_0) |
-				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_5_1)
-				),
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
@@ -494,7 +488,7 @@ static struct mfc_control controls[] = {
 		.type = V4L2_CTRL_TYPE_MENU,
 		.minimum = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED,
 		.maximum = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED,
-		.default_value = 0,
+		.default_value = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED,
 		.menu_skip_mask = 0,
 	},
 	{
@@ -534,7 +528,7 @@ static struct mfc_control controls[] = {
 		.type = V4L2_CTRL_TYPE_MENU,
 		.minimum = V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE,
 		.maximum = V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE,
-		.default_value = 0,
+		.default_value = V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE,
 		.menu_skip_mask = 0,
 	},
 	{
-- 
1.7.0.4

