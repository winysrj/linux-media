Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32981 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbbHLPKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 11:10:11 -0400
From: Aparna Karuthodi <kdasaparna@gmail.com>
To: kdasaparna@gmail.com
Cc: jarod@wilsonet.com, mchehab@osg.samsung.com,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: media:lirc: Added a newline character after declaration
Date: Wed, 12 Aug 2015 20:41:42 +0530
Message-Id: <1439392302-3579-1-git-send-email-kdasaparna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added a newline character to remove a coding style warning detected
by checkpatch.

The warning is given below:
drivers/staging/media/lirc/lirc_serial.c:1169: WARNING: quoted string split
across lines

Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
---
 drivers/staging/media/lirc/lirc_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 19628d0..628577f 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1165,7 +1165,7 @@ module_init(lirc_serial_init_module);
 module_exit(lirc_serial_exit_module);
 
 MODULE_DESCRIPTION("Infra-red receiver driver for serial ports.");
-MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, "
+MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff,\n"
 	      "Christoph Bartelmus, Andrei Tanas");
 MODULE_LICENSE("GPL");
 
-- 
1.7.9.5

