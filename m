Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2HGCsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:07 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:07 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 20/24] au0828: tweak workaround for i2c clock stretching bug
Date: Mon,  6 Aug 2012 22:47:10 -0400
Message-Id: <1344307634-11673-21-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hack I put in a couple of years ago to avoid clock stretching issues
when talking to the xc5000 worked fine for writes, but intermittently fails
for register reads, because the xc5000 may stretch the clock for longer
between bytes (I was seeing cases of 21 us on the analyzer).

The problem manifested itself as the xc5000 firmware version and PLL lock
register intermittently showing garbage values.

Slow down the i2c bus from 30 KHz to 20 KHz to accommodate.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-cards.c |    4 ++--
 drivers/media/video/au0828/au0828-reg.h   |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 1c6015a..4a09b0e 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -46,7 +46,7 @@ struct au0828_board au0828_boards[] = {
 		.name	= "Hauppauge HVR850",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
-		.i2c_clk_divider = AU0828_I2C_CLK_30KHZ,
+		.i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
 		.input = {
 			{
 				.type = AU0828_VMUX_TELEVISION,
@@ -77,7 +77,7 @@ struct au0828_board au0828_boards[] = {
 		   stretch fits inside of a normal clock cycle, or else the
 		   au0828 fails to set the STOP bit.  A 30 KHz clock puts the
 		   clock pulse width at 18us */
-		.i2c_clk_divider = AU0828_I2C_CLK_30KHZ,
+		.i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
 		.input = {
 			{
 				.type = AU0828_VMUX_TELEVISION,
diff --git a/drivers/media/video/au0828/au0828-reg.h b/drivers/media/video/au0828/au0828-reg.h
index c39f3d2..2140f4c 100644
--- a/drivers/media/video/au0828/au0828-reg.h
+++ b/drivers/media/video/au0828/au0828-reg.h
@@ -63,3 +63,4 @@
 #define AU0828_I2C_CLK_250KHZ 0x07
 #define AU0828_I2C_CLK_100KHZ 0x14
 #define AU0828_I2C_CLK_30KHZ  0x40
+#define AU0828_I2C_CLK_20KHZ  0x60
-- 
1.7.1

