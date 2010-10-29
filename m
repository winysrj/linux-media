Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59814 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572Ab0J2TIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 15:08:06 -0400
Subject: [PATCH 2/7] ir-core: convert drivers/media/video/cx88 to ir-core
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Fri, 29 Oct 2010 21:08:02 +0200
Message-ID: <20101029190802.11982.96234.stgit@localhost.localdomain>
In-Reply-To: <20101029190745.11982.75723.stgit@localhost.localdomain>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch converts the cx88 driver (for sampling hw) to use the
decoders provided by ir-core instead of the separate ones provided
by ir-functions (and gets rid of those).

The value for MO_DDS_IO had a comment saying it corresponded to
a 4kHz samplerate. That comment was unfortunately misleading. The
actual samplerate was something like 3250Hz.

The current value has been derived by analyzing the elapsed time
between interrupts for different values (knowing that each interrupt
corresponds to 32 samples).

Thanks to Mariusz Bialonczyk <manio@skyboo.net> for testing my patches
(about one a day for two weeks!) on actual hardware.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-functions.c       |  134 ---------------------------
 drivers/media/video/cx88/Kconfig      |    2 
 drivers/media/video/cx88/cx88-input.c |  163 +++++++--------------------------
 include/media/ir-common.h             |    3 -
 4 files changed, 37 insertions(+), 265 deletions(-)

diff --git a/drivers/media/IR/ir-functions.c b/drivers/media/IR/ir-functions.c
index db591e4..f4c4115 100644
--- a/drivers/media/IR/ir-functions.c
+++ b/drivers/media/IR/ir-functions.c
@@ -111,140 +111,6 @@ u32 ir_extract_bits(u32 data, u32 mask)
 }
 EXPORT_SYMBOL_GPL(ir_extract_bits);
 
