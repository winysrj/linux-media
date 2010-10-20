Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38043 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0JTJgj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 05:36:39 -0400
Received: by mail-bw0-f46.google.com with SMTP id 10so1123351bwz.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 02:36:39 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 4/6] Staging: tm6000: fix macros  and comments coding style issue in tm6000.h
Date: Wed, 20 Oct 2010 12:35:34 +0300
Message-Id: <1287567334-18873-1-git-send-email-ruslan@rpisarev.org.ua>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the tm6000.h file that fixed up a macros and
comment error found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/tm6000/tm6000.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 1ec1bff..712ce84 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -54,8 +54,9 @@ enum tm6000_devtype {
 };
 
 /* ------------------------------------------------------------------
-	Basic structures
-   ------------------------------------------------------------------*/
+ *	Basic structures
+ * ------------------------------------------------------------------
+ */
 
 struct tm6000_fmt {
 	char  *name;
@@ -251,9 +252,9 @@ struct tm6000_fh {
 	enum v4l2_buf_type           type;
 };
 
-#define TM6000_STD	V4L2_STD_PAL|V4L2_STD_PAL_N|V4L2_STD_PAL_Nc|    \
+#define TM6000_STD	(V4L2_STD_PAL|V4L2_STD_PAL_N|V4L2_STD_PAL_Nc|    \
 			V4L2_STD_PAL_M|V4L2_STD_PAL_60|V4L2_STD_NTSC_M| \
-			V4L2_STD_NTSC_M_JP|V4L2_STD_SECAM
+			V4L2_STD_NTSC_M_JP|V4L2_STD_SECAM)
 
 /* In tm6000-cards.c */
 
-- 
1.7.0.4

