Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51834 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdBBOyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 09:54:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Michael Krufky <mkrufky@linuxtv.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] [media] mxl111sf: reduce stack usage in init function
Date: Thu,  2 Feb 2017 15:53:07 +0100
Message-Id: <20170202145318.3803805-4-arnd@arndb.de>
In-Reply-To: <20170202145318.3803805-1-arnd@arndb.de>
References: <20170202145318.3803805-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mxl111sf uses a lot of kernel stack memory as it puts an i2c_client
structure on the stack:

drivers/media/usb/dvb-usb-v2/mxl111sf.c: In function 'mxl111sf_init':
drivers/media/usb/dvb-usb-v2/mxl111sf.c:953:1: error: the frame size of 1248 bytes is larger than 1152 bytes [-Werror=frame-larger-than=]

We can avoid doing this by open-coding the call to i2c_transfer()
instead of calling tveeprom_read(), and not passing an i2c_client
pointer to tveeprom_hauppauge_analog(), which would ignore that
anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 80c635980526..60bc5cc9a483 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -919,7 +919,12 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 	struct mxl111sf_state *state = d_to_priv(d);
 	int ret;
 	static u8 eeprom[256];
-	struct i2c_client c;
+	u8 reg = 0;
+	struct i2c_msg msg[2] = {
+		{ .addr = 0xa0 >> 1, .len = 1, .buf = &reg },
+		{ .addr = 0xa0 >> 1, .flags = I2C_M_RD,
+		  .len = sizeof(eeprom), .buf = eeprom },
+	};
 
 	ret = get_chip_info(state);
 	if (mxl_fail(ret))
@@ -930,13 +935,10 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 	if (state->chip_rev > MXL111SF_V6)
 		mxl111sf_config_pin_mux_modes(state, PIN_MUX_TS_SPI_IN_MODE_1);
 
-	c.adapter = &d->i2c_adap;
-	c.addr = 0xa0 >> 1;
-
-	ret = tveeprom_read(&c, eeprom, sizeof(eeprom));
+	ret = i2c_transfer(&d->i2c_adap, msg, 2);
 	if (mxl_fail(ret))
 		return 0;
-	tveeprom_hauppauge_analog(&c, &state->tv, (0x84 == eeprom[0xa0]) ?
+	tveeprom_hauppauge_analog(NULL, &state->tv, (0x84 == eeprom[0xa0]) ?
 			eeprom + 0xa0 : eeprom + 0x80);
 #if 0
 	switch (state->tv.model) {
-- 
2.9.0

