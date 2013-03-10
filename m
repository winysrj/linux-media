Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58518 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3CJCEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 06/41] af9015: reject device TerraTec Cinergy T Stick Dual RC (rev. 2)
Date: Sun, 10 Mar 2013 04:02:58 +0200
Message-Id: <1362881013-5271-6-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That same USB ID is used both AF9015 and AF9035 driver.
iManufacturer is only thing we can select correct driver without a I/O.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 40 ++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index b86d0f2..2cf7ad2 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1317,6 +1317,43 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	#define af9015_get_rc_config NULL
 #endif
 
+static int af9015_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	char manufacturer[sizeof("ITE Technologies, Inc.")];
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
+		if (!strcmp("ITE Technologies, Inc.", manufacturer)) {
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
 static struct dvb_usb_device_properties af9015_props = {
@@ -1425,6 +1462,7 @@ static const struct usb_device_id af9015_id_table[] = {
 		&af9015_props, "AverMedia AVerTV Volar M (A815Mac)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_RC,
 		&af9015_props, "TerraTec Cinergy T Stick RC", RC_MAP_TERRATEC_SLIM_2) },
+	/* XXX: that same ID [0ccd:0099] is used by af9035 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC,
 		&af9015_props, "TerraTec Cinergy T Stick Dual RC", RC_MAP_TERRATEC_SLIM) },
 	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T,
@@ -1441,7 +1479,7 @@ MODULE_DEVICE_TABLE(usb, af9015_id_table);
 static struct usb_driver af9015_usb_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = af9015_id_table,
-	.probe = dvb_usbv2_probe,
+	.probe = af9015_probe,
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
-- 
1.7.11.7

