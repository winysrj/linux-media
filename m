Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbaICWoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 18:44:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/5] [media] drxk_hard: fix bad alignments
Date: Wed,  3 Sep 2014 19:43:55 -0300
Message-Id: <89fffac802c18caebdf4e91c0785b522c9f6399a.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drxk_hard.c:2224:3-22: code aligned with following code on line 2227

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 88182c18e186..672195147d01 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -2220,12 +2220,13 @@ static int set_agc_rf(struct drxk_state *state,
 		}
 
 		/* Set TOP, only if IF-AGC is in AUTO mode */
-		if (p_if_agc_settings->ctrl_mode == DRXK_AGC_CTRL_AUTO)
+		if (p_if_agc_settings->ctrl_mode == DRXK_AGC_CTRL_AUTO) {
 			status = write16(state,
 					 SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A,
 					 p_agc_cfg->top);
 			if (status < 0)
 				goto error;
+		}
 
 		/* Cut-Off current */
 		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A,
-- 
1.9.3

