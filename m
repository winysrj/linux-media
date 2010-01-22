Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:45363 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab0AVPK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 10:10:59 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: crope@iki.fi
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 4/4] media: dvb/af9015, add hashes support
Date: Fri, 22 Jan 2010 16:10:55 +0100
Message-Id: <1264173055-14787-4-git-send-email-jslaby@suse.cz>
In-Reply-To: <4B4F6BE5.2040102@iki.fi>
References: <4B4F6BE5.2040102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So as a final patch, add support for hash and one hash entry
for MSI digi vox mini II:
iManufacturer 1 Afatech
iProduct      2 DVB-T 2
iSerial       3 010101010600001

It is now handled with proper IR and key map tables.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb/dvb-usb/af9015.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 796f9d5..650c913 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -788,6 +788,13 @@ static const struct af9015_setup af9015_setup_usbids[] = {
 	{ }
 };
 
+static const struct af9015_setup af9015_setup_hashes[] = {
+	{ 0xb8feb708,
+		af9015_rc_keys_msi, ARRAY_SIZE(af9015_rc_keys_msi),
+		af9015_ir_table_msi, ARRAY_SIZE(af9015_ir_table_msi) },
+	{ }
+};
+
 static void af9015_set_remote_config(struct usb_device *udev,
 		struct dvb_usb_device_properties *props)
 {
@@ -800,7 +807,10 @@ static void af9015_set_remote_config(struct usb_device *udev,
 	} else {
 		u16 vendor = le16_to_cpu(udev->descriptor.idVendor);
 
-		if (vendor == USB_VID_AFATECH) {
+		table = af9015_setup_match(af9015_config.eeprom_sum,
+				af9015_setup_hashes);
+
+		if (!table && vendor == USB_VID_AFATECH) {
 			/* Check USB manufacturer and product strings and try
 			   to determine correct remote in case of chip vendor
 			   reference IDs are used.
@@ -831,7 +841,7 @@ static void af9015_set_remote_config(struct usb_device *udev,
 					ARRAY_SIZE(af9015_ir_table_trekstor)
 				};
 			}
-		} else
+		} else if (!table)
 			table = af9015_setup_match(vendor, af9015_setup_usbids);
 	}
 
-- 
1.6.5.7

