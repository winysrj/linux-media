Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.222.116]:40451 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaGWQPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 12:15:38 -0400
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, m.chehab@samsung.com,
	ayaka <ayaka@soulik.info>
Subject: [PATCH] s5p-mfc: correct the formats info for encoder
Date: Thu, 24 Jul 2014 00:15:04 +0800
Message-Id: <1406132104-6430-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1406132104-6430-1-git-send-email-ayaka@soulik.info>
References: <1406132104-6430-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The NV12M is supported by all the version of MFC, so it is better
to use it as default OUTPUT format.
MFC v5 doesn't support NV21, I have tested it, for the SEC doc
it is not supported either.
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index d26b248..4ea3796 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -32,7 +32,7 @@
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 
-#define DEF_SRC_FMT_ENC	V4L2_PIX_FMT_NV12MT
+#define DEF_SRC_FMT_ENC	V4L2_PIX_FMT_NV12M
 #define DEF_DST_FMT_ENC	V4L2_PIX_FMT_H264
 
 static struct s5p_mfc_fmt formats[] = {
@@ -67,8 +67,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT,
 	},
 	{
 		.name		= "H264 Encoded Stream",
-- 
1.9.3

