Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38255 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbdHNRjl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 13:39:41 -0400
Received: by mail-wm0-f65.google.com with SMTP id y206so15200667wmd.5
        for <linux-media@vger.kernel.org>; Mon, 14 Aug 2017 10:39:41 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] dvb-frontends/stv0367: remove QAM_AUTO from ddb_fe_ops
Date: Mon, 14 Aug 2017 19:39:37 +0200
Message-Id: <20170814173937.575-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Since the cab_* codepath doesn't recognize QAM_AUTO, don't announce that
it is supported when it really isn't. Fixes ie. w_scan from
unconditionally using QAM_AUTO on DVB-C scans.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index bc6eb0ab733e..f3529df8211d 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -3283,7 +3283,7 @@ static const struct dvb_frontend_ops stv0367ddb_ops = {
 			0x400 |/* FE_CAN_QAM_4 */
 			FE_CAN_QAM_16 | FE_CAN_QAM_32  |
 			FE_CAN_QAM_64 | FE_CAN_QAM_128 |
-			FE_CAN_QAM_256 | FE_CAN_QAM_AUTO |
+			FE_CAN_QAM_256 |
 			/* DVB-T */
 			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
-- 
2.13.0
