Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:63293 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdIQUTH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 16:19:07 -0400
Subject: [PATCH 3/8] [media] cx231xx: Improve six size determinations
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Message-ID: <c3e10d21-3047-4e5a-861c-7c5efce1a5ca@users.sourceforge.net>
Date: Sun, 17 Sep 2017 22:18:40 +0200
MIME-Version: 1.0
In-Reply-To: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 18:38:50 +0200

Replace the specification of data structures by variable references
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 10 +++++-----
 drivers/media/usb/cx231xx/cx231xx-video.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 0813f368fb3c..35d98ec948b2 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -611,5 +611,5 @@ static int dvb_init(struct cx231xx *dev)
 		return 0;
 	}
 
-	dvb = kzalloc(sizeof(struct cx231xx_dvb), GFP_KERNEL);
+	dvb = kzalloc(sizeof(*dvb), GFP_KERNEL);
 	if (!dvb)
@@ -754,7 +754,7 @@ static int dvb_init(struct cx231xx *dev)
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
 		si2165_pdata.ref_freq_Hz = 16000000,
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
+		memset(&info, 0, sizeof(info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
 		info.addr = 0x64;
 		info.platform_data = &si2165_pdata;
@@ -801,7 +801,7 @@ static int dvb_init(struct cx231xx *dev)
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT,
 		si2165_pdata.ref_freq_Hz = 24000000,
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
+		memset(&info, 0, sizeof(info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
 		info.addr = 0x64;
 		info.platform_data = &si2165_pdata;
@@ -822,7 +822,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dvb->i2c_client_demod = client;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
+		memset(&info, 0, sizeof(info));
 
 		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
 
@@ -869,7 +869,7 @@ static int dvb_init(struct cx231xx *dev)
 		struct i2c_board_info info;
 		struct si2157_config si2157_config;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
+		memset(&info, 0, sizeof(info));
 
 		dev->dvb->frontend = dvb_attach(lgdt3306a_attach,
 			&hauppauge_955q_lgdt3306a_config,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 956f8cbcb454..a12ec3567684 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1771,5 +1771,5 @@ static int cx231xx_v4l2_open(struct file *filp)
 	}
 #endif
 
-	fh = kzalloc(sizeof(struct cx231xx_fh), GFP_KERNEL);
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (!fh)
-- 
2.14.1
