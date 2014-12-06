Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35921 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbaLFVfR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:17 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/22] si2168: define symbol rate limits
Date: Sat,  6 Dec 2014 23:34:35 +0200
Message-Id: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

w_scan complains about missing symbol rate limits:
This dvb driver is *buggy*: the symbol rate limits are undefined - please report to linuxtv.org

Chip supports 1 to 7.2 MSymbol/s on DVB-C.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index ce9ab44..acf0fc3 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -635,6 +635,8 @@ static const struct dvb_frontend_ops si2168_ops = {
 	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
 		.name = "Silicon Labs Si2168",
+		.symbol_rate_min = 1000000,
+		.symbol_rate_max = 7200000,
 		.caps =	FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
-- 
http://palosaari.fi/

