Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24639 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1I2GKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 02:10:00 -0400
Date: Thu, 29 Sep 2011 09:09:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mxl111sf: fix a couple precedence bugs
Message-ID: <20110929060942.GA4104@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Negate has higher precedence than bitwise AND.  I2C_M_RD is 0x1 so
the original code is equivelent to just checking if (!msg->flags).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-i2c.c b/drivers/media/dvb/dvb-usb/mxl111sf-i2c.c
index a330987..2e8c288 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-i2c.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-i2c.c
@@ -453,7 +453,7 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
 
 	mxl_i2c("addr: 0x%02x, read buff len: %d, write buff len: %d",
 		msg->addr, (msg->flags & I2C_M_RD) ? msg->len : 0,
-		(!msg->flags & I2C_M_RD) ? msg->len : 0);
+		(!(msg->flags & I2C_M_RD)) ? msg->len : 0);
 
 	for (index = 0; index < 26; index++)
 		buf[index] = USB_END_I2C_CMD;
@@ -489,7 +489,7 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
 	ret = mxl111sf_i2c_send_data(state, 0, buf);
 
 	/* write data on I2C bus */
-	if ((!msg->flags & I2C_M_RD) && (msg->len > 0)) {
+	if (!(msg->flags & I2C_M_RD) && (msg->len > 0)) {
 		mxl_i2c("%d\t%02x", msg->len, msg->buf[0]);
 
 		/* control register on I2C interface to initialize I2C bus */
