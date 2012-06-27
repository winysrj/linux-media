Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43080 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2F0WYk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 18:24:40 -0400
Received: by ghrr11 with SMTP id r11so1391597ghr.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 15:24:40 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guy Martin <gmsoft@tuxicoman.be>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] [V2] stv090x: variable 'no_signal' set but not used
Date: Wed, 27 Jun 2012 19:18:56 -0300
Message-Id: <1340835544-12053-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove variable and ignore return value of stv090x_chk_signal().

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/dvb/frontends/stv090x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index d79e69f..a4d5954 100644
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
+			(void) stv090x_chk_signal(state);
 		}
 	}
 	return signal_state;
-- 
1.7.10.2

