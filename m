Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:42624 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3L1RAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 12:00:50 -0500
Received: by mail-we0-f176.google.com with SMTP id p61so8873517wes.21
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 09:00:49 -0800 (PST)
Received: from [192.168.1.100] (188.29.109.137.threembb.co.uk. [188.29.109.137])
        by mx.google.com with ESMTPSA id dd3sm21794713wjb.9.2013.12.28.09.00.46
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sat, 28 Dec 2013 09:00:47 -0800 (PST)
Message-ID: <1388250040.5893.1.camel@canaries32-MCP7A>
Subject: [PATCH 1/3] m88rs2000: correct read status lock value.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 28 Dec 2013 17:00:40 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The correct lock values is when bits of the value 0xee are set.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 02699c1..f9d04db 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -469,7 +469,7 @@ static int m88rs2000_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	*status = 0;
 
-	if ((reg & 0x7) == 0x7) {
+	if ((reg & 0xee) == 0xee) {
 		*status = FE_HAS_CARRIER | FE_HAS_SIGNAL | FE_HAS_VITERBI
 			| FE_HAS_SYNC | FE_HAS_LOCK;
 		if (state->config->set_ts_params)
@@ -677,7 +677,7 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 
 	for (i = 0; i < 25; i++) {
 		reg = m88rs2000_readreg(state, 0x8c);
-		if ((reg & 0x7) == 0x7) {
+		if ((reg & 0xee) == 0xee) {
 			status = FE_HAS_LOCK;
 			break;
 		}
-- 
1.8.5.2

