Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36476 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755797AbdCGVHS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 16:07:18 -0500
Received: by mail-wm0-f65.google.com with SMTP id v190so3024771wme.3
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 13:07:07 -0800 (PST)
Received: from dvbdev.wuest.de (ip-178-201-73-185.hsi08.unitymediagroup.de. [178.201.73.185])
        by smtp.gmail.com with ESMTPSA id m186sm13760369wmd.21.2017.03.07.10.58.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Mar 2017 10:58:39 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 12/13] [media] tuners/tda18212: add flag for retrying tuner init on failure
Date: Tue,  7 Mar 2017 19:57:26 +0100
Message-Id: <20170307185727.564-13-d.scheller.oss@gmail.com>
In-Reply-To: <20170307185727.564-1-d.scheller.oss@gmail.com>
References: <20170307185727.564-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Taken from tda18212dd, first read after cold reset sometimes fails on some
cards, trying twice shall do the trick. This is the case with the STV0367
demods soldered on the CineCTv6 bridge boards and older DuoFlex CT modules.

All other users (configs) of the tda18212 are updated as well to be sure
they won't be affected at all by this change.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c | 1 +
 drivers/media/tuners/tda18212.c                      | 5 +++++
 drivers/media/tuners/tda18212.h                      | 7 +++++++
 drivers/media/usb/dvb-usb-v2/anysee.c                | 2 ++
 drivers/media/usb/em28xx/em28xx-dvb.c                | 1 +
 5 files changed, 16 insertions(+)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
index 2c0015b..03688ee 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
@@ -111,6 +111,7 @@ static struct tda18212_config tda18212_conf = {
 	.if_dvbt_7 = 4150,
 	.if_dvbt_8 = 4500,
 	.if_dvbc = 5000,
+	.init_flags = 0,
 };
 
 int c8sectpfe_frontend_attach(struct dvb_frontend **fe,
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 7b80683..2488537 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -220,6 +220,11 @@ static int tda18212_probe(struct i2c_client *client,
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
 	ret = regmap_read(dev->regmap, 0x00, &chip_id);
+
+	/* retry probe if desired */
+	if (ret && (cfg->init_flags & TDA18212_INIT_RETRY))
+		ret = regmap_read(dev->regmap, 0x00, &chip_id);
+
 	dev_dbg(&dev->client->dev, "chip_id=%02x\n", chip_id);
 
 	if (fe->ops.i2c_gate_ctrl)
diff --git a/drivers/media/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
index 6391daf..717aa2c 100644
--- a/drivers/media/tuners/tda18212.h
+++ b/drivers/media/tuners/tda18212.h
@@ -23,6 +23,8 @@
 
 #include "dvb_frontend.h"
 
+#define TDA18212_INIT_RETRY	(1 << 0)
+
 struct tda18212_config {
 	u16 if_dvbt_6;
 	u16 if_dvbt_7;
@@ -36,6 +38,11 @@ struct tda18212_config {
 	u16 if_atsc_qam;
 
 	/*
+	 * flags for tuner init control
+	 */
+	u32 init_flags;
+
+	/*
 	 * pointer to DVB frontend
 	 */
 	struct dvb_frontend *fe;
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 6795c0c..c35b66e 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -332,6 +332,7 @@ static struct tda18212_config anysee_tda18212_config = {
 	.if_dvbt_7 = 4150,
 	.if_dvbt_8 = 4150,
 	.if_dvbc = 5000,
+	.init_flags = 0,
 };
 
 static struct tda18212_config anysee_tda18212_config2 = {
@@ -342,6 +343,7 @@ static struct tda18212_config anysee_tda18212_config2 = {
 	.if_dvbt2_7 = 4000,
 	.if_dvbt2_8 = 4000,
 	.if_dvbc = 5000,
+	.init_flags = 0,
 };
 
 static struct cx24116_config anysee_cx24116_config = {
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 82edd37..143efb0 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -380,6 +380,7 @@ static struct tda18271_config kworld_ub435q_v2_config = {
 static struct tda18212_config kworld_ub435q_v3_config = {
 	.if_atsc_vsb	= 3600,
 	.if_atsc_qam	= 3600,
+	.init_flags	= 0,
 };
 
 static struct zl10353_config em28xx_zl10353_xc3028_no_i2c_gate = {
-- 
2.10.2
