Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0I0NC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:02:57 -0400
Received: by bwz11 with SMTP id 11so3242997bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:02:56 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 03/13] Staging: cx25821: fix comments and space coding style issue in cx25821-audio.h
Date: Mon, 27 Sep 2010 16:02:44 +0300
Message-Id: <1285592564-32202-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821-audio.h file that fixed up a comments
and space Errors found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-audio.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 434b2a3..a702a0d 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -31,18 +31,18 @@
 #define NUMBER_OF_PROGRAMS  8
 
 /*
-  Max size of the RISC program for a buffer. - worst case is 2 writes per line
-  Space is also added for the 4 no-op instructions added on the end.
-*/
+ * Max size of the RISC program for a buffer. - worst case is 2 writes per line
+ * Space is also added for the 4 no-op instructions added on the end.
+ */
 #ifndef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-    (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
+	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
 #endif
 
 /* MAE 12 July 2005 Try to use NOOP RISC instruction instead */
 #ifdef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-    (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
+	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
 #endif
 
 /* Sizes of various instructions in bytes.  Used when adding instructions. */
-- 
1.7.0.4

