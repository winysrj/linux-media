Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:23895 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201AbaCSJx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 05:53:28 -0400
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>
Subject: [PATCH 1/3] [media] adv7842: update RGB quantization range on HDMI/DVI-D mode irq.
Date: Wed, 19 Mar 2014 10:43:43 +0100
Message-Id: <1395222225-30084-2-git-send-email-marbugge@cisco.com>
In-Reply-To: <1395222225-30084-1-git-send-email-marbugge@cisco.com>
References: <1395222225-30084-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was the reason for enabling the HDMI/DVI-D mode irq in the first place.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/adv7842.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 636ac08..5d79c57 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2000,6 +2000,7 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	if (irq_status[5] & 0x08) {
 		v4l2_dbg(1, debug, sd, "%s: irq %s mode\n", __func__,
 			 (io_read(sd, 0x65) & 0x08) ? "HDMI" : "DVI");
+		set_rgb_quantization_range(sd);
 		if (handled)
 			*handled = true;
 	}
-- 
1.8.5.3

