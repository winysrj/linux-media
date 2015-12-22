Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37297 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbbLVOWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 09:22:10 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v2 2/2] media: adv7604: update timings on change of input signal
Date: Tue, 22 Dec 2015 15:22:02 +0100
Message-Id: <1450794122-31293-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this, .get_selection will always return the boot-time state.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 8ad5c28..dcd659b 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1945,6 +1945,7 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	u8 fmt_change_digital;
 	u8 fmt_change;
 	u8 tx_5v;
+	int ret;
 
 	if (irq_reg_0x43)
 		io_write(sd, 0x44, irq_reg_0x43);
@@ -1968,6 +1969,14 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 
 		v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
 
+		/* update timings */
+		ret = adv76xx_query_dv_timings(sd, &state->timings);
+		if (ret == -ENOLINK) {
+			/* no signal, fall back to default timings */
+			state->timings = (struct v4l2_dv_timings)
+				V4L2_DV_BT_CEA_640X480P59_94;
+		}
+
 		if (handled)
 			*handled = true;
 	}
-- 
2.6.3

