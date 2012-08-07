Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2HGCsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:11 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:11 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 23/24] au0828: make xc5000 firmware speedup apply to the xc5000c as well
Date: Mon,  6 Aug 2012 22:47:13 -0400
Message-Id: <1344307634-11673-24-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the firmware speedup work for the 5000c as well as the original
xc5000.  This cuts firmware load time in half.

Thanks to John Casey at Hauppauge for loaning me a board for testing.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-i2c.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-i2c.c b/drivers/media/video/au0828/au0828-i2c.c
index 3bc76df..4ded17f 100644
--- a/drivers/media/video/au0828/au0828-i2c.c
+++ b/drivers/media/video/au0828/au0828-i2c.c
@@ -147,7 +147,8 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 	au0828_write(dev, AU0828_I2C_MULTIBYTE_MODE_2FF, 0x01);
 
 	/* Set the I2C clock */
-	if ((dev->board.tuner_type == TUNER_XC5000) &&
+	if (((dev->board.tuner_type == TUNER_XC5000) ||
+	     (dev->board.tuner_type == TUNER_XC5000C)) &&
 	    (dev->board.tuner_addr == msg->addr) &&
 	    (msg->len == 64)) {
 		/* Hack to speed up firmware load.  The xc5000 lets us do up
-- 
1.7.1

