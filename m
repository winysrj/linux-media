Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH v2 04/18] [media] au0828: remove CONFIG_VIDEO_AU0828_RC scope around au0828_rc_*()
Date: Sat,  9 Aug 2014 21:47:10 -0300
Message-Id: <1407631644-11990-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shuah Khan <shuah.kh@samsung.com>

Remove CONFIG_VIDEO_AU0828_RC scope around au0828_rc_register()
and au0828_rc_unregister() calls in au0828-core

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 56025e689442..b08b979bb9a7 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -153,9 +153,7 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 
 	dprintk(1, "%s()\n", __func__);
 
-#ifdef CONFIG_VIDEO_AU0828_RC
 	au0828_rc_unregister(dev);
-#endif
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
 
@@ -266,10 +264,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 		pr_err("%s() au0282_dev_register failed\n",
 		       __func__);
 
-#ifdef CONFIG_VIDEO_AU0828_RC
 	/* Remote controller */
 	au0828_rc_register(dev);
-#endif
 
 	/*
 	 * Store the pointer to the au0828_dev so it can be accessed in
-- 
1.9.3

