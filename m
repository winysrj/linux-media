Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424Ab0DFSSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:32 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIWwl008028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:32 -0400
Date: Tue, 6 Apr 2010 15:18:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/26] V4L/DVB: ir-core: Make use of the new IR keymap
 modules
Message-ID: <20100406151802.5a0b8c66@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using the ugly keymap sequences, use the new rc-*.ko keymap
files. For now, it is still needed to have one keymap loaded, for the
RC code to work. Later patches will remove this depenency.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 include/media/rc-map.h

diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 3a4f590..3d8dd30 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -1,6 +1,8 @@
 ir-common-objs  := ir-functions.o ir-keymaps.o
 ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o rc-map.o
 
+obj-y += keymaps/
+
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 435d83e..0b05c7b 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -250,8 +250,10 @@ static int __init ir_core_init(void)
 		return rc;
 	}
 
-	/* Initialize/load the decoders that will be used */
+	/* Initialize/load the decoders/keymap code that will be used */
 	ir_raw_init();
+	rc_map_init();
+
 
 	return 0;
 }
diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
index 02c72f0..2f6201c 100644
--- a/drivers/media/IR/rc-map.c
+++ b/drivers/media/IR/rc-map.c
@@ -26,12 +26,14 @@ static struct rc_keymap *seek_rc_map(const char *name)
 
 	spin_lock(&rc_map_lock);
 	list_for_each_entry(map, &rc_map_list, list) {
-		if (!strcmp(name, map->map.name))
-			break;
+		if (!strcmp(name, map->map.name)) {
+			spin_unlock(&rc_map_lock);
+			return map;
+		}
 	}
 	spin_unlock(&rc_map_lock);
 
-	return map;
+	return NULL;
 }
 
 struct ir_scancode_table *get_rc_map(const char *name)
@@ -43,15 +45,22 @@ struct ir_scancode_table *get_rc_map(const char *name)
 	map = seek_rc_map(name);
 #ifdef MODULE
 	if (!map) {
-		rc = request_module("name");
-		if (rc < 0)
+		rc = request_module(name);
+		if (rc < 0) {
+			printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
 			return NULL;
+		}
+		msleep(20);	/* Give some time for IR to register */
 
 		map = seek_rc_map(name);
 	}
 #endif
-	if (!map)
+	if (!map) {
+		printk(KERN_ERR "IR keymap %s not found\n", name);
 		return NULL;
+	}
+
+	printk(KERN_INFO "Registered IR keymap %s\n", map->map.name);
 
 	return &map->map;
 }
@@ -73,3 +82,9 @@ void ir_unregister_map(struct rc_keymap *map)
 	spin_unlock(&rc_map_lock);
 }
 EXPORT_SYMBOL_GPL(ir_unregister_map);
+
+void rc_map_init(void)
+{
+	spin_lock_init(&rc_map_lock);
+
+}
diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index 3a67f30..333d7b1 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -595,7 +595,7 @@ static irqreturn_t dm1105_irq(int irq, void *dev_id)
 int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 {
 	struct input_dev *input_dev;
-	struct ir_scancode_table *ir_codes = &IR_KEYTABLE(dm1105_nec);
+	char *ir_codes = NULL;
 	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
 
@@ -629,7 +629,7 @@ int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 
 	INIT_WORK(&dm1105->ir.work, dm1105_emit_key);
 
-	err = __ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
+	err = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 
 	return err;
 }
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index ab7479a..be20749 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -192,7 +192,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	struct saa7146_dev *saa = budget_ci->budget.dev;
 	struct input_dev *input_dev = budget_ci->ir.dev;
 	int error;
-	struct ir_scancode_table *ir_codes;
+	char *ir_codes = NULL;
 
 
 	budget_ci->ir.dev = input_dev = input_allocate_device();
@@ -232,7 +232,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1011:
 	case 0x1012:
 		/* The hauppauge keymap is a superset of these remotes */
-		ir_codes = &IR_KEYTABLE(hauppauge_new);
+		ir_codes = RC_MAP_HAUPPAUGE_NEW;
 
 		if (rc5_device < 0)
 			budget_ci->ir.rc5_device = 0x1f;
@@ -241,11 +241,11 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1017:
 	case 0x101a:
 		/* for the Technotrend 1500 bundled remote */
-		ir_codes = &IR_KEYTABLE(tt_1500);
+		ir_codes = RC_MAP_TT_1500;
 		break;
 	default:
 		/* unknown remote */
-		ir_codes = &IR_KEYTABLE(budget_ci_old);
+		ir_codes = RC_MAP_BUDGET_CI_OLD;
 		break;
 	}
 
@@ -256,7 +256,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	budget_ci->ir.timer_keyup.function = msp430_ir_keyup;
 	budget_ci->ir.timer_keyup.data = (unsigned long) &budget_ci->ir;
 	budget_ci->ir.last_raw = 0xffff; /* An impossible value */
