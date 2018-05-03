Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44842 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751192AbeECVUX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 17:20:23 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 3/9] cx231xx: Style fix for struct zero init
Date: Thu,  3 May 2018 16:20:09 -0500
Message-Id: <1525382415-4049-4-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
References: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace zero fill memset inits with
equivalent {} in declaration

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 99f1a77..12f2dcc 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -787,10 +787,9 @@ static int dvb_init(struct cx231xx *dev)
 	{
 		struct i2c_client *client;
 		struct i2c_board_info info;
-		struct si2165_platform_data si2165_pdata;
+		struct si2165_platform_data si2165_pdata = {};
 
 		/* attach demod */
-		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 		si2165_pdata.fe = &dev->dvb->frontend[0];
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL;
 		si2165_pdata.ref_freq_hz = 16000000;
@@ -832,11 +831,10 @@ static int dvb_init(struct cx231xx *dev)
 	{
 		struct i2c_client *client;
 		struct i2c_board_info info;
-		struct si2165_platform_data si2165_pdata;
-		struct si2157_config si2157_config;
+		struct si2165_platform_data si2165_pdata = {};
+		struct si2157_config si2157_config = {};
 
 		/* attach demod */
-		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 		si2165_pdata.fe = &dev->dvb->frontend[0];
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT;
 		si2165_pdata.ref_freq_hz = 24000000;
@@ -870,7 +868,6 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
 
 		/* attach tuner */
-		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend[0];
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 		si2157_config.mdev = dev->media_dev;
@@ -907,7 +904,7 @@ static int dvb_init(struct cx231xx *dev)
 	{
 		struct i2c_client *client;
 		struct i2c_board_info info;
-		struct si2157_config si2157_config;
+		struct si2157_config si2157_config = {};
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 
@@ -929,7 +926,6 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
 
 		/* attach tuner */
-		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend[0];
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 		si2157_config.mdev = dev->media_dev;
-- 
2.7.4
