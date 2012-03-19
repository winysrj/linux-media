Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47921 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030512Ab2CSU2H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 16:28:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH FOR 3.4] rtl28xxu: dynamic USB ID support
Date: Mon, 19 Mar 2012 22:27:47 +0200
Message-Id: <1332188867-26543-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB USB core refuses to	load driver when current USB ID
does not match IDs on driver table. Due to that dynamic
IDs does not work. Replace reference design ID by dynamic
ID in .probe() in order to get it working.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/rtl28xxu.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 8f4736a..4e69e9d 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -909,6 +909,8 @@ static int rtl28xxu_probe(struct usb_interface *intf,
 	int ret, i;
 	int properties_count = ARRAY_SIZE(rtl28xxu_properties);
 	struct dvb_usb_device *d;
+	struct usb_device *udev;
+	bool found;
 
 	deb_info("%s: interface=%d\n", __func__,
 		intf->cur_altsetting->desc.bInterfaceNumber);
@@ -916,6 +918,29 @@ static int rtl28xxu_probe(struct usb_interface *intf,
 	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
 		return 0;
 
+	/* Dynamic USB ID support. Replaces first device ID with current one .*/
+	udev = interface_to_usbdev(intf);
+
+	for (i = 0, found = false; i < ARRAY_SIZE(rtl28xxu_table) - 1; i++) {
+		if (rtl28xxu_table[i].idVendor ==
+				le16_to_cpu(udev->descriptor.idVendor) &&
+				rtl28xxu_table[i].idProduct ==
+				le16_to_cpu(udev->descriptor.idProduct)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		deb_info("%s: using dynamic ID %04x:%04x\n", __func__,
+				le16_to_cpu(udev->descriptor.idVendor),
+				le16_to_cpu(udev->descriptor.idProduct));
+		rtl28xxu_properties[0].devices[0].warm_ids[0]->idVendor =
+				le16_to_cpu(udev->descriptor.idVendor);
+		rtl28xxu_properties[0].devices[0].warm_ids[0]->idProduct =
+				le16_to_cpu(udev->descriptor.idProduct);
+	}
+
 	for (i = 0; i < properties_count; i++) {
 		ret = dvb_usb_device_init(intf, &rtl28xxu_properties[i],
 				THIS_MODULE, &d, adapter_nr);
-- 
1.7.7.6

