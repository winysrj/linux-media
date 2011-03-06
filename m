Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64624 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1CFNka (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 08:40:30 -0500
Date: Sun, 6 Mar 2011 16:40:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [media] stv0367: signedness bug in
 stv0367_get_tuner_freq()
Message-ID: <20110306134011.GO3416@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We use err to store negative error codes so it should be signed.  And
if we return an error from stv0367_get_tuner_freq() that needs to be
handled properly as well.  (param->frequency is a u32).

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index eecdf23..7117ce9 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -913,7 +913,7 @@ static u32 stv0367_get_tuner_freq(struct dvb_frontend *fe)
 	struct dvb_frontend_ops	*frontend_ops = NULL;
 	struct dvb_tuner_ops	*tuner_ops = NULL;
 	u32 freq = 0;
-	u32 err = 0;
+	int err = 0;
 
 	dprintk("%s:\n", __func__);
 
diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index ec9de40..1304618 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -1940,7 +1940,7 @@ static int stv0367ter_get_frontend(struct dvb_frontend *fe,
 	int constell = 0,/* snr = 0,*/ Data = 0;
 
 	param->frequency = stv0367_get_tuner_freq(fe);
-	if (param->frequency < 0)
+	if ((int)param->frequency < 0)
 		param->frequency = c->frequency;
 
 	constell = stv0367_readbits(state, F367TER_TPS_CONST);
