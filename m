Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaDQONn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 44/49] adv7604: Specify the default input through platform data
Date: Thu, 17 Apr 2014 16:13:15 +0200
Message-Id: <1397744000-23967-45-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And set input routing when initializing the device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 7 +++++++
 include/media/adv7604.h     | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index b14dc7d..342d73d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2441,6 +2441,13 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 
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
index 276135b..40b4ae0 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -104,6 +104,8 @@ struct adv7604_platform_data {
 	/* DIS_CABLE_DET_RST: 1 if the 5V pins are unused and unconnected */
 	unsigned disable_cable_det_rst:1;
 
+	int default_input;
+
 	/* Analog input muxing mode */
 	enum adv7604_ain_sel ain_sel;
 
-- 
1.8.3.2

