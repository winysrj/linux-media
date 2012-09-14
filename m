Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:48003 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2INJ1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 05:27:44 -0400
From: =?UTF-8?q?R=C3=A9mi=20Cardona?= <remi.cardona@smartjog.com>
To: linux-media@vger.kernel.org
Cc: liplianin@me.by
Subject: [PATCH 6/6] [media] ds3000: add module parameter to force firmware upload
Date: Fri, 14 Sep 2012 11:27:26 +0200
Message-Id: <1347614846-19046-7-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
---
 drivers/media/dvb/frontends/ds3000.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 970963c..3e0e9de 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -30,6 +30,7 @@
 #include "ds3000.h"
 
 static int debug;
+static int force_fw_upload;
 
 #define dprintk(args...) \
 	do { \
@@ -396,10 +397,13 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
 	dprintk("%s()\n", __func__);
 
 	ret = ds3000_readreg(state, 0xb2);
-	if (ret == 0) {
+	if (ret == 0 && force_fw_upload == 0) {
 		printk(KERN_INFO "%s: Firmware already uploaded, skipping\n",
 			__func__);
 		return ret;
+	} else if (ret == 0 && force_fw_upload) {
+		printk(KERN_INFO "%s: Firmware already uploaded, "
+			"forcing upload\n", __func__);
 	} else if (ret < 0) {
 		return ret;
 	}
@@ -1308,6 +1312,9 @@ static struct dvb_frontend_ops ds3000_ops = {
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
 
+module_param(force_fw_upload, int, 0644);
+MODULE_PARM_DESC(force_fw_upload, "Force firmware upload (default:0)");
+
 MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
 			"DS3000/TS2020 hardware");
 MODULE_AUTHOR("Konstantin Dimitrov");
-- 
1.7.10.4

