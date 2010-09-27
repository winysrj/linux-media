Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0I0NGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:06:50 -0400
Received: by bwz11 with SMTP id 11so3246776bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:06:49 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 10/13] Staging: cx25821: fix tabs and space coding style issue in cx25821-video-upstream-ch2.h
Date: Mon, 27 Sep 2010 16:06:38 +0300
Message-Id: <1285592798-32694-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821-video-upstream-ch2.h file that fixed up
a space errors found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
index 6234063..029e830 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
@@ -88,14 +88,14 @@
 #endif
 
 #ifndef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
-#define PAL_RISC_BUF_SIZE         ( 2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE) )
+#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+#define PAL_RISC_BUF_SIZE         (2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE))
 #define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE )
-#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
-#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE )
+				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
 #define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE) )
+#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
 #define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE )
+				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
 #endif
-- 
1.7.0.4

