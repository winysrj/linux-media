Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:45345 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab0AVPLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 10:11:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: crope@iki.fi
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/4] media: dvb/af9015, implement eeprom hashing
Date: Fri, 22 Jan 2010 16:10:52 +0100
Message-Id: <1264173055-14787-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <4B4F6BE5.2040102@iki.fi>
References: <4B4F6BE5.2040102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will be useful for matching of IR tables later.

We read the eeprom anyway for dumping. Switch the dumping to
print_hex_dump_bytes and compute hash above that by
hash = 0;
for (u32 VAL) in (eeprom):
  hash *= GOLDEN_RATIO_PRIME_32
  hash += VAL; // while preserving endinaness

The computation is moved earlier to the flow, namely from
af9015_af9013_frontend_attach to af9015_read_config, so that
we can access the sum in af9015_read_config already.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/af9015.c |   65 +++++++++++++++++++++++------------
 drivers/media/dvb/dvb-usb/af9015.h |    1 +
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index a365c05..616b3ba 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -21,6 +21,8 @@
  *
  */
 
+#include <linux/hash.h>
+
 #include "af9015.h"
 #include "af9013.h"
 #include "mt2060.h"
@@ -553,26 +555,45 @@ exit:
 	return ret;
 }
 
-/* dump eeprom */
-static int af9015_eeprom_dump(struct dvb_usb_device *d)
+/* hash (and dump) eeprom */
+static int af9015_eeprom_hash(struct usb_device *udev)
 {
-	u8 reg, val;
+	static const unsigned int eeprom_size = 256;
+	unsigned int reg;
+	int ret;
+	u8 val, *eeprom;
+	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, &val};
 
-	for (reg = 0; ; reg++) {
-		if (reg % 16 == 0) {
-			if (reg)
-				deb_info(KERN_CONT "\n");
-			deb_info(KERN_DEBUG "%02x:", reg);
-		}
-		if (af9015_read_reg_i2c(d, AF9015_I2C_EEPROM, reg, &val) == 0)
-			deb_info(KERN_CONT " %02x", val);
-		else
-			deb_info(KERN_CONT " --");
-		if (reg == 0xff)
-			break;
+	eeprom = kmalloc(eeprom_size, GFP_KERNEL);
+	if (eeprom == NULL)
+		return -ENOMEM;
+
+	for (reg = 0; reg < eeprom_size; reg++) {
+		req.addr = reg;
+		ret = af9015_rw_udev(udev, &req);
+		if (ret)
+			goto free;
+		eeprom[reg] = val;
 	}
-	deb_info(KERN_CONT "\n");
-	return 0;
+
+	if (dvb_usb_af9015_debug & 0x01)
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, eeprom,
+				eeprom_size);
+
+	BUG_ON(eeprom_size % 4);
+
+	af9015_config.eeprom_sum = 0;
+	for (reg = 0; reg < eeprom_size / sizeof(u32); reg++) {
+		af9015_config.eeprom_sum *= GOLDEN_RATIO_PRIME_32;
+		af9015_config.eeprom_sum += le32_to_cpu(((u32 *)eeprom)[reg]);
+	}
+
+	deb_info("%s: eeprom sum=%.8x\n", __func__, af9015_config.eeprom_sum);
+
+	ret = 0;
+free:
+	kfree(eeprom);
+	return ret;
 }
 
 static int af9015_download_ir_table(struct dvb_usb_device *d)
@@ -728,6 +749,11 @@ static int af9015_read_config(struct usb_device *udev)
 	}
 	if (ret)
 		goto error;
+
+	ret = af9015_eeprom_hash(udev);
+	if (ret)
+		goto error;
+
 	deb_info("%s: IR mode:%d\n", __func__, val);
 	for (i = 0; i < af9015_properties_count; i++) {
 		if (val == AF9015_IR_MODE_DISABLED) {
@@ -1125,11 +1151,6 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 
 		deb_info("%s: init I2C\n", __func__);
 		ret = af9015_i2c_init(adap->dev);
-
-		/* dump eeprom (debug) */
-		ret = af9015_eeprom_dump(adap->dev);
-		if (ret)
-			return ret;
 	} else {
 		/* select I2C adapter */
 		i2c_adap = &state->i2c_adap;
diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
index 931c851..ef36b18 100644
--- a/drivers/media/dvb/dvb-usb/af9015.h
+++ b/drivers/media/dvb/dvb-usb/af9015.h
@@ -107,6 +107,7 @@ struct af9015_config {
 	u16 mt2060_if1[2];
 	u16 firmware_size;
 	u16 firmware_checksum;
+	u32 eeprom_sum;
 	u8  *ir_table;
 	u16 ir_table_size;
 };
-- 
1.6.5.7

