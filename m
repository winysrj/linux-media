Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43634 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0JTJeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 05:34:31 -0400
Received: by bwz10 with SMTP id 10so1122571bwz.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 02:34:30 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 1/6] Staging: tm6000: fix macros  coding style issue and initialise statics to 0 in tm6000-core.c
Date: Wed, 20 Oct 2010 12:34:18 +0300
Message-Id: <1287567258-18601-1-git-send-email-ruslan@rpisarev.org.ua>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the tm6000-core.c file that fixed up a macros error
and error initialise statics to 0 found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/tm6000/tm6000-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index cded411..9c0bf84 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -30,14 +30,14 @@
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
-#define USB_TIMEOUT	5*HZ /* ms */
+#define USB_TIMEOUT	(5*HZ) /* ms */
 
 int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 			  u16 value, u16 index, u8 *buf, u16 len)
 {
 	int          ret, i;
 	unsigned int pipe;
-	static int   ini = 0, last = 0, n = 0;
+	static int   ini, last, n;
 	u8	     *data = NULL;
 
 	if (len)
-- 
1.7.0.4

