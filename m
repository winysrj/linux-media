Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C18BC4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1AD0217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518161;
	bh=wS1cfCpKRpfxn9mGLG8Y1vO/CY7QIY3tT94rETzgl7Y=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=pYHOmMm2bwqT7635vz6Rm4LtcdE+3mZNhFXxxlfj7aCe4k5f/zt/w/sLr8HS/09r2
	 utd431jtnS0R82hFKG6m5xOeMfP48Uf9pcIxOuSusx3O7iUYeE0In1Sc4A+NxPW0PL
	 dYoTG8ke+LpmHwgrmlW7ZrvnHw/FAl0lBXHRngFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfBRT3Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfBRT3P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=l8oqePxi3N205g+3Dvi7/lt0UqnOqY7a9kq7DM5Vp0g=; b=u28PVOSBVNcBYs3AxLpOt4mz4k
        Lr02Rx6rjM3ji1kzGHq6qASCnmPkCQmQlS9nlbQwKzftI8XbJCurFc7IUDe19i83oRbH1B9QE/n6t
        WGsYJSDcNsdH/IDDZo9DU3PE6c3oJO9H/mnT4YIke7ffVwQC2vhqG0KUjK0QPGuKG0Fa1o5sEKHTh
        Jy+/ovyemSCxhj8dzDbxU02BXBrvv/rLXaGZ2NZ+r4KXbmr20BRPHBKdYlAPZ+gse5ko01DqqUyni
        RD0ewSkVyohPS5ButuEqhCOKSyUF9IVKcydY8cSQ9Ro8IePK+aPiljr48JWHCw/dP6eBvzUdtzSCT
        MKESyGdA==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Uu-Ff; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006fm-9N; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 04/14] media: i2c: fix several typos
Date:   Mon, 18 Feb 2019 14:28:58 -0500
Message-Id: <5e233752f27cb8a9708221519b2cd21e1cb85939.1550518128.git.mchehab+samsung@kernel.org>
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
 drivers/media/i2c/adv7175.c              |  2 +-
 drivers/media/i2c/adv7842.c              | 10 +++++-----
 drivers/media/i2c/bt819.c                |  4 ++--
 drivers/media/i2c/cx25840/cx25840-core.h |  2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c   |  4 ++--
 drivers/media/i2c/et8ek8/et8ek8_mode.c   |  2 +-
 drivers/media/i2c/imx214.c               |  2 +-
 drivers/media/i2c/imx274.c               |  4 ++--
 drivers/media/i2c/lm3560.c               |  2 +-
 drivers/media/i2c/lm3646.c               |  2 +-
 drivers/media/i2c/m5mols/m5mols.h        |  2 +-
 drivers/media/i2c/m5mols/m5mols_core.c   |  2 +-
 drivers/media/i2c/msp3400-driver.c       |  2 +-
 drivers/media/i2c/mt9t112.c              |  2 +-
 drivers/media/i2c/ov5640.c               |  2 +-
 drivers/media/i2c/ov6650.c               |  4 ++--
 drivers/media/i2c/ov7740.c               |  2 +-
 drivers/media/i2c/ov9650.c               |  4 ++--
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |  2 +-
 drivers/media/i2c/s5k6aa.c               |  2 +-
 drivers/media/i2c/saa7115.c              |  2 +-
 drivers/media/i2c/saa717x.c              |  2 +-
 drivers/media/i2c/tda1997x_regs.h        |  2 +-
 drivers/media/i2c/tda9840.c              |  2 +-
 drivers/media/i2c/tea6415c.c             |  2 +-
 drivers/media/i2c/tea6420.c              |  2 +-
 drivers/media/i2c/tvaudio.c              |  4 ++--
 drivers/media/i2c/tvp514x.c              |  2 +-
 28 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index e31e8d909bb9..419b98117133 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -219,7 +219,7 @@ static int adv7175_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
 		 * SECAM->PAL (typically it does not work
 		 * due to genlock: when decoder is in SECAM
 		 * and encoder in in PAL the subcarrier can
-		 * not be syncronized with horizontal
+		 * not be synchronized with horizontal
 		 * quency) */
 		adv7175_write_block(sd, init_pal, sizeof(init_pal));
 		if (encoder->input == 0)
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 989259488e3d..11ab2df02dc7 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3102,11 +3102,11 @@ static int adv7842_ddr_ram_test(struct v4l2_subdev *sd)
 
 	io_write(sd, 0x00, 0x01);  /* Program SDP 4x1 */
 	io_write(sd, 0x01, 0x00);  /* Program SDP mode */
