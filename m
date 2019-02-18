Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D283C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E0C3217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518164;
	bh=myVdl2rglMCNGvTbjS4wk8BNlNv9hRm+MTaks/28Rvw=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=skZbbslOzcSt+mPbVRxvk+hZUrlCCEvQqxSWkdjjWDfFTI2tZUXMjcTgQn0BKUPTK
	 S6Vrt7XXWW8wusdZx2KW0GA82Q1A59tvCRn7ohK6xT6S9V4qBmajAXXDquKGQmbdGE
	 x0rWHPzDnObtCyoI6UNd6f21czHB5MpolBXjEwEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfBRT3X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfBRT3O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yXj2bLcH2to6pfpIhzXnbO34Fn5s8Pdx9OcR4md2sro=; b=g+TssaERHYLTaiETs+4g6kqVPP
        anQ2Psmf4rvyWJnJ5pVlDHfxrR0oS3LLPrED5BGmLzPVjVXGR+E+fndOHGHGuem+hRjhfzp3cU9Sk
        BohzX/Z/mE7LYJ7PfBS9uTKBQzT9JDQQs485I1eJw7GvUShbKYM6zhapDAElJfTQA2Dy2DJub2xae
        lmzgHdrttQ0x9umPBigKILt3d0ku/rui1jmOS8IPBRTY4SFt9yCyDzfQJixMdTAOuvLA3ZG0Zc6No
        +qHEODn6Iy/quImt/I0JPIRdTpa666y91kFYv8nm+3JqTFqaq+bLaqib0hKttMNiosnkeC7vUdHtT
        Z3GZA6Bg==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Um-61; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006g2-Ce; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 08/14] media: tuners: fix several typos
Date:   Mon, 18 Feb 2019 14:29:02 -0500
Message-Id: <9b09cc517c4f997a833d0d207e17acf70503a509.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/tuners/mxl5005s.c        |  2 +-
 drivers/media/tuners/qm1d1b0004.h      |  2 +-
 drivers/media/tuners/r820t.c           |  4 ++--
 drivers/media/tuners/tda18271-common.c | 10 +++++-----
 drivers/media/tuners/tda18271-fe.c     |  2 +-
 drivers/media/tuners/tda18271.h        |  4 ++--
 drivers/media/tuners/xc4000.c          |  4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index ec584316c812..1c07e2225fb3 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -3584,7 +3584,7 @@ static u32 MXL_Ceiling(u32 value, u32 resolution)
 	return value / resolution + (value % resolution > 0 ? 1 : 0);
 }
 
-/* Retrieve the Initialzation Registers */
+/* Retrieve the Initialization Registers */
 static u16 MXL_GetInitRegister(struct dvb_frontend *fe, u8 *RegNum,
 	u8 *RegVal, int *count)
 {
diff --git a/drivers/media/tuners/qm1d1b0004.h b/drivers/media/tuners/qm1d1b0004.h
index 7734ed109a22..7950ecd56430 100644
--- a/drivers/media/tuners/qm1d1b0004.h
+++ b/drivers/media/tuners/qm1d1b0004.h
@@ -14,7 +14,7 @@ struct qm1d1b0004_config {
 	struct dvb_frontend *fe;
 
 	u32 lpf_freq;   /* LPF frequency[kHz]. Default: symbol rate */
-	bool half_step; /* use PLL frequency step of 500Hz istead of 1000Hz */
+	bool half_step; /* use PLL frequency step of 500Hz instead of 1000Hz */
 };
 
 /* special values indicating to use the default in qm1d1b0004_config */
diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index ba4be08a8551..aed2f130ec74 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1664,7 +1664,7 @@ static int r820t_iq_tree(struct r820t_priv *priv,
 
 	/*
 	 * record IMC results by input gain/phase location then adjust
-	 * gain or phase positive 1 step and negtive 1 step,
+	 * gain or phase positive 1 step and negative 1 step,
 	 * both record results
 	 */
 
@@ -2066,7 +2066,7 @@ static int r820t_imr_callibrate(struct r820t_priv *priv)
 	}
 
 	/*
-	 * Disables IMR callibration. That emulates the same behaviour
+	 * Disables IMR calibration. That emulates the same behaviour
 	 * as what is done by rtl-sdr userspace library. Useful for testing
 	 */
 	if (no_imr_cal) {
diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
index 054b3b747dae..d46a2e775e82 100644
--- a/drivers/media/tuners/tda18271-common.c
+++ b/drivers/media/tuners/tda18271-common.c
@@ -528,14 +528,14 @@ int tda18271_init_regs(struct dvb_frontend *fe)
  *  Standby modes, EP3 [7:5]
  *
  *  | SM  || SM_LT || SM_XT || mode description
- *  |=====\\=======\\=======\\===================================
+ *  |=====\\=======\\=======\\====================================
  *  |  0  ||   0   ||   0   || normal mode
- *  |-----||-------||-------||-----------------------------------
+ *  |-----||-------||-------||------------------------------------
  *  |     ||       ||       || standby mode w/ slave tuner output
- *  |  1  ||   0   ||   0   || & loop thru & xtal oscillator on
- *  |-----||-------||-------||-----------------------------------
+ *  |  1  ||   0   ||   0   || & loop through & xtal oscillator on
+ *  |-----||-------||-------||------------------------------------
  *  |  1  ||   1   ||   0   || standby mode w/ xtal oscillator on
- *  |-----||-------||-------||-----------------------------------
+ *  |-----||-------||-------||------------------------------------
  *  |  1  ||   1   ||   1   || power off
  *
  */
diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 4d69029229e4..cac6b8e62b73 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -48,7 +48,7 @@ static int tda18271_toggle_output(struct dvb_frontend *fe, int standby)
 	if (tda_fail(ret))
 		goto fail;
 
-	tda_dbg("%s mode: xtal oscillator %s, slave tuner loop thru %s\n",
+	tda_dbg("%s mode: xtal oscillator %s, slave tuner loop through %s\n",
 		standby ? "standby" : "active",
 		priv->output_opt & TDA18271_OUTPUT_XT_OFF ? "off" : "on",
 		priv->output_opt & TDA18271_OUTPUT_LT_OFF ? "off" : "on");
diff --git a/drivers/media/tuners/tda18271.h b/drivers/media/tuners/tda18271.h
index 7e07966c5ace..1a23532586ef 100644
--- a/drivers/media/tuners/tda18271.h
+++ b/drivers/media/tuners/tda18271.h
@@ -69,10 +69,10 @@ enum tda18271_i2c_gate {
 };
 
 enum tda18271_output_options {
-	/* slave tuner output & loop thru & xtal oscillator always on */
+	/* slave tuner output & loop through & xtal oscillator always on */
 	TDA18271_OUTPUT_LT_XT_ON = 0,
 
-	/* slave tuner output loop thru off */
+	/* slave tuner output loop through off */
 	TDA18271_OUTPUT_LT_OFF = 1,
 
 	/* xtal oscillator off */
diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index eb6d65dae748..a351390ee744 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1471,8 +1471,8 @@ static int xc4000_get_signal(struct dvb_frontend *fe, u16 *strength)
 	if (rc < 0)
 		goto ret;
 
-	/* Informations from real testing of DVB-T and radio part,
-	   coeficient for one dB is 0xff.
+	/* Information from real testing of DVB-T and radio part,
+	   coefficient for one dB is 0xff.
 	 */
 	tuner_dbg("Signal strength: -%ddB (%05d)\n", value >> 8, value);
 
-- 
2.20.1

