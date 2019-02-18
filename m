Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA6EC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC632177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518165;
	bh=W8JgcWBfqvWtdfs9LD6Vi8ZjvXz/8yHWlgIczuDrurQ=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=2Gqpi5g54zgNa9FjDsN6H0gjYk48n7cyXIGaMscjv3h/rI9tH1lxUU9H/aEAq+KDK
	 qmhNGkLBq4JrXkxM1d45UYPXUsZ4IeiT7yrCEN2SolQHC/k19UUdUX5+2WfF+7bQhA
	 Lr5BrgtO7etE7rw72o0SUcZIXqZNIX2QhMTo/2MQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfBRT3Z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfBRT3O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nEKTY0xiSB/K3xMmZs53S8nl5nUp+8L01+BbbnJ3jiw=; b=CV3D+Wxy2pWkgNkDr/wb/x+IX3
        KRifWuXVKu4FZEMiUXQb2sQmrlT8YToa35xkZ+2W1sF4uqfRIrv0ArezV37wXArNaGMpENJH/xb4W
        /orQcFnjCPL7lSalTa/hNYZjamBM0NvoAq7Dfs8e/QkcWGWPXSC6irjzgxlwmm/7TGPKfGeQ8xAVS
        NGBvivWzvHRnj2vZGnZCZoGncLQG6mXeNAhukpk4ohEnOBCZiHppeh+xS3X2NJjT+5gZT6FSBUJbm
        ljcBXrOCb6AVW3J1B/4+/5CH0IT7alIqqeryhLLeqx3PytoNu6m0Ssa1AGTYbGc49mhqTqETYIiH9
        zhcEszmA==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Uk-6H; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006fy-Bu; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 07/14] media: rc: fix several typos
Date:   Mon, 18 Feb 2019 14:29:01 -0500
Message-Id: <bbb83a55ff8b68a2b1735b078e3d706e00c89fd1.1550518128.git.mchehab+samsung@kernel.org>
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
 drivers/media/rc/Kconfig                            |  4 ++--
 drivers/media/rc/ati_remote.c                       |  2 +-
 drivers/media/rc/ene_ir.c                           |  2 +-
 drivers/media/rc/ene_ir.h                           |  2 +-
 drivers/media/rc/fintek-cir.h                       |  2 +-
 drivers/media/rc/ir-xmp-decoder.c                   |  2 +-
 drivers/media/rc/ite-cir.c                          |  2 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c       |  4 ++--
 drivers/media/rc/keymaps/rc-behold.c                |  2 +-
 drivers/media/rc/keymaps/rc-manli.c                 |  2 +-
 drivers/media/rc/keymaps/rc-powercolor-real-angel.c |  2 +-
 drivers/media/rc/mceusb.c                           |  2 +-
 drivers/media/rc/rc-ir-raw.c                        |  2 +-
 drivers/media/rc/rc-main.c                          | 12 ++++++------
 drivers/media/rc/redrat3.c                          |  2 +-
 15 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 8a216068a35a..baa68227922e 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -240,7 +240,7 @@ config IR_FINTEK
 	depends on RC_CORE
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
-	   /transciever made by Fintek. This chip is found on assorted
+	   /transceiver made by Fintek. This chip is found on assorted
 	   Jetway motherboards (and of course, possibly others).
 
 	   To compile this driver as a module, choose M here: the
@@ -274,7 +274,7 @@ config IR_NUVOTON
 	depends on RC_CORE
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
-	   /transciever made by Nuvoton (formerly Winbond). This chip is
+	   /transceiver made by Nuvoton (formerly Winbond). This chip is
 	   found in the ASRock ION 330HT, as well as assorted Intel
 	   DP55-series motherboards (and of course, possibly others).
 
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 265e91a2a70d..bc2da64858c3 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -304,7 +304,7 @@ static const struct {
 	{KIND_LITERAL,  0x7c, BTN_RIGHT},/* right btn down */
 	{KIND_LITERAL,  0x7d, BTN_RIGHT},/* right btn up */
 
-	/* Artificial "doubleclick" events are generated by the hardware.
+	/* Artificial "double-click" events are generated by the hardware.
 	 * They are mapped to the "side" and "extra" mouse buttons here. */
 	{KIND_FILTERED, 0x7a, BTN_SIDE}, /* left dblclick */
 	{KIND_FILTERED, 0x7e, BTN_EXTRA},/* right dblclick */
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index dd2fd307ef85..293ccee2c05e 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -184,7 +184,7 @@ static int ene_hw_detect(struct ene_device *dev)
 	return 0;
 }
 
