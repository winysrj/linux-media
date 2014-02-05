Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaBEQmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:42:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 44/47] adv7604: Specify the default input through platform data
Date: Wed,  5 Feb 2014 17:42:35 +0100
Message-Id: <1391618558-5580-45-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And set input routing when initializing the device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 7 +++++++
 include/media/adv7604.h     | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 2f38071..e586c1c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2419,6 +2419,13 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 
 	disable_input(sd);
 
+	if (pdata->default_input >= 0 &&
+	    pdata->default_input < state->source_pad) {
+		state->selected_input = pdata->default_input;
+		select_input(sd);
+		enable_input(sd);
+	}
+
 	/* power */
 	io_write(sd, 0x0c, 0x42);   /* Power up part and power down VDP */
 	io_write(sd, 0x0b, 0x44);   /* Power down ESDP block */
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index dddb0cb..0cad7a7 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -94,6 +94,8 @@ struct adv7604_platform_data {
 	int hpd_gpio[4];
 	bool hpd_gpio_low[4];
 
+	int default_input;
+
 	/* Analog input muxing mode */
 	enum adv7604_ain_sel ain_sel;
 
-- 
1.8.3.2

