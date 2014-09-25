Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39869 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaIYLkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 07:40:00 -0400
Date: Thu, 25 Sep 2014 14:39:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] em28xx-input: NULL dereference on error
Message-ID: <20140925113941.GB3708@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We call "kfree(ir->i2c_client);" in the error handling and that doesn't
work if "ir" is NULL.

Fixes: 78e719a5f30b ('[media] em28xx-input: i2c IR decoders: improve i2c_client handling')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 581f6da..23f8f6a 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -712,8 +712,10 @@ static int em28xx_ir_init(struct em28xx *dev)
 	em28xx_info("Registering input extension\n");
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
 	rc = rc_allocate_device();
-	if (!ir || !rc)
+	if (!rc)
 		goto error;
 
 	/* record handles to ourself */
