Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535FAC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05694217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518162;
	bh=ngaNEWWJNyqPgqi5EyPVUacgxh96l7/noXrYCBFzAFA=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=HjSg0AFQEjmk2j0whZSFArCpyNuBIU6+AHryWuljB1DnopSWV+C1xcM9TpD7Il+TO
	 Sv1Jjx1JaaJIJqrBM9WHhqZCRc6aMjsqEnZ4UTwqO0k9JvvHGscvPmFdD7XWcLZTQ/
	 aPqlaNXdNHwBggMJk/giLvlk2FnQXHRcNeivsS5U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfBRT3U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfBRT3P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T1+10SESVeAiguoPcDFUcvOTO93grJ+b1FrVt7im9+c=; b=fe9N24W379l14y6RdUSb+eAWBu
        aNym03ipbkq50PL1WKVRWYPe9frKcTjZWlmTgybvhvw5QWUcUcUw42wJ3U18QT00eqkHsYT4n2JcL
        2YUeO1X6u1p4v6TCu+lNmN5RtDctTcTVwhc6D41iGuDlevlP1lYqHw+/XISF1y9BDqfPDZkUuoZZq
        fRGX8hmbc5ppeYUqxffG9uphJJZqL4YKTLvOVk4HfVfU4AEZ8Em4ptsYDot+aG76Mm4ZuoOpQeEI+
        7qhFunhenmzyJbvtwtN6G1CRVZyJAKq6vw2dAh9NRhvgaPOlzfa/bd9hecaqklwCRp0tKizrd4fo5
        YjYSc4GQ==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Ut-Fe; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006fq-AC; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH 05/14] media: pci: fix several typos
Date:   Mon, 18 Feb 2019 14:28:59 -0500
Message-Id: <5a496a8eb414e592ae74a94ae22d191eac2685d6.1550518128.git.mchehab+samsung@kernel.org>
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
 drivers/media/pci/bt8xx/bttv-audio-hook.c  |  2 +-
 drivers/media/pci/bt8xx/bttv-audio-hook.h  |  2 +-
 drivers/media/pci/bt8xx/bttv-cards.c       | 12 ++++++------
 drivers/media/pci/bt8xx/bttv-driver.c      |  4 ++--
 drivers/media/pci/bt8xx/bttv-risc.c        |  2 +-
 drivers/media/pci/bt8xx/bttv.h             |  2 +-
 drivers/media/pci/bt8xx/dst.c              | 22 +++++++++++-----------
 drivers/media/pci/cobalt/cobalt-v4l2.c     |  2 +-
 drivers/media/pci/cx18/cx18-cards.h        |  2 +-
 drivers/media/pci/cx18/cx18-dvb.c          |  4 ++--
 drivers/media/pci/cx18/cx18-fileops.c      |  2 +-
 drivers/media/pci/cx18/cx18-io.h           |  2 +-
 drivers/media/pci/cx18/cx18-vbi.c          |  2 +-
 drivers/media/pci/cx18/cx23418.h           |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c    |  2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c   |  2 +-
 drivers/media/pci/cx23885/cx23885-core.c   |  6 +++---
 drivers/media/pci/cx23885/cx23885.h        |  2 +-
 drivers/media/pci/cx23885/cx23888-ir.c     |  4 ++--
 drivers/media/pci/cx25821/cx25821-alsa.c   |  2 +-
 drivers/media/pci/cx25821/cx25821-sram.h   |  2 +-
 drivers/media/pci/cx25821/cx25821.h        |  2 +-
 drivers/media/pci/dm1105/dm1105.c          |  2 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c          |  2 +-
 drivers/media/pci/meye/meye.h              |  2 +-
 drivers/media/pci/ngene/ngene-core.c       |  2 +-
 drivers/media/pci/pt3/pt3.h                |  2 +-
 drivers/media/pci/saa7134/saa7134-cards.c  |  2 +-
 drivers/media/pci/saa7146/mxb.c            |  4 ++--
 drivers/media/pci/saa7164/saa7164-api.c    |  2 +-
 drivers/media/pci/saa7164/saa7164-cards.c  |  4 ++--
 drivers/media/pci/saa7164/saa7164-core.c   |  4 ++--
 drivers/media/pci/saa7164/saa7164-fw.c     |  2 +-
 drivers/media/pci/solo6x10/solo6x10-disp.c |  4 ++--
 drivers/media/pci/sta2x11/sta2x11_vip.c    |  2 +-
 drivers/media/pci/ttpci/av7110.c           |  6 +++---
 drivers/media/pci/tw68/tw68-video.c        |  2 +-
 38 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-audio-hook.c b/drivers/media/pci/bt8xx/bttv-audio-hook.c
