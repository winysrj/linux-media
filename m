Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54196 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbcGZGyF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 02:54:05 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] si2165: avoid division by zero
Date: Tue, 26 Jul 2016 08:53:40 +0200
Message-Id: <20160726065340.7396-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When si2165_init fails, the clk values in state are still at zero.
But the dvb-core ignores the return value of init will call tune
afterwards.
This will trigger a division by zero when tuning.
At least check for the variables to be non-zero before dividing.

This happened for a system with WinTV HVR-4400 PCIe-card after suspend-to-disk.
Do suspend-to-disk without accessing the DVB device before.
After wakeup try to tune.
si2165_init fails at checking the chip_mode and aborts.
Then si2165_set_if_freq_shift will fail with div-by-zero.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 8bf716a..849c3c4 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -751,6 +751,9 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 	u64 oversamp;
 	u32 reg_value;
 
+	if (!dvb_rate)
+		return -EINVAL;
+
 	oversamp = si2165_get_fe_clk(state);
 	oversamp <<= 23;
 	do_div(oversamp, dvb_rate);
@@ -775,6 +778,9 @@ static int si2165_set_if_freq_shift(struct si2165_state *state)
 		return -EINVAL;
 	}
 
+	if (!fe_clk)
+		return -EINVAL;
+
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	if_freq_shift = IF;
 	if_freq_shift <<= 29;
-- 
2.9.2