-	error = __ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
+	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 	if (error) {
 		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
 		return error;
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index eae4925..814fd34 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -247,7 +247,7 @@ static void bttv_ir_stop(struct bttv *btv)
 int bttv_input_init(struct bttv *btv)
 {
 	struct card_ir *ir;
-	struct ir_scancode_table *ir_codes = NULL;
+	char *ir_codes = NULL;
 	struct input_dev *input_dev;
 	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
@@ -265,7 +265,7 @@ int bttv_input_init(struct bttv *btv)
 	case BTTV_BOARD_AVERMEDIA:
 	case BTTV_BOARD_AVPHONE98:
 	case BTTV_BOARD_AVERMEDIA98:
-		ir_codes         = &IR_KEYTABLE(avermedia);
+		ir_codes         = RC_MAP_AVERMEDIA;
 		ir->mask_keycode = 0xf88000;
 		ir->mask_keydown = 0x010000;
 		ir->polling      = 50; // ms
@@ -273,14 +273,14 @@ int bttv_input_init(struct bttv *btv)
 
 	case BTTV_BOARD_AVDVBT_761:
 	case BTTV_BOARD_AVDVBT_771:
-		ir_codes         = &IR_KEYTABLE(avermedia_dvbt);
+		ir_codes         = RC_MAP_AVERMEDIA_DVBT;
 		ir->mask_keycode = 0x0f00c0;
 		ir->mask_keydown = 0x000020;
 		ir->polling      = 50; // ms
 		break;
 
 	case BTTV_BOARD_PXELVWPLTVPAK:
-		ir_codes         = &IR_KEYTABLE(pixelview);
+		ir_codes         = RC_MAP_PIXELVIEW;
 		ir->mask_keycode = 0x003e00;
 		ir->mask_keyup   = 0x010000;
 		ir->polling      = 50; // ms
@@ -288,24 +288,24 @@ int bttv_input_init(struct bttv *btv)
 	case BTTV_BOARD_PV_M4900:
 	case BTTV_BOARD_PV_BT878P_9B:
 	case BTTV_BOARD_PV_BT878P_PLUS:
-		ir_codes         = &IR_KEYTABLE(pixelview);
+		ir_codes         = RC_MAP_PIXELVIEW;
 		ir->mask_keycode = 0x001f00;
 		ir->mask_keyup   = 0x008000;
 		ir->polling      = 50; // ms
 		break;
 
 	case BTTV_BOARD_WINFAST2000:
-		ir_codes         = &IR_KEYTABLE(winfast);
+		ir_codes         = RC_MAP_WINFAST;
 		ir->mask_keycode = 0x1f8;
 		break;
 	case BTTV_BOARD_MAGICTVIEW061:
 	case BTTV_BOARD_MAGICTVIEW063:
-		ir_codes         = &IR_KEYTABLE(winfast);
+		ir_codes         = RC_MAP_WINFAST;
 		ir->mask_keycode = 0x0008e000;
 		ir->mask_keydown = 0x00200000;
 		break;
 	case BTTV_BOARD_APAC_VIEWCOMP:
-		ir_codes         = &IR_KEYTABLE(apac_viewcomp);
+		ir_codes         = RC_MAP_APAC_VIEWCOMP;
 		ir->mask_keycode = 0x001f00;
 		ir->mask_keyup   = 0x008000;
 		ir->polling      = 50; // ms
@@ -313,30 +313,30 @@ int bttv_input_init(struct bttv *btv)
 	case BTTV_BOARD_ASKEY_CPH03X:
 	case BTTV_BOARD_CONCEPTRONIC_CTVFMI2:
 	case BTTV_BOARD_CONTVFMI:
-		ir_codes         = &IR_KEYTABLE(pixelview);
+		ir_codes         = RC_MAP_PIXELVIEW;
 		ir->mask_keycode = 0x001F00;
 		ir->mask_keyup   = 0x006000;
 		ir->polling      = 50; // ms
 		break;
 	case BTTV_BOARD_NEBULA_DIGITV:
-		ir_codes = &IR_KEYTABLE(nebula);
+		ir_codes = RC_MAP_NEBULA;
 		btv->custom_irq = bttv_rc5_irq;
 		ir->rc5_gpio = 1;
 		break;
 	case BTTV_BOARD_MACHTV_MAGICTV:
-		ir_codes         = &IR_KEYTABLE(apac_viewcomp);
+		ir_codes         = RC_MAP_APAC_VIEWCOMP;
 		ir->mask_keycode = 0x001F00;
 		ir->mask_keyup   = 0x004000;
 		ir->polling      = 50; /* ms */
 		break;
 	case BTTV_BOARD_KOZUMI_KTV_01C:
-		ir_codes         = &IR_KEYTABLE(pctv_sedna);
+		ir_codes         = RC_MAP_PCTV_SEDNA;
 		ir->mask_keycode = 0x001f00;
 		ir->mask_keyup   = 0x006000;
 		ir->polling      = 50; /* ms */
 		break;
 	case BTTV_BOARD_ENLTV_FM_2:
-		ir_codes         = &IR_KEYTABLE(encore_enltv2);
+		ir_codes         = RC_MAP_ENCORE_ENLTV2;
 		ir->mask_keycode = 0x00fd00;
 		ir->mask_keyup   = 0x000080;
 		ir->polling      = 1; /* ms */
@@ -391,7 +391,7 @@ int bttv_input_init(struct bttv *btv)
 	bttv_ir_start(btv, ir);
 
 	/* all done */
-	err = __ir_input_register(btv->remote->dev, ir_codes, NULL, MODULE_NAME);
+	err = ir_input_register(btv->remote->dev, ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index 476c016..cfa1f28 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -109,7 +109,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	/* Our default information for ir-kbd-i2c.c to use */
 	switch (hw) {
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
-		init_data->ir_codes = &IR_KEYTABLE(hauppauge_new);
+		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type = IR_TYPE_RC5;
 		init_data->name = cx->card_name;
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 5767d3e..f7d0ad6 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -339,7 +339,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 {
 	struct card_ir *ir;
 	struct input_dev *input_dev;
-	struct ir_scancode_table *ir_codes = NULL;
+	char *ir_codes = NULL;
 	int ir_type, ir_addr, ir_start;
 	int ret;
 
@@ -354,7 +354,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 		/* Parameters for the grey Hauppauge remote for the HVR-1850 */
-		ir_codes = &IR_KEYTABLE(hauppauge_new);
+		ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		ir_type = IR_TYPE_RC5;
 		ir_addr = 0x1e; /* RC-5 system bits emitted by the remote */
 		ir_start = RC5_START_BITS_NORMAL; /* A basic RC-5 remote */
@@ -399,7 +399,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	dev->ir_input = ir;
 	cx23885_input_ir_start(dev);
 
-	ret = __ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
+	ret = ir_input_register(ir->dev, ir_codes, NULL, MODULE_NAME);
 	if (ret)
 		goto err_out_stop;
 
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 638e599..f5d6130 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -244,7 +244,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 {
 	struct cx88_IR *ir;
 	struct input_dev *input_dev;
-	struct ir_scancode_table *ir_codes = NULL;
+	char *ir_codes = NULL;
 	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
 
@@ -260,14 +260,14 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_DNTV_LIVE_DVB_T:
 	case CX88_BOARD_KWORLD_DVB_T:
 	case CX88_BOARD_KWORLD_DVB_T_CX22702:
-		ir_codes = &IR_KEYTABLE(dntv_live_dvb_t);
+		ir_codes = RC_MAP_DNTV_LIVE_DVB_T;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x60;
 		ir->polling = 50; /* ms */
 		break;
 	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
-		ir_codes = &IR_KEYTABLE(cinergy_1400);
+		ir_codes = RC_MAP_CINERGY_1400;
 		ir_type = IR_TYPE_PD;
 		ir->sampling = 0xeb04; /* address */
 		break;
@@ -282,14 +282,14 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PCHDTV_HD3000:
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ir_codes = &IR_KEYTABLE(hauppauge_new);
+		ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		ir_type = IR_TYPE_RC5;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
 	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_WINFAST_DTV1800H:
-		ir_codes = &IR_KEYTABLE(winfast);
+		ir_codes = RC_MAP_WINFAST;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
 		ir->mask_keyup = 0x100;
@@ -298,14 +298,14 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
-		ir_codes = &IR_KEYTABLE(winfast);
+		ir_codes = RC_MAP_WINFAST;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
 		ir->mask_keyup = 0x100;
 		ir->polling = 1; /* ms */
 		break;
 	case CX88_BOARD_IODATA_GVBCTV7E:
-		ir_codes = &IR_KEYTABLE(iodata_bctv7e);
+		ir_codes = RC_MAP_IODATA_BCTV7E;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0xfd;
 		ir->mask_keydown = 0x02;
@@ -313,7 +313,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_PROLINK_PLAYTVPVR:
 	case CX88_BOARD_PIXELVIEW_PLAYTV_ULTRA_PRO:
-		ir_codes = &IR_KEYTABLE(pixelview);
+		ir_codes = RC_MAP_PIXELVIEW;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x80;
@@ -321,28 +321,28 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_PROLINK_PV_8000GT:
 	case CX88_BOARD_PROLINK_PV_GLOBAL_XTREME:
-		ir_codes = &IR_KEYTABLE(pixelview_new);
+		ir_codes = RC_MAP_PIXELVIEW_NEW;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x3f;
 		ir->mask_keyup = 0x80;
 		ir->polling = 1; /* ms */
 		break;
 	case CX88_BOARD_KWORLD_LTV883:
-		ir_codes = &IR_KEYTABLE(pixelview);
+		ir_codes = RC_MAP_PIXELVIEW;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x60;
 		ir->polling = 1; /* ms */
 		break;
 	case CX88_BOARD_ADSTECH_DVB_T_PCI:
-		ir_codes = &IR_KEYTABLE(adstech_dvb_t_pci);
+		ir_codes = RC_MAP_ADSTECH_DVB_T_PCI;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0xbf;
 		ir->mask_keyup = 0x40;
 		ir->polling = 50; /* ms */
 		break;
 	case CX88_BOARD_MSI_TVANYWHERE_MASTER:
-		ir_codes = &IR_KEYTABLE(msi_tvanywhere);
+		ir_codes = RC_MAP_MSI_TVANYWHERE;
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x40;
@@ -350,7 +350,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_AVERTV_303:
 	case CX88_BOARD_AVERTV_STUDIO_303:
-		ir_codes         = &IR_KEYTABLE(avertv_303);
+		ir_codes         = RC_MAP_AVERTV_303;
 		ir->gpio_addr    = MO_GP2_IO;
 		ir->mask_keycode = 0xfb;
 		ir->mask_keydown = 0x02;
@@ -363,41 +363,41 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PROF_7300:
 	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
-		ir_codes = &IR_KEYTABLE(tbs_nec);
+		ir_codes = RC_MAP_TBS_NEC;
 		ir_type = IR_TYPE_PD;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_TEVII_S460:
 	case CX88_BOARD_TEVII_S420:
-		ir_codes = &IR_KEYTABLE(tevii_nec);
+		ir_codes = RC_MAP_TEVII_NEC;
 		ir_type = IR_TYPE_PD;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
-		ir_codes         = &IR_KEYTABLE(dntv_live_dvbt_pro);
+		ir_codes         = RC_MAP_DNTV_LIVE_DVBT_PRO;
 		ir_type          = IR_TYPE_PD;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	case CX88_BOARD_NORWOOD_MICRO:
-		ir_codes         = &IR_KEYTABLE(norwood);
+		ir_codes         = RC_MAP_NORWOOD;
 		ir->gpio_addr    = MO_GP1_IO;
 		ir->mask_keycode = 0x0e;
 		ir->mask_keyup   = 0x80;
 		ir->polling      = 50; /* ms */
 		break;
 	case CX88_BOARD_NPGTECH_REALTV_TOP10FM:
-		ir_codes         = &IR_KEYTABLE(npgtech);
+		ir_codes         = RC_MAP_NPGTECH;
 		ir->gpio_addr    = MO_GP0_IO;
 		ir->mask_keycode = 0xfa;
 		ir->polling      = 50; /* ms */
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
-		ir_codes         = &IR_KEYTABLE(pinnacle_pctv_hd);
+		ir_codes         = RC_MAP_PINNACLE_PCTV_HD;
 		ir_type          = IR_TYPE_RC5;
 		ir->sampling     = 1;
 		break;
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
-		ir_codes         = &IR_KEYTABLE(powercolor_real_angel);
+		ir_codes         = RC_MAP_POWERCOLOR_REAL_ANGEL;
 		ir->gpio_addr    = MO_GP2_IO;
 		ir->mask_keycode = 0x7e;
 		ir->polling      = 100; /* ms */
@@ -438,7 +438,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	ir->props.close = cx88_ir_close;
 
 	/* all done */
-	err = __ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
+	err = ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 55fcc2e..41a2c76 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -601,7 +601,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Gadmei UTV330+",
 		.tuner_type   = TUNER_TNF_5335MF,
 		.tda9887_conf = TDA9887_PRESENT,
-		.ir_codes     = &IR_KEYTABLE(gadmei_rm008z),
+		.ir_codes     = RC_MAP_GADMEI_RM008Z,
 		.decoder      = EM28XX_SAA711X,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input        = { {
@@ -790,7 +790,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware = 1,
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
-		.ir_codes     = &IR_KEYTABLE(hauppauge_new),
+		.ir_codes     = RC_MAP_HAUPPAUGE_NEW,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -815,7 +815,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
-		.ir_codes     = &IR_KEYTABLE(hauppauge_new),
+		.ir_codes     = RC_MAP_HAUPPAUGE_NEW,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -841,7 +841,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &IR_KEYTABLE(hauppauge_new),
+		.ir_codes       = RC_MAP_HAUPPAUGE_NEW,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -867,7 +867,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &IR_KEYTABLE(rc5_hauppauge_new),
+		.ir_codes       = RC_MAP_RC5_HAUPPAUGE_NEW,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -893,7 +893,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &IR_KEYTABLE(pinnacle_pctv_hd),
+		.ir_codes       = RC_MAP_PINNACLE_PCTV_HD,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -919,7 +919,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &IR_KEYTABLE(ati_tv_wonder_hd_600),
+		.ir_codes       = RC_MAP_ATI_TV_WONDER_HD_600,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -945,7 +945,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder        = EM28XX_TVP5150,
 		.has_dvb        = 1,
 		.dvb_gpio       = default_digital,
-		.ir_codes       = &IR_KEYTABLE(terratec_cinergy_xs),
+		.ir_codes       = RC_MAP_TERRATEC_CINERGY_XS,
 		.xclk           = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1295,7 +1295,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder	= EM28XX_SAA711X,
 		.has_dvb	= 1,
 		.dvb_gpio	= em2882_kworld_315u_digital,
-		.ir_codes	= &IR_KEYTABLE(kworld_315u),
+		.ir_codes	= RC_MAP_KWORLD_315U,
 		.xclk		= EM28XX_XCLK_FREQUENCY_12MHZ,
 		.i2c_speed	= EM28XX_I2C_CLK_WAIT_ENABLE,
 		/* Analog mode - still not ready */
@@ -1424,7 +1424,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = kworld_330u_digital,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
-		.ir_codes     = &IR_KEYTABLE(kworld_315u),
+		.ir_codes     = RC_MAP_KWORLD_315U,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1447,7 +1447,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder      = EM28XX_TVP5150,
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
-		.ir_codes     = &IR_KEYTABLE(terratec_cinergy_xs),
+		.ir_codes     = RC_MAP_TERRATEC_CINERGY_XS,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1540,7 +1540,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware = 1,
 		.decoder      = EM28XX_TVP5150,
 		.tuner_gpio   = default_tuner_gpio,
-		.ir_codes     = &IR_KEYTABLE(kaiomy),
+		.ir_codes     = RC_MAP_KAIOMY,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1640,7 +1640,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware = 1,
 		.has_dvb      = 1,
 		.dvb_gpio     = evga_indtube_digital,
-		.ir_codes     = &IR_KEYTABLE(evga_indtube),
+		.ir_codes     = RC_MAP_EVGA_INDTUBE,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -2334,21 +2334,21 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 	switch (dev->model) {
 	case EM2800_BOARD_TERRATEC_CINERGY_200:
 	case EM2820_BOARD_TERRATEC_CINERGY_250:
-		dev->init_data.ir_codes = &IR_KEYTABLE(em_terratec);
+		dev->init_data.ir_codes = RC_MAP_EM_TERRATEC;
 		dev->init_data.get_key = em28xx_get_key_terratec;
 		dev->init_data.name = "i2c IR (EM28XX Terratec)";
 		break;
 	case EM2820_BOARD_PINNACLE_USB_2:
-		dev->init_data.ir_codes = &IR_KEYTABLE(pinnacle_grey);
+		dev->init_data.ir_codes = RC_MAP_PINNACLE_GREY;
 		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
 		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
 		break;
 	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
-		dev->init_data.ir_codes = &IR_KEYTABLE(rc5_hauppauge_new);
+		dev->init_data.ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
 		dev->init_data.get_key = em28xx_get_key_em_haup;
 		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
 	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
-		dev->init_data.ir_codes = &IR_KEYTABLE(winfast_usbii_deluxe);;
+		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;;
 		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
 		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
 		break;
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index c237c72..3200f48 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -381,7 +381,6 @@ int em28xx_ir_change_protocol(void *priv, u64 ir_type)
 
 	/* Adjust xclk based o IR table for RC5/NEC tables */
 
-	dev->board.ir_codes->ir_type = IR_TYPE_OTHER;
 	if (ir_type == IR_TYPE_RC5) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
@@ -392,8 +391,6 @@ int em28xx_ir_change_protocol(void *priv, u64 ir_type)
 	} else
 		rc = -EINVAL;
 
-	dev->board.ir_codes->ir_type = ir_type;
-
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
 			      EM28XX_XCLK_IR_RC5_MODE);
 
@@ -456,7 +453,6 @@ int em28xx_ir_init(struct em28xx *dev)
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
 	/* Set IR protocol */
-	em28xx_ir_change_protocol(ir, dev->board.ir_codes->ir_type);
 	err = ir_input_init(input_dev, &ir->ir, IR_TYPE_OTHER);
 	if (err < 0)
 		goto err_out_free;
@@ -474,7 +470,7 @@ int em28xx_ir_init(struct em28xx *dev)
 	em28xx_ir_start(ir);
 
 	/* all done */
-	err = __ir_input_register(ir->input, dev->board.ir_codes,
+	err = ir_input_register(ir->input, dev->board.ir_codes,
 				&ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index eec1291..b252d1b 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -412,7 +412,7 @@ struct em28xx_board {
 
 	struct em28xx_input       input[MAX_EM28XX_INPUT];
 	struct em28xx_input	  radio;
-	struct ir_scancode_table  *ir_codes;
+	char			  *ir_codes;
 };
 
 struct em28xx_eeprom {
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index e6ada5e..29d4397 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -297,7 +297,7 @@ static void ir_work(struct work_struct *work)
 
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct ir_scancode_table *ir_codes = NULL;
+	char *ir_codes = NULL;
 	const char *name = NULL;
 	u64 ir_type = 0;
 	struct IR_i2c *ir;
@@ -322,13 +322,13 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &IR_KEYTABLE(empty);
+		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x4b:
 		name        = "PV951";
 		ir->get_key = get_key_pv951;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &IR_KEYTABLE(pv951);
+		ir_codes    = RC_MAP_PV951;
 		break;
 	case 0x18:
 	case 0x1f:
@@ -337,22 +337,22 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir->get_key = get_key_haup;
 		ir_type     = IR_TYPE_RC5;
 		if (hauppauge == 1) {
-			ir_codes    = &IR_KEYTABLE(hauppauge_new);
+			ir_codes    = RC_MAP_HAUPPAUGE_NEW;
 		} else {
-			ir_codes    = &IR_KEYTABLE(rc5_tv);
+			ir_codes    = RC_MAP_RC5_TV;
 		}
 		break;
 	case 0x30:
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &IR_KEYTABLE(empty);
+		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
 		ir_type     = IR_TYPE_RC5;
-		ir_codes    = &IR_KEYTABLE(fusionhdtv_mce);
+		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
 	case 0x0b:
 	case 0x47:
@@ -365,9 +365,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			ir_type     = IR_TYPE_RC5;
 			ir->get_key = get_key_haup_xvr;
 			if (hauppauge == 1) {
-				ir_codes    = &IR_KEYTABLE(hauppauge_new);
+				ir_codes    = RC_MAP_HAUPPAUGE_NEW;
 			} else {
-				ir_codes    = &IR_KEYTABLE(rc5_tv);
+				ir_codes    = RC_MAP_RC5_TV;
 			}
 		} else {
 			/* Handled by saa7134-input */
@@ -379,7 +379,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &IR_KEYTABLE(avermedia_cardbus);
+		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
 		break;
 	}
 
@@ -447,7 +447,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
 
-	err = __ir_input_register(ir->input, ir->ir_codes, NULL, MODULE_NAME);
+	err = ir_input_register(ir->input, ir->ir_codes, NULL, MODULE_NAME);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index a363e33..a5b92d1 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -193,7 +193,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 	/* Our default information for ir-kbd-i2c.c to use */
 	switch (hw) {
 	case IVTV_HW_I2C_IR_RX_AVER:
-		init_data->ir_codes = &IR_KEYTABLE(avermedia_cardbus);
+		init_data->ir_codes = RC_MAP_AVERMEDIA_CARDBUS;
 		init_data->internal_get_key_func =
 					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
 		init_data->type = IR_TYPE_OTHER;
@@ -202,14 +202,14 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
 	case IVTV_HW_I2C_IR_RX_HAUP_INT:
 		/* Default to old black remote */
-		init_data->ir_codes = &IR_KEYTABLE(rc5_tv);
+		init_data->ir_codes = RC_MAP_RC5_TV;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
 		init_data->type = IR_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
-		init_data->ir_codes = &IR_KEYTABLE(hauppauge_new);
+		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type = IR_TYPE_RC5;
 		init_data->name = itv->card_name;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 2a3cae9..0459ae6 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -586,7 +586,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 {
 	struct card_ir *ir;
 	struct input_dev *input_dev;
-	struct ir_scancode_table *ir_codes = NULL;
+	char *ir_codes = NULL;
 	u32 mask_keycode = 0;
 	u32 mask_keydown = 0;
 	u32 mask_keyup   = 0;
@@ -594,6 +594,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	int rc5_gpio	 = 0;
 	int nec_gpio	 = 0;
 	int raw_decode   = 0;
+	int allow_protocol_change = 0;
 	u64 ir_type = IR_TYPE_OTHER;
 	int err;
 
@@ -610,27 +611,27 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_FLYTVPLATINUM_FM:
 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
 	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
-		ir_codes     = &IR_KEYTABLE(flyvideo);
+		ir_codes     = RC_MAP_FLYVIDEO;
 		mask_keycode = 0xEC00000;
 		mask_keydown = 0x0040000;
 		break;
 	case SAA7134_BOARD_CINERGY400:
 	case SAA7134_BOARD_CINERGY600:
 	case SAA7134_BOARD_CINERGY600_MK3:
-		ir_codes     = &IR_KEYTABLE(cinergy);
+		ir_codes     = RC_MAP_CINERGY;
 		mask_keycode = 0x00003f;
 		mask_keyup   = 0x040000;
 		break;
 	case SAA7134_BOARD_ECS_TVP3XP:
 	case SAA7134_BOARD_ECS_TVP3XP_4CB5:
-		ir_codes     = &IR_KEYTABLE(eztv);
+		ir_codes     = RC_MAP_EZTV;
 		mask_keycode = 0x00017c;
 		mask_keyup   = 0x000002;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_KWORLD_XPERT:
 	case SAA7134_BOARD_AVACSSMARTTV:
-		ir_codes     = &IR_KEYTABLE(pixelview);
+		ir_codes     = RC_MAP_PIXELVIEW;
 		mask_keycode = 0x00001F;
 		mask_keyup   = 0x000020;
 		polling      = 50; // ms
@@ -647,7 +648,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
 	case SAA7134_BOARD_AVERMEDIA_M102:
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
-		ir_codes     = &IR_KEYTABLE(avermedia);
+		ir_codes     = RC_MAP_AVERMEDIA;
 		mask_keycode = 0x0007C8;
 		mask_keydown = 0x000010;
 		polling      = 50; // ms
@@ -656,14 +657,14 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS0, 0x4);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M135A:
-		ir_codes     = &IR_KEYTABLE(avermedia_m135a_rm_jx);
+		ir_codes     = RC_MAP_AVERMEDIA_M135A_RM_JX;
 		mask_keydown = 0x0040000;
 		mask_keycode = 0xffff;
 		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
-		ir_codes     = &IR_KEYTABLE(avermedia);
+		ir_codes     = RC_MAP_AVERMEDIA;
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; // ms
@@ -672,7 +673,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A16D:
-		ir_codes     = &IR_KEYTABLE(avermedia_a16d);
+		ir_codes     = RC_MAP_AVERMEDIA_A16D;
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; /* ms */
@@ -681,14 +682,14 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
 		break;
 	case SAA7134_BOARD_KWORLD_TERMINATOR:
-		ir_codes     = &IR_KEYTABLE(pixelview);
+		ir_codes     = RC_MAP_PIXELVIEW;
 		mask_keycode = 0x00001f;
 		mask_keyup   = 0x000060;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_MANLI_MTV001:
 	case SAA7134_BOARD_MANLI_MTV002:
-		ir_codes     = &IR_KEYTABLE(manli);
+		ir_codes     = RC_MAP_MANLI;
 		mask_keycode = 0x001f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; /* ms */
@@ -708,25 +709,25 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_507_9FM:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
-		ir_codes     = &IR_KEYTABLE(manli);
+		ir_codes     = RC_MAP_MANLI;
 		mask_keycode = 0x003f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; /* ms */
 		break;
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
-		ir_codes     = &IR_KEYTABLE(behold_columbus);
+		ir_codes     = RC_MAP_BEHOLD_COLUMBUS;
 		mask_keycode = 0x003f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_SEDNA_PC_TV_CARDBUS:
-		ir_codes     = &IR_KEYTABLE(pctv_sedna);
+		ir_codes     = RC_MAP_PCTV_SEDNA;
 		mask_keycode = 0x001f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_GOTVIEW_7135:
-		ir_codes     = &IR_KEYTABLE(gotview7135);
+		ir_codes     = RC_MAP_GOTVIEW7135;
 		mask_keycode = 0x0003CC;
 		mask_keydown = 0x000010;
 		polling	     = 5; /* ms */
@@ -735,80 +736,80 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
-		ir_codes     = &IR_KEYTABLE(videomate_tv_pvr);
+		ir_codes     = RC_MAP_VIDEOMATE_TV_PVR;
 		mask_keycode = 0x00003F;
 		mask_keyup   = 0x400000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_PROTEUS_2309:
-		ir_codes     = &IR_KEYTABLE(proteus_2309);
+		ir_codes     = RC_MAP_PROTEUS_2309;
 		mask_keycode = 0x00007F;
 		mask_keyup   = 0x000080;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
-		ir_codes     = &IR_KEYTABLE(videomate_tv_pvr);
+		ir_codes     = RC_MAP_VIDEOMATE_TV_PVR;
 		mask_keycode = 0x003F00;
 		mask_keyup   = 0x040000;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
 	case SAA7134_BOARD_FLYDVBT_LR301:
 	case SAA7134_BOARD_FLYDVBTDUO:
-		ir_codes     = &IR_KEYTABLE(flydvb);
+		ir_codes     = RC_MAP_FLYDVB;
 		mask_keycode = 0x0001F00;
 		mask_keydown = 0x0040000;
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
-		ir_codes     = &IR_KEYTABLE(asus_pc39);
+		ir_codes     = RC_MAP_ASUS_PC39;
 		mask_keydown = 0x0040000;
 		rc5_gpio = 1;
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
-		ir_codes     = &IR_KEYTABLE(encore_enltv);
+		ir_codes     = RC_MAP_ENCORE_ENLTV;
 		mask_keycode = 0x00007f;
 		mask_keyup   = 0x040000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV_FM53:
-		ir_codes     = &IR_KEYTABLE(encore_enltv_fm53);
+		ir_codes     = RC_MAP_ENCORE_ENLTV_FM53;
 		mask_keydown = 0x0040000;
 		mask_keycode = 0x00007f;
 		nec_gpio = 1;
 		break;
 	case SAA7134_BOARD_10MOONSTVMASTER3:
-		ir_codes     = &IR_KEYTABLE(encore_enltv);
+		ir_codes     = RC_MAP_ENCORE_ENLTV;
 		mask_keycode = 0x5f80000;
 		mask_keyup   = 0x8000000;
 		polling      = 50; //ms
 		break;
 	case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
-		ir_codes     = &IR_KEYTABLE(genius_tvgo_a11mce);
+		ir_codes     = RC_MAP_GENIUS_TVGO_A11MCE;
 		mask_keycode = 0xff;
 		mask_keydown = 0xf00000;
 		polling = 50; /* ms */
 		break;
 	case SAA7134_BOARD_REAL_ANGEL_220:
-		ir_codes     = &IR_KEYTABLE(real_audio_220_32_keys);
+		ir_codes     = RC_MAP_REAL_AUDIO_220_32_KEYS;
 		mask_keycode = 0x3f00;
 		mask_keyup   = 0x4000;
 		polling = 50; /* ms */
 		break;
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
-		ir_codes     = &IR_KEYTABLE(kworld_plus_tv_analog);
+		ir_codes     = RC_MAP_KWORLD_PLUS_TV_ANALOG;
 		mask_keycode = 0x7f;
 		polling = 40; /* ms */
 		break;
 	case SAA7134_BOARD_VIDEOMATE_S350:
-		ir_codes     = &IR_KEYTABLE(videomate_s350);
+		ir_codes     = RC_MAP_VIDEOMATE_S350;
 		mask_keycode = 0x003f00;
 		mask_keydown = 0x040000;
 		break;
 	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
-		ir_codes     = &IR_KEYTABLE(winfast);
+		ir_codes     = RC_MAP_WINFAST;
 		mask_keycode = 0x5f00;
 		mask_keyup   = 0x020000;
 		polling      = 50; /* ms */
@@ -853,13 +854,11 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->props.open = saa7134_ir_open;
 	ir->props.close = saa7134_ir_close;
 
-	if (ir_codes->ir_type != IR_TYPE_OTHER && !raw_decode) {
+	if (!raw_decode && allow_protocol_change) {
 		ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
 		ir->props.change_protocol = saa7134_ir_change_protocol;
-
-		/* Set IR protocol */
-		saa7134_ir_change_protocol(ir->props.priv, ir_codes->ir_type);
 	}
+
 	err = ir_input_init(input_dev, &ir->ir, ir_type);
 	if (err < 0)
 		goto err_out_free;
@@ -877,10 +876,10 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 	input_dev->dev.parent = &dev->pci->dev;
 
-	err = __ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
+	err = ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_free;
-	if (ir_codes->ir_type != IR_TYPE_OTHER) {
+	if (raw_decode) {
 		err = ir_raw_event_register(ir->dev);
 		if (err)
 			goto err_out_free;
@@ -938,24 +937,24 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "Pinnacle PCTV";
 		if (pinnacle_remote == 0) {
 			dev->init_data.get_key = get_key_pinnacle_color;
-			dev->init_data.ir_codes = &IR_KEYTABLE(pinnacle_color);
+			dev->init_data.ir_codes = RC_MAP_PINNACLE_COLOR;
 			info.addr = 0x47;
 		} else {
 			dev->init_data.get_key = get_key_pinnacle_grey;
-			dev->init_data.ir_codes = &IR_KEYTABLE(pinnacle_grey);
+			dev->init_data.ir_codes = RC_MAP_PINNACLE_GREY;
 			info.addr = 0x47;
 		}
 		break;
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
 		dev->init_data.name = "Purple TV";
 		dev->init_data.get_key = get_key_purpletv;
-		dev->init_data.ir_codes = &IR_KEYTABLE(purpletv);
+		dev->init_data.ir_codes = RC_MAP_PURPLETV;
 		info.addr = 0x7a;
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 		dev->init_data.name = "MSI TV@nywhere Plus";
 		dev->init_data.get_key = get_key_msi_tvanywhere_plus;
-		dev->init_data.ir_codes = &IR_KEYTABLE(msi_tvanywhere_plus);
+		dev->init_data.ir_codes = RC_MAP_MSI_TVANYWHERE_PLUS;
 		info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
@@ -969,7 +968,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		dev->init_data.name = "HVR 1110";
 		dev->init_data.get_key = get_key_hvr1110;
-		dev->init_data.ir_codes = &IR_KEYTABLE(hauppauge_new);
+		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE_NEW;
 		info.addr = 0x71;
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
@@ -987,7 +986,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_X7:
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
-		dev->init_data.ir_codes = &IR_KEYTABLE(behold);
+		dev->init_data.ir_codes = RC_MAP_BEHOLD;
 		dev->init_data.type = IR_TYPE_NEC;
 		info.addr = 0x2d;
 		break;
@@ -998,7 +997,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_FLYDVB_TRIO:
 		dev->init_data.name = "FlyDVB Trio";
 		dev->init_data.get_key = get_key_flydvb_trio;
-		dev->init_data.ir_codes = &IR_KEYTABLE(flydvb);
+		dev->init_data.ir_codes = RC_MAP_FLYDVB;
 		info.addr = 0x0b;
 		break;
 	default:
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 8e975f2..e1772b8 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -21,6 +21,7 @@
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
+#include <media/rc-map.h>
 
 extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
@@ -124,6 +125,7 @@ EXPORT_SYMBOL_GPL(IR_KEYTABLE(tabname))
 int ir_register_map(struct rc_keymap *map);
 void ir_unregister_map(struct rc_keymap *map);
 struct ir_scancode_table *get_rc_map(const char *name);
+void rc_map_init(void);
 
 /* Routines from ir-keytable.c */
 
@@ -141,15 +143,30 @@ static inline int ir_input_register(struct input_dev *dev,
 		      const struct ir_dev_props *props,
 		      const char *driver_name) {
 	struct ir_scancode_table *ir_codes;
+	struct ir_input_dev *ir_dev;
+	int rc;
+
+	if (!map_name)
+		return -EINVAL;
 
 	ir_codes = get_rc_map(map_name);
 	if (!ir_codes)
 		return -EINVAL;
 
-	return __ir_input_register(dev, ir_codes, props, driver_name);
+	rc = __ir_input_register(dev, ir_codes, props, driver_name);
+	if (rc < 0)
+		return -EINVAL;
+
+	ir_dev = input_get_drvdata(dev);
+
+	if (!rc && ir_dev->props && ir_dev->props->change_protocol)
+		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
+						    ir_codes->ir_type);
+
+	return rc;
 }
 
-		      void ir_input_unregister(struct input_dev *input_dev);
+void ir_input_unregister(struct input_dev *input_dev);
 
 /* Routines from ir-sysfs.c */
 
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 9142936..057ff64 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -6,7 +6,7 @@
 struct IR_i2c;
 
 struct IR_i2c {
-	struct ir_scancode_table *ir_codes;
+	char		       *ir_codes;
 
 	struct i2c_client      *c;
 	struct input_dev       *input;
@@ -34,7 +34,7 @@ enum ir_kbd_get_key_fn {
 
 /* Can be passed when instantiating an ir_video i2c device */
 struct IR_i2c_init_data {
-	struct ir_scancode_table *ir_codes;
+	char			*ir_codes;
 	const char             *name;
 	u64          type; /* IR_TYPE_RC5, IR_TYPE_PD, etc */
 	/*
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
new file mode 100644
index 0000000..9ea0033
--- /dev/null
+++ b/include/media/rc-map.h
@@ -0,0 +1,81 @@
+/*
+ * rc-map.h - define RC map names used by RC drivers
+ *
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/ir-core.h>
+
+#define RC_MAP_ADSTECH_DVB_T_PCI         "rc-adstech-dvb-t-pci"
+#define RC_MAP_APAC_VIEWCOMP             "rc-apac-viewcomp"
+#define RC_MAP_ASUS_PC39                 "rc-asus-pc39"
+#define RC_MAP_ATI_TV_WONDER_HD_600      "rc-ati-tv-wonder-hd-600"
+#define RC_MAP_AVERMEDIA_A16D            "rc-avermedia-a16d"
+#define RC_MAP_AVERMEDIA_CARDBUS         "rc-avermedia-cardbus"
+#define RC_MAP_AVERMEDIA_DVBT            "rc-avermedia-dvbt"
+#define RC_MAP_AVERMEDIA_M135A_RM_JX     "rc-avermedia-m135a-rm-jx"
+#define RC_MAP_AVERMEDIA                 "rc-avermedia"
+#define RC_MAP_AVERTV_303                "rc-avertv-303"
+#define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
+#define RC_MAP_BEHOLD                    "rc-behold"
+#define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
+#define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
+#define RC_MAP_CINERGY                   "rc-cinergy"
+#define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
+#define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
+#define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
+#define RC_MAP_EMPTY                     "rc-empty"
+#define RC_MAP_EM_TERRATEC               "rc-em-terratec"
+#define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
+#define RC_MAP_ENCORE_ENLTV_FM53         "rc-encore-enltv-fm53"
+#define RC_MAP_ENCORE_ENLTV              "rc-encore-enltv"
+#define RC_MAP_EVGA_INDTUBE              "rc-evga-indtube"
+#define RC_MAP_EZTV                      "rc-eztv"
+#define RC_MAP_FLYDVB                    "rc-flydvb"
+#define RC_MAP_FLYVIDEO                  "rc-flyvideo"
+#define RC_MAP_FUSIONHDTV_MCE            "rc-fusionhdtv-mce"
+#define RC_MAP_GADMEI_RM008Z             "rc-gadmei-rm008z"
+#define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
+#define RC_MAP_GOTVIEW7135               "rc-gotview7135"
+#define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge-new"
+#define RC_MAP_IODATA_BCTV7E             "rc-iodata-bctv7e"
+#define RC_MAP_KAIOMY                    "rc-kaiomy"
+#define RC_MAP_KWORLD_315U               "rc-kworld-315u"
+#define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
+#define RC_MAP_MANLI                     "rc-manli"
+#define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
+#define RC_MAP_MSI_TVANYWHERE            "rc-msi-tvanywhere"
+#define RC_MAP_NEBULA                    "rc-nebula"
+#define RC_MAP_NEC_TERRATEC_CINERGY_XS   "rc-nec-terratec-cinergy-xs"
+#define RC_MAP_NORWOOD                   "rc-norwood"
+#define RC_MAP_NPGTECH                   "rc-npgtech"
+#define RC_MAP_PCTV_SEDNA                "rc-pctv-sedna"
+#define RC_MAP_PINNACLE_COLOR            "rc-pinnacle-color"
+#define RC_MAP_PINNACLE_GREY             "rc-pinnacle-grey"
+#define RC_MAP_PINNACLE_PCTV_HD          "rc-pinnacle-pctv-hd"
+#define RC_MAP_PIXELVIEW_NEW             "rc-pixelview-new"
+#define RC_MAP_PIXELVIEW                 "rc-pixelview"
+#define RC_MAP_POWERCOLOR_REAL_ANGEL     "rc-powercolor-real-angel"
+#define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
+#define RC_MAP_PURPLETV                  "rc-purpletv"
+#define RC_MAP_PV951                     "rc-pv951"
+#define RC_MAP_RC5_HAUPPAUGE_NEW         "rc-rc5-hauppauge-new"
+#define RC_MAP_RC5_TV                    "rc-rc5-tv"
+#define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
+#define RC_MAP_TBS_NEC                   "rc-tbs-nec"
+#define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
+#define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
+#define RC_MAP_TT_1500                   "rc-tt-1500"
+#define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
+#define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
+#define RC_MAP_WINFAST                   "rc-winfast"
+#define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
+/*
+ * Please, do not just append newer Remote Controller names at the end.
+ * The names should be ordered in alphabetical order
+ */
-- 
1.6.6.1


