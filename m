Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36450 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeAVRN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 12:13:56 -0500
Received: by mail-wr0-f193.google.com with SMTP id d9so9498569wre.3
        for <linux-media@vger.kernel.org>; Mon, 22 Jan 2018 09:13:56 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v2 5/5] media: dvb-frontends/stv0910: report active delsys in get_frontend()
Date: Mon, 22 Jan 2018 18:13:46 +0100
Message-Id: <20180122171346.822-6-d.scheller.oss@gmail.com>
In-Reply-To: <20180122171346.822-1-d.scheller.oss@gmail.com>
References: <20180122171346.822-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Report the active delivery system based on the receive_mode state of the
demodulator.

Suggested-by: Richard Scobie <rascobie@slingshot.co.nz>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 7ab014cec56c..6e6a70ad7354 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1580,6 +1580,7 @@ static int get_frontend(struct dvb_frontend *fe,
 		p->modulation = modcod2mod[mc];
 		p->fec_inner = modcod2fec[mc];
 		p->rolloff = ro2ro[state->fe_rolloff];
+		p->delivery_system = SYS_DVBS2;
 	} else if (state->receive_mode == RCVMODE_DVBS) {
 		read_reg(state, RSTV0910_P2_VITCURPUN + state->regoff, &tmp);
 		switch (tmp & 0x1F) {
@@ -1603,6 +1604,7 @@ static int get_frontend(struct dvb_frontend *fe,
 			break;
 		}
 		p->rolloff = ROLLOFF_35;
+		p->delivery_system = SYS_DVBS;
 	}
 
 	if (state->receive_mode != RCVMODE_NONE) {
-- 
2.13.6
