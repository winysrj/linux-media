Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45217 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbbCSOXL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 10:23:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] mn88472: define symbol rate limits
Date: Thu, 19 Mar 2015 16:23:03 +0200
Message-Id: <1426774983-13741-2-git-send-email-crope@iki.fi>
In-Reply-To: <1426774983-13741-1-git-send-email-crope@iki.fi>
References: <1426774983-13741-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

w_scan complains about missing symbol rate limits:
This dvb driver is *buggy*: the symbol rate limits are undefined - please report to linuxtv.org

Lets add some reasonable limits in order to keep w_scan happy :)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/mn88472/mn88472.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index c041fbf..8c9fefa 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -378,6 +378,8 @@ static struct dvb_frontend_ops mn88472_ops = {
 	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
 		.name = "Panasonic MN88472",
+		.symbol_rate_min = 1000000,
+		.symbol_rate_max = 7200000,
 		.caps =	FE_CAN_FEC_1_2                 |
 			FE_CAN_FEC_2_3                 |
 			FE_CAN_FEC_3_4                 |
-- 
http://palosaari.fi/

