Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134AbaKANjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 09:39:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/7] [media] cx25840: Don't report an error if max size is adjusted
Date: Sat,  1 Nov 2014 11:38:56 -0200
Message-Id: <29596c3093b8ec2833cf4dc5413e2bfc04b3272a.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <cover.1414849031.git.mchehab@osg.samsung.com>
References: <cover.1414849031.git.mchehab@osg.samsung.com>
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

