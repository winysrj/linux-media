Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:40116 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759197AbaCSJx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 05:53:26 -0400
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>
Subject: [PATCH 3/3] [media] adv7842: Disable access to EDID DDC lines before chip power up.
Date: Wed, 19 Mar 2014 10:43:45 +0100
Message-Id: <1395222225-30084-4-git-send-email-marbugge@cisco.com>
In-Reply-To: <1395222225-30084-1-git-send-email-marbugge@cisco.com>
References: <1395222225-30084-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In core_init make sure access to EDID DDC lines are disabled
before chip is powered up. Also DISABLE_AUTO_EDID before power up.
The correct setting is applied later when setting the EDID.
Some sources (MAC) kept on reading EDID even when Hotplug was low
and in the short period in core_init before the DDC lines was enabled
read a corrupt EDID.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/adv7842.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 805a117..3b3bd42 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2687,6 +2687,12 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 
 	disable_input(sd);
 
+	/*
+	 * Disable I2C access to internal EDID ram from HDMI DDC ports
+	 * Disable auto edid enable when leaving powerdown mode
+	 */
+	rep_write_and_or(sd, 0x77, 0xd3, 0x20);
+
 	/* power */
 	io_write(sd, 0x0c, 0x42);   /* Power up part and power down VDP */
 	io_write(sd, 0x15, 0x80);   /* Power up pads */
@@ -2767,9 +2773,6 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 
 	enable_input(sd);
 
-	/* disable I2C access to internal EDID ram from HDMI DDC ports */
-	rep_write_and_or(sd, 0x77, 0xf3, 0x00);
-
 	if (pdata->hpa_auto) {
 		/* HPA auto, HPA 0.5s after Edid set and Cable detect */
 		hdmi_write(sd, 0x69, 0x5c);
-- 
1.8.5.3

