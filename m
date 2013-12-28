Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64547 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3L1RFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 12:05:05 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so8896437wgh.2
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 09:05:04 -0800 (PST)
Received: from [192.168.1.100] (188.29.109.137.threembb.co.uk. [188.29.109.137])
        by mx.google.com with ESMTPSA id fj8sm60691903wib.1.2013.12.28.09.05.03
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sat, 28 Dec 2013 09:05:03 -0800 (PST)
Message-ID: <1388250291.5893.5.camel@canaries32-MCP7A>
Subject: [PATCH 3/3] m88rs2000: Correct m88rs2000_get_fec
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 28 Dec 2013 17:04:51 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Value of fec is achieved by the upper nibble bits 6,7 & 8.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 002b109..b235146 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -581,18 +581,20 @@ static fe_code_rate_t m88rs2000_get_fec(struct m88rs2000_state *state)
 	reg = m88rs2000_readreg(state, 0x76);
 	m88rs2000_writereg(state, 0x9a, 0xb0);
 
+	reg &= 0xf0;
+	reg >>= 5;
+
 	switch (reg) {
-	case 0x88:
+	case 0x4:
 		return FEC_1_2;
-	case 0x68:
+	case 0x3:
 		return FEC_2_3;
-	case 0x48:
+	case 0x2:
 		return FEC_3_4;
-	case 0x28:
+	case 0x1:
 		return FEC_5_6;
-	case 0x18:
+	case 0x0:
 		return FEC_7_8;
-	case 0x08:
 	default:
 		break;
 	}
-- 
1.8.5.2


