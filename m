Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38167 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0I0NEs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:04:48 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3244338bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:04:47 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 06/13] Staging: cx25821: fix tabs and space coding style issue in cx25821-medusa-reg.h
Date: Mon, 27 Sep 2010 16:04:35 +0300
Message-Id: <1285592675-32408-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 This is a patch to the cx25821-medusa-reg.h file that fixed up a tabs
 and space warnings found by the checkpatch.pl tools.

 Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-medusa-reg.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-medusa-reg.h b/drivers/staging/cx25821/cx25821-medusa-reg.h
index f7f33b3..1c1c228 100644
--- a/drivers/staging/cx25821/cx25821-medusa-reg.h
+++ b/drivers/staging/cx25821/cx25821-medusa-reg.h
@@ -443,13 +443,13 @@
 /*****************************************************************************/
 /* LUMA_CTRL register fields */
 #define VDEC_A_BRITE_CTRL				0x1014
-#define VDEC_A_CNTRST_CTRL       		0x1015
-#define VDEC_A_PEAK_SEL          		0x1016
+#define VDEC_A_CNTRST_CTRL			0x1015
+#define VDEC_A_PEAK_SEL				0x1016
 
 /*****************************************************************************/
 /* CHROMA_CTRL register fields */
-#define VDEC_A_USAT_CTRL         		0x1018
-#define VDEC_A_VSAT_CTRL         		0x1019
-#define VDEC_A_HUE_CTRL          		0x101A
+#define VDEC_A_USAT_CTRL			0x1018
+#define VDEC_A_VSAT_CTRL			0x1019
+#define VDEC_A_HUE_CTRL				0x101A
 
 #endif
-- 
1.7.0.4

