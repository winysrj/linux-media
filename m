Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35053 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbbCSOXK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 10:23:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] mn88473: define symbol rate limits
Date: Thu, 19 Mar 2015 16:23:02 +0200
Message-Id: <1426774983-13741-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

w_scan complains about missing symbol rate limits:
This dvb driver is *buggy*: the symbol rate limits are undefined - please report to linuxtv.org

Lets add some reasonable limits in order to keep w_scan happy :)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/mn88473/mn88473.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index 196fcd6..f9f418f 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -342,6 +342,8 @@ static struct dvb_frontend_ops mn88473_ops = {
 	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_AC},
 	.info = {
 		.name = "Panasonic MN88473",
+		.symbol_rate_min = 1000000,
+		.symbol_rate_max = 7200000,
 		.caps =	FE_CAN_FEC_1_2                 |
 			FE_CAN_FEC_2_3                 |
 			FE_CAN_FEC_3_4                 |
-- 
http://palosaari.fi/

