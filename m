Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58953 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab2CFNsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 08:48:20 -0500
Received: by mail-ee0-f46.google.com with SMTP id c41so1888705eek.19
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2012 05:48:19 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: dheitmueller@kernellabs.com, snjw23@gmail.com,
	Gianluca Gennari <gennarone@gmail.com>,
	Ryley Angus <rangus@student.unimelb.edu.au>
Subject: [PATCH 2/2] as102: set optimal eLNA config values for each device
Date: Tue,  6 Mar 2012 14:47:46 +0100
Message-Id: <1331041666-22361-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331041666-22361-1-git-send-email-gennarone@gmail.com>
References: <1331041666-22361-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ryley and me tested several eLNA configuration values with both a rooftop
and a portable antenna.

Ryley fuond out that the best value for his Elgato stick is indeed the current
default value 0xC0.

Instead, my stick is not capable of tuning VHF channels with 0xC0. With 0x80,
VHF works but the tuner sensitivity with the portable antenna is poor.
Instead, the value 0xA0 works with VHF and also gives good performance with
both the rooftop and the portable antenna.

So we concluded that devices built on the reference design work best with 0xA0,
while custom designs (Elgato, PCTV) seem to require 0xC0.

I also removed the unused parameter "minor" in struct as102_dev_t.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
Signed-off-by: Ryley Angus <rangus@student.unimelb.edu.au>
---
 drivers/staging/media/as102/as102_drv.h     |    2 +-
 drivers/staging/media/as102/as102_fe.c      |    2 +-
 drivers/staging/media/as102/as102_usb_drv.c |   15 ++++++++++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index 957f0ed..b0e5a23 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -76,7 +76,7 @@ struct as102_dev_t {
 	struct as10x_bus_adapter_t bus_adap;
 	struct list_head device_entry;
 	struct kref kref;
-	unsigned long minor;
+	uint8_t elna_cfg;
 
 	struct dvb_adapter dvb_adap;
 	struct dvb_frontend dvb_fe;
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index bdc5a38..9f2c610 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -265,7 +265,7 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 
 	if (acquire) {
 		if (elna_enable)
-			as10x_cmd_set_context(&dev->bus_adap, 1010, 0xC0);
+			as10x_cmd_set_context(&dev->bus_adap, CONTEXT_LNA, dev->elna_cfg);
 
 		ret = as10x_cmd_turn_on(&dev->bus_adap);
 	} else {
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index d775be0..8b7357e 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -57,6 +57,17 @@ static const char * const as102_device_names[] = {
 	NULL /* Terminating entry */
 };
 
+/* eLNA configuration: devices built on the reference design work best
+   with 0xA0, while custom designs seem to require 0xC0 */
+static uint8_t const as102_elna_cfg[] = {
+	0xA0,
+	0xC0,
+	0xC0,
+	0xA0,
+	0xA0,
+	0x00 /* Terminating entry */
+};
+
 struct usb_driver as102_usb_driver = {
 	.name		= DRIVER_FULL_NAME,
 	.probe		= as102_usb_probe,
@@ -369,8 +380,10 @@ static int as102_usb_probe(struct usb_interface *intf,
 	/* Assign the user-friendly device name */
 	for (i = 0; i < (sizeof(as102_usb_id_table) /
 			 sizeof(struct usb_device_id)); i++) {
-		if (id == &as102_usb_id_table[i])
+		if (id == &as102_usb_id_table[i]) {
 			as102_dev->name = as102_device_names[i];
+			as102_dev->elna_cfg = as102_elna_cfg[i];
+		}
 	}
 
 	if (as102_dev->name == NULL)
-- 
1.7.0.4