-static int inline getbit(u32 *samples, int bit)
-{
-	return (samples[bit/32] & (1 << (31-(bit%32)))) ? 1 : 0;
-}
-
-/* sump raw samples for visual debugging ;) */
-int ir_dump_samples(u32 *samples, int count)
-{
-	int i, bit, start;
-
-	printk(KERN_DEBUG "ir samples: ");
-	start = 0;
-	for (i = 0; i < count * 32; i++) {
-		bit = getbit(samples,i);
-		if (bit)
-			start = 1;
-		if (0 == start)
-			continue;
-		printk("%s", bit ? "#" : "_");
-	}
-	printk("\n");
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_dump_samples);
-
-/* decode raw samples, pulse distance coding used by NEC remotes */
-int ir_decode_pulsedistance(u32 *samples, int count, int low, int high)
-{
-	int i,last,bit,len;
-	u32 curBit;
-	u32 value;
-
-	/* find start burst */
-	for (i = len = 0; i < count * 32; i++) {
-		bit = getbit(samples,i);
-		if (bit) {
-			len++;
-		} else {
-			if (len >= 29)
-				break;
-			len = 0;
-		}
-	}
-
-	/* start burst to short */
-	if (len < 29)
-		return 0xffffffff;
-
-	/* find start silence */
-	for (len = 0; i < count * 32; i++) {
-		bit = getbit(samples,i);
-		if (bit) {
-			break;
-		} else {
-			len++;
-		}
-	}
-
-	/* silence to short */
-	if (len < 7)
-		return 0xffffffff;
-
-	/* go decoding */
-	len   = 0;
-	last = 1;
-	value = 0; curBit = 1;
-	for (; i < count * 32; i++) {
-		bit  = getbit(samples,i);
-		if (last) {
-			if(bit) {
-				continue;
-			} else {
-				len = 1;
-			}
-		} else {
-			if (bit) {
-				if (len > (low + high) /2)
-					value |= curBit;
-				curBit <<= 1;
-				if (curBit == 1)
-					break;
-			} else {
-				len++;
-			}
-		}
-		last = bit;
-	}
-
-	return value;
-}
-EXPORT_SYMBOL_GPL(ir_decode_pulsedistance);
-
-/* decode raw samples, biphase coding, used by rc5 for example */
-int ir_decode_biphase(u32 *samples, int count, int low, int high)
-{
-	int i,last,bit,len,flips;
-	u32 value;
-
-	/* find start bit (1) */
-	for (i = 0; i < 32; i++) {
-		bit = getbit(samples,i);
-		if (bit)
-			break;
-	}
-
-	/* go decoding */
-	len   = 0;
-	flips = 0;
-	value = 1;
-	for (; i < count * 32; i++) {
-		if (len > high)
-			break;
-		if (flips > 1)
-			break;
-		last = bit;
-		bit  = getbit(samples,i);
-		if (last == bit) {
-			len++;
-			continue;
-		}
-		if (len < low) {
-			len++;
-			flips++;
-			continue;
-		}
-		value <<= 1;
-		value |= bit;
-		flips = 0;
-		len   = 1;
-	}
-	return value;
-}
-EXPORT_SYMBOL_GPL(ir_decode_biphase);
-
 /* RC5 decoding stuff, moved from bttv-input.c to share it with
  * saa7134 */
 
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index 0fa85cb..bcfd1ac 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX88
 	tristate "Conexant 2388x (bt878 successor) support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on VIDEO_DEV && PCI && I2C && INPUT && IR_CORE
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index fc777bc..436ace8 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -41,7 +41,6 @@ struct cx88_IR {
 	struct cx88_core *core;
 	struct input_dev *input;
 	struct ir_dev_props props;
-	u64 ir_type;
 
 	int users;
 
@@ -50,8 +49,6 @@ struct cx88_IR {
 
 	/* sample from gpio pin 16 */
 	u32 sampling;
-	u32 samples[16];
-	int scount;
 
 	/* poll external decoder */
 	int polling;
@@ -63,6 +60,10 @@ struct cx88_IR {
 	u32 mask_keyup;
 };
 
+static unsigned ir_samplerate = 4;
+module_param(ir_samplerate, uint, 0444);
+MODULE_PARM_DESC(ir_samplerate, "IR samplerate in kHz, 1 - 20, default 4");
+
 static int ir_debug;
 module_param(ir_debug, int, 0644);	/* debug level [IR] */
 MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
@@ -176,8 +177,8 @@ static int __cx88_ir_start(void *priv)
 	}
 	if (ir->sampling) {
 		core->pci_irqmask |= PCI_INT_IR_SMPINT;
-		cx_write(MO_DDS_IO, 0xa80a80);	/* 4 kHz sample rate */
-		cx_write(MO_DDSCFG_IO, 0x5);	/* enable */
+		cx_write(MO_DDS_IO, 0x33F286 * ir_samplerate); /* samplerate */
+		cx_write(MO_DDSCFG_IO, 0x5); /* enable */
 	}
 	return 0;
 }
@@ -264,7 +265,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
 		ir_codes = RC_MAP_CINERGY_1400;
-		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xeb04; /* address */
 		break;
 	case CX88_BOARD_HAUPPAUGE:
@@ -279,7 +279,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
 		ir_codes = RC_MAP_HAUPPAUGE_NEW;
-		ir_type = IR_TYPE_RC5;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
@@ -367,18 +366,15 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
 		ir_codes = RC_MAP_TBS_NEC;
-		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_TEVII_S460:
 	case CX88_BOARD_TEVII_S420:
 		ir_codes = RC_MAP_TEVII_NEC;
-		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
 		ir_codes         = RC_MAP_DNTV_LIVE_DVBT_PRO;
-		ir_type          = IR_TYPE_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	case CX88_BOARD_NORWOOD_MICRO:
@@ -396,7 +392,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
 		ir_codes         = RC_MAP_PINNACLE_PCTV_HD;
