Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35533 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbdFYL0u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 07:26:50 -0400
Received: by mail-wr0-f196.google.com with SMTP id z45so24022064wrb.2
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 04:26:50 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 1/4] [media] dvb-frontends/stv0367: Improve DVB-C/T frontend status
Date: Sun, 25 Jun 2017 13:26:43 +0200
Message-Id: <20170625112646.7973-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170625112646.7973-1-d.scheller.oss@gmail.com>
References: <20170625112646.7973-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

The stv0367 driver provide a lot of status on its state machine.
Change the logic to provide more information about frontend locking
status. Also, while any detailed status isn't available, provide a more
complete FE_STATUS for DVB-T.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Tested-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index f266c18c574c..9e5432b761b5 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1507,7 +1507,8 @@ static int stv0367ter_read_status(struct dvb_frontend *fe,
 	*status = 0;
 
 	if (stv0367_readbits(state, F367TER_LK)) {
-		*status |= FE_HAS_LOCK;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
+			  | FE_HAS_SYNC | FE_HAS_LOCK;
 		dprintk("%s: stv0367 has locked\n", __func__);
 	}
 
@@ -2155,6 +2156,18 @@ static int stv0367cab_read_status(struct dvb_frontend *fe,
 
 	*status = 0;
 
+	if (state->cab_state->state > FE_CAB_NOSIGNAL)
+		*status |= FE_HAS_SIGNAL;
+
+	if (state->cab_state->state > FE_CAB_NOCARRIER)
+		*status |= FE_HAS_CARRIER;
+
+	if (state->cab_state->state >= FE_CAB_DEMODOK)
+		*status |= FE_HAS_VITERBI;
+
+	if (state->cab_state->state >= FE_CAB_DATAOK)
+		*status |= FE_HAS_SYNC;
+
 	if (stv0367_readbits(state, (state->cab_state->qamfec_status_reg ?
 		state->cab_state->qamfec_status_reg : F367CAB_QAMFEC_LOCK))) {
 		*status |= FE_HAS_LOCK;
-- 
2.13.0
