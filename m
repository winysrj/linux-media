Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40541 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933425AbdKAVGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>
Subject: [PATCH v2 18/26] media: dvbsky: shut up a bogus warning
Date: Wed,  1 Nov 2017 17:05:55 -0400
Message-Id: <346f93f074e79236398d275343adc63a87b75c78.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch gives two bogus warnings on this driver:
	drivers/media/usb/dvb-usb-v2/dvbsky.c:336 dvbsky_s960_attach() error: uninitialized symbol 'i2c_adapter'.
	drivers/media/usb/dvb-usb-v2/dvbsky.c:459 dvbsky_s960c_attach() error: uninitialized symbol 'i2c_adapter'.

Shut them up.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 131b6c08e199..f90540f947f8 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -309,7 +309,7 @@ static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret = 0;
 	/* demod I2C adapter */
-	struct i2c_adapter *i2c_adapter;
+	struct i2c_adapter *i2c_adapter = NULL;
 	struct i2c_client *client;
 	struct i2c_board_info info;
 	struct ts2020_config ts2020_config = {};
@@ -431,7 +431,7 @@ static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret = 0;
 	/* demod I2C adapter */
-	struct i2c_adapter *i2c_adapter;
+	struct i2c_adapter *i2c_adapter = NULL;
 	struct i2c_client *client_tuner, *client_ci;
 	struct i2c_board_info info;
 	struct sp2_config sp2_config;
-- 
2.13.6
