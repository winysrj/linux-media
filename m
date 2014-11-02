Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKBMcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:47 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 04/14] [media] cx25840: Don't report an error if max size is adjusted
Date: Sun,  2 Nov 2014 10:32:27 -0200
Message-Id: <551e6ce7ad0283aee6236db6a8f850f1b8ec9a1e.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason to report:
	cx25840 7-0044:  Firmware download size changed to 16 bytes max length

If the driver needs to adjust the buffer's maximum size.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/cx25840/cx25840-firmware.c b/drivers/media/i2c/cx25840/cx25840-firmware.c
index b3169f94ece8..6092bf71300f 100644
--- a/drivers/media/i2c/cx25840/cx25840-firmware.c
+++ b/drivers/media/i2c/cx25840/cx25840-firmware.c
@@ -122,10 +122,9 @@ int cx25840_loadfw(struct i2c_client *client)
 		gpio_da = cx25840_read(client, 0x164);
 	}
 
-	if (is_cx231xx(state) && MAX_BUF_SIZE > 16) {
-		v4l_err(client, " Firmware download size changed to 16 bytes max length\n");
-		MAX_BUF_SIZE = 16;  /* cx231xx cannot accept more than 16 bytes at a time */
-	}
+	/* cx231xx cannot accept more than 16 bytes at a time */
+	if (is_cx231xx(state) && MAX_BUF_SIZE > 16)
+		MAX_BUF_SIZE = 16;
 
 	if (request_firmware(&fw, fwname, FWDEV(client)) != 0) {
 		v4l_err(client, "unable to open firmware %s\n", fwname);
-- 
1.9.3

