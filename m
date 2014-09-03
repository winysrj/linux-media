Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 45/46] [media] mxl5005s: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:17 -0300
Message-Id: <c283643d5c1d9b7e7b4d07c11632e6fd0bd11e66.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index b473b76cb278..92a3be4fde87 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -1692,7 +1692,6 @@ static u16 MXL5005_TunerConfig(struct dvb_frontend *fe,
 	)
 {
 	struct mxl5005s_state *state = fe->tuner_priv;
-	u16 status = 0;
 
 	state->Mode = Mode;
 	state->IF_Mode = IF_mode;
@@ -1715,7 +1714,7 @@ static u16 MXL5005_TunerConfig(struct dvb_frontend *fe,
 	/* Synthesizer LO frequency calculation */
 	MXL_SynthIFLO_Calc(fe);
 
-	return status;
+	return 0;
 }
 
 static void MXL_SynthIFLO_Calc(struct dvb_frontend *fe)
-- 
1.9.3

