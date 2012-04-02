Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2DBV0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:26:46 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj6so3023786wib.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:26:46 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 5/5] af9035: use module_usb_driver macro
Date: Mon,  2 Apr 2012 23:25:17 +0200
Message-Id: <1333401917-27203-6-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's save a few lines of code using the module_usb_driver macro.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9035.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index 8bf6367..3242312 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -973,31 +973,7 @@ static struct usb_driver af9035_usb_driver = {
 	.id_table = af9035_id,
 };
 
-/* module stuff */
-static int __init af9035_usb_module_init(void)
-{
-	int ret;
-
-	ret = usb_register(&af9035_usb_driver);
-	if (ret < 0)
-		goto err;
-
-	return 0;
-
-err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
-
-	return ret;
-}
-
-static void __exit af9035_usb_module_exit(void)
-{
-	/* deregister this driver from the USB subsystem */
-	usb_deregister(&af9035_usb_driver);
-}
-
-module_init(af9035_usb_module_init);
-module_exit(af9035_usb_module_exit);
+module_usb_driver(af9035_usb_driver);
 
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Afatech AF9035 driver");
-- 
1.7.5.4

