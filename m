Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f42.google.com ([209.85.213.42]:33855 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2F1OJB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 10:09:01 -0400
Received: by yhfq11 with SMTP id q11so2586235yhf.1
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 07:09:00 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guy Martin <gmsoft@tuxicoman.be>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] [V3] stv090x: variable 'no_signal' set but not used
Date: Thu, 28 Jun 2012 11:08:32 -0300
Message-Id: <1340892520-9063-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove variable and ignore return value of stv090x_chk_signal().

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/dvb/frontends/stv090x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index d79e69f..ea86a56 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3172,7 +3172,7 @@ static enum stv090x_signal_state stv090x_algo(struct stv090x_state *state)
 	enum stv090x_signal_state signal_state = STV090x_NOCARRIER;
 	u32 reg;
 	s32 agc1_power, power_iq = 0, i;
-	int lock = 0, low_sr = 0, no_signal = 0;
+	int lock = 0, low_sr = 0;
 
 	reg = STV090x_READ_DEMOD(state, TSCFGH);
 	STV090x_SETFIELD_Px(reg, RST_HWARE_FIELD, 1); /* Stop path 1 stream merger */
@@ -3413,7 +3413,7 @@ static enum stv090x_signal_state stv090x_algo(struct stv090x_state *state)
 				goto err;
 		} else {
 			signal_state = STV090x_NODATA;
-			no_signal = stv090x_chk_signal(state);
+			stv090x_chk_signal(state);
 		}
 	}
 	return signal_state;
-- 
1.7.10.2

