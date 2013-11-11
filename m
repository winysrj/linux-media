Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:47965 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3KKWcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 17:32:03 -0500
To: linux-media@vger.kernel.org
Subject: [PATCH] [RESEND] gspca-stk1135: Add delay after configuring clock
From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 11 Nov 2013 23:31:36 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201311112331.37052.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a small delay at the end of configure_clock() to allow sensor to initialize.
This is needed by Asus VX2S laptop webcam to detect sensor type properly (the already-supported MT9M112).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/usb/gspca/stk1135.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/gspca/stk1135.c b/drivers/media/usb/gspca/stk1135.c
index 8add2f7..d8a813c 100644
--- a/drivers/media/usb/gspca/stk1135.c
+++ b/drivers/media/usb/gspca/stk1135.c
@@ -361,6 +361,9 @@ static void stk1135_configure_clock(struct gspca_dev *gspca_dev)
 
 	/* set serial interface clock divider (30MHz/0x1f*16+2) = 60240 kHz) */
 	reg_w(gspca_dev, STK1135_REG_SICTL + 2, 0x1f);
+
+	/* wait a while for sensor to catch up */
+	udelay(1000);
 }
 
 static void stk1135_camera_disable(struct gspca_dev *gspca_dev)
-- 
Ondrej Zary
