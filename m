Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbcEJFk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 01:40:29 -0400
From: Colin King <colin.king@canonical.com>
To: kernel-tram@lists.ubuntu.com,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] m88rs2000: initialize status to zero
Date: Tue, 10 May 2016 06:40:22 +0100
Message-Id: <1462858822-14803-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

status is not initialized so it can contain garbage. The
check for status containing the FE_HAS_LOCK bit may randomly pass
or fail if the read of register 0x8c fails to set status after 25
read attempts.  Fix this by initializing status to 0.

Issue found with CoverityScan, CID#986738

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index a09b123..ef79a4e 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -609,7 +609,7 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 {
 	struct m88rs2000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	enum fe_status status;
+	enum fe_status status = 0;
 	int i, ret = 0;
 	u32 tuner_freq;
 	s16 offset = 0;
-- 
2.8.1

