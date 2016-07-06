Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33047 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbcGFXTU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:19:20 -0400
Received: by mail-pf0-f193.google.com with SMTP id c74so124335pfb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:19:20 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 06/11] media: adv7180: add bt.656-4 OF property
Date: Wed,  6 Jul 2016 15:59:59 -0700
Message-Id: <1467846004-12731-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a device tree boolean property "bt656-4" to allow setting
the ITU-R BT.656-4 compatible bit.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7180.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 92e2f37..fff887c 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -58,7 +58,7 @@
 
 #define ADV7180_REG_OUTPUT_CONTROL			0x0003
 #define ADV7180_REG_EXTENDED_OUTPUT_CONTROL		0x0004
-#define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS		0xC5
+#define ADV7180_EXTENDED_OUTPUT_CONTROL_BT656_4		0x80
 
 #define ADV7180_REG_AUTODETECT_ENABLE			0x0007
 #define ADV7180_AUTODETECT_DEFAULT			0x7f
@@ -216,6 +216,7 @@ struct adv7180_state {
 	struct gpio_desc	*pwdn_gpio;
 	v4l2_std_id		curr_norm;
 	bool			autodetect;
+	bool			bt656_4; /* use bt.656-4 standard for NTSC */
 	bool			powered;
 	u8			input;
 
@@ -1281,6 +1282,17 @@ static int init_device(struct adv7180_state *state)
 	if (ret)
 		goto out_unlock;
 
+	if (state->bt656_4) {
+		ret = adv7180_read(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL);
+		if (ret < 0)
+			goto out_unlock;
+		ret |= ADV7180_EXTENDED_OUTPUT_CONTROL_BT656_4;
+		ret = adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
+				    ret);
+		if (ret < 0)
+			goto out_unlock;
+	}
+
 	ret = adv7180_program_std(state);
 	if (ret)
 		goto out_unlock;
@@ -1332,6 +1344,10 @@ static int adv7180_of_parse(struct adv7180_state *state)
 		return PTR_ERR(state->pwdn_gpio);
 	}
 
+	/* select ITU-R BT.656-4 compatible? */
+	if (of_property_read_bool(client->dev.of_node, "bt656-4"))
+		state->bt656_4 = true;
+
 	return 0;
 }
 
-- 
1.9.1

