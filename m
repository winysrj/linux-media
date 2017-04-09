Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34902 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752586AbdDITin (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:43 -0400
Received: by mail-wr0-f196.google.com with SMTP id t20so26640548wra.2
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:42 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 12/19] [media] dvb-frontends/cxd2841er: make lock wait in set_fe_tc() optional
Date: Sun,  9 Apr 2017 21:38:21 +0200
Message-Id: <20170409193828.18458-13-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Don't wait for FE_HAS_LOCK in set_frontend_tc() and thus don't hammer the
lock status register with inquiries when CXD2841ER_NO_WAIT_LOCK is set
in the configuration, which also unneccessarily blocks applications until
a TS LOCK has been acquired. Rather, API and applications will check for
a TS LOCK by utilising the tune fe_op, read_status and get_frontend ops,
which is sufficient.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 4 ++++
 drivers/media/dvb-frontends/cxd2841er.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 894cb5a..67d4399 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3460,6 +3460,10 @@ static int cxd2841er_set_frontend_tc(struct dvb_frontend *fe)
 		cxd2841er_tuner_set(fe);
 
 	cxd2841er_tune_done(priv);
+
+	if (priv->flags & CXD2841ER_NO_WAIT_LOCK)
+		goto done;
+
 	timeout = 2500;
 	while (timeout > 0) {
 		ret = cxd2841er_read_status_tc(fe, &status);
diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
index 061e551..d77b59f 100644
--- a/drivers/media/dvb-frontends/cxd2841er.h
+++ b/drivers/media/dvb-frontends/cxd2841er.h
@@ -29,6 +29,7 @@
 #define CXD2841ER_TS_SERIAL	4	/* bit 2 */
 #define CXD2841ER_ASCOT		8	/* bit 3 */
 #define CXD2841ER_EARLY_TUNE	16	/* bit 4 */
+#define CXD2841ER_NO_WAIT_LOCK	32	/* bit 5 */
 
 enum cxd2841er_xtal {
 	SONY_XTAL_20500, /* 20.5 MHz */
-- 
2.10.2
