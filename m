Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49877
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751171AbdIOJLI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 05:11:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH 1/5] media: stv0288: get rid of set_property boilerplate
Date: Fri, 15 Sep 2017 06:10:57 -0300
Message-Id: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver doesn't implement support for set_property(). Yet,
it implements a boilerplate for it. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/stv0288.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index 45cbc898ad25..67f91814b9f7 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -447,12 +447,6 @@ static int stv0288_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int stv0288_set_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
 static int stv0288_set_frontend(struct dvb_frontend *fe)
 {
 	struct stv0288_state *state = fe->demodulator_priv;
@@ -567,7 +561,6 @@ static const struct dvb_frontend_ops stv0288_ops = {
 	.set_tone = stv0288_set_tone,
 	.set_voltage = stv0288_set_voltage,
 
-	.set_property = stv0288_set_property,
 	.set_frontend = stv0288_set_frontend,
 };
 
-- 
2.13.5
