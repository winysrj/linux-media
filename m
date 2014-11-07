Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:36789 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbaKGULv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 15:11:51 -0500
Received: from [24.206.115.17] (helo=[192.168.1.7])
	by elasmtp-kukur.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <thebitpit@earthlink.net>)
	id 1XmpmC-0004xs-MV
	for linux-media@vger.kernel.org; Fri, 07 Nov 2014 15:04:56 -0500
Message-ID: <545D25E8.5080701@earthlink.net>
Date: Fri, 07 Nov 2014 14:04:56 -0600
From: The Bit Pit <thebitpit@earthlink.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH]  KWorld UB435Q V3 (ATSC) tuner
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From Wilson Michaels <thebitpit@earthlink.net>

This patch fixes the KWorld UB435-Q V3 (ATSC) tuner functions:
1) The LED indicator now works.
2) Start up initialization is faster.
3) Add "lgdt330x" device name i2c_devs array used for debugging
4) Correct comments about the UB435-Q V3

Signed-off-by: Wilson Michaels <thebitpit@earthlink.net>

#
# On branch media_tree/master
# Your branch is up-to-date with 'r_media_tree/master'.
#
# Changes to be committed:
# modified:   drivers/media/usb/em28xx/em28xx-cards.c
# modified:   drivers/media/usb/em28xx/em28xx-i2c.c
#
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c
b/drivers/media/usb/em28xx/em28xx-cards.c
index 3c97bf1..96835de 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -189,11 +189,19 @@ static struct em28xx_reg_seq kworld_a340_digital[] = {
        {       -1,             -1,     -1,             -1},
 };
 
+/*
+ * KWorld UB435-Q V3 (ATSC) GPIOs map:
+ * EM_GPIO_0 - i2c disable/enable (1 = off, 0 = on)
+ * EM_GPIO_1 - LED disable/enable (1 = off, 0 = on)
+ * EM_GPIO_2 - currently unknown
+ * EM_GPIO_3 - currently unknown
+ * EM_GPIO_4 - currently unknown
+ * EM_GPIO_5 - TDA18272/M tuner (1 = active, 0 = in reset)
+ * EM_GPIO_6 - LGDT3304 ATSC/QAM demod (1 = active, 0 = in reset)
+ * EM_GPIO_7 - currently unknown
+ */
 static struct em28xx_reg_seq kworld_ub435q_v3_digital[] = {
-       {EM2874_R80_GPIO_P0_CTRL,       0xff,   0xff,   100},
-       {EM2874_R80_GPIO_P0_CTRL,       0xfe,   0xff,   100},
-       {EM2874_R80_GPIO_P0_CTRL,       0xbe,   0xff,   100},
-       {EM2874_R80_GPIO_P0_CTRL,       0xfe,   0xff,   100},
+       {EM2874_R80_GPIO_P0_CTRL,       0x6e,   ~EM_GPIO_4,     10},
        {       -1,                     -1,     -1,     -1},
 };
 
@@ -532,7 +540,7 @@ static struct em28xx_led kworld_ub435q_v3_leds[] = {
        {
                .role      = EM28XX_LED_DIGITAL_CAPTURING,
                .gpio_reg  = EM2874_R80_GPIO_P0_CTRL,
-               .gpio_mask = 0x80,
+               .gpio_mask = 0x02,
                .inverted  = 1,
        },
        {-1, 0, 0, 0},
@@ -2182,7 +2190,7 @@ struct em28xx_board em28xx_boards[] = {
        },
        /*
         * 1b80:e34c KWorld USB ATSC TV Stick UB435-Q V3
-        * Empia EM2874B + LG DT3305 + NXP TDA18271HDC2
+        * Empia EM2874B + LG DT3305 + NXP TDA18272/M
         */
        [EM2874_BOARD_KWORLD_UB435Q_V3] = {
                .name           = "KWorld USB ATSC TV Stick UB435-Q V3",
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c
b/drivers/media/usb/em28xx/em28xx-i2c.c
index 1048c1a..5bc6ef1 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -877,6 +877,7 @@ static struct i2c_client em28xx_client_template = {
  * incomplete list of known devices
  */
 static char *i2c_devs[128] = {
+       [0x1c >> 1] = "lgdt330x",
        [0x3e >> 1] = "remote IR sensor",
        [0x4a >> 1] = "saa7113h",
        [0x52 >> 1] = "drxk",

