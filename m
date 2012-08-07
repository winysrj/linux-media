Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2HGCsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:03 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:02 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 16/24] au0828: tune retry interval for i2c interaction
Date: Mon,  6 Aug 2012 22:47:06 -0400
Message-Id: <1344307634-11673-17-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the retry timeout and number of retries to speed up xc5000 firmware
download.  With this change it goes from 4.2 seconds to 2.9.  The net time
waited is pretty much the same, but we just poll more often.

Tested at 250 KHz as well as 30 KHz.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-i2c.c b/drivers/media/video/au0828/au0828-i2c.c
index d454555..3bc76df 100644
--- a/drivers/media/video/au0828/au0828-i2c.c
+++ b/drivers/media/video/au0828/au0828-i2c.c
@@ -33,8 +33,8 @@ static int i2c_scan;
 module_param(i2c_scan, int, 0444);
 MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
-#define I2C_WAIT_DELAY 512
-#define I2C_WAIT_RETRY 64
+#define I2C_WAIT_DELAY 25
+#define I2C_WAIT_RETRY 1000
 
 static inline int i2c_slave_did_write_ack(struct i2c_adapter *i2c_adap)
 {
-- 
1.7.1

