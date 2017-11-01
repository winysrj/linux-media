Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52520 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933280AbdKAVGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH v2 22/26] [RFC] media: cxd2841er: ensure that status will always be available
Date: Wed,  1 Nov 2017 17:05:59 -0400
Message-Id: <36d7bfe208024f2301c2d2b31dcf5d995d162b18.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The loop with read status use a dynamic timeout value, calculated
from symbol rate. It should run the loop at least one time for
the status to be handled after the loop.

While this should, in practice, happen every time, it doesn't
hurt to change the logic to make it explicit.

This solves a smatch warning:
	drivers/media/dvb-frontends/cxd2841er.c:3350 cxd2841er_set_frontend_s() error: uninitialized symbol 'status'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

---

On a separate note, it looks weird to have something there waiting
for lock. This should happen on userspace, except if there are
some bugs at the hardware that prevent it to work otherwise.
---
 drivers/media/dvb-frontends/cxd2841er.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 48ee9bc00c06..98e40b7adad5 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3340,13 +3340,17 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
 
 	cxd2841er_tune_done(priv);
 	timeout = ((3000000 + (symbol_rate - 1)) / symbol_rate) + 150;
-	for (i = 0; i < timeout / CXD2841ER_DVBS_POLLING_INVL; i++) {
+
+	i = 0;
+	do {
 		usleep_range(CXD2841ER_DVBS_POLLING_INVL*1000,
 			(CXD2841ER_DVBS_POLLING_INVL + 2) * 1000);
 		cxd2841er_read_status_s(fe, &status);
 		if (status & FE_HAS_LOCK)
 			break;
-	}
+		i++;
+	} while (i < timeout / CXD2841ER_DVBS_POLLING_INVL);
+
 	if (status & FE_HAS_LOCK) {
 		if (cxd2841er_get_carrier_offset_s_s2(
 				priv, &carr_offset)) {
-- 
2.13.6
