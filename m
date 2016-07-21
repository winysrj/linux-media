Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:38230
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbcGUN4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 09:56:32 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media] cxd2841er: force 8MHz bandwidth for DVB-C if specified bw not supported
Date: Thu, 21 Jul 2016 09:56:25 -0400
Message-Id: <1469109385-3881-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if specified DVB-C bandwidth not supported then force 8MHz.
Should work for most cases.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 3df0604..10608a9 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -2763,6 +2763,14 @@ static int cxd2841er_sleep_tc_to_active_c_band(struct cxd2841er_priv *priv,
 	u8 b10_b6[3];
 	u32 iffreq;
 
+	if (bandwidth != 6000000 &&
+			bandwidth != 7000000 &&
+			bandwidth != 8000000) {
+		dev_info(&priv->i2c->dev, "%s(): unsupported bandwidth %d. Forcing 8Mhz!\n",
+				__func__, bandwidth);
+		bandwidth = 8000000;
+	}
+
 	dev_dbg(&priv->i2c->dev, "%s() bw=%d\n", __func__, bandwidth);
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
 	switch (bandwidth) {
-- 
2.7.4

