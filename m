Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:44502 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbbBDNIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 08:08:14 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [media] cx231xx: drop condition with no effect
Date: Wed,  4 Feb 2015 08:03:11 -0500
Message-Id: <1423054991-1414-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The if and the else code are identical - so the condition has no effect
on the effective code.
This patch removes the condition and the duplicated code.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

The if and the else code are identical - so the condition has no effect.
The value of the assignment was placed into () for readability as other long 
bit-wise constructs in this file also do so.

Patch was only compile tested with imx_v6_v7_defconfig
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y, CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y,
CONFIG_VIDEO_CX231XX=m

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/media/usb/cx231xx/cx231xx-core.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 4a3f28c..832ba99 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -176,16 +176,9 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 	saddr_len = req_data->saddr_len;
 
 	/* Set wValue */
-	if (saddr_len == 1)	/* need check saddr_len == 0  */
-		ven_req.wValue =
-		    req_data->
-		    dev_addr << 9 | _i2c_period << 4 | saddr_len << 2 |
-		    _i2c_nostop << 1 | I2C_SYNC | _i2c_reserve << 6;
-	else
-		ven_req.wValue =
-		    req_data->
-		    dev_addr << 9 | _i2c_period << 4 | saddr_len << 2 |
-		    _i2c_nostop << 1 | I2C_SYNC | _i2c_reserve << 6;
+	ven_req.wValue = (req_data->dev_addr << 9 | _i2c_period << 4 |
+			  saddr_len << 2 | _i2c_nostop << 1 | I2C_SYNC |
+			  _i2c_reserve << 6);
 
 	/* set channel number */
 	if (req_data->direction & I2C_M_RD) {
-- 
1.7.10.4

