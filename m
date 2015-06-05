Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbbFEO2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/11] [media] dib0090: Remove a dead code
Date: Fri,  5 Jun 2015 11:27:37 -0300
Message-Id: <9953b067e2ba933274a091cf8294b40eb602fa36.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/dvb-frontends/dib0090.c:1710 dib0090_dc_offset_calibration() warn: missing break? reassigning '*tune_state'

There's no need to change tune_state there, as the fall though code
will change it again to another state. So, simplify it by
removing the dead code.

While here, fix a typo:
	Sart => Start

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 68e2af2650d3..47cb72243b9d 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -1696,12 +1696,10 @@ static int dib0090_dc_offset_calibration(struct dib0090_state *state, enum front
 
 		if (state->identity.p1g)
 			state->dc = dc_p1g_table;
-		*tune_state = CT_TUNER_STEP_0;
 
 		/* fall through */
-
 	case CT_TUNER_STEP_0:
-		dprintk("Sart/continue DC calibration for %s path", (state->dc->i == 1) ? "I" : "Q");
+		dprintk("Start/continue DC calibration for %s path", (state->dc->i == 1) ? "I" : "Q");
 		dib0090_write_reg(state, 0x01, state->dc->bb1);
 		dib0090_write_reg(state, 0x07, state->bb7 | (state->dc->i << 7));
 
-- 
2.4.2

