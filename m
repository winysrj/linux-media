Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/11] [media] cx231xx, em28xx: pass media_device to si2157
Date: Fri, 12 Feb 2016 07:45:05 -0200
Message-Id: <ca52980172915258c690a80951d41dad92557ce7.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As si2157 doesn't use the subdev, but has instead a binding
logic that doesn't have any core framework, we need to manually
pass the media_device struct via platform data on every place
it is called.

This fixes support for HVR-955Q when MC is enabled.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 6 ++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index b8d5b2be9293..1eeddfc79829 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -801,6 +801,9 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend;
+#ifdef CONFIG_MEDIA_CONTROLLER
+		si2157_config.mdev = dev->media_dev;
+#endif
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
@@ -857,6 +860,9 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend;
+#ifdef CONFIG_MEDIA_CONTROLLER
+		si2157_config.mdev = dev->media_dev;
+#endif
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 7ca2fbd3b14a..5ffdb0db8335 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1671,6 +1671,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = dvb->fe[0];
 			si2157_config.if_port = 1;
+#ifdef CONFIG_MEDIA_CONTROLLER
+			si2157_config.mdev = dev->media_dev;
+#endif
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
@@ -1732,6 +1735,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = dvb->fe[0];
 			si2157_config.if_port = 0;
+#ifdef CONFIG_MEDIA_CONTROLLER
+			si2157_config.mdev = dev->media_dev;
+#endif
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2146", I2C_NAME_SIZE);
 			info.addr = 0x60;
-- 
2.5.0


