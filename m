Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1L3PJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:30 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Ttd009129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 52/94] [media] stb6100: use get_frontend, instead of get_frontend_legacy()
Date: Fri, 30 Dec 2011 13:07:49 -0200
Message-Id: <1325257711-12274-53-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/stb6100.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb6100.c b/drivers/media/dvb/frontends/stb6100.c
index 7f68fd3..a566763 100644
--- a/drivers/media/dvb/frontends/stb6100.c
+++ b/drivers/media/dvb/frontends/stb6100.c
@@ -327,7 +327,7 @@ static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 	int rc;
 	const struct stb6100_lkup *ptr;
 	struct stb6100_state *state = fe->tuner_priv;
-	struct dvb_frontend_parameters p;
+	struct dtv_frontend_properties p;
 
 	u32 srate = 0, fvco, nint, nfrac;
 	u8 regs[STB6100_NUMREGS];
@@ -335,11 +335,11 @@ static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 
 	dprintk(verbose, FE_DEBUG, 1, "Version 2010-8-14 13:51");
 
-	if (fe->ops.get_frontend_legacy) {
+	if (fe->ops.get_frontend) {
 		dprintk(verbose, FE_DEBUG, 1, "Get frontend parameters");
-		fe->ops.get_frontend_legacy(fe, &p);
+		fe->ops.get_frontend(fe, &p);
 	}
-	srate = p.u.qpsk.symbol_rate;
+	srate = p.symbol_rate;
 
 	/* Set up tuner cleanly, LPF calibration on */
 	rc = stb6100_write_reg(state, STB6100_FCCK, 0x4d | STB6100_FCCK_FCCK);
-- 
1.7.8.352.g876a6

