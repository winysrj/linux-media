Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0JRWxP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 18:53:15 -0400
Date: Mon, 18 Oct 2010 20:52:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, jarod@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] mceusb: add support for cx231xx-based IR (e. g.
 Polaris)
Message-ID: <20101018205257.46cf3e8c@pedra>
In-Reply-To: <cover.1287442245.git.mchehab@redhat.com>
References: <cover.1287442245.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

For now, it adds support for Conexant EVK and for Pixelview.
We should probably find a better way to specify all Conexant
Polaris devices, to avoid needing to repeat this setup on
both mceusb and cx231xx-cards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index bc620e1..61ccb8f 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -104,6 +104,8 @@ static int debug;
 #define VENDOR_NORTHSTAR	0x04eb
 #define VENDOR_REALTEK		0x0bda
 #define VENDOR_TIVO		0x105a
+#define VENDOR_PIXELVIEW	0x1554
+#define VENDOR_CONEXANT		0x0572
 
 static struct usb_device_id mceusb_dev_table[] = {
 	/* Original Microsoft MCE IR Transceiver (often HP-branded) */
@@ -198,6 +200,10 @@ static struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe004) },
 	/* TiVo PC IR Receiver */
 	{ USB_DEVICE(VENDOR_TIVO, 0x2000) },
+	/* Pixelview SBTVD Hybrid */
+	{ USB_DEVICE_VER(VENDOR_PIXELVIEW, 0x5010, 0x4000, 0x4001) },
+	/* Conexant SDK */
+	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a1) },
 	/* Terminating entry */
 	{ }
 };
@@ -229,6 +235,12 @@ static struct usb_device_id std_tx_mask_list[] = {
 	{}
 };
 
+static struct usb_device_id cx_polaris_list[] = {
+	{ USB_DEVICE(VENDOR_PIXELVIEW, 0x5010) },
+	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a1) },
+	{}
+};
+
 /* data structure for each usb transceiver */
 struct mceusb_dev {
 	/* ir-core bits */
@@ -929,6 +941,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	bool is_gen3;
 	bool is_microsoft_gen1;
 	bool tx_mask_inverted;
+	bool is_polaris;
 
 	dev_dbg(&intf->dev, ": %s called\n", __func__);
 
@@ -937,6 +950,13 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	is_gen3 = usb_match_id(intf, gen3_list) ? 1 : 0;
 	is_microsoft_gen1 = usb_match_id(intf, microsoft_gen1_list) ? 1 : 0;
 	tx_mask_inverted = usb_match_id(intf, std_tx_mask_list) ? 0 : 1;
+	is_polaris = usb_match_id(intf, cx_polaris_list) ? 1 : 0;
+
+	if (is_polaris) {
+		/* Interface 0 is IR */
+		if (idesc->desc.bInterfaceNumber)
+			return -ENODEV;
+	}
 
 	/* step through the endpoints to find first bulk in and out endpoint */
 	for (i = 0; i < idesc->desc.bNumEndpoints; ++i) {
-- 
1.7.1


