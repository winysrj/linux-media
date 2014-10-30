Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35019 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161068AbaJ3UNO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:13:14 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v4 09/14] cx231xx: let is_tuner check the real i2c port and not the i2c master number
Date: Thu, 30 Oct 2014 21:12:30 +0100
Message-Id: <1414699955-5760-10-git-send-email-zzam@gentoo.org>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get used i2c port from bus_nr and status of port_3 switch.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index af9180f..9ade3ac 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -54,10 +54,19 @@ do {							\
       } 						\
 } while (0)
 
+static inline int get_real_i2c_port(struct cx231xx *dev, int bus_nr)
+{
+	if (bus_nr == 1)
+		return dev->port_3_switch_enabled ? I2C_1_MUX_3 : I2C_1_MUX_1;
+	return bus_nr;
+}
+
 static inline bool is_tuner(struct cx231xx *dev, struct cx231xx_i2c *bus,
 			const struct i2c_msg *msg, int tuner_type)
 {
-	if (bus->nr != dev->board.tuner_i2c_master)
+	int i2c_port = get_real_i2c_port(dev, bus->nr);
+
+	if (i2c_port != dev->board.tuner_i2c_master)
 		return false;
 
 	if (msg->addr != dev->board.tuner_addr)
-- 
2.1.2