-	afe_write(sd, 0x80, 0x92); /* SDP Recommeneded Write */
-	afe_write(sd, 0x9B, 0x01); /* SDP Recommeneded Write ADV7844ES1 */
-	afe_write(sd, 0x9C, 0x60); /* SDP Recommeneded Write ADV7844ES1 */
-	afe_write(sd, 0x9E, 0x02); /* SDP Recommeneded Write ADV7844ES1 */
-	afe_write(sd, 0xA0, 0x0B); /* SDP Recommeneded Write ADV7844ES1 */
+	afe_write(sd, 0x80, 0x92); /* SDP Recommended Write */
+	afe_write(sd, 0x9B, 0x01); /* SDP Recommended Write ADV7844ES1 */
+	afe_write(sd, 0x9C, 0x60); /* SDP Recommended Write ADV7844ES1 */
+	afe_write(sd, 0x9E, 0x02); /* SDP Recommended Write ADV7844ES1 */
+	afe_write(sd, 0xA0, 0x0B); /* SDP Recommended Write ADV7844ES1 */
 	afe_write(sd, 0xC3, 0x02); /* Memory BIST Initialisation */
 	io_write(sd, 0x0C, 0x40);  /* Power up ADV7844 */
 	io_write(sd, 0x15, 0xBA);  /* Enable outputs */
diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 472e37637c8d..e6d3fe7790bc 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -164,12 +164,12 @@ static int bt819_init(struct v4l2_subdev *sd)
 		0x0e, 0xb4,	/* 0x0e Chroma Gain (V) msb */
 		0x0f, 0x00,	/* 0x0f Hue control */
 		0x12, 0x04,	/* 0x12 Output Format */
-		0x13, 0x20,	/* 0x13 Vertial Scaling msb 0x00
+		0x13, 0x20,	/* 0x13 Vertical Scaling msb 0x00
 					   chroma comb OFF, line drop scaling, interlace scaling
 					   BUG? Why does turning the chroma comb on fuck up color?
 					   Bug in the bt819 stepping on my board?
 					*/
-		0x14, 0x00,	/* 0x14 Vertial Scaling lsb */
+		0x14, 0x00,	/* 0x14 Vertical Scaling lsb */
 		0x16, 0x07,	/* 0x16 Video Timing Polarity
 					   ACTIVE=active low
 					   FIELD: high=odd,
diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index 9efefa15d090..e3ff1d7ec770 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -66,7 +66,7 @@ enum cx25840_media_pads {
  * @is_initialized:	whether we have already loaded firmware into the chip
  *			and initialized it
  * @vbi_regs_offset:	offset of vbi regs
- * @fw_wait:		wait queue to wake an initalization function up when
+ * @fw_wait:		wait queue to wake an initialization function up when
  *			firmware loading (on a separate workqueue) finishes
  * @fw_work:		a work that actually loads the firmware on a separate
  *			workqueue
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 69cdc09981af..a266118cd7ca 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -549,7 +549,7 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
 	ror = stats & STATS_ROR; /* Rx FIFO Over Run */
 
 	tse = irqen & IRQEN_TSE; /* Tx FIFO Service Request IRQ Enable */
-	rse = irqen & IRQEN_RSE; /* Rx FIFO Service Reuqest IRQ Enable */
+	rse = irqen & IRQEN_RSE; /* Rx FIFO Service Request IRQ Enable */
 	rte = irqen & IRQEN_RTE; /* Rx Pulse Width Timer Time Out IRQ Enable */
 	roe = irqen & IRQEN_ROE; /* Rx FIFO Over Run IRQ Enable */
 
