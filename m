Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab1L3PJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:29 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9T5X009125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 51/94] [media] stb0899: convert get_frontend to the new struct
Date: Fri, 30 Dec 2011 13:07:48 -0200
Message-Id: <1325257711-12274-52-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/stb0899_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index 9fa31d5..0c47a99 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1589,13 +1589,13 @@ static int stb0899_track(struct dvb_frontend *fe, struct dvb_frontend_parameters
 	return 0;
 }
 
-static int stb0899_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int stb0899_get_frontend(struct dvb_frontend *fe, struct dtv_frontend_properties *p)
 {
 	struct stb0899_state *state		= fe->demodulator_priv;
 	struct stb0899_internal *internal	= &state->internal;
 
 	dprintk(state->verbose, FE_DEBUG, 1, "Get params");
-	p->u.qpsk.symbol_rate = internal->srate;
+	p->symbol_rate = internal->srate;
 
 	return 0;
 }
@@ -1648,7 +1648,7 @@ static struct dvb_frontend_ops stb0899_ops = {
 	.get_frontend_algo		= stb0899_frontend_algo,
 	.search				= stb0899_search,
 	.track				= stb0899_track,
-	.get_frontend_legacy = stb0899_get_frontend,
+	.get_frontend                   = stb0899_get_frontend,
 
 
 	.read_status			= stb0899_read_status,
-- 
1.7.8.352.g876a6

