Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.110]:42756 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753817AbdHRBqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 21:46:16 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id AEB71685E
        for <linux-media@vger.kernel.org>; Thu, 17 Aug 2017 20:23:46 -0500 (CDT)
Date: Thu, 17 Aug 2017 20:23:44 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] dib0090: fix duplicated code for different branches
Message-ID: <20170818012344.GA13561@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor code in order to avoid identical code for different branches.

This issue was detected with the help of Coccinelle.

Addresses-Coverity-ID: 1226795
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
This code was tested by compilation only.

 drivers/media/dvb-frontends/dib0090.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index ae53a19..d9d730d 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -2435,14 +2435,7 @@ static int dib0090_tune(struct dvb_frontend *fe)
 			Den = 1;
 
 			if (Rest > 0) {
-				if (state->config->analog_output)
-					lo6 |= (1 << 2) | 2;
-				else {
-					if (state->identity.in_soc)
-						lo6 |= (1 << 2) | 2;
-					else
-						lo6 |= (1 << 2) | 2;
-				}
+				lo6 |= (1 << 2) | 2;
 				Den = 255;
 			}
 			dib0090_write_reg(state, 0x15, (u16) FBDiv);
-- 
2.5.0
