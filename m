Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39275 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754364AbeCGKNl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 05:13:41 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Subject: [PATCH 3/3] media: cxd2880: remove unused vars
Date: Wed,  7 Mar 2018 05:13:36 -0500
Message-Id: <8239bac18a760249c800eb032acc3f66cba8df04.1520417613.git.mchehab@s-opensource.com>
In-Reply-To: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
References: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
In-Reply-To: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
References: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/cxd2880/cxd2880_top.c: In function ‘cxd2880_set_ber_per_period_t’:
drivers/media/dvb-frontends/cxd2880/cxd2880_top.c:677:34: warning: variable ‘c’ set but not used [-Wunused-but-set-variable]
  struct dtv_frontend_properties *c;
                                  ^
drivers/media/dvb-frontends/cxd2880/cxd2880_top.c: In function ‘cxd2880_set_ber_per_period_t2’:
drivers/media/dvb-frontends/cxd2880/cxd2880_top.c:790:34: warning: variable ‘c’ set but not used [-Wunused-but-set-variable]
  struct dtv_frontend_properties *c;
                                  ^
drivers/media/dvb-frontends/cxd2880/cxd2880_top.c: In function ‘cxd2880_get_frontend’:
drivers/media/dvb-frontends/cxd2880/cxd2880_top.c:1799:23: warning: variable ‘priv’ set but not used [-Wunused-but-set-variable]
  struct cxd2880_priv *priv = NULL;
                       ^~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
index 05360a11bea9..d474dc1b05da 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
@@ -674,7 +674,6 @@ static int cxd2880_read_ber(struct dvb_frontend *fe, u32 *ber)
 static int cxd2880_set_ber_per_period_t(struct dvb_frontend *fe)
 {
 	int ret;
-	struct dtv_frontend_properties *c;
 	struct cxd2880_priv *priv;
 	struct cxd2880_dvbt_tpsinfo info;
 	enum cxd2880_dtv_bandwidth bw = CXD2880_DTV_BW_1_7_MHZ;
@@ -691,7 +690,6 @@ static int cxd2880_set_ber_per_period_t(struct dvb_frontend *fe)
 	}
 
 	priv = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
 	bw = priv->dvbt_tune_param.bandwidth;
 
 	ret = cxd2880_tnrdmd_dvbt_mon_tps_info(&priv->tnrdmd,
@@ -787,7 +785,6 @@ static int cxd2880_set_ber_per_period_t(struct dvb_frontend *fe)
 static int cxd2880_set_ber_per_period_t2(struct dvb_frontend *fe)
 {
 	int ret;
-	struct dtv_frontend_properties *c;
 	struct cxd2880_priv *priv;
 	struct cxd2880_dvbt2_l1pre l1pre;
 	struct cxd2880_dvbt2_l1post l1post;
@@ -815,7 +812,6 @@ static int cxd2880_set_ber_per_period_t2(struct dvb_frontend *fe)
 	}
 
 	priv = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
 	bw = priv->dvbt2_tune_param.bandwidth;
 
 	ret = cxd2880_tnrdmd_dvbt2_mon_l1_pre(&priv->tnrdmd, &l1pre);
@@ -1796,7 +1792,6 @@ static int cxd2880_get_frontend_t2(struct dvb_frontend *fe,
 static int cxd2880_get_frontend(struct dvb_frontend *fe,
 				struct dtv_frontend_properties *props)
 {
-	struct cxd2880_priv *priv = NULL;
 	int ret;
 
 	if (!fe || !props) {
@@ -1804,8 +1799,6 @@ static int cxd2880_get_frontend(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	priv = fe->demodulator_priv;
-
 	pr_debug("system=%d\n", fe->dtv_property_cache.delivery_system);
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
-- 
2.14.3
