Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0I0NAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:00:46 -0400
Received: by bwz11 with SMTP id 11so3241017bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:00:45 -0700 (PDT)
From: ruslanpisarev@gmail.com
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 01/13] Staging: cx25821: fox "ERROR: space prohibited after that open parenthesis '('" This is a patch to the cx25821-audio-upstream.h file that fixed up a space Errors found by the checkpatch.pl tools Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Date: Mon, 27 Sep 2010 16:00:24 +0300
Message-Id: <4ca0957b.02a3cc0a.7597.ffff9c77@mx.google.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Ruslan Pisarev <ruslan@rpisarev.org.ua>

---
 drivers/staging/cx25821/cx25821-audio-upstream.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.h b/drivers/staging/cx25821/cx25821-audio-upstream.h
index ca987ad..668a4f1 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.h
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.h
@@ -46,11 +46,11 @@
 #define USE_RISC_NOOP_AUDIO   1
 
 #ifdef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    ( LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 #ifndef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    ( LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 static int _line_size;
-- 
1.7.0.4

