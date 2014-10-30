Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35006 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161035AbaJ3UNH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:13:07 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v4 05/14] cx231xx: Modifiy the symbolic constants for i2c ports and describe
Date: Thu, 30 Oct 2014 21:12:26 +0100
Message-Id: <1414699955-5760-6-git-send-email-zzam@gentoo.org>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change to I2C_0 ... I2C_2 for the master ports
and add I2C_1_MUX_1 and I2C_1_MUX_3 for the muxed ones.

V2: Renamed mux adapters to seperate them from master adapters.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/cx231xx/cx231xx.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index c92382f..377216b 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -322,10 +322,11 @@ enum cx231xx_decoder {
 };
 
 enum CX231XX_I2C_MASTER_PORT {
-	I2C_0 = 0,
-	I2C_1 = 1,
-	I2C_2 = 2,
-	I2C_3 = 3
+	I2C_0 = 0,       /* master 0 - internal connection */
+	I2C_1 = 1,       /* master 1 - used with mux */
+	I2C_2 = 2,       /* master 2 */
+	I2C_1_MUX_1 = 3, /* master 1 - port 1 (I2C_DEMOD_EN = 0) */
+	I2C_1_MUX_3 = 4  /* master 1 - port 3 (I2C_DEMOD_EN = 1) */
 };
 
 struct cx231xx_board {
-- 
2.1.2

