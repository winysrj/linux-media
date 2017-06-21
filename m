Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33890 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFUUK5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 16:10:57 -0400
Received: by mail-wr0-f193.google.com with SMTP id k67so1425017wrc.1
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 13:10:57 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Subject: [PATCH] [media] dvb-frontends/stv0367: deduplicate DDB dvb_frontend_ops caps
Date: Wed, 21 Jun 2017 22:10:54 +0200
Message-Id: <20170621201054.23806-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index e726c2e00460..b42b99ad4d3f 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -3126,15 +3126,12 @@ static const struct dvb_frontend_ops stv0367ddb_ops = {
 			0x400 |/* FE_CAN_QAM_4 */
 			FE_CAN_QAM_16 | FE_CAN_QAM_32  |
 			FE_CAN_QAM_64 | FE_CAN_QAM_128 |
-			FE_CAN_QAM_256 | FE_CAN_FEC_AUTO |
+			FE_CAN_QAM_256 | FE_CAN_QAM_AUTO |
 			/* DVB-T */
-			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
-			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
-			FE_CAN_FEC_AUTO |
-			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
-			FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_QAM_AUTO |
-			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_RECOVER |
-			FE_CAN_INVERSION_AUTO |
+			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK | FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_RECOVER | FE_CAN_INVERSION_AUTO |
 			FE_CAN_MUTE_TS
 	},
 	.release = stv0367_release,
-- 
2.13.0
