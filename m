Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37523 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1LEKMa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 05:12:30 -0500
Received: by qcqz2 with SMTP id z2so1327256qcq.19
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2011 02:12:29 -0800 (PST)
From: Peter Korsgaard <jacmet@sunsite.dk>
To: k.debski@samsung.com, mchehab@infradead.org,
	linux-media@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] s5p_mfc_enc: fix s/H264/H263/ typo
Date: Mon,  5 Dec 2011 11:12:15 +0100
Message-Id: <1323079935-5351-1-git-send-email-jacmet@sunsite.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 1e8cdb7..dff9dc7 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -61,7 +61,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.num_planes = 1,
 	},
 	{
-		.name = "H264 Encoded Stream",
+		.name = "H263 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H263,
 		.codec_mode = S5P_FIMV_CODEC_H263_ENC,
 		.type = MFC_FMT_ENC,
-- 
1.7.7.1

