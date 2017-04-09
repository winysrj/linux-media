Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34886 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbdDITih (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:37 -0400
Received: by mail-wr0-f194.google.com with SMTP id t20so26640429wra.2
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:37 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 06/19] [media] dvb-frontends/cxd2841er: add variable for configuration flags
Date: Sun,  9 Apr 2017 21:38:15 +0200
Message-Id: <20170409193828.18458-7-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Throughout the patch series some configuration flags will be added to the
demod driver. This patch prepares this by adding the flags var to
struct cxd2841er_config, which will serve as a bitmask to toggle various
options and behaviour in the driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 2 ++
 drivers/media/dvb-frontends/cxd2841er.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 6648bd1..f49a09b 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -65,6 +65,7 @@ struct cxd2841er_priv {
 	u8				system;
 	enum cxd2841er_xtal		xtal;
 	enum fe_caps caps;
+	u32				flags;
 };
 
 static const struct cxd2841er_cnr_data s_cn_data[] = {
@@ -3736,6 +3737,7 @@ static struct dvb_frontend *cxd2841er_attach(struct cxd2841er_config *cfg,
 	priv->i2c_addr_slvx = (cfg->i2c_addr + 4) >> 1;
 	priv->i2c_addr_slvt = (cfg->i2c_addr) >> 1;
 	priv->xtal = cfg->xtal;
+	priv->flags = cfg->flags;
 	priv->frontend.demodulator_priv = priv;
 	dev_info(&priv->i2c->dev,
 		"%s(): I2C adapter %p SLVX addr %x SLVT addr %x\n",
diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
index 7f1acfb..2fb8b38 100644
--- a/drivers/media/dvb-frontends/cxd2841er.h
+++ b/drivers/media/dvb-frontends/cxd2841er.h
@@ -33,6 +33,7 @@ enum cxd2841er_xtal {
 struct cxd2841er_config {
 	u8	i2c_addr;
 	enum cxd2841er_xtal	xtal;
+	u32	flags;
 };
 
 #if IS_REACHABLE(CONFIG_DVB_CXD2841ER)
-- 
2.10.2
