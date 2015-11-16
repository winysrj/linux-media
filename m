Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbbKPKVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/16] tda6655: get rid of get_state()/set_state()
Date: Mon, 16 Nov 2015 08:21:10 -0200
Message-Id: <afda57f7a21175b247531ecc5ced01b003173b42.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those ops aren't used by any driver, with is weird. I suspect
that mantis_vb3030 driver were not working properly...

Anyway, now that the driver uses the set_parms, the DVB
frontend core should do the right thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/tda665x.c | 36 -----------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 6ced688c3264..82f8cc534f33 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -66,28 +66,6 @@ exit:
 	return err;
 }
 
-static int tda665x_get_state(struct dvb_frontend *fe,
-			     enum tuner_param param,
-			     struct tuner_state *tstate)
-{
-	struct tda665x_state *state = fe->tuner_priv;
-	int err = 0;
-
-	switch (param) {
-	case DVBFE_TUNER_FREQUENCY:
-		tstate->frequency = state->frequency;
-		break;
-	case DVBFE_TUNER_BANDWIDTH:
-		break;
-	default:
-		printk(KERN_ERR "%s: Unknown parameter (param=%d)\n", __func__, param);
-		err = -EINVAL;
-		break;
-	}
-
-	return err;
-}
-
 static int tda665x_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tda665x_state *state = fe->tuner_priv;
@@ -219,17 +197,6 @@ static int tda665x_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int tda665x_set_state(struct dvb_frontend *fe,
-			     enum tuner_param param,
-			     struct tuner_state *tstate)
-{
-	if (param & DVBFE_TUNER_FREQUENCY)
-		return  tda665x_set_frequency(fe, tstate->frequency);
-
-	printk(KERN_ERR "%s: Unknown parameter (param=%d)\n", __func__, param);
-	return -EINVAL;
-}
-
 static int tda665x_release(struct dvb_frontend *fe)
 {
 	struct tda665x_state *state = fe->tuner_priv;
@@ -240,9 +207,6 @@ static int tda665x_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_tuner_ops tda665x_ops = {
-
-	.set_state	= tda665x_set_state,
-	.get_state	= tda665x_get_state,
 	.get_status	= tda665x_get_status,
 	.set_params	= tda665x_set_params,
 	.get_frequency	= tda665x_get_frequency,
-- 
2.5.0

