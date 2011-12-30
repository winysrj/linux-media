Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9QrY026524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 12/94] [media] cx23123: remove an unused argument from cx24123_pll_writereg()
Date: Fri, 30 Dec 2011 13:07:09 -0200
Message-Id: <1325257711-12274-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx24123_pll_writereg doesn't use dvb_frontend_parameters. Just
remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/cx24123.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index 96f99a8..4dfe786 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -601,8 +601,7 @@ static int cx24123_pll_calculate(struct dvb_frontend *fe,
  * Tuner cx24109 is written through a dedicated 3wire interface
  * on the demod chip.
  */
-static int cx24123_pll_writereg(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p, u32 data)
+static int cx24123_pll_writereg(struct dvb_frontend *fe, u32 data)
 {
 	struct cx24123_state *state = fe->demodulator_priv;
 	unsigned long timeout;
@@ -673,12 +672,12 @@ static int cx24123_pll_tune(struct dvb_frontend *fe,
 	}
 
 	/* Write the new VCO/VGA */
-	cx24123_pll_writereg(fe, p, state->VCAarg);
-	cx24123_pll_writereg(fe, p, state->VGAarg);
+	cx24123_pll_writereg(fe, state->VCAarg);
+	cx24123_pll_writereg(fe, state->VGAarg);
 
 	/* Write the new bandselect and pll args */
-	cx24123_pll_writereg(fe, p, state->bandselectarg);
-	cx24123_pll_writereg(fe, p, state->pllarg);
+	cx24123_pll_writereg(fe, state->bandselectarg);
+	cx24123_pll_writereg(fe, state->pllarg);
 
 	/* set the FILTUNE voltage */
 	val = cx24123_readreg(state, 0x28) & ~0x3;
-- 
1.7.8.352.g876a6

