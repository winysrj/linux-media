Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43634 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0JTJet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 05:34:49 -0400
Received: by mail-bw0-f46.google.com with SMTP id 10so1122571bwz.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 02:34:49 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 2/6] Staging: tm6000: fix "ERROR: do not initialise statics to 0 or NULL" in tm6000-i2c.c
Date: Wed, 20 Oct 2010 12:34:40 +0300
Message-Id: <1287567280-18700-1-git-send-email-ruslan@rpisarev.org.ua>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the tm6000-i2c.c file that fixed "ERROR: do not
initialise statics to 0 or NULL" found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/tm6000/tm6000-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 79bc67f..a08d6a3 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -36,7 +36,7 @@
 #define I2C_HW_B_TM6000 I2C_HW_B_EM28XX
 /* ----------------------------------------------------------- */
 
-static unsigned int i2c_debug = 0;
+static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
-- 
1.7.0.4

