Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44308
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751787AbdINLo1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 07:44:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [RFC 2/5] media: stv6110: get rid of get_property hack
Date: Thu, 14 Sep 2017 08:44:19 -0300
Message-Id: <ce5a9dfb578aa063750f1a20ee247b452a08944e.1505389446.git.mchehab@s-opensource.com>
In-Reply-To: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
References: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
In-Reply-To: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
References: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason why it would hardcode symbol rate to 15MBaud
if get_property ops is not defined.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/stv6110.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index e4fd9c1b0560..5b096fab0511 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -273,11 +273,8 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 				((((priv->mclk / 1000000) - 16) & 0x1f) << 3);
 
 	/* BB_GAIN = db/2 */
-	if (fe->ops.set_property && fe->ops.get_property) {
-		srate = c->symbol_rate;
-		dprintk("%s: Get Frontend parameters: srate=%d\n",
-							__func__, srate);
-	} else
+	srate = c->symbol_rate;
+	if (!srate)
 		srate = 15000000;
 
 	priv->regs[RSTV6110_CTRL2] &= ~0x0f;
-- 
2.13.5
