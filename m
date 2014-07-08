Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:39484 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaGHKyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 06:54:11 -0400
Received: from [10.96.45.129] ([80.232.242.31])
	by fortimail.online.lv  with ESMTP id s68AcKpB017344-s68AcKpC017344
	for <linux-media@vger.kernel.org>; Tue, 8 Jul 2014 13:38:20 +0300
Message-ID: <53BBCA1C.90103@apollo.lv>
Date: Tue, 08 Jul 2014 13:38:20 +0300
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix typo in comments
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Expression ((7bit i2c_addr << 1) & 0x01) can not be right
because it is always 0

Signed-off-by: Raimonds Cicans <ray@apollo.lv>
---
  drivers/media/usb/dvb-usb/dibusb.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb.h b/drivers/media/usb/dvb-usb/dibusb.h
index e47c321..32ab139 100644
--- a/drivers/media/usb/dvb-usb/dibusb.h
+++ b/drivers/media/usb/dvb-usb/dibusb.h
@@ -36,7 +36,7 @@
  
  /*
   * i2c read
- * bulk write: 0x02 ((7bit i2c_addr << 1) & 0x01) register_bytes length_word
+ * bulk write: 0x02 ((7bit i2c_addr << 1) | 0x01) register_bytes length_word
   * bulk read:  byte_buffer (length_word bytes)
   */
  #define DIBUSB_REQ_I2C_READ			0x02
-- 
1.8.5.5