index 346fc7f58839..8febe7358a8f 100644
--- a/drivers/media/pci/bt8xx/bttv-audio-hook.c
+++ b/drivers/media/pci/bt8xx/bttv-audio-hook.c
@@ -1,5 +1,5 @@
 /*
- * Handlers for board audio hooks, splitted from bttv-cards
+ * Handlers for board audio hooks, split from bttv-cards
  *
  * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  * This code is placed under the terms of the GNU General Public License
diff --git a/drivers/media/pci/bt8xx/bttv-audio-hook.h b/drivers/media/pci/bt8xx/bttv-audio-hook.h
index be16a537a03a..c61b9ac4f4e3 100644
--- a/drivers/media/pci/bt8xx/bttv-audio-hook.h
+++ b/drivers/media/pci/bt8xx/bttv-audio-hook.h
@@ -1,5 +1,5 @@
 /*
- * Handlers for board audio hooks, splitted from bttv-cards
+ * Handlers for board audio hooks, split from bttv-cards
  *
  * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  * This code is placed under the terms of the GNU General Public License
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 2616243b2c49..b1c6f3e9c3d0 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -2,7 +2,7 @@
 
     bttv-cards.c
 
-    this file has configuration informations - card-specific stuff
+    this file has configuration information - card-specific stuff
     like the big tvcards array for the most part
 
     Copyright (C) 1996,97,98 Ralph  Metzler (rjkm@thp.uni-koeln.de)
@@ -1391,7 +1391,7 @@ struct tvcard bttv_tvcards[] = {
 		.gpiomux        = {0x947fff, 0x987fff,0x947fff,0x947fff },
 		.gpiomute	= 0x947fff,
 		/* tvtuner, radio,   external,internal, mute,  stereo
-		* tuner, Composit, SVid, Composit-on-Svid-adapter */
+		* tuner, Composite, SVid, Composite-on-Svid-adapter */
 		.muxsel         = MUXSEL(2, 3, 0, 1),
 		.tuner_type     = TUNER_MT2032,
 		.tuner_addr	= ADDR_UNSET,
