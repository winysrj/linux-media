Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:40408 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdL2MWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 07:22:41 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: corbet@lwn.net, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4l2: i2c: ov7670: Fix PLL bypass register values
Date: Fri, 29 Dec 2017 13:22:26 +0100
Message-Id: <1514550146-20195-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following commits:
commit f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")
commit 04ee6d92047e ("[media] media: ov7670: add possibility to bypass pll for ov7675")
introduced the ability to bypass PLL multiplier and use input clock (xvclk)
as pixel clock output frequency for ov7675 sensor.

PLL is bypassed using register DBLV[7:6], according to ov7670 and ov7675
sensor manuals. Macros used to set DBLV register seem wrong in the
driver, as their values do not match what reported in the datasheet.

Fix by changing DBLV_* macros to use bits [7:6] and set bits [3:0] to
default 0x0a reserved value (according to datasheets).

While at there, remove a write to DBLV register in
"ov7675_set_framerate()" that over-writes the previous one to the same
register that takes "info->pll_bypass" flag into account instead of setting PLL
multiplier to 4x unconditionally.

And, while at there, since "info->pll_bypass" is only used in
set/get_framerate() functions used by ov7675 only, it is not necessary
to check for the device id at probe time to make sure that when using
ov7670 "info->pll_bypass" is set to false.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov7670.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

---
Javier, as you're the author of commit 04ee6d92047e1ac68d4eb615119343f4f0fc57db
that introduced DBLV_ macros, have you ever seen it working with those macros
values? Where did those value come from? I have checked both ov7670 and ov7675
datasheet and they seems wrong, but I don't have an ov7675 sensor, so I can
only compile test this...

Thanks
   j

EDIT: seems like Javier email address is not valid anymore.. I'm dropping
it from receiver list, hoping he reads the media mailing list.

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 950a0ac..0a5fa33 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -158,10 +158,10 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define REG_GFIX	0x69	/* Fix gain control */

 #define REG_DBLV	0x6b	/* PLL control an debugging */
-#define   DBLV_BYPASS	  0x00	  /* Bypass PLL */
-#define   DBLV_X4	  0x01	  /* clock x4 */
-#define   DBLV_X6	  0x10	  /* clock x6 */
-#define   DBLV_X8	  0x11	  /* clock x8 */
+#define   DBLV_BYPASS	  0x0a	  /* Bypass PLL */
+#define   DBLV_X4	  0x4a	  /* clock x4 */
+#define   DBLV_X6	  0x8a	  /* clock x6 */
+#define   DBLV_X8	  0xca	  /* clock x8 */

 #define REG_REG76	0x76	/* OV's name */
 #define   R76_BLKPCOR	  0x80	  /* Black pixel correction enable */
@@ -841,7 +841,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;

-	return ov7670_write(sd, REG_DBLV, DBLV_X4);
+	return 0;
 }

 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
@@ -1692,11 +1692,7 @@ static int ov7670_probe(struct i2c_client *client,
 		if (config->clock_speed)
 			info->clock_speed = config->clock_speed;

-		/*
-		 * It should be allowed for ov7670 too when it is migrated to
-		 * the new frame rate formula.
-		 */
-		if (config->pll_bypass && id->driver_data != MODEL_OV7670)
+		if (config->pll_bypass)
 			info->pll_bypass = true;

 		if (config->pclk_hb_disable)
--
2.7.4
