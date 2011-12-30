Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9QXe024163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 17/94] [media] dib9000: remove unused parameters
Date: Fri, 30 Dec 2011 13:07:14 -0200
Message-Id: <1325257711-12274-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dib9000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 4d82a4a..0488068 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -1136,7 +1136,7 @@ static int dib9000_fw_init(struct dib9000_state *state)
 	return 0;
 }
 
-static void dib9000_fw_set_channel_head(struct dib9000_state *state, struct dvb_frontend_parameters *ch)
+static void dib9000_fw_set_channel_head(struct dib9000_state *state)
 {
 	u8 b[9];
 	u32 freq = state->fe[0]->dtv_property_cache.frequency / 1000;
@@ -1157,7 +1157,7 @@ static void dib9000_fw_set_channel_head(struct dib9000_state *state, struct dvb_
 	dib9000_risc_mem_write(state, FE_MM_W_CHANNEL_HEAD, b);
 }
 
-static int dib9000_fw_get_channel(struct dvb_frontend *fe, struct dvb_frontend_parameters *channel)
+static int dib9000_fw_get_channel(struct dvb_frontend *fe)
 {
 	struct dib9000_state *state = fe->demodulator_priv;
 	struct dibDVBTChannel {
@@ -1462,7 +1462,7 @@ static int dib9000_fw_tune(struct dvb_frontend *fe, struct dvb_frontend_paramete
 
 	switch (state->tune_state) {
 	case CT_DEMOD_START:
-		dib9000_fw_set_channel_head(state, ch);
+		dib9000_fw_set_channel_head(state);
 
 		/* write the channel context - a channel is initialized to 0, so it is OK */
 		dib9000_risc_mem_write(state, FE_MM_W_CHANNEL_CONTEXT, (u8 *) fe_info);
@@ -1911,7 +1911,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 	}
 
 	/* get the channel from master chip */
-	ret = dib9000_fw_get_channel(fe, fep);
+	ret = dib9000_fw_get_channel(fe);
 	if (ret != 0)
 		goto return_value;
 
-- 
1.7.8.352.g876a6