-		ir_type          = IR_TYPE_RC5;
 		ir->sampling     = 1;
 		break;
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
@@ -412,7 +407,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	}
 
-	if (NULL == ir_codes) {
+	if (!ir_codes) {
 		err = -ENODEV;
 		goto err_out_free;
 	}
@@ -436,8 +431,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	snprintf(ir->name, sizeof(ir->name), "cx88 IR (%s)", core->board.name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
 
-	ir->ir_type = ir_type;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
@@ -454,10 +447,18 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	ir->core = core;
 	core->ir = ir;
 
+	if (ir->sampling) {
+		ir_type = IR_TYPE_ALL;
+		ir->props.driver_type = RC_DRIVER_IR_RAW;
+		ir->props.timeout = 10 * 1000 * 1000; /* 10 ms */
+	} else
+		ir->props.driver_type = RC_DRIVER_SCANCODE;
+
 	ir->props.priv = core;
 	ir->props.open = cx88_ir_open;
 	ir->props.close = cx88_ir_close;
 	ir->props.scanmask = hardware_mask;
+	ir->props.allowed_protos = ir_type;
 
 	/* all done */
 	err = ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
@@ -494,128 +495,36 @@ int cx88_ir_fini(struct cx88_core *core)
 void cx88_ir_irq(struct cx88_core *core)
 {
 	struct cx88_IR *ir = core->ir;
-	u32 samples, ircode;
-	int i, start, range, toggle, dev, code;
+	u32 samples;
+	unsigned todo, bits;
+	struct ir_raw_event ev;
+	struct ir_input_dev *irdev;
 
-	if (NULL == ir)
-		return;
-	if (!ir->sampling)
+	if (!ir || !ir->sampling)
 		return;
 
+	/*
+	 * Samples are stored in a 32 bit register, oldest sample in
+	 * the msb. A set bit represents space and an unset bit
+	 * represents a pulse.
+	 */
 	samples = cx_read(MO_SAMPLE_IO);
-	if (0 != samples && 0xffffffff != samples) {
-		/* record sample data */
-		if (ir->scount < ARRAY_SIZE(ir->samples))
-			ir->samples[ir->scount++] = samples;
-		return;
-	}
-	if (!ir->scount) {
-		/* nothing to sample */
-		return;
-	}
-
-	/* have a complete sample */
-	if (ir->scount < ARRAY_SIZE(ir->samples))
-		ir->samples[ir->scount++] = samples;
-	for (i = 0; i < ir->scount; i++)
-		ir->samples[i] = ~ir->samples[i];
-	if (ir_debug)
-		ir_dump_samples(ir->samples, ir->scount);
-
-	/* decode it */
-	switch (core->boardnr) {
-	case CX88_BOARD_TEVII_S460:
-	case CX88_BOARD_TEVII_S420:
-	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
-	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
-	case CX88_BOARD_OMICOM_SS4_PCI:
-	case CX88_BOARD_SATTRADE_ST4200:
-	case CX88_BOARD_TBS_8920:
-	case CX88_BOARD_TBS_8910:
-	case CX88_BOARD_PROF_7300:
-	case CX88_BOARD_PROF_7301:
-	case CX88_BOARD_PROF_6200:
-	case CX88_BOARD_TWINHAN_VP1027_DVBS:
-		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);
-
-		if (ircode == 0xffffffff) { /* decoding error */
-			ir_dprintk("pulse distance decoding error\n");
-			break;
-		}
-
-		ir_dprintk("pulse distance decoded: %x\n", ircode);
+       	irdev = input_get_drvdata(ir->input);
 
-		if (ircode == 0) { /* key still pressed */
-			ir_dprintk("pulse distance decoded repeat code\n");
-			ir_repeat(ir->input);
-			break;
-		}
-
-		if ((ircode & 0xffff) != (ir->sampling & 0xffff)) { /* wrong address */
-			ir_dprintk("pulse distance decoded wrong address\n");
-			break;
-		}
-
-		if (((~ircode >> 24) & 0xff) != ((ircode >> 16) & 0xff)) { /* wrong checksum */
-			ir_dprintk("pulse distance decoded wrong check sum\n");
-			break;
-		}
+	if (samples == 0xff && irdev->idle)
+		return;
 
-		ir_dprintk("Key Code: %x\n", (ircode >> 16) & 0xff);
-		ir_keydown(ir->input, (ircode >> 16) & 0xff, 0);
-		break;
-	case CX88_BOARD_HAUPPAUGE:
-	case CX88_BOARD_HAUPPAUGE_DVB_T1:
-	case CX88_BOARD_HAUPPAUGE_NOVASE2_S1:
-	case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
-	case CX88_BOARD_HAUPPAUGE_HVR1100:
-	case CX88_BOARD_HAUPPAUGE_HVR3000:
-	case CX88_BOARD_HAUPPAUGE_HVR4000:
-	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
-	case CX88_BOARD_PCHDTV_HD3000:
-	case CX88_BOARD_PCHDTV_HD5500:
-	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ircode = ir_decode_biphase(ir->samples, ir->scount, 5, 7);
-		ir_dprintk("biphase decoded: %x\n", ircode);
-		/*
-		 * RC5 has an extension bit which adds a new range
-		 * of available codes, this is detected here. Also
-		 * hauppauge remotes (black/silver) always use
-		 * specific device ids. If we do not filter the
-		 * device ids then messages destined for devices
-		 * such as TVs (id=0) will get through to the
-		 * device causing mis-fired events.
-		 */
-		/* split rc5 data block ... */
-		start = (ircode & 0x2000) >> 13;
-		range = (ircode & 0x1000) >> 12;
-		toggle= (ircode & 0x0800) >> 11;
-		dev   = (ircode & 0x07c0) >> 6;
-		code  = (ircode & 0x003f) | ((range << 6) ^ 0x0040);
-		if( start != 1)
-			/* no key pressed */
-			break;
-		if ( dev != 0x1e && dev != 0x1f )
-			/* not a hauppauge remote */
-			break;
-		ir_keydown(ir->input, code, toggle);
-		break;
-	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
-		ircode = ir_decode_biphase(ir->samples, ir->scount, 5, 7);
-		ir_dprintk("biphase decoded: %x\n", ircode);
-		if ((ircode & 0xfffff000) != 0x3000)
-			break;
-		/* Note: bit 0x800 being the toggle is assumed, not checked
-		   with real hardware  */
-		ir_keydown(ir->input, ircode & 0x3f, ircode & 0x0800 ? 1 : 0);
-		break;
+	init_ir_raw_event(&ev);
+	for (todo = 32; todo > 0; todo -= bits) {
+		ev.pulse = samples & 0x80000000 ? false : true;
+		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
+		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
+		ir_raw_event_store_with_filter(ir->input, &ev);
+		samples <<= bits;
 	}
-
-	ir->scount = 0;
-	return;
+	ir_raw_event_handle(ir->input);
 }
 
-
 void cx88_i2c_init_ir(struct cx88_core *core)
 {
 	struct i2c_board_info info;
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 528050e..4152420 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -96,9 +96,6 @@ void ir_input_nokey(struct input_dev *dev, struct ir_input_state *ir);
 void ir_input_keydown(struct input_dev *dev, struct ir_input_state *ir,
 		      u32 ir_key);
 u32  ir_extract_bits(u32 data, u32 mask);
-int  ir_dump_samples(u32 *samples, int count);
-int  ir_decode_biphase(u32 *samples, int count, int low, int high);
-int  ir_decode_pulsedistance(u32 *samples, int count, int low, int high);
 u32  ir_rc5_decode(unsigned int code);
 
 void ir_rc5_timer_end(unsigned long data);

