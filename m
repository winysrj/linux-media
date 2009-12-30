Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:54647 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751468AbZL3TQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 14:16:06 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/media/video/tveeprom.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:13:10 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F650@mi8nycmail19.Mi8.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/media/video/tveeprom.c b/drivers/media/video/tveeprom.c
index d533ea5..0a87749 100644
--- a/drivers/media/video/tveeprom.c
+++ b/drivers/media/video/tveeprom.c
@@ -680,10 +680,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 	tveeprom_info("Hauppauge model %d, rev %s, serial# %d\n",
 		tvee->model, tvee->rev_str, tvee->serial_number);
 	if (tvee->has_MAC_address == 1)
-		tveeprom_info("MAC address is %02X-%02X-%02X-%02X-%02X-%02X\n",
-			tvee->MAC_address[0], tvee->MAC_address[1],
-			tvee->MAC_address[2], tvee->MAC_address[3],
-			tvee->MAC_address[4], tvee->MAC_address[5]);
+		tveeprom_info("MAC address is %pM\n", tvee->MAC_address);
 	tveeprom_info("tuner model is %s (idx %d, type %d)\n",
 		t_name1, tuner1, tvee->tuner_type);
 	tveeprom_info("TV standards%s%s%s%s%s%s%s%s (eeprom 0x%02x)\n", 
