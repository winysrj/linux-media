Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49371 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab2FNSBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 14:01:03 -0400
Received: by yenl2 with SMTP id l2so1171135yen.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 11:01:03 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guy Martin <gmsoft@tuxicoman.be>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 7/8] stv090x: variable 'no_signal' set but not used
Date: Thu, 14 Jun 2012 14:58:15 -0300
Message-Id: <1339696716-14373-7-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/dvb/frontends/stv090x.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index d79e69f..d229dba 100644
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
@@ -3411,10 +3411,9 @@ static enum stv090x_signal_state stv090x_algo(struct stv090x_state *state)
 			/* Reset the packet Error counter2 */
 			if (STV090x_WRITE_DEMOD(state, ERRCTRL2, 0xc1) < 0)
 				goto err;
-		} else {
+		} else
 			signal_state = STV090x_NODATA;
-			no_signal = stv090x_chk_signal(state);
-		}
+
 	}
 	return signal_state;
 
-- 
1.7.10.2

