Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64690 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaBDU0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 15:26:46 -0500
Received: by mail-wg0-f54.google.com with SMTP id x13so13165303wgg.21
        for <linux-media@vger.kernel.org>; Tue, 04 Feb 2014 12:26:45 -0800 (PST)
Received: from [192.168.1.100] (188.28.136.71.threembb.co.uk. [188.28.136.71])
        by mx.google.com with ESMTPSA id q2sm55337986wjq.0.2014.02.04.12.26.43
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 04 Feb 2014 12:26:44 -0800 (PST)
Message-ID: <1391545594.11112.25.camel@canaries32-MCP7A>
Subject: [PATCH 1/2] m88rs2000: add caps FE_CAN_INVERSION_AUTO
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 04 Feb 2014 20:26:34 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This frontend is always auto inversion.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # v3.9+
---
 drivers/media/dvb-frontends/m88rs2000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index b235146..ee2fec8 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -746,7 +746,7 @@ static struct dvb_frontend_ops m88rs2000_ops = {
 		.symbol_rate_tolerance	= 500,	/* ppm */
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		      FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
-		      FE_CAN_QPSK |
+		      FE_CAN_QPSK | FE_CAN_INVERSION_AUTO |
 		      FE_CAN_FEC_AUTO
 	},
 
-- 
1.9.rc1




