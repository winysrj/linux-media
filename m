Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60003 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA0MAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 07:00:55 -0500
Received: by mail-pb0-f45.google.com with SMTP id un15so5795580pbc.4
        for <linux-media@vger.kernel.org>; Mon, 27 Jan 2014 04:00:55 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] radio-keene: Use module_usb_driver
Date: Mon, 27 Jan 2014 17:26:02 +0530
Message-Id: <1390823762-14296-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_usb_driver eliminates the boilerplate and makes the code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/radio/radio-keene.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index fa3964022b96..3d127825eceb 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -416,22 +416,5 @@ static struct usb_driver usb_keene_driver = {
 	.reset_resume		= usb_keene_resume,
 };
 
-static int __init keene_init(void)
-{
-	int retval = usb_register(&usb_keene_driver);
-
-	if (retval)
-		pr_err(KBUILD_MODNAME
-			": usb_register failed. Error number %d\n", retval);
-
-	return retval;
-}
-
-static void __exit keene_exit(void)
-{
-	usb_deregister(&usb_keene_driver);
-}
-
-module_init(keene_init);
-module_exit(keene_exit);
+module_usb_driver(usb_keene_driver);
 
-- 
1.7.9.5