@@ -1411,7 +1411,7 @@ struct tvcard bttv_tvcards[] = {
 		.gpiomux        = {0x947fff, 0x987fff,0x947fff,0x947fff },
 		.gpiomute	= 0x947fff,
 		/* tvtuner, radio,   external,internal, mute,  stereo
-		* tuner, Composit, SVid, Composit-on-Svid-adapter */
+		* tuner, Composite, SVid, Composite-on-Svid-adapter */
 		.muxsel         = MUXSEL(2, 3, 0, 1),
 		.tuner_type     = TUNER_MT2032,
 		.tuner_addr	= ADDR_UNSET,
@@ -4180,7 +4180,7 @@ static void init_PXC200(struct bttv *btv)
 	bttv_I2CWrite(btv,0x5E,0,0x80,1);
 
 	/*	Initialise 12C508 PIC */
-	/*	The I2CWrite and I2CRead commmands are actually to the
+	/*	The I2CWrite and I2CRead commands are actually to the
 	 *	same chips - but the R/W bit is included in the address
 	 *	argument so the numbers are different */
 
@@ -4289,7 +4289,7 @@ init_RTV24 (struct bttv *btv)
 /* ----------------------------------------------------------------------- */
 /*
  *  The PCI-8604PW contains a CPLD, probably an ispMACH 4A, that filters
- *  the PCI REQ signals comming from the four BT878 chips. After power
+ *  the PCI REQ signals coming from the four BT878 chips. After power
  *  up, the CPLD does not forward requests to the bus, which prevents
  *  the BT878 from fetching RISC instructions from memory. While the
  *  CPLD is connected to most of the GPIOs of PCI device 0xD, only
@@ -4405,7 +4405,7 @@ static void rv605_muxsel(struct bttv *btv, unsigned int input)
 
 	gpio_bits(0x07f, muxgpio[input]);
 
-	/* reset all conections */
+	/* reset all connections */
 	gpio_bits(0x200,0x200);
 	mdelay(1);
 	gpio_bits(0x200,0x000);
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 5e769c09dbd0..b7150648081d 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2435,7 +2435,7 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.field = field;
 
-	/* update our state informations */
+	/* update our state information */
 	fh->fmt              = fmt;
 	fh->cap.field        = f->fmt.pix.field;
 	fh->cap.last         = V4L2_FIELD_NONE;
@@ -3064,7 +3064,7 @@ static int bttv_open(struct file *file)
 	   V4L2 apps we now reset the cropping parameters as seen through
 	   this fh, which is to say VIDIOC_G_SELECTION and scaling limit checks
 	   will use btv->crop[0], the default cropping parameters for the
-	   current video standard, and VIDIOC_S_FMT will not implicitely
+	   current video standard, and VIDIOC_S_FMT will not implicitly
 	   change the cropping parameters until VIDIOC_S_SELECTION has been
 	   called. */
 	fh->do_crop = !reset_crop; /* module parameter */
diff --git a/drivers/media/pci/bt8xx/bttv-risc.c b/drivers/media/pci/bt8xx/bttv-risc.c
index 74aff6877d9c..6b3c73674a3c 100644
--- a/drivers/media/pci/bt8xx/bttv-risc.c
+++ b/drivers/media/pci/bt8xx/bttv-risc.c
@@ -93,7 +93,7 @@ bttv_risc_packed(struct bttv *btv, struct btcx_riscmem *risc,
 			*(rp++)=cpu_to_le32(sg_dma_address(sg)+offset);
 			offset+=bpl;
 		} else {
-			/* scanline needs to be splitted */
+			/* scanline needs to be split */
 			todo = bpl;
 			*(rp++)=cpu_to_le32(BT848_RISC_WRITE|BT848_RISC_SOL|
 					    (sg_dma_len(sg)-offset));
diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
index a27384adadd2..d24b9ef9f59f 100644
--- a/drivers/media/pci/bt8xx/bttv.h
+++ b/drivers/media/pci/bt8xx/bttv.h
@@ -288,7 +288,7 @@ extern void bttv_init_card1(struct bttv *btv);
 extern void bttv_init_card2(struct bttv *btv);
 extern void bttv_init_tuner(struct bttv *btv);
 
-/* card-specific funtions */
+/* card-specific functions */
 extern void tea5757_set_freq(struct bttv *btv, unsigned short freq);
 extern u32 bttv_tda9880_setnorm(struct bttv *btv, u32 gpiobits);
 
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index b98de2a22f78..c94318c71a0c 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -1295,15 +1295,15 @@ static int dst_get_signal(struct dst_state *state)
 
 static int dst_tone_power_cmd(struct dst_state *state)
 {
-	u8 paket[8] = { 0x00, 0x09, 0xff, 0xff, 0x01, 0x00, 0x00, 0x00 };
+	u8 packet[8] = { 0x00, 0x09, 0xff, 0xff, 0x01, 0x00, 0x00, 0x00 };
 
 	if (state->dst_type != DST_TYPE_IS_SAT)
 		return -EOPNOTSUPP;
-	paket[4] = state->tx_tuna[4];
-	paket[2] = state->tx_tuna[2];
-	paket[3] = state->tx_tuna[3];
-	paket[7] = dst_check_sum (paket, 7);
-	return dst_command(state, paket, 8);
+	packet[4] = state->tx_tuna[4];
+	packet[2] = state->tx_tuna[2];
+	packet[3] = state->tx_tuna[3];
+	packet[7] = dst_check_sum (packet, 7);
+	return dst_command(state, packet, 8);
 }
 
 static int dst_get_tuna(struct dst_state *state)
@@ -1429,18 +1429,18 @@ static int dst_write_tuna(struct dvb_frontend *fe)
 static int dst_set_diseqc(struct dvb_frontend *fe, struct dvb_diseqc_master_cmd *cmd)
 {
 	struct dst_state *state = fe->demodulator_priv;
-	u8 paket[8] = { 0x00, 0x08, 0x04, 0xe0, 0x10, 0x38, 0xf0, 0xec };
+	u8 packet[8] = { 0x00, 0x08, 0x04, 0xe0, 0x10, 0x38, 0xf0, 0xec };
 
 	if (state->dst_type != DST_TYPE_IS_SAT)
 		return -EOPNOTSUPP;
 	if (cmd->msg_len > 0 && cmd->msg_len < 5)
-		memcpy(&paket[3], cmd->msg, cmd->msg_len);
+		memcpy(&packet[3], cmd->msg, cmd->msg_len);
 	else if (cmd->msg_len == 5 && state->dst_hw_cap & DST_TYPE_HAS_DISEQC5)
-		memcpy(&paket[2], cmd->msg, cmd->msg_len);
+		memcpy(&packet[2], cmd->msg, cmd->msg_len);
 	else
 		return -EINVAL;
-	paket[7] = dst_check_sum(&paket[0], 7);
-	return dst_command(state, paket, 8);
+	packet[7] = dst_check_sum(&packet[0], 7);
+	return dst_command(state, packet, 8);
 }
 
 static int dst_set_voltage(struct dvb_frontend *fe, enum fe_sec_voltage voltage)
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index c088de551081..f9fa3a7c3b8f 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -375,7 +375,7 @@ static void cobalt_dma_stop_streaming(struct cobalt_stream *s)
 	}
 	spin_unlock_irqrestore(&s->irqlock, flags);
 
-	/* Wait 100 milisecond for DMA to finish, abort on timeout. */
+	/* Wait 100 millisecond for DMA to finish, abort on timeout. */
 	if (!wait_event_timeout(s->q.done_wq, is_dma_done(s),
 				msecs_to_jiffies(timeout_msec))) {
 		omni_sg_dma_abort_channel(s);
diff --git a/drivers/media/pci/cx18/cx18-cards.h b/drivers/media/pci/cx18/cx18-cards.h
index 02d0fb703a41..c563cc2358ba 100644
--- a/drivers/media/pci/cx18/cx18-cards.h
+++ b/drivers/media/pci/cx18/cx18-cards.h
@@ -83,7 +83,7 @@ struct cx18_gpio_i2c_slave_reset {
 	u32 active_hi_mask; /* GPIO outputs that reset i2c chips when high */
 	int msecs_asserted; /* time period reset must remain asserted */
 	int msecs_recovery; /* time after deassert for chips to be ready */
-	u32 ir_reset_mask;  /* GPIO to reset the Zilog Z8F0811 IR contoller */
+	u32 ir_reset_mask;  /* GPIO to reset the Zilog Z8F0811 IR controller */
 };
 
 struct cx18_gpio_audio_input {	/* select tuner/line in input */
diff --git a/drivers/media/pci/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
index a3a7f7065349..51ecbe350d0e 100644
--- a/drivers/media/pci/cx18/cx18-dvb.c
+++ b/drivers/media/pci/cx18/cx18-dvb.c
@@ -120,8 +120,8 @@ static struct zl10353_config leadtek_dvr3100h_demod = {
 /*
  * Due to
  *
- * 1. an absence of information on how to prgram the MT352
- * 2. the Linux mt352 module pushing MT352 initialzation off onto us here
+ * 1. an absence of information on how to program the MT352
+ * 2. the Linux mt352 module pushing MT352 initialization off onto us here
  *
  * We have to use an init sequence that *you* must extract from the Windows
  * driver (yuanrap.sys) and which we load as a firmware.
diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
index a3f44e30f821..f778965a2eb8 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -403,7 +403,7 @@ static size_t cx18_copy_mdl_to_user(struct cx18_stream *s,
 		tot_written += rc;
 
 		if (stop ||	/* Forced stopping point for VBI insertion */
-		    tot_written >= ucount ||	/* Reader request statisfied */
+		    tot_written >= ucount ||	/* Reader request satisfied */
 		    mdl->curr_buf->readpos < mdl->curr_buf->bytesused ||
 		    mdl->readpos >= mdl->bytesused) /* MDL buffers drained */
 			break;
diff --git a/drivers/media/pci/cx18/cx18-io.h b/drivers/media/pci/cx18/cx18-io.h
index a3c96fb5d28d..da7871fdb56d 100644
--- a/drivers/media/pci/cx18/cx18-io.h
+++ b/drivers/media/pci/cx18/cx18-io.h
@@ -23,7 +23,7 @@
 /*
  * Readback and retry of MMIO access for reliability:
  * The concept was suggested by Steve Toth <stoth@linuxtv.org>.
- * The implmentation is the fault of Andy Walls <awalls@md.metrocast.net>.
+ * The implementation is the fault of Andy Walls <awalls@md.metrocast.net>.
  *
  * *write* functions are implied to retry the mmio unless suffixed with _noretry
  * *read* functions never retry the mmio (it never helps to do so)
diff --git a/drivers/media/pci/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
index 81f1e27436fd..48cb96f953a0 100644
--- a/drivers/media/pci/cx18/cx18-vbi.c
+++ b/drivers/media/pci/cx18/cx18-vbi.c
@@ -24,7 +24,7 @@
 /*
  * Raster Reference/Protection (RP) bytes, used in Start/End Active
  * Video codes emitted from the digitzer in VIP 1.x mode, that flag the start
- * of VBI sample or VBI ancillary data regions in the digitial ratser line.
+ * of VBI sample or VBI ancillary data regions in the digital ratser line.
  *
  * Task FieldEven VerticalBlank HorizontalBlank 0 0 0 0
  */
diff --git a/drivers/media/pci/cx18/cx23418.h b/drivers/media/pci/cx18/cx23418.h
index 15205b662952..e9f6e50ca5b4 100644
--- a/drivers/media/pci/cx18/cx23418.h
+++ b/drivers/media/pci/cx18/cx23418.h
@@ -439,7 +439,7 @@
 /* Error in I2C data xfer (but I2C device is present) */
 #define CXERR_I2CDEV_XFERERR    0x000011
 
-/* Chanel changing component not ready */
+/* Channel changing component not ready */
 #define CXERR_CHANNELNOTREADY   0x000012
 
 /* PPU (Presensation/Decoder) mail box is corrupted */
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index a00b77d80ed9..4863bd4ea5d0 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1561,7 +1561,7 @@ int cx23885_417_register(struct cx23885_dev *dev)
 	pr_info("%s: registered device %s [mpeg]\n",
 	       dev->name, video_device_node_name(dev->v4l_device));
 
-	/* ST: Configure the encoder paramaters, but don't begin
+	/* ST: Configure the encoder parameters, but don't begin
 	 * encoding, this resolves an issue where the first time the
 	 * encoder is started video can be choppy.
 	 */
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index ee9d329c4038..c9c1385208f9 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -59,7 +59,7 @@ module_param(audio_debug, int, 0644);
 MODULE_PARM_DESC(audio_debug, "enable debug messages [analog audio]");
 
 /****************************************************************************
-			Board specific funtions
+			Board specific functions
  ****************************************************************************/
 
 /* Constants taken from cx88-reg.h */
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index fd5c52b21436..cec3cbca8d32 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1996,9 +1996,9 @@ static inline int encoder_on_portc(struct cx23885_dev *dev)
  * and report errors if we think we're tampering with a GPIo that might
  * be assigned to the encoder (and used for the host bus).
  *
- * GPIO  2 thru  0 - On the cx23885 bridge
- * GPIO 18 thru  3 - On the cx23417 host bus interface
- * GPIO 23 thru 19 - On the cx25840 a/v core
+ * GPIO  2 through  0 - On the cx23885 bridge
+ * GPIO 18 through  3 - On the cx23417 host bus interface
+ * GPIO 23 through 19 - On the cx25840 a/v core
  */
 void cx23885_gpio_set(struct cx23885_dev *dev, u32 mask)
 {
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index cf965efabe66..4d34799431dc 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -246,7 +246,7 @@ struct cx23885_i2c {
 	struct i2c_client          i2c_client;
 	u32                        i2c_rc;
 
-	/* 885 registers used for raw addess */
+	/* 885 registers used for raw address */
 	u32                        i2c_period;
 	u32                        reg_ctrl;
 	u32                        reg_stat;
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index 1d775c90df51..a4d66141c4bb 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -548,7 +548,7 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
 	ror = stats & STATS_ROR; /* Rx FIFO Over Run */
 
 	tse = irqen & IRQEN_TSE; /* Tx FIFO Service Request IRQ Enable */
-	rse = irqen & IRQEN_RSE; /* Rx FIFO Service Reuqest IRQ Enable */
+	rse = irqen & IRQEN_RSE; /* Rx FIFO Service Request IRQ Enable */
 	rte = irqen & IRQEN_RTE; /* Rx Pulse Width Timer Time Out IRQ Enable */
 	roe = irqen & IRQEN_ROE; /* Rx FIFO Over Run IRQ Enable */
 
@@ -638,7 +638,7 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
 		events |= V4L2_SUBDEV_IR_RX_END_OF_RX_DETECTED;
 	}
 	if (v) {
-		/* Clear STATS_ROR & STATS_RTO as needed by reseting hardware */
+		/* Clear STATS_ROR & STATS_RTO as needed by resetting hardware */
 		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl & ~v);
 		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl);
 		*handled = true;
diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 0a6c90e92557..926e12a1554a 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -120,7 +120,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
 /****************************************************************************
-			Module specific funtions
+			Module specific functions
  ****************************************************************************/
 /* Constants taken from cx88-reg.h */
 #define AUD_INT_DN_RISCI1       (1 <<  0)
diff --git a/drivers/media/pci/cx25821/cx25821-sram.h b/drivers/media/pci/cx25821/cx25821-sram.h
index b94e0d4df664..a907662dbb1c 100644
--- a/drivers/media/pci/cx25821/cx25821-sram.h
+++ b/drivers/media/pci/cx25821/cx25821-sram.h
@@ -24,7 +24,7 @@
 #define AUDIO_CMDS_SIZE           80	/* AUDIO CMDS size in bytes */
 #define MBIF_CMDS_SIZE            80	/* MBIF  CMDS size in bytes */
 
-/* #define RX_SRAM_POOL_START_SIZE   = 0;  //  Start of useable RX SRAM for buffers */
+/* #define RX_SRAM_POOL_START_SIZE   = 0;  //  Start of usable RX SRAM for buffers */
 #define VID_IQ_SIZE               64	/* VID instruction queue size in bytes */
 #define MBIF_IQ_SIZE              64
 #define AUDIO_IQ_SIZE             64	/* AUD instruction queue size in bytes */
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 25eba4ac4499..b422275ff4f1 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -156,7 +156,7 @@ struct cx25821_i2c {
 	struct i2c_client i2c_client;
 	u32 i2c_rc;
 
-	/* cx25821 registers used for raw addess */
+	/* cx25821 registers used for raw address */
 	u32 i2c_period;
 	u32 reg_ctrl;
 	u32 reg_stat;
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index a84c8270ea13..60138ca3372b 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -517,7 +517,7 @@ static int dm1105_i2c_xfer(struct i2c_adapter *i2c_adap,
 				msgs[i].buf[byte] = rc;
 			}
 		} else if ((msgs[i].buf[0] == 0xf7) && (msgs[i].addr == 0x55)) {
-			/* prepaired for cx24116 firmware */
+			/* prepared for cx24116 firmware */
 			/* Write in small blocks */
 			len = msgs[i].len - 1;
 			k = 1;
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 9b664c02ed03..617fb2e944dc 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -264,7 +264,7 @@ static void cio2_fbpt_exit(struct cio2_queue *q, struct device *dev)
  */
 
 /*
- * shift for keeping value range suitable for 32-bit integer arithmetics
+ * shift for keeping value range suitable for 32-bit integer arithmetic
  */
 #define LIMIT_SHIFT	8
 
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 1380474519f2..c3c2c79585f5 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -110,7 +110,7 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
 			/*
 			 * Inherit the -EFAULT from rc's
 			 * initialization, but allow it to be
-			 * overriden by uv_pages above if it was an
+			 * overridden by uv_pages above if it was an
 			 * actual errno.
 			 */
 		} else {
diff --git a/drivers/media/pci/meye/meye.h b/drivers/media/pci/meye/meye.h
index 0af868eb6210..aff6631535be 100644
--- a/drivers/media/pci/meye/meye.h
+++ b/drivers/media/pci/meye/meye.h
@@ -281,7 +281,7 @@ struct meye_grab_buffer {
 	unsigned long sequence;		/* sequence number */
 };
 
-/* size of kfifos containings buffer indices */
+/* size of kfifos containing buffer indices */
 #define MEYE_QUEUE_SIZE	MEYE_MAX_BUFNBRS
 
 /* Motion Eye device structure */
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 25f16833a475..27953b3610a3 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1014,7 +1014,7 @@ static int FillTSIdleBuffer(struct SRingBufferDescriptor *pIdleBuffer,
 	/* Point to first buffer entry */
 	struct SBufferHeader *Cur = pRingBuffer->Head;
 	int i;
-	/* Loop thru all buffer and set Buffer 2 pointers to TSIdlebuffer */
+	/* Loop through all buffer and set Buffer 2 pointers to TSIdlebuffer */
 	for (i = 0; i < n; i++) {
 		Cur->Buffer2 = pIdleBuffer->Head->Buffer1;
 		Cur->scList2 = pIdleBuffer->Head->scList1;
diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
index 495891a4ee17..a53124438f51 100644
--- a/drivers/media/pci/pt3/pt3.h
+++ b/drivers/media/pci/pt3/pt3.h
@@ -76,7 +76,7 @@ struct xfer_desc {
 	u32 addr_l; /* bus address of target data buffer */
 	u32 addr_h;
 	u32 size;
-	u32 next_l; /* bus adddress of the next xfer_desc */
+	u32 next_l; /* bus address of the next xfer_desc */
 	u32 next_h;
 };
 
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 40ce033cb884..94d6484a3afe 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -6423,7 +6423,7 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5168,
-		.subdevice    = 0x3502,  /* whats the difference to 0x3306 ?*/
+		.subdevice    = 0x3502,  /* what's the difference to 0x3306 ?*/
 		.driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 44440c6208df..e94324b1de68 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -399,7 +399,7 @@ static int mxb_init_done(struct saa7146_dev* dev)
 
 	/* check if the saa7740 (aka 'sound arena module') is present
 	   on the mxb. if so, we must initialize it. due to lack of
-	   informations about the saa7740, the values were reverse
+	   information about the saa7740, the values were reverse
 	   engineered. */
 	msg.addr = 0x1b;
 	msg.flags = 0;
@@ -495,7 +495,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 			input_port_selection[input].hps_sync);
 
 	/* prepare switching of tea6415c and saa7111a;
-	   have a look at the 'background'-file for further informations  */
+	   have a look at the 'background'-file for further information  */
 	switch (input) {
 	case TUNER:
 		i = SAA7115_COMPOSITE0;
diff --git a/drivers/media/pci/saa7164/saa7164-api.c b/drivers/media/pci/saa7164/saa7164-api.c
index e318ccf81277..d6c996f39cf2 100644
--- a/drivers/media/pci/saa7164/saa7164-api.c
+++ b/drivers/media/pci/saa7164/saa7164-api.c
@@ -749,7 +749,7 @@ int saa7164_api_initialize_dif(struct saa7164_port *port)
 	if (port->type == SAA7164_MPEG_ENCODER) {
 		/* Pick any analog standard to init the diff.
 		 * we'll come back during encoder_init'
-		 * and set the correct standard if requried.
+		 * and set the correct standard if required.
 		 */
 		std = V4L2_STD_NTSC;
 	} else
diff --git a/drivers/media/pci/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
index 3af16062e79d..9a6fe7cd4d59 100644
--- a/drivers/media/pci/saa7164/saa7164-cards.c
+++ b/drivers/media/pci/saa7164/saa7164-cards.c
@@ -685,7 +685,7 @@ struct saa7164_subid saa7164_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0xf111,
 		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2255,
-		/* Prototype card left here for documenation purposes.
+		/* Prototype card left here for documentation purposes.
 		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2255proto,
 		*/
 	}, {
@@ -866,7 +866,7 @@ void saa7164_card_setup(struct saa7164_dev *dev)
  * access to I2C. Instead we have to communicate through the device f/w for
  * register access to 'processing units'. Each unit has a unique
  * id, regardless of how the physical implementation occurs across
- * the three physical i2c busses. The being said if we want leverge of
+ * the three physical i2c buses. The being said if we want leverge of
  * the existing kernel drivers for tuners and demods we have to 'speak i2c',
  * to this bridge implements 3 virtual i2c buses. This is a helper function
  * for those.
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index f33349e16359..05f25c9bb308 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -157,7 +157,7 @@ static void saa7164_ts_verifier(struct saa7164_buffer *buf)
 
 	}
 
-	/* Only report errors if we've been through this function atleast
+	/* Only report errors if we've been through this function at least
 	 * once already and the cached cc values are primed. First time through
 	 * always generates errors.
 	 */
@@ -1020,7 +1020,7 @@ static int saa7164_dev_setup(struct saa7164_dev *dev)
 	dev->bmmio = (u8 __iomem *)dev->lmmio;
 	dev->bmmio2 = (u8 __iomem *)dev->lmmio2;
 
-	/* Inerrupt and ack register locations offset of bmmio */
+	/* Interrupt and ack register locations offset of bmmio */
 	dev->int_status = 0x183000 + 0xf80;
 	dev->int_ack = 0x183000 + 0xf90;
 
diff --git a/drivers/media/pci/saa7164/saa7164-fw.c b/drivers/media/pci/saa7164/saa7164-fw.c
index a50461861133..ed27b3ce5e8e 100644
--- a/drivers/media/pci/saa7164/saa7164-fw.c
+++ b/drivers/media/pci/saa7164/saa7164-fw.c
@@ -409,7 +409,7 @@ int saa7164_downloadfirmware(struct saa7164_dev *dev)
 		(version & 0x0000001f),
 		(version & 0xffff0000) >> 16);
 
-	/* Load the firmwware from the disk if required */
+	/* Load the firmware from the disk if required */
 	if (version == 0) {
 
 		printk(KERN_INFO "%s() Waiting for firmware upload (%s)\n",
diff --git a/drivers/media/pci/solo6x10/solo6x10-disp.c b/drivers/media/pci/solo6x10/solo6x10-disp.c
index 11c98f0625e4..f61007022471 100644
--- a/drivers/media/pci/solo6x10/solo6x10-disp.c
+++ b/drivers/media/pci/solo6x10/solo6x10-disp.c
@@ -71,7 +71,7 @@ static void solo_vin_config(struct solo_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_VI_CH_FORMAT,
 		       SOLO_VI_FD_SEL_MASK(0) | SOLO_VI_PROG_MASK(0));
 
-	/* On 6110, initialize mozaic darkness stength */
+	/* On 6110, initialize mozaic darkness strength */
 	if (solo_dev->type == SOLO_DEV_6010)
 		solo_reg_write(solo_dev, SOLO_VI_FMT_CFG, 0);
 	else
@@ -230,7 +230,7 @@ int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 }
 
 /* First 8k is motion flag (512 bytes * 16). Following that is an 8k+8k
- * threshold and working table for each channel. Atleast that's what the
+ * threshold and working table for each channel. At least that's what the
  * spec says. However, this code (taken from rdk) has some mystery 8k
  * block right after the flag area, before the first thresh table. */
 static void solo_motion_config(struct solo_dev *solo_dev)
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 411177ec4d72..2452d8f59cb0 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -110,7 +110,7 @@ static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
  * @std: video standard (e.g. PAL/NTSC)
  * @input: input line for video signal ( 0 or 1 )
  * @disabled: Device is in power down state
- * @slock: for excluse acces of registers
+ * @slock: for excluse access of registers
  * @vb_vidq: queue maintained by videobuf2 layer
  * @buffer_list: list of buffer in use
  * @sequence: sequence number of acquired buffer
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 409defc75c05..9345287ad963 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2313,7 +2313,7 @@ static int frontend_init(struct av7110 *av7110)
  * (n in defined in the RPS_THRESH1 counter threshold)
  * I think HS is raised high on the beginning of the n-th line
  * and remains high until this n-th line that triggered
- * it is completely received. When the receiption of n-th line
+ * it is completely received. When the reception of n-th line
  * ends, HS is lowered.
  *
  * To transmit data over DMA, 7146 needs changing state at
@@ -2347,7 +2347,7 @@ static int frontend_init(struct av7110 *av7110)
  * hardware debug note: a working budget card (including budget patch)
  * with vpeirq() interrupt setup in mode "0x90" (every 64K) will
  * generate 3 interrupts per 25-Hz DMA frame of 2*188*512 bytes
- * and that means 3*25=75 Hz of interrupt freqency, as seen by
+ * and that means 3*25=75 Hz of interrupt frequency, as seen by
  * watch cat /proc/interrupts
  *
  * If this frequency is 3x lower (and data received in the DMA
@@ -2356,7 +2356,7 @@ static int frontend_init(struct av7110 *av7110)
  * this means VSYNC line is not connected in the hardware.
  * (check soldering pcb and pins)
  * The same behaviour of missing VSYNC can be duplicated on budget
- * cards, by seting DD1_INIT trigger mode 7 in 3rd nibble.
+ * cards, by setting DD1_INIT trigger mode 7 in 3rd nibble.
  */
 static int av7110_attach(struct saa7146_dev* dev,
 			 struct saa7146_pci_extension_data *pci_ext)
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index d3f727045ae8..4f74b14c3b4f 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -446,7 +446,7 @@ static void tw68_buf_queue(struct vb2_buffer *vb)
 /*
  * buffer_prepare
  *
- * Set the ancilliary information into the buffer structure.  This
+ * Set the ancillary information into the buffer structure.  This
  * includes generating the necessary risc program if it hasn't already
  * been done for the current buffer format.
  * The structure fh contains the details of the format requested by the
-- 
2.20.1

