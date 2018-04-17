Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:51043 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755118AbeDQQkY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:40:24 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/9] cx231xx: Fix several incorrect demod addresses
Date: Tue, 17 Apr 2018 11:39:47 -0500
Message-Id: <1523983195-28691-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the board values match the hard coded
constants used in the dvb initialization.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index c76b210..5b54e73 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -715,7 +715,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_i2c_master = I2C_1_MUX_3,
 		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
-		.demod_addr = 0x0e,
+		.demod_addr = 0x64, /* 0xc8 >> 1 */
 		.norm = V4L2_STD_PAL,
 
 		.input = {{
@@ -754,7 +754,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_i2c_master = I2C_1_MUX_3,
 		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
-		.demod_addr = 0x0e,
+		.demod_addr = 0x64, /* 0xc8 >> 1 */
 		.norm = V4L2_STD_PAL,
 
 		.input = {{
@@ -793,7 +793,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_i2c_master = I2C_1_MUX_3,
 		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
-		.demod_addr = 0x0e,
+		.demod_addr = 0x59, /* 0xb2 >> 1 */
 		.norm = V4L2_STD_NTSC,
 
 		.input = {{
-- 
2.7.4
