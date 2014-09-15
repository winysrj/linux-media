Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17178 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaIOGsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:48:01 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00JSMK7U7V60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:47:54 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 03/17] [media] s5p-mfc: set B-frames as 2 while encoding
Date: Mon, 15 Sep 2014 12:12:58 +0530
Message-id: <1410763393-12183-4-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

set default number of B-frames as 2 while encoding
for better compression. This User can however change
this setting using V4L2_CID_MPEG_VIDEO_B_FRAMES.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index cd1b2a2..f7a6f68 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -280,7 +280,7 @@ static struct mfc_control controls[] = {
 		.minimum = 0,
 		.maximum = 2,
 		.step = 1,
-		.default_value = 0,
+		.default_value = 2,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_H264_PROFILE,
-- 
1.7.3.rc2

