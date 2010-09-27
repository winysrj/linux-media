Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38167 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849Ab0I0NFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:05:23 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3244338bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:05:22 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 08/13] Staging: cx25821: fix tabs and space coding style issue in cx25821-reg.h
Date: Mon, 27 Sep 2010 16:05:14 +0300
Message-Id: <1285592714-32563-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821-reg.h file that fixed up a macros errors found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-reg.h b/drivers/staging/cx25821/cx25821-reg.h
index cfe0f32..a3fc25a 100644
--- a/drivers/staging/cx25821/cx25821-reg.h
+++ b/drivers/staging/cx25821/cx25821-reg.h
@@ -163,8 +163,8 @@
 #define  FLD_VID_DST_RISC2         0x00000010
 #define  FLD_VID_SRC_RISC1         0x00000002
 #define  FLD_VID_DST_RISC1         0x00000001
-#define  FLD_VID_SRC_ERRORS		FLD_VID_SRC_OPC_ERR | FLD_VID_SRC_SYNC | FLD_VID_SRC_UF
-#define  FLD_VID_DST_ERRORS		FLD_VID_DST_OPC_ERR | FLD_VID_DST_SYNC | FLD_VID_DST_OF
+#define  FLD_VID_SRC_ERRORS		(FLD_VID_SRC_OPC_ERR | FLD_VID_SRC_SYNC | FLD_VID_SRC_UF)
+#define  FLD_VID_DST_ERRORS		(FLD_VID_DST_OPC_ERR | FLD_VID_DST_SYNC | FLD_VID_DST_OF)
 
 /* ***************************************************************************** */
 #define  AUD_A_INT_MSK             0x0400C0	/* Audio Int interrupt mask */
-- 
1.7.0.4

