Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44888 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754044AbeCWL5e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 27/30] media: em28xx-input: improve error handling code
Date: Fri, 23 Mar 2018 07:57:13 -0400
Message-Id: <728d9fd9f148f03ec0bfa4891a44210a032d9663.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current I2C error handling logic makes static analyzers
confused:

	drivers/media/usb/em28xx/em28xx-input.c:96 em28xx_get_key_terratec() error: uninitialized symbol 'b'.

Change it to match the coding style we're using elsewhere.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index eb2ec0384b69..2dc1be00b8b8 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -82,11 +82,16 @@ struct em28xx_IR {
 static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
 				   enum rc_proto *protocol, u32 *scancode)
 {
+	int rc;
 	unsigned char b;
 
 	/* poll IR chip */
-	if (i2c_master_recv(i2c_dev, &b, 1) != 1)
+	rc = i2c_master_recv(i2c_dev, &b, 1);
+	if (rc != 1) {
+		if (rc < 0)
+			return rc;
 		return -EIO;
+	}
 
 	/*
 	 * it seems that 0xFE indicates that a button is still hold
-- 
2.14.3
