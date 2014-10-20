Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.outflux.net ([198.145.64.163]:50039 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaJTVrt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 17:47:49 -0400
Date: Mon, 20 Oct 2014 14:47:34 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] af9035: make sure loading modules is const
Message-ID: <20141020214734.GA32228@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure that loaded modules are const char strings so we don't
load arbitrary modules in the future, nor allow for format string
leaks in the module request call.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 00758c83eec7..1896ab218b11 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -193,8 +193,8 @@ static int af9035_wr_reg_mask(struct dvb_usb_device *d, u32 reg, u8 val,
 	return af9035_wr_regs(d, reg, &val, 1);
 }
 
-static int af9035_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
-		void *platform_data, struct i2c_adapter *adapter)
+static int af9035_add_i2c_dev(struct dvb_usb_device *d, const char *type,
+		u8 addr, void *platform_data, struct i2c_adapter *adapter)
 {
 	int ret, num;
 	struct state *state = d_to_priv(d);
@@ -221,7 +221,7 @@ static int af9035_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
 		goto err;
 	}
 
-	request_module(board_info.type);
+	request_module("%s", board_info.type);
 
 	/* register I2C device */
 	client = i2c_new_device(adapter, &board_info);
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
