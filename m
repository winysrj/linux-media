Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36096 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbdHWQKK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 12:10:10 -0400
Received: by mail-wr0-f193.google.com with SMTP id f8so353053wrf.3
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 09:10:10 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, Ralph Metzler <rjkm@metzlerbros.de>,
        Richard Scobie <r.scobie@clear.net.nz>
Subject: [PATCH 5/5] [media] dvb-frontends/stv0910: change minsymrate to 100Ksyms/s
Date: Wed, 23 Aug 2017 18:10:02 +0200
Message-Id: <20170823161002.25459-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170823161002.25459-1-d.scheller.oss@gmail.com>
References: <20170823161002.25459-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The demodulator supports symbol rates as low as 100Ksyms/s - the demod
setup in start() already handles such low symbol rates and reviewers
of stv0910 equipped cards even found and tested transponders with
SRs in that range. So, announce this in the fe_ops.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Richard Scobie <r.scobie@clear.net.nz>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 0d4a6a115159..8bf855c301f5 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1698,7 +1698,7 @@ static const struct dvb_frontend_ops stv0910_ops = {
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 0,
 		.frequency_tolerance	= 0,
-		.symbol_rate_min	= 1000000,
+		.symbol_rate_min	= 100000,
 		.symbol_rate_max	= 70000000,
 		.caps			= FE_CAN_INVERSION_AUTO |
 					  FE_CAN_FEC_AUTO       |
-- 
2.13.0
