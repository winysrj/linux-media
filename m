Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1037 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751621AbbAMMB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:29 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 06/16] [media] adv7180: Reset the device before initialization
Date: Tue, 13 Jan 2015 13:01:11 +0100
Message-Id: <1421150481-30230-7-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reset the device when initializing it so it is in a good known state and the
assumed register settings matches the actual register settings.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index cc05db9..eeb5a4a 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -30,6 +30,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/mutex.h>
+#include <linux/delay.h>
 
 #define ADV7180_REG_INPUT_CONTROL			0x0000
 #define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM	0x00
@@ -524,6 +525,9 @@ static int init_device(struct adv7180_state *state)
 
 	mutex_lock(&state->mutex);
 
+	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
+	usleep_range(2000, 10000);
+
 	/* Initialize adv7180 */
 	/* Enable autodetection */
 	if (state->autodetect) {
@@ -696,14 +700,14 @@ static int adv7180_resume(struct device *dev)
 	struct adv7180_state *state = to_state(sd);
 	int ret;
 
-	if (state->powered) {
-		ret = adv7180_set_power(state, true);
-		if (ret)
-			return ret;
-	}
 	ret = init_device(state);
 	if (ret < 0)
 		return ret;
+
+	ret = adv7180_set_power(state, state->powered);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
1.8.0

