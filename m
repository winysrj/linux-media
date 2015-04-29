Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbD2XGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/27] vp702x: comment dead code
Date: Wed, 29 Apr 2015 20:05:58 -0300
Message-Id: <afdfe60ae4bc6e3be641230f2e36d3cc600ee67e.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the first version of this driver, the remote controller
code is disabled, adding an early return inside vp702x_rc_query().

Let's disable the code with #if 0, to remove this warning:

drivers/media/usb/dvb-usb/vp702x.c:268 vp702x_rc_query() info: ignoring unreachable code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
index 22cf9f96cb9e..ee1e19e36445 100644
--- a/drivers/media/usb/dvb-usb/vp702x.c
+++ b/drivers/media/usb/dvb-usb/vp702x.c
@@ -259,11 +259,10 @@ static struct rc_map_table rc_map_vp702x_table[] = {
 /* remote control stuff (does not work with my box) */
 static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	u8 *key;
-	int i;
-
 /* remove the following return to enabled remote querying */
-	return 0;
+#if 0
+	u8 *key;
+	int i;
 
 	key = kmalloc(10, GFP_KERNEL);
 	if (!key)
@@ -286,6 +285,8 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			break;
 		}
 	kfree(key);
+#endif
+
 	return 0;
 }
 
-- 
2.1.0