-/* Read properities of hw sample buffer */
+/* Read properties of hw sample buffer */
 static void ene_rx_setup_hw_buffer(struct ene_device *dev)
 {
 	u16 tmp;
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index 494646b2a284..0a45352efe40 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -118,7 +118,7 @@
 #define ENE_CIRDAT_IN		0xFEC7
 
 
-/* RLC configuration - sample period (1us resulution) + idle mode */
+/* RLC configuration - sample period (1us resolution) + idle mode */
 #define ENE_CIRRLC_CFG		0xFEC8
 #define ENE_CIRRLC_CFG_OVERFLOW	0x80	/* interrupt on overflows if set */
 #define ENE_DEFAULT_SAMPLE_PERIOD 50
diff --git a/drivers/media/rc/fintek-cir.h b/drivers/media/rc/fintek-cir.h
index ac34a774d018..dffe0bbfc6eb 100644
--- a/drivers/media/rc/fintek-cir.h
+++ b/drivers/media/rc/fintek-cir.h
@@ -176,7 +176,7 @@ struct fintek_dev {
 #define CIR_CR_IRCS		0x05 /* Before host writes command to IR, host
 					must set to 1. When host finshes write
 					command to IR, host must clear to 0. */
-#define CIR_CR_COMMAND_DATA	0x06 /* Host read or write comand data */
+#define CIR_CR_COMMAND_DATA	0x06 /* Host read or write command data */
 #define CIR_CR_CLASS		0x07 /* 0xff = rx-only, 0x66 = rx + 2 tx,
 					0x33 = rx + 1 tx */
 #define CIR_CR_DEV_EN		0x30 /* bit0 = 1 enables CIR */
diff --git a/drivers/media/rc/ir-xmp-decoder.c b/drivers/media/rc/ir-xmp-decoder.c
index c965f51df1c1..2639b0b6d2f8 100644
--- a/drivers/media/rc/ir-xmp-decoder.c
+++ b/drivers/media/rc/ir-xmp-decoder.c
@@ -94,7 +94,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			n = data->durations;
 			/*
 			 * the 4th nibble should be 15 so base the divider on this
-			 * to transform durations into nibbles. Substract 2000 from
+			 * to transform durations into nibbles. Subtract 2000 from
 			 * the divider to compensate for fluctuations in the signal
 			 */
 			divider = (n[3] - XMP_NIBBLE_PREFIX) / 15 - 2000;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index cd3c60ba8519..1d48a9e59f93 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -515,7 +515,7 @@ static int ite_tx_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 	/* and set the carrier values for reception */
 	ite_set_carrier_params(dev);
 
-	/* reenable the receiver */
+	/* re-enable the receiver */
 	if (dev->in_use)
 		dev->params.enable_rx(dev);
 
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index e73057945bd1..b68380a76010 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -14,7 +14,7 @@
  * The "ascii-art picture" below (in comments, first row
  * is the keycode in hex, and subsequent row(s) shows
  * the button labels (several variants when appropriate)
- * helps to descide which keycodes to assign to the buttons.
+ * helps to decide which keycodes to assign to the buttons.
  */
 
 static struct rc_map_table behold_columbus[] = {
@@ -68,7 +68,7 @@ static struct rc_map_table behold_columbus[] = {
 	{ 0x18, KEY_VOLUMEDOWN },
 
 	/*   0x0E   0x1E     0x0F     0x1A  *
-	 *   Stop   Pause  Previouse  Next  *
+	 *   Stop   Pause  Previous   Next  *
 	 *                                  */
 
 	{ 0x0E, KEY_STOP },
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index e1b2c8e26883..2b7cddb2f36d 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -17,7 +17,7 @@
  * The "ascii-art picture" below (in comments, first row
  * is the keycode in hex, and subsequent row(s) shows
  * the button labels (several variants when appropriate)
- * helps to descide which keycodes to assign to the buttons.
+ * helps to decide which keycodes to assign to the buttons.
  */
 
 static struct rc_map_table behold[] = {
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index 29c9feaf413b..5e9a49e2dd6a 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -14,7 +14,7 @@
    The "ascii-art picture" below (in comments, first row
    is the keycode in hex, and subsequent row(s) shows
    the button labels (several variants when appropriate)
-   helps to descide which keycodes to assign to the buttons.
+   helps to decide which keycodes to assign to the buttons.
  */
 
 static struct rc_map_table manli[] = {
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index 4988e71c524c..cf98cf8dc13c 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -26,7 +26,7 @@ static struct rc_map_table powercolor_real_angel[] = {
 	{ 0x07, KEY_7 },
 	{ 0x08, KEY_8 },
 	{ 0x09, KEY_9 },
-	{ 0x0a, KEY_DIGITS },		/* single, double, tripple digit */
+	{ 0x0a, KEY_DIGITS },		/* single, double, triple digit */
 	{ 0x29, KEY_PREVIOUS },		/* previous channel */
 	{ 0x12, KEY_BRIGHTNESSUP },
 	{ 0x13, KEY_BRIGHTNESSDOWN },
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 8d7d3ef88862..fa4840940486 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -79,7 +79,7 @@
 #define MCE_CMD			0x1f
 #define MCE_PORT_IR		0x4	/* (0x4 << 5) | MCE_CMD = 0x9f */
 #define MCE_PORT_SYS		0x7	/* (0x7 << 5) | MCE_CMD = 0xff */
-#define MCE_PORT_SER		0x6	/* 0xc0 thru 0xdf flush & 0x1f bytes */
+#define MCE_PORT_SER		0x6	/* 0xc0 through 0xdf flush & 0x1f bytes */
 #define MCE_PORT_MASK		0xe0	/* Mask out command bits */
 
 /* Command port headers */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index e10b4644a442..39dd46bbd0c1 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -186,7 +186,7 @@ int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
 		dev->raw->this_ev = *ev;
 	}
 
-	/* Enter idle mode if nessesary */
+	/* Enter idle mode if necessary */
 	if (!ev->pulse && dev->timeout &&
 	    dev->raw->this_ev.duration >= dev->timeout)
 		ir_raw_event_set_idle(dev, true);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 66a174979b3c..dd5337e39e91 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1035,7 +1035,7 @@ struct rc_filter_attribute {
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type(s).
- * it is trigged by reading /sys/class/rc/rc?/protocols.
+ * it is triggered by reading /sys/class/rc/rc?/protocols.
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  *
@@ -1206,7 +1206,7 @@ void ir_raw_load_modules(u64 *protocols)
  * @len:	length of the input buffer
  *
  * This routine is for changing the IR protocol type.
- * It is trigged by writing to /sys/class/rc/rc?/[wakeup_]protocols.
+ * It is triggered by writing to /sys/class/rc/rc?/[wakeup_]protocols.
  * See parse_protocol_change() for the valid commands.
  * Returns @len on success or a negative error code.
  *
@@ -1290,7 +1290,7 @@ static ssize_t store_protocols(struct device *device,
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine to read a scancode filter value or mask.
- * It is trigged by reading /sys/class/rc/rc?/[wakeup_]filter[_mask].
+ * It is triggered by reading /sys/class/rc/rc?/[wakeup_]filter[_mask].
  * It prints the current scancode filter value or mask of the appropriate filter
  * type in hexadecimal into @buf and returns the size of the buffer.
  *
@@ -1333,7 +1333,7 @@ static ssize_t show_filter(struct device *device,
  * @len:	length of the input buffer
  *
  * This routine is for changing a scancode filter value or mask.
- * It is trigged by writing to /sys/class/rc/rc?/[wakeup_]filter[_mask].
+ * It is triggered by writing to /sys/class/rc/rc?/[wakeup_]filter[_mask].
  * Returns -EINVAL if an invalid filter value for the current protocol was
  * specified or if scancode filtering is not supported by the driver, otherwise
  * returns @len.
@@ -1417,7 +1417,7 @@ static ssize_t store_filter(struct device *device,
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type(s).
- * it is trigged by reading /sys/class/rc/rc?/wakeup_protocols.
+ * it is triggered by reading /sys/class/rc/rc?/wakeup_protocols.
  * It returns the protocol names of supported protocols.
  * The enabled protocols are printed in brackets.
  *
@@ -1468,7 +1468,7 @@ static ssize_t show_wakeup_protocols(struct device *device,
  * @len:	length of the input buffer
  *
  * This routine is for changing the IR protocol type.
- * It is trigged by writing to /sys/class/rc/rc?/wakeup_protocols.
+ * It is triggered by writing to /sys/class/rc/rc?/wakeup_protocols.
  * Returns @len on success or a negative error code.
  *
  * dev->lock is taken to guard against races between
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 08c51ffd74a0..b82a5c9db12c 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -140,7 +140,7 @@ MODULE_PARM_DESC(length_fuzz, "Length Fuzz (0-127)");
  * When receiving a continuous ir stream (for example when a user is
  * holding a button down on a remote), this specifies the minimum size
  * of a space when the redrat3 sends a irdata packet to the host. Specified
- * in miliseconds. Default value 18ms.
+ * in milliseconds. Default value 18ms.
  * The value can be between 2 and 30 inclusive.
  */
 static int minimum_pause = 18;
-- 
2.20.1

