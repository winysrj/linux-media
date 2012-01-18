Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58910 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab2ARR5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 12:57:47 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] cxd2820r: fix dvb_frontend_ops
Date: Wed, 18 Jan 2012 19:57:33 +0200
Message-Id: <1326909453-12367-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix bug introduced by multi-frontend to single-frontend change.

* Add missing DVB-C caps
* Change frontend name as single frontend does all the standards

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/cxd2820r_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index caae7f7..5fe591d 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -562,7 +562,7 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 	.delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
 	/* default: DVB-T/T2 */
 	.info = {
-		.name = "Sony CXD2820R (DVB-T/T2)",
+		.name = "Sony CXD2820R",
 
 		.caps =	FE_CAN_FEC_1_2			|
 			FE_CAN_FEC_2_3			|
@@ -572,7 +572,9 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 			FE_CAN_FEC_AUTO			|
 			FE_CAN_QPSK			|
 			FE_CAN_QAM_16			|
+			FE_CAN_QAM_32			|
 			FE_CAN_QAM_64			|
+			FE_CAN_QAM_128			|
 			FE_CAN_QAM_256			|
 			FE_CAN_QAM_AUTO			|
 			FE_CAN_TRANSMISSION_MODE_AUTO	|
-- 
1.7.4.4

