Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0114.outbound.protection.outlook.com ([104.47.32.114]:20288
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751508AbeDZGgz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:36:55 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH 2/3] [media] cxd2880:Optimized spi drive current and BER/PER set/get condition
Date: Thu, 26 Apr 2018 15:41:29 +0900
Message-ID: <20180426064129.32161-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20180426063635.31923-1-Yasunari.Takiguchi@sony.com>
References: <20180426063635.31923-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the optimization for SPI drive current and 
signal lock condition check part for BER/PER measure
to ensure BER/PER are stable

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---

[Change list]
   drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
      -reduced the SPI output drive current
      -optimized signal lock condition check part for BER/PER measure
       to ensure BER/PER are stable

 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
index d474dc1b05da..bd9101e246d5 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
@@ -520,6 +520,15 @@ static int cxd2880_init(struct dvb_frontend *fe)
 		pr_err("cxd2880 integ init failed %d\n", ret);
 		return ret;
 	}
+
+	ret = cxd2880_tnrdmd_set_cfg(&priv->tnrdmd,
+				     CXD2880_TNRDMD_CFG_TSPIN_CURRENT,
+				     0x00);
+	if (ret) {
+		mutex_unlock(priv->spi_mutex);
+		pr_err("cxd2880 set config failed %d\n", ret);
+		return ret;
+	}
 	mutex_unlock(priv->spi_mutex);
 
 	pr_debug("OK.\n");
@@ -1126,7 +1135,7 @@ static int cxd2880_get_stats(struct dvb_frontend *fe,
 	priv = fe->demodulator_priv;
 	c = &fe->dtv_property_cache;
 
-	if (!(status & FE_HAS_LOCK)) {
+	if (!(status & FE_HAS_LOCK) || !(status & FE_HAS_CARRIER)) {
 		c->pre_bit_error.len = 1;
 		c->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		c->pre_bit_count.len = 1;
@@ -1345,7 +1354,8 @@ static int cxd2880_read_status(struct dvb_frontend *fe,
 
 	pr_debug("status %d\n", *status);
 
-	if (priv->s == 0 && (*status & FE_HAS_LOCK)) {
+	if (priv->s == 0 && (*status & FE_HAS_LOCK) &&
+	    (*status & FE_HAS_CARRIER)) {
 		mutex_lock(priv->spi_mutex);
 		if (c->delivery_system == SYS_DVBT) {
 			ret = cxd2880_set_ber_per_period_t(fe);
-- 
2.15.1
