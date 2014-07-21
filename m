Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55249 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbaGUQ2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 12:28:23 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] xc4000: Update firmware name
Date: Mon, 21 Jul 2014 13:28:13 -0300
Message-Id: <1405960095-29408-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1405960095-29408-1-git-send-email-m.chehab@samsung.com>
References: <1405960095-29408-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The firmware name at:
   http://www.kernellabs.com/firmware/xc4000/

Is different from the one at the Kernel. Update it
try first the new name, falling back to the previous one
if the new name can't be found.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc4000.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 2018befabb5a..44df271a78f8 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -116,6 +116,7 @@ struct xc4000_priv {
 #define XC4000_AUDIO_STD_MONO		32
 
 #define XC4000_DEFAULT_FIRMWARE "dvb-fe-xc4000-1.4.fw"
+#define XC4000_DEFAULT_FIRMWARE_NEW "dvb-fe-xc4000-1.4.1.fw"
 
 /* Misc Defines */
 #define MAX_TV_STANDARD			24
@@ -730,13 +731,25 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 	char		      name[33];
 	const char	      *fname;
 
-	if (firmware_name[0] != '\0')
+	if (firmware_name[0] != '\0') {
 		fname = firmware_name;
-	else
-		fname = XC4000_DEFAULT_FIRMWARE;
 
-	dprintk(1, "Reading firmware %s\n", fname);
-	rc = request_firmware(&fw, fname, priv->i2c_props.adap->dev.parent);
+		dprintk(1, "Reading custom firmware %s\n", fname);
+		rc = request_firmware(&fw, fname,
+				      priv->i2c_props.adap->dev.parent);
+	} else {
+		fname = XC4000_DEFAULT_FIRMWARE_NEW;
+		dprintk(1, "Trying to read firmware %s\n", fname);
+		rc = request_firmware(&fw, fname,
+				      priv->i2c_props.adap->dev.parent);
+		if (rc == -ENOENT) {
+			fname = XC4000_DEFAULT_FIRMWARE;
+			dprintk(1, "Trying to read firmware %s\n", fname);
+			rc = request_firmware(&fw, fname,
+					      priv->i2c_props.adap->dev.parent);
+		}
+	}
+
 	if (rc < 0) {
 		if (rc == -ENOENT)
 			printk(KERN_ERR "Error: firmware %s not found.\n", fname);
@@ -746,6 +759,8 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 
 		return rc;
 	}
+	dprintk(1, "Loading Firmware: %s\n", fname);
+
 	p = fw->data;
 	endp = p + fw->size;
 
-- 
1.9.3

