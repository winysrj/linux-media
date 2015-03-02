Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbbCBRiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:38:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Satoshi Nagahama <sattnag@aim.com>
Subject: [PATCH] [media] siano: avoid a linkedit error if !MC
Date: Mon,  2 Mar 2015 14:38:43 -0300
Message-Id: <f704eab5b6beff878fc68dca800a4979ec97a15c.1425317919.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the media controller (MC) is not enabled, it will compile
fine, but will fail at the linkedition:

 ERROR: "media_device_unregister" [drivers/media/usb/siano/smsusb.ko] undefined!

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 0b13ad3d3a8c..c945e4c2fbd4 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -440,7 +440,9 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	if (rc < 0) {
 		pr_err("smscore_register_device(...) failed, rc %d\n", rc);
 		smsusb_term_device(intf);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
 		media_device_unregister(mdev);
+#endif
 		kfree(mdev);
 		return rc;
 	}
-- 
2.1.0

