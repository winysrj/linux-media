Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58409 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3CJCEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 07/41] af9035: [0ccd:0099] TerraTec Cinergy T Stick Dual RC (rev. 2)
Date: Sun, 10 Mar 2013 04:02:59 +0200
Message-Id: <1362881013-5271-7-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That same USB ID is used both AF9015 and AF9035 driver.
iManufacturer is only thing we can select correct driver without a I/O.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 42 ++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index cc05f59..1e1cee6 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1328,6 +1328,43 @@ err:
 	#define af9035_get_rc_config NULL
 #endif
 
+static int af9035_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	char manufacturer[sizeof("Afatech")];
+
+	memset(manufacturer, 0, sizeof(manufacturer));
+	usb_string(udev, udev->descriptor.iManufacturer,
+			manufacturer, sizeof(manufacturer));
+	/*
+	 * There is two devices having same ID but different chipset. One uses
+	 * AF9015 and the other IT9135 chipset. Only difference seen on lsusb
+	 * is iManufacturer string.
+	 *
+	 * idVendor           0x0ccd TerraTec Electronic GmbH
+	 * idProduct          0x0099
+	 * bcdDevice            2.00
+	 * iManufacturer           1 Afatech
+	 * iProduct                2 DVB-T 2
+	 *
+	 * idVendor           0x0ccd TerraTec Electronic GmbH
+	 * idProduct          0x0099
+	 * bcdDevice            2.00
+	 * iManufacturer           1 ITE Technologies, Inc.
+	 * iProduct                2 DVB-T TV Stick
+	 */
+	if ((le16_to_cpu(udev->descriptor.idVendor) == USB_VID_TERRATEC) &&
+			(le16_to_cpu(udev->descriptor.idProduct) == 0x0099)) {
+		if (!strcmp("Afatech", manufacturer)) {
+			dev_dbg(&udev->dev, "%s: rejecting device\n", __func__);
+			return -ENODEV;
+		}
+	}
+
+	return dvb_usbv2_probe(intf, id);
+}
+
 /* interface 0 is used by DVB-T receiver and
    interface 1 is for remote controller (HID) */
 static const struct dvb_usb_device_properties af9035_props = {
@@ -1384,6 +1421,9 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "AVerMedia Twinstar (A825)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
+	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
+		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
@@ -1391,7 +1431,7 @@ MODULE_DEVICE_TABLE(usb, af9035_id_table);
 static struct usb_driver af9035_usb_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = af9035_id_table,
-	.probe = dvb_usbv2_probe,
+	.probe = af9035_probe,
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
-- 
1.7.11.7

