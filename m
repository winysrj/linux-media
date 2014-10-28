Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46277 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 10/13] [media] lbdt3306a: remove uneeded braces
Date: Tue, 28 Oct 2014 13:00:45 -0200
Message-Id: <00513c9903dfe4aa22ecf5ac6b275e9c9796daa5.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WARNING: braces {} are not necessary for any arm of this statement
+		if (ret == 0) {
[...]
+		} else {
[...]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 38b64b2c745c..9c80d4c26381 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1518,11 +1518,10 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	if (fe->ops.tuner_ops.get_rf_strength) {
 		ret = fe->ops.tuner_ops.get_rf_strength(fe, &strength);
-		if (ret == 0) {
+		if (ret == 0)
 			dbg_info("strength=%d\n", strength);
-		} else {
+		else
 			dbg_info("fe->ops.tuner_ops.get_rf_strength() failed\n");
-		}
 	}
 
 	*status = 0;
-- 
1.9.3

