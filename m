Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43323 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbbHTHft (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 03:35:49 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] tc358743: only queue subdev notifications if devnode is set
Date: Thu, 20 Aug 2015 09:35:43 +0200
Message-Id: <1440056143-5992-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware interrupts are enabled in the probe function, before the subdev
is registered to its v4l2_device. Until v4l2_device_register_subdev_node
is called, sd->devnode is NULL and v4l2_subdev_notify_event must not be
called.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 7eba223..cd73cb4 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -860,7 +860,8 @@ static void tc358743_format_change(struct v4l2_subdev *sd)
 				&timings, false);
 	}
 
-	v4l2_subdev_notify_event(sd, &tc358743_ev_fmt);
+	if (sd->devnode)
+		v4l2_subdev_notify_event(sd, &tc358743_ev_fmt);
 }
 
 static void tc358743_init_interrupts(struct v4l2_subdev *sd)
-- 
2.4.6

