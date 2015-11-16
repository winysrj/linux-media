Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbKPKVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/16] [media] tda666x: add support for set_parms() and get_frequency()
Date: Mon, 16 Nov 2015 08:21:08 -0200
Message-Id: <4b5cfb2f91ad08bd6eead44aaa072472b3ac61c4.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two callbacks are the ones that should be used by normal
DVB frontend drivers.

Add support for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/tda665x.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 9c892533e6a7..6ced688c3264 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -88,6 +88,15 @@ static int tda665x_get_state(struct dvb_frontend *fe,
 	return err;
 }
 
+static int tda665x_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct tda665x_state *state = fe->tuner_priv;
+
+	*frequency = state->frequency;
+
+	return 0;
+}
+
 static int tda665x_get_status(struct dvb_frontend *fe, u32 *status)
 {
 	struct tda665x_state *state = fe->tuner_priv;
@@ -201,6 +210,15 @@ exit:
 	return err;
 }
 
+static int tda665x_set_params(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	tda665x_set_frequency(fe, c->frequency);
+
+	return 0;
+}
+
 static int tda665x_set_state(struct dvb_frontend *fe,
 			     enum tuner_param param,
 			     struct tuner_state *tstate)
@@ -226,6 +244,8 @@ static struct dvb_tuner_ops tda665x_ops = {
 	.set_state	= tda665x_set_state,
 	.get_state	= tda665x_get_state,
 	.get_status	= tda665x_get_status,
+	.set_params	= tda665x_set_params,
+	.get_frequency	= tda665x_get_frequency,
 	.release	= tda665x_release
 };
 
-- 
2.5.0

