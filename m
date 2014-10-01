Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34762 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaJAFUj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 01:20:39 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH V2 05/13] cx231xx: Modifiy the symbolic constants for i2c ports and describe
Date: Wed,  1 Oct 2014 07:20:13 +0200
Message-Id: <1412140821-16285-6-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change to I2C_0 ... I2C_2 for the master ports
and add I2C_1_MUX_1 and I2C_1_MUX_3 for the muxed ones.

V2: Renamed mux adapters to seperate them from master adapters.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
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
2.1.1

