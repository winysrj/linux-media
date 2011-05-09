Return-path: <mchehab@gaivota>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:44904 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102Ab1EITyK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:10 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 01/16] tm6000: add radio capabilities
Date: Mon,  9 May 2011 21:53:49 +0200
Message-Id: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

add radio capabilities


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    4 +++
 drivers/staging/tm6000/tm6000-video.c |   34 +++++++++++++++++---------------
 drivers/staging/tm6000/tm6000.h       |    1 +
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 6e51486..31ccd2f 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -254,6 +254,7 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353    = 1,
 			.has_eeprom     = 1,
 			.has_remote     = 1,
+			.has_radio	= 1.
 			.has_input_comp = 1,
 			.has_input_svid = 1,
 		},
@@ -276,6 +277,7 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353    = 0,
 			.has_eeprom     = 1,
 			.has_remote     = 1,
+			.has_radio	= 1,
 			.has_input_comp = 1,
 			.has_input_svid = 1,
 		},
@@ -350,6 +352,7 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353    = 1,
 			.has_eeprom     = 1,
 			.has_remote     = 0,
+			.has_radio	= 1,
 			.has_input_comp = 0,
 			.has_input_svid = 0,
 		},
@@ -372,6 +375,7 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353    = 0,
 			.has_eeprom     = 1,
 			.has_remote     = 0,
+			.has_radio	= 1,
 			.has_input_comp = 0,
 			.has_input_svid = 0,
 		},
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index f82edfa..a434a32 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1730,24 +1730,26 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	printk(KERN_INFO "%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vfd));
 
-	dev->radio_dev = vdev_init(dev, &tm6000_radio_template,
-						   "radio");
-	if (!dev->radio_dev) {
-		printk(KERN_INFO "%s: can't register radio device\n",
-		       dev->name);
-		return ret; /* FIXME release resource */
-	}
+	if (dev->caps.has_radio) {
+		dev->radio_dev = vdev_init(dev, &tm6000_radio_template,
+							   "radio");
+		if (!dev->radio_dev) {
+			printk(KERN_INFO "%s: can't register radio device\n",
+			       dev->name);
+			return ret; /* FIXME release resource */
+		}
 
-	ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
-				    radio_nr);
-	if (ret < 0) {
-		printk(KERN_INFO "%s: can't register radio device\n",
-		       dev->name);
-		return ret; /* FIXME release resource */
-	}
+		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+					    radio_nr);
+		if (ret < 0) {
+			printk(KERN_INFO "%s: can't register radio device\n",
+			       dev->name);
+			return ret; /* FIXME release resource */
+		}
 
-	printk(KERN_INFO "%s: registered device %s\n",
-	       dev->name, video_device_node_name(dev->radio_dev));
+		printk(KERN_INFO "%s: registered device %s\n",
+		       dev->name, video_device_node_name(dev->radio_dev));
+	}
 
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index fdd6d30..8cdc992 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -129,6 +129,7 @@ struct tm6000_capabilities {
 	unsigned int    has_zl10353:1;
 	unsigned int    has_eeprom:1;
 	unsigned int    has_remote:1;
+	unsigned int    has_radio:1;
 	unsigned int    has_input_comp:1;
 	unsigned int    has_input_svid:1;
 };
-- 
1.7.4.2

