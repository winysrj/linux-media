Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1BMRcP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 12:32:15 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1DHWFp0023846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:32:15 -0500
Received: from pedra (vpn-239-52.phx2.redhat.com [10.3.239.52])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1DHT5kO015438
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:32:14 -0500
Date: Sun, 13 Feb 2011 15:28:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/5] [media] cx231xx: Use a generic check for TUNER_XC5000
Message-ID: <20110213152854.22573ce8@pedra>
In-Reply-To: <cover.1297617986.git.mchehab@redhat.com>
References: <cover.1297617986.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The check for xc5000 assumes that the tuner will always
be using the same bus and will have the same address.
As those are configurable via dev->board, it should use,
instead, the values defined there.

Also, a similar type of test will be needed by other
tuners (for example, for TUNER_XC2028)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-i2c.c b/drivers/media/video/cx231xx/cx231xx-i2c.c
index 8356706..925f3a0 100644
--- a/drivers/media/video/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/video/cx231xx/cx231xx-i2c.c
@@ -54,6 +54,21 @@ do {							\
       } 						\
 } while (0)
 
+static inline bool is_tuner(struct cx231xx *dev, struct cx231xx_i2c *bus,
+			const struct i2c_msg *msg, int tuner_type)
+{
+	if (bus->nr != dev->board.tuner_i2c_master)
+		return false;
+
+	if (msg->addr != dev->board.tuner_addr)
+		return false;
+
+	if (dev->tuner_type != tuner_type)
+		return false;
+
+	return true;
+}
+
 /*
  * cx231xx_i2c_send_bytes()
  */
@@ -71,9 +86,7 @@ int cx231xx_i2c_send_bytes(struct i2c_adapter *i2c_adap,
 	u16 saddr = 0;
 	u8 need_gpio = 0;
 
-	if ((bus->nr == 1) && (msg->addr == 0x61)
-	    && (dev->tuner_type == TUNER_XC5000)) {
-
+	if (is_tuner(dev, bus, msg, TUNER_XC5000)) {
 		size = msg->len;
 
 		if (size == 2) {	/* register write sub addr */
@@ -180,9 +193,7 @@ static int cx231xx_i2c_recv_bytes(struct i2c_adapter *i2c_adap,
 	u16 saddr = 0;
 	u8 need_gpio = 0;
 
-	if ((bus->nr == 1) && (msg->addr == 0x61)
-	    && dev->tuner_type == TUNER_XC5000) {
-
+	if (is_tuner(dev, bus, msg, TUNER_XC5000)) {
 		if (msg->len == 2)
 			saddr = msg->buf[0] << 8 | msg->buf[1];
 		else if (msg->len == 1)
@@ -274,9 +285,7 @@ static int cx231xx_i2c_recv_bytes_with_saddr(struct i2c_adapter *i2c_adap,
 	else if (msg1->len == 1)
 		saddr = msg1->buf[0];
 
-	if ((bus->nr == 1) && (msg2->addr == 0x61)
-	    && dev->tuner_type == TUNER_XC5000) {
-
+	if (is_tuner(dev, bus, msg2, TUNER_XC5000)) {
 		if ((msg2->len < 16)) {
 
 			dprintk1(1,
@@ -454,8 +463,8 @@ static char *i2c_devs[128] = {
 	[0x32 >> 1] = "GeminiIII",
 	[0x02 >> 1] = "Aquarius",
 	[0xa0 >> 1] = "eeprom",
-	[0xc0 >> 1] = "tuner/XC3028",
-	[0xc2 >> 1] = "tuner/XC5000",
+	[0xc0 >> 1] = "tuner",
+	[0xc2 >> 1] = "tuner",
 };
 
 /*
-- 
1.7.1


