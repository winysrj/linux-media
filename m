Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 8/8] xc5000: delay tuner sleep to 5 seconds
Date: Wed, 21 May 2014 15:20:02 -0300
Message-Id: <1400696402-1805-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some drivers, like au0828 are very sensitive to tuner sleep and may
break if the sleep happens too fast. Also, by keeping the tuner alive
for a while could speedup tuning process during channel scan. So,
change the logic to delay the actual sleep to 5 seconds after its
command.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 8df92619883f..2b3d514be672 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -25,6 +25,7 @@
 #include <linux/moduleparam.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
+#include <linux/workqueue.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
@@ -65,12 +66,18 @@ struct xc5000_priv {
 	u16 pll_register_no;
 	u8 init_status_supported;
 	u8 fw_checksum_supported;
+
+	struct dvb_frontend *fe;
+	struct delayed_work timer_sleep;
 };
 
 /* Misc Defines */
 #define MAX_TV_STANDARD			24
 #define XC_MAX_I2C_WRITE_LENGTH		64
 
+/* Time to suspend after the .sleep callback is called */
+#define XC5000_SLEEP_TIME		5000 /* ms */
+
 /* Signal Types */
 #define XC_RF_MODE_AIR			0
 #define XC_RF_MODE_CABLE		1
@@ -1096,6 +1103,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
 	u16 pll_lock_status;
 	u16 fw_ck;
 
+	cancel_delayed_work(&priv->timer_sleep);
+
 	if (force || xc5000_is_firmware_loaded(fe) != 0) {
 
 fw_retry:
@@ -1164,27 +1173,39 @@ fw_retry:
 	return ret;
 }
 
-static int xc5000_sleep(struct dvb_frontend *fe)
+static void xc5000_do_timer_sleep(struct work_struct *timer_sleep)
 {
+	struct xc5000_priv *priv =container_of(timer_sleep, struct xc5000_priv,
+					       timer_sleep.work);
+	struct dvb_frontend *fe = priv->fe;
 	int ret;
 
 	dprintk(1, "%s()\n", __func__);
 
-	/* Avoid firmware reload on slow devices */
-	if (no_poweroff)
-		return 0;
-
 	/* According to Xceive technical support, the "powerdown" register
 	   was removed in newer versions of the firmware.  The "supported"
 	   way to sleep the tuner is to pull the reset pin low for 10ms */
 	ret = xc5000_tuner_reset(fe);
-	if (ret != 0) {
+	if (ret != 0)
 		printk(KERN_ERR
 			"xc5000: %s() unable to shutdown tuner\n",
 			__func__);
-		return -EREMOTEIO;
-	} else
+}
+
+static int xc5000_sleep(struct dvb_frontend *fe)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+
+	dprintk(1, "%s()\n", __func__);
+
+	/* Avoid firmware reload on slow devices */
+	if (no_poweroff)
 		return 0;
+
+	schedule_delayed_work(&priv->timer_sleep,
+			      msecs_to_jiffies(XC5000_SLEEP_TIME));
+
+	return 0;
 }
 
 static int xc5000_init(struct dvb_frontend *fe)
@@ -1211,8 +1232,10 @@ static int xc5000_release(struct dvb_frontend *fe)
 
 	mutex_lock(&xc5000_list_mutex);
 
-	if (priv)
+	if (priv) {
+		cancel_delayed_work(&priv->timer_sleep);
 		hybrid_tuner_release_state(priv);
+	}
 
 	mutex_unlock(&xc5000_list_mutex);
 
@@ -1284,6 +1307,8 @@ struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 		/* new tuner instance */
 		priv->bandwidth = 6000000;
 		fe->tuner_priv = priv;
+		priv->fe = fe;
+		INIT_DELAYED_WORK(&priv->timer_sleep, xc5000_do_timer_sleep);
 		break;
 	default:
 		/* existing tuner instance */
-- 
1.9.0

