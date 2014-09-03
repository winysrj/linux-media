Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781AbaICWoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 18:44:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/5] [media] drxd_hard: fix bad alignments
Date: Wed,  3 Sep 2014 19:43:54 -0300
Message-Id: <cea130021448763b15f4b16af184bbab4be118fb.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by cocinelle:

drivers/media/dvb-frontends/drxd_hard.c:2632:3-51: code aligned with following code on line 2633

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index ae2276db77bc..961641b67728 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2628,10 +2628,11 @@ static int DRXD_init(struct drxd_state *state, const u8 *fw, u32 fw_size)
 			break;
 
 		/* Apply I2c address patch to B1 */
-		if (!state->type_A && state->m_HiI2cPatch != NULL)
+		if (!state->type_A && state->m_HiI2cPatch != NULL) {
 			status = WriteTable(state, state->m_HiI2cPatch);
 			if (status < 0)
 				break;
+		}
 
 		if (state->type_A) {
 			/* HI firmware patch for UIO readout,
-- 
1.9.3

