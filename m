Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33594 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HSJs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 05:48:58 -0400
Date: Thu, 19 Aug 2010 11:47:50 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: opera1: remove unneeded NULL check
Message-ID: <20100819094750.GM645@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

"fw" is always a non-NULL pointer at this point, and anyway
release_firmware() accepts NULL pointers.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 6b22ec6..f896337 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -483,9 +483,7 @@ static int opera1_xilinx_load_firmware(struct usb_device *dev,
 		}
 	}
 	kfree(p);
-	if (fw) {
-		release_firmware(fw);
-	}
+	release_firmware(fw);
 	return ret;
 }
 
