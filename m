Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbD2XGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:25 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/27] go7007: Comment some dead code
Date: Wed, 29 Apr 2015 20:05:57 -0300
Message-Id: <ff7c0b61ee73f4995b838c5437ead3658e22366b.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/go7007/go7007-usb.c:1099 go7007_usb_probe() info: ignoring unreachable code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 3f986e1178ce..4857c467e76c 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -338,6 +338,7 @@ static const struct go7007_usb_board board_matrix_revolution = {
 	},
 };
 
+#if 0
 static const struct go7007_usb_board board_lifeview_lr192 = {
 	.flags		= GO7007_USB_EZUSB,
 	.main_info	= {
@@ -364,6 +365,7 @@ static const struct go7007_usb_board board_lifeview_lr192 = {
 		},
 	},
 };
+#endif
 
 static const struct go7007_usb_board board_endura = {
 	.flags		= 0,
@@ -1096,8 +1098,10 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	case GO7007_BOARDID_LIFEVIEW_LR192:
 		dev_err(&intf->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
 		return -ENODEV;
+#if 0
 		name = "Lifeview TV Walker Ultra";
 		board = &board_lifeview_lr192;
+#endif
 		break;
 	case GO7007_BOARDID_SENSORAY_2250:
 		dev_info(&intf->dev, "Sensoray 2250 found\n");
-- 
2.1.0

