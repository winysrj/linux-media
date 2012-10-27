Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab2J0UmM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:12 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgCAD006318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:12 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 27/68] [media] cx231xx: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:45 -0200
Message-Id: <1351370486-29040-28-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/cx231xx/cx231xx-avcore.c:1071:5: warning: no previous prototype for 'stopAudioFirmware' [-Wmissing-prototypes]
drivers/media/usb/cx231xx/cx231xx-avcore.c:1076:5: warning: no previous prototype for 'restartAudioFirmware' [-Wmissing-prototypes]
drivers/media/usb/cx231xx/cx231xx-cards.c:689:6: warning: no previous prototype for 'cx231xx_reset_out' [-Wmissing-prototypes]
drivers/media/usb/cx231xx/cx231xx-cards.c:697:6: warning: no previous prototype for 'cx231xx_enable_OSC' [-Wmissing-prototypes]
drivers/media/usb/cx231xx/cx231xx-cards.c:701:6: warning: no previous prototype for 'cx231xx_sleep_s5h1432' [-Wmissing-prototypes]
drivers/media/usb/cx231xx/cx231xx-i2c.c:75:5: warning: no previous prototype for 'cx231xx_i2c_send_bytes' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-cards.c  | 8 +++++---
 drivers/media/usb/cx231xx/cx231xx-i2c.c    | 4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 447148e..d34dbcf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1068,12 +1068,12 @@ int cx231xx_unmute_audio(struct cx231xx *dev)
 }
 EXPORT_SYMBOL_GPL(cx231xx_unmute_audio);
 
-int stopAudioFirmware(struct cx231xx *dev)
+static int stopAudioFirmware(struct cx231xx *dev)
 {
 	return vid_blk_write_byte(dev, DL_CTL_CONTROL, 0x03);
 }
 
-int restartAudioFirmware(struct cx231xx *dev)
+static int restartAudioFirmware(struct cx231xx *dev)
 {
 	return vid_blk_write_byte(dev, DL_CTL_CONTROL, 0x13);
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index b84ebc5..bbed1e4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -686,7 +686,7 @@ int cx231xx_tuner_callback(void *ptr, int component, int command, int arg)
 }
 EXPORT_SYMBOL_GPL(cx231xx_tuner_callback);
 
-void cx231xx_reset_out(struct cx231xx *dev)
+static void cx231xx_reset_out(struct cx231xx *dev)
 {
 	cx231xx_set_gpio_value(dev, CX23417_RESET, 1);
 	msleep(200);
@@ -694,11 +694,13 @@ void cx231xx_reset_out(struct cx231xx *dev)
 	msleep(200);
 	cx231xx_set_gpio_value(dev, CX23417_RESET, 1);
 }
-void cx231xx_enable_OSC(struct cx231xx *dev)
+
+static void cx231xx_enable_OSC(struct cx231xx *dev)
 {
 	cx231xx_set_gpio_value(dev, CX23417_OSC_EN, 1);
 }
-void cx231xx_sleep_s5h1432(struct cx231xx *dev)
+
+static void cx231xx_sleep_s5h1432(struct cx231xx *dev)
 {
 	cx231xx_set_gpio_value(dev, SLEEP_S5H1432, 0);
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 781feed..96a5a09 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -72,8 +72,8 @@ static inline bool is_tuner(struct cx231xx *dev, struct cx231xx_i2c *bus,
 /*
  * cx231xx_i2c_send_bytes()
  */
-int cx231xx_i2c_send_bytes(struct i2c_adapter *i2c_adap,
-			   const struct i2c_msg *msg)
+static int cx231xx_i2c_send_bytes(struct i2c_adapter *i2c_adap,
+				  const struct i2c_msg *msg)
 {
 	struct cx231xx_i2c *bus = i2c_adap->algo_data;
 	struct cx231xx *dev = bus->dev;
-- 
1.7.11.7

