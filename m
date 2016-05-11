Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52913 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbcEKHLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 03:11:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] adv7511: always update CEC irq mask
Date: Wed, 11 May 2016 09:11:26 +0200
Message-Id: <1462950688-23290-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1462950688-23290-1-git-send-email-hverkuil@xs4all.nl>
References: <1462950688-23290-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of doing:

	if (state->cec_enabled_adap)
		adv7511_wr_and_or(sd, 0x95, 0xc0, enable ? 0x39 : 0x00);

do:

	adv7511_wr_and_or(sd, 0x95, 0xc0,
			  (state->cec_enabled_adap && enable) ? 0x39 : 0x00);

This ensures that the cec irq mask is always updated correctly according
to both conditions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 002117b..ddcde2d 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -937,8 +937,8 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 	else if (adv7511_have_hotplug(sd))
 		irqs |= MASK_ADV7511_EDID_RDY_INT;
 
-	if (state->cec_enabled_adap)
-		adv7511_wr_and_or(sd, 0x95, 0xc0, enable ? 0x39 : 0x00);
+	adv7511_wr_and_or(sd, 0x95, 0xc0,
+			  (state->cec_enabled_adap && enable) ? 0x39 : 0x00);
 
 	/*
 	 * This i2c write can fail (approx. 1 in 1000 writes). But it
-- 
2.8.1

