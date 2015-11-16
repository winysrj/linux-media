Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbKPKVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/16] stb6100: get rid of tuner_state at struct stb6100_state
Date: Mon, 16 Nov 2015 08:21:06 -0200
Message-Id: <811ff75eeffa249b374643ae24c4dc907d127be5.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The stb6100 driver has a struct tuner_state on its state
struct, that it is used only to store the bandwidth. Even so,
this struct is not really used, as every time the bandwidth
is get or set, it goes through the hardware.

So, get rid of that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/stb6100.c | 9 ++++-----
 drivers/media/dvb-frontends/stb6100.h | 1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index e7f8d2c55565..5d8dbde03249 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -252,6 +252,7 @@ static int stb6100_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 {
 	int rc;
 	u8 f;
+	u32 bw;
 	struct stb6100_state *state = fe->tuner_priv;
 
 	rc = stb6100_read_reg(state, STB6100_F);
@@ -259,9 +260,9 @@ static int stb6100_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 		return rc;
 	f = rc & STB6100_F_F;
 
-	state->status.bandwidth = (f + 5) * 2000;	/* x2 for ZIF	*/
+	bw = (f + 5) * 2000;	/* x2 for ZIF	*/
 
-	*bandwidth = state->bandwidth = state->status.bandwidth * 1000;
+	*bandwidth = state->bandwidth = bw * 1000;
 	dprintk(verbose, FE_DEBUG, 1, "bandwidth = %u Hz", state->bandwidth);
 	return 0;
 }
@@ -495,15 +496,13 @@ static int stb6100_sleep(struct dvb_frontend *fe)
 static int stb6100_init(struct dvb_frontend *fe)
 {
 	struct stb6100_state *state = fe->tuner_priv;
-	struct tuner_state *status = &state->status;
 	int refclk = 27000000; /* Hz */
 
 	/*
 	 * iqsense = 1
 	 * tunerstep = 125000
 	 */
-	status->bandwidth	= 36000;	/* kHz	*/
-	state->bandwidth	= status->bandwidth * 1000;	/* Hz	*/
+	state->bandwidth	= 36000000;	/* Hz	*/
 	state->reference	= refclk / 1000;	/* kHz	*/
 
 	/* Set default bandwidth. Modified, PN 13-May-10	*/
diff --git a/drivers/media/dvb-frontends/stb6100.h b/drivers/media/dvb-frontends/stb6100.h
index 218c8188865d..f7b468b6dc26 100644
--- a/drivers/media/dvb-frontends/stb6100.h
+++ b/drivers/media/dvb-frontends/stb6100.h
@@ -86,7 +86,6 @@ struct stb6100_state {
 	const struct stb6100_config	*config;
 	struct dvb_tuner_ops		ops;
 	struct dvb_frontend		*frontend;
-	struct tuner_state		status;
 
 	u32 frequency;
 	u32 srate;
-- 
2.5.0