@@ -638,7 +638,7 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
 		events |= V4L2_SUBDEV_IR_RX_END_OF_RX_DETECTED;
 	}
 	if (v) {
-		/* Clear STATS_ROR & STATS_RTO as needed by reseting hardware */
+		/* Clear STATS_ROR & STATS_RTO as needed by resetting hardware */
 		cx25840_write4(c, CX25840_IR_CNTRL_REG, cntrl & ~v);
 		cx25840_write4(c, CX25840_IR_CNTRL_REG, cntrl);
 		*handled = true;
diff --git a/drivers/media/i2c/et8ek8/et8ek8_mode.c b/drivers/media/i2c/et8ek8/et8ek8_mode.c
index a79882a83885..f503303cb8bc 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_mode.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_mode.c
@@ -79,7 +79,7 @@ static struct et8ek8_reglist mode1_poweron_mode2_16vga_2592x1968_12_07fps = {
 		{ ET8EK8_REG_8BIT, 0x1258, 0x00 },
 		/* From parallel out to serial out */
 		{ ET8EK8_REG_8BIT, 0x125D, 0x88 },
-		/* From w/ embeded data to w/o embeded data */
+		/* From w/ embedded data to w/o embedded data */
 		{ ET8EK8_REG_8BIT, 0x125E, 0xC0 },
 		/* CCP2 out is from STOP to ACTIVE */
 		{ ET8EK8_REG_8BIT, 0x1263, 0x98 },
diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
index ec3d1b855f62..9857e151db46 100644
--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -377,7 +377,7 @@ static const struct reg_8 mode_table_common[] = {
 	/* Moire reduction */
 	{0x6957, 0x01},
 
-	/* image enhancment */
+	/* image enhancement */
 	{0x6987, 0x17},
 	{0x698A, 0x03},
 	{0x698B, 0x03},
diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index c2ac2fd1b96b..f3ff1af209f9 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -405,12 +405,12 @@ static const struct reg_8 imx274_start_2[] = {
  */
 static const struct reg_8 imx274_start_3[] = {
 	{0x30F4, 0x00},
-	{0x3018, 0xA2}, /* XHS VHS OUTUPT */
+	{0x3018, 0xA2}, /* XHS VHS OUTPUT */
 	{IMX274_TABLE_END, 0x00}
 };
 
 /*
- * imx274 register configuration for stoping stream
+ * imx274 register configuration for stopping stream
  */
 static const struct reg_8 imx274_stop[] = {
 	{IMX274_STANDBY_REG, 0x01},
diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index f122f03bd6b7..70c3294c21d3 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -55,7 +55,7 @@ enum led_enable {
  * @regmap: reg. map for i2c
  * @lock: muxtex for serial access.
  * @led_mode: V4L2 LED mode
- * @ctrls_led: V4L2 contols
+ * @ctrls_led: V4L2 controls
  * @subdev_led: V4L2 subdev
  */
 struct lm3560_flash {
diff --git a/drivers/media/i2c/lm3646.c b/drivers/media/i2c/lm3646.c
index 12ef2653987b..73fbe3c37fc9 100644
--- a/drivers/media/i2c/lm3646.c
+++ b/drivers/media/i2c/lm3646.c
@@ -62,7 +62,7 @@ enum led_mode {
  * @regmap: reg. map for i2c
  * @lock: muxtex for serial access.
  * @led_mode: V4L2 LED mode
- * @ctrls_led: V4L2 contols
+ * @ctrls_led: V4L2 controls
  * @subdev_led: V4L2 subdev
  * @mode_reg : mode register value
  */
diff --git a/drivers/media/i2c/m5mols/m5mols.h b/drivers/media/i2c/m5mols/m5mols.h
index 90a6c520f115..aef5b4f8904e 100644
--- a/drivers/media/i2c/m5mols/m5mols.h
+++ b/drivers/media/i2c/m5mols/m5mols.h
@@ -253,7 +253,7 @@ struct m5mols_info {
  *
  * The I2C read operation of the M-5MOLS requires 2 messages. The first
  * message sends the information about the command, command category, and total
- * message size. The second message is used to retrieve the data specifed in
+ * message size. The second message is used to retrieve the data specified in
  * the first message
  *
  *   1st message                                2nd message
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index b8b2bf4cbfb2..454a336be336 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -291,7 +291,7 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
  * @reg: the I2C_REG() address of an 8-bit status register to check
  * @value: expected status register value
  * @mask: bit mask for the read status register value
- * @timeout: timeout in miliseconds, or -1 for default timeout
+ * @timeout: timeout in milliseconds, or -1 for default timeout
  *
  * The @reg register value is ORed with @mask before comparing with @value.
  *
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index c63be01059b2..522fb1d561e7 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -11,7 +11,7 @@
  *
  *  FM-Mono
  *      should work. The stereo modes are backward compatible to FM-mono,
- *      therefore FM-Mono should be allways available.
+ *      therefore FM-Mono should be always available.
  *
  *  FM-Stereo (B/G, used in germany)
  *      should work, with autodetect
diff --git a/drivers/media/i2c/mt9t112.c b/drivers/media/i2c/mt9t112.c
index ef353a244e33..ae3c336eadf5 100644
--- a/drivers/media/i2c/mt9t112.c
+++ b/drivers/media/i2c/mt9t112.c
@@ -541,7 +541,7 @@ static int mt9t112_init_setting(const struct i2c_client *client)
 	mt9t112_mcu_write(ret, client, VAR(18, 109), 0x0AF0);
 
 	/*
-	 * Flicker Dectection registers.
+	 * Flicker Detection registers.
 	 * This section should be replaced whenever new timing file is
 	 * generated. All the following registers need to be replaced.
 	 * Following registers are generated from Register Wizard but user can
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5278c8723fdd..82d4ce93312c 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -721,7 +721,7 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
 
 /*
  * After trying the various combinations, reading various
- * documentations spreaded around the net, and from the various
+ * documentations spread around the net, and from the various
  * feedback, the clock tree is probably as follows:
  *
  *   +--------------+
diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 5d1b218bb7f0..c33fd584cb44 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -15,7 +15,7 @@
  * Copyright (C) 2008 Magnus Damm
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
  *
- * Hardware specific bits initialy based on former work by Matt Callow
+ * Hardware specific bits initially based on former work by Matt Callow
  * drivers/media/video/omap/sensor_ov6650.c
  * Copyright (C) 2006 Matt Callow
  *
@@ -759,7 +759,7 @@ static int ov6650_s_frame_interval(struct v4l2_subdev *sd,
 
 	/*
 	 * Keep result to be used as tpf limit
-	 * for subseqent clock divider calculations
+	 * for subsequent clock divider calculations
 	 */
 	priv->tpf.numerator = div;
 	priv->tpf.denominator = FRAME_RATE_MAX;
diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 177688afd9a6..00e3a4656953 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -20,7 +20,7 @@
 #define REG_BGAIN	0x01	/* blue gain */
 #define REG_RGAIN	0x02	/* red gain */
 #define REG_GGAIN	0x03	/* green gain */
-#define REG_REG04	0x04	/* analog setting, dont change*/
+#define REG_REG04	0x04	/* analog setting, don't change*/
 #define REG_BAVG	0x05	/* b channel average */
 #define REG_GAVG	0x06	/* g channel average */
 #define REG_RAVG	0x07	/* r channel average */
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index f0587c0c0a72..eefd57ec2a73 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -45,8 +45,8 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
  * OV9650/OV9652 register definitions
  */
 #define REG_GAIN		0x00	/* Gain control, AGC[7:0] */
-#define REG_BLUE		0x01	/* AWB - Blue chanel gain */
-#define REG_RED			0x02	/* AWB - Red chanel gain */
+#define REG_BLUE		0x01	/* AWB - Blue channel gain */
+#define REG_RED			0x02	/* AWB - Red channel gain */
 #define REG_VREF		0x03	/* [7:6] - AGC[9:8], [5:3]/[2:0] */
 #define  VREF_GAIN_MASK		0xc0	/* - VREF end/start low 3 bits */
 #define REG_COM1		0x04
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index c461847ddae8..b52fe250f75f 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1431,7 +1431,7 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 	for (++i; i < S5C73M3_MAX_SUPPLIES; i++) {
 		int r = regulator_enable(state->supplies[i].consumer);
 		if (r < 0)
-			v4l2_err(&state->oif_sd, "Failed to reenable %s: %d\n",
+			v4l2_err(&state->oif_sd, "Failed to re-enable %s: %d\n",
 				 state->supplies[i].supply, r);
 	}
 
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index ab26f549d716..f8630c4c2ef0 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -729,7 +729,7 @@ static int s5k6aa_new_config_sync(struct i2c_client *client, int timeout,
  * @s5k6aa: pointer to &struct s5k6aa describing the device
  * @preset: s5kaa preset to be applied
  *
- * Configure output resolution and color fromat, pixel clock
+ * Configure output resolution and color format, pixel clock
  * frequency range, device frame rate type and frame period range.
  */
 static int s5k6aa_set_prev_config(struct s5k6aa *s5k6aa,
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 6bc278aa31fc..88dc6baac639 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1766,7 +1766,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 		 * exists. However, tests on a device labeled as:
 		 * "GM7113C 1145" returned "10" on all 16 chip
 		 * version (reg 0x00) reads. So, we need to also
-		 * accept at least verion 0. For now, let's just
+		 * accept at least version 0. For now, let's just
 		 * assume that a device that returns "0000" for
 		 * the lower nibble is a gm7113c.
 		 */
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 668c39cc29e8..86b8b65ea683 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -844,7 +844,7 @@ static void set_h_prescale(struct v4l2_subdev *sd,
 	if (i == count)
 		return;
 
-	/* horizonal prescaling */
+	/* horizontal prescaling */
 	saa717x_write(sd, 0x60 + task_shift, vals[i].xpsc);
 	/* accumulation length */
 	saa717x_write(sd, 0x61 + task_shift, vals[i].xacl);
diff --git a/drivers/media/i2c/tda1997x_regs.h b/drivers/media/i2c/tda1997x_regs.h
index f55dfc423a86..ecf87534613b 100644
--- a/drivers/media/i2c/tda1997x_regs.h
+++ b/drivers/media/i2c/tda1997x_regs.h
@@ -596,7 +596,7 @@
 #define RESET_AUDIO		BIT(0)	/* Reset Audio FIFO control */
 
 /* HDCP_BCAPS bits */
-#define HDCP_HDMI		BIT(7)	/* HDCP suports HDMI (vs DVI only) */
+#define HDCP_HDMI		BIT(7)	/* HDCP supports HDMI (vs DVI only) */
 #define HDCP_REPEATER		BIT(6)	/* HDCP supports repeater function */
 #define HDCP_READY		BIT(5)	/* set by repeater function */
 #define HDCP_FAST		BIT(4)	/* Up to 400kHz */
diff --git a/drivers/media/i2c/tda9840.c b/drivers/media/i2c/tda9840.c
index 0dd6ff3e6201..6ba53f3a6dd2 100644
--- a/drivers/media/i2c/tda9840.c
+++ b/drivers/media/i2c/tda9840.c
@@ -7,7 +7,7 @@
     The tda9840 is a stereo/dual sound processor with digital
     identification. It can be found at address 0x84 on the i2c-bus.
 
-    For detailed informations download the specifications directly
+    For detailed information download the specifications directly
     from SGS Thomson at http://www.st.com
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/i2c/tea6415c.c b/drivers/media/i2c/tea6415c.c
index 084bd75bb32c..965c6ccc4fee 100644
--- a/drivers/media/i2c/tea6415c.c
+++ b/drivers/media/i2c/tea6415c.c
@@ -9,7 +9,7 @@
     It is cascadable, i.e. it can be found at the addresses
     0x86 and 0x06 on the i2c-bus.
 
-    For detailed informations download the specifications directly
+    For detailed information download the specifications directly
     from SGS Thomson at http://www.st.com
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/i2c/tea6420.c b/drivers/media/i2c/tea6420.c
index b7f4e58f3624..2701a4c9734d 100644
--- a/drivers/media/i2c/tea6420.c
+++ b/drivers/media/i2c/tea6420.c
@@ -9,7 +9,7 @@
     It is cascadable, i.e. it can be found at the addresses 0x98
     and 0x9a on the i2c-bus.
 
-    For detailed informations download the specifications directly
+    For detailed information download the specifications directly
     from SGS Thomson at http://www.st.com
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index af2da977a685..e6796e94dadf 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -538,7 +538,7 @@ static int tda9840_checkit(struct CHIPSTATE *chip)
 #define TDA9855_INT	0    /* Selects inputs LOR and LOL.  (internal) */
 
 /* Unique to TDA9850:  */
-/* lower 4 bits contol SAP noise threshold, over which SAP turns off
+/* lower 4 bits control SAP noise threshold, over which SAP turns off
  * set to values of 0x00 through 0x0f for SAP1 through SAP16 */
 
 
@@ -546,7 +546,7 @@ static int tda9840_checkit(struct CHIPSTATE *chip)
 /* Common to TDA9855 and TDA9850: */
 #define TDA985x_SAP	3<<6 /* Selects SAP output, mute if not received */
 #define TDA985x_MONOSAP	2<<6 /* Selects Mono on left, SAP on right */
-#define TDA985x_STEREO	1<<6 /* Selects Stereo ouput, mono if not received */
+#define TDA985x_STEREO	1<<6 /* Selects Stereo output, mono if not received */
 #define TDA985x_MONO	0    /* Forces Mono output */
 #define TDA985x_LMU	1<<3 /* Mute (LOR/LOL for 9855, OUTL/OUTR for 9850) */
 
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 1cc83cb934e2..3ada3bb27402 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -67,7 +67,7 @@ enum tvp514x_std {
 };
 
 /**
- * struct tvp514x_std_info - Structure to store standard informations
+ * struct tvp514x_std_info - Structure to store standard information
  * @width: Line width in pixels
  * @height:Number of active lines
  * @video_std: Value to write in REG_VIDEO_STD register
-- 
2.20.1

