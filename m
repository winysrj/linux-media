Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51240 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2FKLKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 07:10:01 -0400
Received: by dady13 with SMTP id y13so5244228dad.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 04:10:01 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, kyungmin.park@samsung.com,
	mchehab@infradead.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-mfc: Fix checkpatch error in s5p_mfc_shm.h file
Date: Mon, 11 Jun 2012 16:28:42 +0530
Message-Id: <1339412322-15524-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following error:
ERROR: open brace '{' following enum go on the same line
+enum MFC_SHM_OFS
+{

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
index 764eac6..cf962a4 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
@@ -13,8 +13,7 @@
 #ifndef S5P_MFC_SHM_H_
 #define S5P_MFC_SHM_H_
 
-enum MFC_SHM_OFS
-{
+enum MFC_SHM_OFS {
 	EXTENEDED_DECODE_STATUS	= 0x00,	/* D */
 	SET_FRAME_TAG		= 0x04, /* D */
 	GET_FRAME_TAG_TOP	= 0x08, /* D */
-- 
1.7.4.1

