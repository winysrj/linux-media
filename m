Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45699 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3JDET0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 00:19:26 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: Adjust the default values of some encoder params
Date: Fri,  4 Oct 2013 09:50:05 +0530
Message-Id: <1380860405-30623-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch sets the default values of MAX_QP and GOP size encoder
parameters to some firmware recommended default values. This enables
the applications to get a better encoded output using the default
settings itself.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 41f5a3c..4ff3b6c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -113,7 +113,7 @@ static struct mfc_control controls[] = {
 		.minimum = 0,
 		.maximum = (1 << 16) - 1,
 		.step = 1,
-		.default_value = 0,
+		.default_value = 12,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
@@ -356,7 +356,7 @@ static struct mfc_control controls[] = {
 		.minimum = 0,
 		.maximum = 51,
 		.step = 1,
-		.default_value = 1,
+		.default_value = 51,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP,
@@ -399,7 +399,7 @@ static struct mfc_control controls[] = {
 		.minimum = 1,
 		.maximum = 31,
 		.step = 1,
-		.default_value = 1,
+		.default_value = 31,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP,
@@ -444,7 +444,7 @@ static struct mfc_control controls[] = {
 		.minimum = 0,
 		.maximum = 51,
 		.step = 1,
-		.default_value = 1,
+		.default_value = 51,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP,
-- 
1.7.9.5

