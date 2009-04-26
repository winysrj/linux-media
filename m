Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:27639 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZDZIoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 04:44:06 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1Ly13U-0005z4-V1
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Sun, 26 Apr 2009 11:53:49 +0200
Date: Sun, 26 Apr 2009 10:43:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Link firmware to physical device
Message-ID: <20090426104359.47a75070@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the physical device rather than the i2c adapter as the reference
device when loading firmwares. This will prevent the sysfs name
collision with i2c-dev that has been reported many times.

I may have missed other drivers which need the same fix.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Note: this assumes that the i2c-adapter's parent has been set
properly. This should be the case but it's hard to garantee that this
is actually the case for all i2c-adapter drivers around. This thus
needs testing.

 linux/drivers/media/common/tuners/tuner-xc2028.c |    2 +-
 linux/drivers/media/common/tuners/xc5000.c       |    2 +-
 linux/drivers/media/dvb/frontends/af9013.c       |    2 +-
 linux/drivers/media/dvb/frontends/cx24116.c      |    2 +-
 linux/drivers/media/dvb/frontends/drx397xD.c     |    4 ++--
 linux/drivers/media/dvb/frontends/nxt200x.c      |    6 ++++--
 linux/drivers/media/dvb/frontends/or51132.c      |    2 +-
 linux/drivers/media/dvb/frontends/tda10048.c     |    2 +-
 8 files changed, 12 insertions(+), 10 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/common/tuners/tuner-xc2028.c	2009-03-01 16:09:08.000000000 +0100
+++ v4l-dvb/linux/drivers/media/common/tuners/tuner-xc2028.c	2009-04-26 09:46:12.000000000 +0200
@@ -276,7 +276,7 @@ static int load_all_firmwares(struct dvb
 		fname = firmware_name;
 
 	tuner_dbg("Reading firmware %s\n", fname);
-	rc = request_firmware(&fw, fname, &priv->i2c_props.adap->dev);
+	rc = request_firmware(&fw, fname, priv->i2c_props.adap->dev.parent);
 	if (rc < 0) {
 		if (rc == -ENOENT)
 			tuner_err("Error: firmware %s not found.\n",
--- v4l-dvb.orig/linux/drivers/media/common/tuners/xc5000.c	2009-03-27 15:01:39.000000000 +0100
+++ v4l-dvb/linux/drivers/media/common/tuners/xc5000.c	2009-04-26 09:51:16.000000000 +0200
@@ -594,7 +594,7 @@ static int xc5000_fwupload(struct dvb_fr
 		XC5000_DEFAULT_FIRMWARE);
 
 	ret = request_firmware(&fw, XC5000_DEFAULT_FIRMWARE,
-		&priv->i2c_props.adap->dev);
+		priv->i2c_props.adap->dev.parent);
 	if (ret) {
 		printk(KERN_ERR "xc5000: Upload failed. (file not found?)\n");
 		ret = XC_RESULT_RESET_FAILURE;
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/af9013.c	2009-03-01 16:09:08.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/frontends/af9013.c	2009-04-26 09:46:04.000000000 +0200
@@ -1456,7 +1456,7 @@ static int af9013_download_firmware(stru
 		af9013_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file,  &state->i2c->dev);
+	ret = request_firmware(&fw, fw_file, state->i2c->dev.parent);
 	if (ret) {
 		err("did not find the firmware file. (%s) "
 			"Please see linux/Documentation/dvb/ for more details" \
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/cx24116.c	2009-03-01 16:09:08.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/frontends/cx24116.c	2009-04-26 09:52:02.000000000 +0200
@@ -492,7 +492,7 @@ static int cx24116_firmware_ondemand(str
 		printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n",
 			__func__, CX24116_DEFAULT_FIRMWARE);
 		ret = request_firmware(&fw, CX24116_DEFAULT_FIRMWARE,
-			&state->i2c->dev);
+			state->i2c->dev.parent);
 		printk(KERN_INFO "%s: Waiting for firmware upload(2)...\n",
 			__func__);
 		if (ret) {
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/drx397xD.c	2009-04-17 11:22:56.000000000 +0200
+++ v4l-dvb/linux/drivers/media/dvb/frontends/drx397xD.c	2009-04-26 09:48:03.000000000 +0200
@@ -124,10 +124,10 @@ static int drx_load_fw(struct drx397xD_s
 	}
 	memset(&fw[ix].data[0], 0, sizeof(fw[0].data));
 
-	if (request_firmware(&fw[ix].file, fw[ix].name, &s->i2c->dev) != 0) {
+	rc = request_firmware(&fw[ix].file, fw[ix].name, s->i2c->dev.parent);
+	if (rc != 0) {
 		printk(KERN_ERR "%s: Firmware \"%s\" not available\n",
 		       mod_name, fw[ix].name);
-		rc = -ENOENT;
 		goto exit_err;
 	}
 
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/nxt200x.c	2009-03-01 16:09:08.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/frontends/nxt200x.c	2009-04-26 09:48:30.000000000 +0200
@@ -880,7 +880,8 @@ static int nxt2002_init(struct dvb_front
 
 	/* request the firmware, this will block until someone uploads it */
 	printk("nxt2002: Waiting for firmware upload (%s)...\n", NXT2002_DEFAULT_FIRMWARE);
-	ret = request_firmware(&fw, NXT2002_DEFAULT_FIRMWARE, &state->i2c->dev);
+	ret = request_firmware(&fw, NXT2002_DEFAULT_FIRMWARE,
+			       state->i2c->dev.parent);
 	printk("nxt2002: Waiting for firmware upload(2)...\n");
 	if (ret) {
 		printk("nxt2002: No firmware uploaded (timeout or file not found?)\n");
@@ -944,7 +945,8 @@ static int nxt2004_init(struct dvb_front
 
 	/* request the firmware, this will block until someone uploads it */
 	printk("nxt2004: Waiting for firmware upload (%s)...\n", NXT2004_DEFAULT_FIRMWARE);
-	ret = request_firmware(&fw, NXT2004_DEFAULT_FIRMWARE, &state->i2c->dev);
+	ret = request_firmware(&fw, NXT2004_DEFAULT_FIRMWARE,
+			       state->i2c->dev.parent);
 	printk("nxt2004: Waiting for firmware upload(2)...\n");
 	if (ret) {
 		printk("nxt2004: No firmware uploaded (timeout or file not found?)\n");
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/or51132.c	2009-03-01 16:09:08.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/frontends/or51132.c	2009-04-26 09:48:41.000000000 +0200
@@ -340,7 +340,7 @@ static int or51132_set_parameters(struct
 		}
 		printk("or51132: Waiting for firmware upload(%s)...\n",
 		       fwname);
-		ret = request_firmware(&fw, fwname, &state->i2c->dev);
+		ret = request_firmware(&fw, fwname, state->i2c->dev.parent);
 		if (ret) {
 			printk(KERN_WARNING "or51132: No firmware up"
 			       "loaded(timeout or file not found?)\n");
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/tda10048.c	2009-03-01 16:09:08.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/frontends/tda10048.c	2009-04-26 09:51:31.000000000 +0200
@@ -289,7 +289,7 @@ static int tda10048_firmware_upload(stru
 		TDA10048_DEFAULT_FIRMWARE);
 
 	ret = request_firmware(&fw, TDA10048_DEFAULT_FIRMWARE,
-		&state->i2c->dev);
+		state->i2c->dev.parent);
 	if (ret) {
 		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",
 			__func__);


-- 
Jean Delvare
