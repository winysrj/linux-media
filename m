Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaCJXOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 45/48] adv7604: Specify the default input through platform data
Date: Tue, 11 Mar 2014 00:15:56 +0100
Message-Id: <1394493359-14115-46-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And set input routing when initializing the device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 7 +++++++
 include/media/adv7604.h     | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 7f70c6f..cce140c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2404,6 +2404,13 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 
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
index a1798d6..6d69207 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -90,6 +90,8 @@ struct adv7604_platform_data {
 	/* DIS_CABLE_DET_RST: 1 if the 5V pins are unused and unconnected */
 	unsigned disable_cable_det_rst:1;
 
+	int default_input;
+
 	/* Analog input muxing mode */
 	enum adv7604_ain_sel ain_sel;
 
-- 
1.8.3.2

