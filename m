Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2HERow (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 13:44:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] [media] az6007: handle CI during suspend/resume
Date: Sun,  5 Aug 2012 14:44:39 -0300
Message-Id: <1344188679-8247-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb-usb-v2 core doesn't know anything about CI. So, the
driver needs to handle it by hand. This patch stops CI just
before stopping URB's/RC, and restarts it before URB/RC start.

It should be noticed that suspend/resume is not yet working properly,
as the PM model requires the implementation of reset_resume:
	dvb_usb_az6007 1-6:1.0: no reset_resume for driver dvb_usb_az6007?
But this is not implemented there at dvb-usb-v2 yet.

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/az6007.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/az6007.c b/drivers/media/dvb/dvb-usb-v2/az6007.c
index 4a0ee64..420cb62 100644
--- a/drivers/media/dvb/dvb-usb-v2/az6007.c
+++ b/drivers/media/dvb/dvb-usb-v2/az6007.c
@@ -876,16 +876,37 @@ static struct usb_device_id az6007_usb_table[] = {
 
 MODULE_DEVICE_TABLE(usb, az6007_usb_table);
 
+static int az6007_suspend(struct usb_interface *intf, pm_message_t msg)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+
+	az6007_ci_uninit(d);
+	return dvb_usbv2_suspend(intf, msg);
+}
+
+static int az6007_resume(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	struct dvb_usb_adapter *adap = &d->adapter[0];
+
+	az6007_ci_init(adap);
+	return dvb_usbv2_resume(intf);
+}
+
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver az6007_usb_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= az6007_usb_table,
 	.probe		= dvb_usbv2_probe,
 	.disconnect	= az6007_usb_disconnect,
-	.suspend	= dvb_usbv2_suspend,
-	.resume		= dvb_usbv2_resume,
 	.no_dynamic_id	= 1,
 	.soft_unbind	= 1,
+	/*
+	 * FIXME: need to implement reset_resume, likely with
+	 * dvb-usb-v2 core support
+	 */
+	.suspend	= az6007_suspend,
+	.resume		= az6007_resume,
 };
 
 module_usb_driver(az6007_usb_driver);
-- 
1.7.11.2

