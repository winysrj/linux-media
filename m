Return-path: <linux-media-owner@vger.kernel.org>
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754970Ab0AERDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:20 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/media/video/tveeprom.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:47:36 -0700
Cc: linux-media@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050947.36961.hartleys@visionengravers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

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
