Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:40115 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752396AbeDHRWR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 13:22:17 -0400
Received: by mail-pf0-f196.google.com with SMTP id y66so4321469pfi.7
        for <linux-media@vger.kernel.org>; Sun, 08 Apr 2018 10:22:16 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        crope@iki.fi
Subject: [PATCH v5 1/5] dvb-frontends/dvb-pll: add i2c driver support
Date: Mon,  9 Apr 2018 02:21:34 +0900
Message-Id: <20180408172138.9974-2-tskd08@gmail.com>
In-Reply-To: <20180408172138.9974-1-tskd08@gmail.com>
References: <20180408172138.9974-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

registers the module as an i2c driver,
but keeps dvb_pll_attach() untouched for compatibility.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v4:
- do not #define chip name constants

Changes since v3:
- use standard i2c_device_id instead of dvb_pll_config

 drivers/media/dvb-frontends/dvb-pll.c | 67 +++++++++++++++++++++++++++
 drivers/media/dvb-frontends/dvb-pll.h |  4 ++
 2 files changed, 71 insertions(+)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 5553b89b804..ff0f477276a 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -827,6 +827,73 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 }
 EXPORT_SYMBOL(dvb_pll_attach);
 
+
+static int
+dvb_pll_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct dvb_pll_config *cfg;
+	struct dvb_frontend *fe;
+	unsigned int desc_id;
+
+	cfg = client->dev.platform_data;
+	fe = cfg->fe;
+	i2c_set_clientdata(client, fe);
+	desc_id = (unsigned int) id->driver_data;
+
+	if (!dvb_pll_attach(fe, client->addr, client->adapter, desc_id))
+		return -ENOMEM;
+
+	dev_info(&client->dev, "DVB Simple Tuner attached.\n");
+	return 0;
+}
+
+static int dvb_pll_remove(struct i2c_client *client)
+{
+	struct dvb_frontend *fe;
+
+	fe = i2c_get_clientdata(client);
+	dvb_pll_release(fe);
+	return 0;
+}
+
+
+static const struct i2c_device_id dvb_pll_id[] = {
+	{"dtt7579",		DVB_PLL_THOMSON_DTT7579},
+	{"dtt759x",		DVB_PLL_THOMSON_DTT759X},
+	{"z201",		DVB_PLL_LG_Z201},
+	{"unknown_1",		DVB_PLL_UNKNOWN_1},
+	{"tua6010xs",		DVB_PLL_TUA6010XS},
+	{"env57h1xd5",		DVB_PLL_ENV57H1XD5},
+	{"tua6034",		DVB_PLL_TUA6034},
+	{"tda665x",		DVB_PLL_TDA665X},
+	{"tded4",		DVB_PLL_TDED4},
+	{"tdhu2",		DVB_PLL_TDHU2},
+	{"tbmv",		DVB_PLL_SAMSUNG_TBMV},
+	{"sd1878_tda8261",	DVB_PLL_PHILIPS_SD1878_TDA8261},
+	{"opera1",		DVB_PLL_OPERA1},
+	{"dtos403ih102a",	DVB_PLL_SAMSUNG_DTOS403IH102A},
+	{"tdtc9251dh0",		DVB_PLL_SAMSUNG_TDTC9251DH0},
+	{"tbdu18132",		DVB_PLL_SAMSUNG_TBDU18132},
+	{"tbmu24112",		DVB_PLL_SAMSUNG_TBMU24112},
+	{"tdee4",		DVB_PLL_TDEE4},
+	{"dtt7520x",		DVB_PLL_THOMSON_DTT7520X},
+	{}
+};
+
+
+MODULE_DEVICE_TABLE(i2c, dvb_pll_id);
+
+static struct i2c_driver dvb_pll_driver = {
+	.driver = {
+		.name = "dvb_pll",
+	},
+	.probe    = dvb_pll_probe,
+	.remove   = dvb_pll_remove,
+	.id_table = dvb_pll_id,
+};
+
+module_i2c_driver(dvb_pll_driver);
+
 MODULE_DESCRIPTION("dvb pll library");
 MODULE_AUTHOR("Gerd Knorr");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index ca885e71d2f..101537ae4ef 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -30,6 +30,10 @@
 #define DVB_PLL_TDEE4		       18
 #define DVB_PLL_THOMSON_DTT7520X       19
 
+struct dvb_pll_config {
+	struct dvb_frontend *fe;
+};
+
 #if IS_REACHABLE(CONFIG_DVB_PLL)
 /**
  * Attach a dvb-pll to the supplied frontend structure.
-- 
2.17.0
