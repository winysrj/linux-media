Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab0DFSS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:28 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IISmQ022712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:28 -0400
Date: Tue, 6 Apr 2010 15:18:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/26] V4L/DVB: IR: use IR_KEYTABLE where an IR table is
 needed
Message-ID: <20100406151804.25d7f824@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaces most of the occurences of IR keytables on V4L drivers by a macro
that evaluates to provide the name of the exported symbol.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index f1721e9..17003ed 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -595,7 +595,7 @@ static irqreturn_t dm1105_irq(int irq, void *dev_id)
 int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 {
 	struct input_dev *input_dev;
-	struct ir_scancode_table *ir_codes = &ir_codes_dm1105_nec_table;
+	struct ir_scancode_table *ir_codes = &IR_KEYTABLE(dm1105_nec);
 	u64 ir_type = IR_TYPE_OTHER;
 	int err = -ENOMEM;
 
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index ec89afd..75c640e 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -232,7 +232,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1011:
 	case 0x1012:
 		/* The hauppauge keymap is a superset of these remotes */
-		ir_codes = &ir_codes_hauppauge_new_table;
+		ir_codes = &IR_KEYTABLE(hauppauge_new);
 
 		if (rc5_device < 0)
 			budget_ci->ir.rc5_device = 0x1f;
@@ -241,11 +241,11 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1017:
 	case 0x101a:
 		/* for the Technotrend 1500 bundled remote */
-		ir_codes = &ir_codes_tt_1500_table;
+		ir_codes = &IR_KEYTABLE(tt_1500);
 		break;
 	default:
 		/* unknown remote */
-		ir_codes = &ir_codes_budget_ci_old_table;
+		ir_codes = &IR_KEYTABLE(budget_ci_old);
 		break;
 	}
 
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 6c11687..d5d26e6 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -265,7 +265,7 @@ int bttv_input_init(struct bttv *btv)
 	case BTTV_BOARD_AVERMEDIA:
 	case BTTV_BOARD_AVPHONE98:
 	case BTTV_BOARD_AVERMEDIA98:
-		ir_codes         = &ir_codes_avermedia_table;
+		ir_codes         = &IR_KEYTABLE(avermedia);
 		ir->mask_keycode = 0xf88000;
 		ir->mask_keydown = 0x010000;
 		ir->polling      = 50; // ms
@@ -273,14 +273,14 @@ int bttv_input_init(struct bttv *btv)
 
 	case BTTV_BOARD_AVDVBT_761:
 	case BTTV_BOARD_AVDVBT_771:
-		ir_codes         = &ir_codes_avermedia_dvbt_table;
+		ir_codes         = &IR_KEYTABLE(avermedia_dvbt);
 		ir->mask_keycode = 0x0f00c0;
 		ir->mask_keydown = 0x000020;
 		ir->polling      = 50; // ms
 		break;
 
 	case BTTV_BOARD_PXELVWPLTVPAK:
-		ir_codes         = &ir_codes_pixelview_table;
+		ir_codes         = &IR_KEYTABLE(pixelview);
 		ir->mask_keycode = 0x003e00;
 		ir->mask_keyup   = 0x010000;
 		ir->polling      = 50; // ms
@@ -288,24 +288,24 @@ int bttv_input_init(struct bttv *btv)
 	case BTTV_BOARD_PV_M4900:
 	case BTTV_BOARD_PV_BT878P_9B:
 	case BTTV_BOARD_PV_BT878P_PLUS:
-		ir_codes         = &ir_codes_pixelview_table;
+		ir_codes         = &IR_KEYTABLE(pixelview);
 		ir->mask_keycode = 0x001f00;
 		ir->mask_keyup   = 0x008000;
 		ir->polling      = 50; // ms
 		break;
 
 	case BTTV_BOARD_WINFAST2000:
-		ir_codes         = &ir_codes_winfast_table;
+		ir_codes         = &IR_KEYTABLE(winfast);
 		ir->mask_keycode = 0x1f8;
 		break;
 	case BTTV_BOARD_MAGICTVIEW061:
 	case BTTV_BOARD_MAGICTVIEW063:
-		ir_codes         = &ir_codes_winfast_table;
+		ir_codes         = &IR_KEYTABLE(winfast);
 		ir->mask_keycode = 0x0008e000;
 		ir->mask_keydown = 0x00200000;
 		break;
 	case BTTV_BOARD_APAC_VIEWCOMP:
-		ir_codes         = &ir_codes_apac_viewcomp_table;
+		ir_codes         = &IR_KEYTABLE(apac_viewcomp);
 		ir->mask_keycode = 0x001f00;
 		ir->mask_keyup   = 0x008000;
 		ir->polling      = 50; // ms
@@ -313,30 +313,30 @@ int bttv_input_init(struct bttv *btv)
 	case BTTV_BOARD_ASKEY_CPH03X:
 	case BTTV_BOARD_CONCEPTRONIC_CTVFMI2:
 	case BTTV_BOARD_CONTVFMI:
-		ir_codes         = &ir_codes_pixelview_table;
+		ir_codes         = &IR_KEYTABLE(pixelview);
 		ir->mask_keycode = 0x001F00;
 		ir->mask_keyup   = 0x006000;
 		ir->polling      = 50; // ms
 		break;
 	case BTTV_BOARD_NEBULA_DIGITV:
-		ir_codes = &ir_codes_nebula_table;
+		ir_codes = &IR_KEYTABLE(nebula);
 		btv->custom_irq = bttv_rc5_irq;
 		ir->rc5_gpio = 1;
 		break;
 	case BTTV_BOARD_MACHTV_MAGICTV:
-		ir_codes         = &ir_codes_apac_viewcomp_table;
+		ir_codes         = &IR_KEYTABLE(apac_viewcomp);
 		ir->mask_keycode = 0x001F00;
 		ir->mask_keyup   = 0x004000;
 		ir->polling      = 50; /* ms */
 		break;
 	case BTTV_BOARD_KOZUMI_KTV_01C:
-		ir_codes         = &ir_codes_pctv_sedna_table;
+		ir_codes         = &IR_KEYTABLE(pctv_sedna);
 		ir->mask_keycode = 0x001f00;
 		ir->mask_keyup   = 0x006000;
 		ir->polling      = 50; /* ms */
 		break;
 	case BTTV_BOARD_ENLTV_FM_2:
-		ir_codes         = &ir_codes_encore_enltv2_table;
+		ir_codes         = &IR_KEYTABLE(encore_enltv2);
 		ir->mask_keycode = 0x00fd00;
 		ir->mask_keyup   = 0x000080;
 		ir->polling      = 1; /* ms */
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index eecf29a..476c016 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -109,7 +109,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	/* Our default information for ir-kbd-i2c.c to use */
 	switch (hw) {
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
-		init_data->ir_codes = &ir_codes_hauppauge_new_table;
+		init_data->ir_codes = &IR_KEYTABLE(hauppauge_new);
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type = IR_TYPE_RC5;
 		init_data->name = cx->card_name;
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 2e6c023..c7e854d 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -354,7 +354,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 		/* Parameters for the grey Hauppauge remote for the HVR-1850 */
-		ir_codes = &ir_codes_hauppauge_new_table;
+		ir_codes = &IR_KEYTABLE(hauppauge_new);
 		ir_type = IR_TYPE_RC5;
 		ir_addr = 0x1e; /* RC-5 system bits emitted by the remote */
 		ir_start = RC5_START_BITS_NORMAL; /* A basic RC-5 remote */
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index a7214d0..b73b9e3 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -260,14 +260,14 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_DNTV_LIVE_DVB_T:
 	case CX88_BOARD_KWORLD_DVB_T:
 	case CX88_BOARD_KWORLD_DVB_T_CX22702:
-		ir_codes = &ir_codes_dntv_live_dvb_t_table;
+		ir_codes = &IR_KEYTABLE(dntv_live_dvb_t);
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x60;
 		ir->polling = 50; /* ms */
 		break;
 	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
-		ir_codes = &ir_codes_cinergy_1400_table;
+		ir_codes = &IR_KEYTABLE(cinergy_1400);
 		ir_type = IR_TYPE_PD;
 		ir->sampling = 0xeb04; /* address */
 		break;
@@ -282,14 +282,14 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PCHDTV_HD3000:
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ir_codes = &ir_codes_hauppauge_new_table;
+		ir_codes = &IR_KEYTABLE(hauppauge_new);
 		ir_type = IR_TYPE_RC5;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
 	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_WINFAST_DTV1800H:
-		ir_codes = &ir_codes_winfast_table;
+		ir_codes = &IR_KEYTABLE(winfast);
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
 		ir->mask_keyup = 0x100;
@@ -298,14 +298,14 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
-		ir_codes = &ir_codes_winfast_table;
+		ir_codes = &IR_KEYTABLE(winfast);
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
 		ir->mask_keyup = 0x100;
 		ir->polling = 1; /* ms */
 		break;
 	case CX88_BOARD_IODATA_GVBCTV7E:
-		ir_codes = &ir_codes_iodata_bctv7e_table;
+		ir_codes = &IR_KEYTABLE(iodata_bctv7e);
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0xfd;
 		ir->mask_keydown = 0x02;
@@ -313,7 +313,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_PROLINK_PLAYTVPVR:
 	case CX88_BOARD_PIXELVIEW_PLAYTV_ULTRA_PRO:
-		ir_codes = &ir_codes_pixelview_table;
+		ir_codes = &IR_KEYTABLE(pixelview);
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x80;
@@ -321,28 +321,28 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_PROLINK_PV_8000GT:
 	case CX88_BOARD_PROLINK_PV_GLOBAL_XTREME:
-		ir_codes = &ir_codes_pixelview_new_table;
+		ir_codes = &IR_KEYTABLE(pixelview_new);
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x3f;
 		ir->mask_keyup = 0x80;
 		ir->polling = 1; /* ms */
 		break;
 	case CX88_BOARD_KWORLD_LTV883:
-		ir_codes = &ir_codes_pixelview_table;
+		ir_codes = &IR_KEYTABLE(pixelview);
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x60;
 		ir->polling = 1; /* ms */
 		break;
 	case CX88_BOARD_ADSTECH_DVB_T_PCI:
-		ir_codes = &ir_codes_adstech_dvb_t_pci_table;
+		ir_codes = &IR_KEYTABLE(adstech_dvb_t_pci);
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0xbf;
 		ir->mask_keyup = 0x40;
 		ir->polling = 50; /* ms */
 		break;
 	case CX88_BOARD_MSI_TVANYWHERE_MASTER:
-		ir_codes = &ir_codes_msi_tvanywhere_table;
+		ir_codes = &IR_KEYTABLE(msi_tvanywhere);
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keycode = 0x1f;
 		ir->mask_keyup = 0x40;
@@ -350,7 +350,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_AVERTV_303:
 	case CX88_BOARD_AVERTV_STUDIO_303:
-		ir_codes         = &ir_codes_avertv_303_table;
+		ir_codes         = &IR_KEYTABLE(avertv_303);
 		ir->gpio_addr    = MO_GP2_IO;
 		ir->mask_keycode = 0xfb;
 		ir->mask_keydown = 0x02;
@@ -363,41 +363,41 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PROF_7300:
 	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
-		ir_codes = &ir_codes_tbs_nec_table;
+		ir_codes = &IR_KEYTABLE(tbs_nec);
 		ir_type = IR_TYPE_PD;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_TEVII_S460:
 	case CX88_BOARD_TEVII_S420:
-		ir_codes = &ir_codes_tevii_nec_table;
+		ir_codes = &IR_KEYTABLE(tevii_nec);
 		ir_type = IR_TYPE_PD;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
-		ir_codes         = &ir_codes_dntv_live_dvbt_pro_table;
+		ir_codes         = &IR_KEYTABLE(dntv_live_dvbt_pro);
 		ir_type          = IR_TYPE_PD;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	case CX88_BOARD_NORWOOD_MICRO:
-		ir_codes         = &ir_codes_norwood_table;
+		ir_codes         = &IR_KEYTABLE(norwood);
 		ir->gpio_addr    = MO_GP1_IO;
 		ir->mask_keycode = 0x0e;
 		ir->mask_keyup   = 0x80;
 		ir->polling      = 50; /* ms */
 		break;
 	case CX88_BOARD_NPGTECH_REALTV_TOP10FM:
-		ir_codes         = &ir_codes_npgtech_table;
+		ir_codes         = &IR_KEYTABLE(npgtech);
 		ir->gpio_addr    = MO_GP0_IO;
 		ir->mask_keycode = 0xfa;
 		ir->polling      = 50; /* ms */
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
-		ir_codes         = &ir_codes_pinnacle_pctv_hd_table;
+		ir_codes         = &IR_KEYTABLE(pinnacle_pctv_hd);
 		ir_type          = IR_TYPE_RC5;
 		ir->sampling     = 1;
 		break;
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
-		ir_codes         = &ir_codes_powercolor_real_angel_table;
+		ir_codes         = &IR_KEYTABLE(powercolor_real_angel);
 		ir->gpio_addr    = MO_GP2_IO;
 		ir->mask_keycode = 0x7e;
 		ir->polling      = 100; /* ms */
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 92a28b8..55fcc2e 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -601,7 +601,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Gadmei UTV330+",
 		.tuner_type   = TUNER_TNF_5335MF,
 		.tda9887_conf = TDA9887_PRESENT,
-		.ir_codes     = &ir_codes_gadmei_rm008z_table,
+		.ir_codes     = &IR_KEYTABLE(gadmei_rm008z),
 		.decoder      = EM28XX_SAA711X,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input        = { {
@@ -790,7 +790,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware = 1,
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
-		.ir_codes     = &ir_codes_hauppauge_new_table,
+		.ir_codes     = &IR_KEYTABLE(hauppauge_new),
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -815,7 +815,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
-		.ir_codes     = &ir_codes_hauppauge_new_table,
+		.ir_codes     = &IR_KEYTABLE(hauppauge_new),
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -841,7 +841,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &ir_codes_hauppauge_new_table,
+		.ir_codes       = &IR_KEYTABLE(hauppauge_new),
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -867,7 +867,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &ir_codes_rc5_hauppauge_new_table,
+		.ir_codes       = &IR_KEYTABLE(rc5_hauppauge_new),
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -893,7 +893,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &ir_codes_pinnacle_pctv_hd_table,
+		.ir_codes       = &IR_KEYTABLE(pinnacle_pctv_hd),
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -919,7 +919,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = &ir_codes_ati_tv_wonder_hd_600_table,
+		.ir_codes       = &IR_KEYTABLE(ati_tv_wonder_hd_600),
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -945,7 +945,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder        = EM28XX_TVP5150,
 		.has_dvb        = 1,
 		.dvb_gpio       = default_digital,
-		.ir_codes       = &ir_codes_terratec_cinergy_xs_table,
+		.ir_codes       = &IR_KEYTABLE(terratec_cinergy_xs),
 		.xclk           = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1295,7 +1295,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder	= EM28XX_SAA711X,
 		.has_dvb	= 1,
 		.dvb_gpio	= em2882_kworld_315u_digital,
-		.ir_codes	= &ir_codes_kworld_315u_table,
+		.ir_codes	= &IR_KEYTABLE(kworld_315u),
 		.xclk		= EM28XX_XCLK_FREQUENCY_12MHZ,
 		.i2c_speed	= EM28XX_I2C_CLK_WAIT_ENABLE,
 		/* Analog mode - still not ready */
@@ -1424,7 +1424,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = kworld_330u_digital,
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
-		.ir_codes     = &ir_codes_kworld_315u_table,
+		.ir_codes     = &IR_KEYTABLE(kworld_315u),
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1447,7 +1447,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder      = EM28XX_TVP5150,
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
-		.ir_codes     = &ir_codes_terratec_cinergy_xs_table,
+		.ir_codes     = &IR_KEYTABLE(terratec_cinergy_xs),
 		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -1540,7 +1540,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware = 1,
 		.decoder      = EM28XX_TVP5150,
 		.tuner_gpio   = default_tuner_gpio,
-		.ir_codes     = &ir_codes_kaiomy_table,
+		.ir_codes     = &IR_KEYTABLE(kaiomy),
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1640,7 +1640,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware = 1,
 		.has_dvb      = 1,
 		.dvb_gpio     = evga_indtube_digital,
-		.ir_codes     = &ir_codes_evga_indtube_table,
+		.ir_codes     = &IR_KEYTABLE(evga_indtube),
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -2334,21 +2334,21 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 	switch (dev->model) {
 	case EM2800_BOARD_TERRATEC_CINERGY_200:
 	case EM2820_BOARD_TERRATEC_CINERGY_250:
-		dev->init_data.ir_codes = &ir_codes_em_terratec_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(em_terratec);
 		dev->init_data.get_key = em28xx_get_key_terratec;
 		dev->init_data.name = "i2c IR (EM28XX Terratec)";
 		break;
 	case EM2820_BOARD_PINNACLE_USB_2:
-		dev->init_data.ir_codes = &ir_codes_pinnacle_grey_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(pinnacle_grey);
 		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
 		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
 		break;
 	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
-		dev->init_data.ir_codes = &ir_codes_rc5_hauppauge_new_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(rc5_hauppauge_new);
 		dev->init_data.get_key = em28xx_get_key_em_haup;
 		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
 	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
-		dev->init_data.ir_codes = &ir_codes_winfast_usbii_deluxe_table;;
+		dev->init_data.ir_codes = &IR_KEYTABLE(winfast_usbii_deluxe);;
 		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
 		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
 		break;
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 6af69d5..607a0be 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -322,13 +322,13 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &ir_codes_empty_table;
+		ir_codes    = &IR_KEYTABLE(empty);
 		break;
 	case 0x4b:
 		name        = "PV951";
 		ir->get_key = get_key_pv951;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &ir_codes_pv951_table;
+		ir_codes    = &IR_KEYTABLE(pv951);
 		break;
 	case 0x18:
 	case 0x1f:
@@ -337,22 +337,22 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir->get_key = get_key_haup;
 		ir_type     = IR_TYPE_RC5;
 		if (hauppauge == 1) {
-			ir_codes    = &ir_codes_hauppauge_new_table;
+			ir_codes    = &IR_KEYTABLE(hauppauge_new);
 		} else {
-			ir_codes    = &ir_codes_rc5_tv_table;
+			ir_codes    = &IR_KEYTABLE(rc5_tv);
 		}
 		break;
 	case 0x30:
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &ir_codes_empty_table;
+		ir_codes    = &IR_KEYTABLE(empty);
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
 		ir_type     = IR_TYPE_RC5;
-		ir_codes    = &ir_codes_fusionhdtv_mce_table;
+		ir_codes    = &IR_KEYTABLE(fusionhdtv_mce);
 		break;
 	case 0x0b:
 	case 0x47:
@@ -365,9 +365,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			ir_type     = IR_TYPE_RC5;
 			ir->get_key = get_key_haup_xvr;
 			if (hauppauge == 1) {
-				ir_codes    = &ir_codes_hauppauge_new_table;
+				ir_codes    = &IR_KEYTABLE(hauppauge_new);
 			} else {
-				ir_codes    = &ir_codes_rc5_tv_table;
+				ir_codes    = &IR_KEYTABLE(rc5_tv);
 			}
 		} else {
 			/* Handled by saa7134-input */
@@ -379,7 +379,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
 		ir_type     = IR_TYPE_OTHER;
-		ir_codes    = &ir_codes_avermedia_cardbus_table;
+		ir_codes    = &IR_KEYTABLE(avermedia_cardbus);
 		break;
 	}
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 2ee03c2..a363e33 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -193,7 +193,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 	/* Our default information for ir-kbd-i2c.c to use */
 	switch (hw) {
 	case IVTV_HW_I2C_IR_RX_AVER:
-		init_data->ir_codes = &ir_codes_avermedia_cardbus_table;
+		init_data->ir_codes = &IR_KEYTABLE(avermedia_cardbus);
 		init_data->internal_get_key_func =
 					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
 		init_data->type = IR_TYPE_OTHER;
@@ -202,14 +202,14 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
 	case IVTV_HW_I2C_IR_RX_HAUP_INT:
 		/* Default to old black remote */
-		init_data->ir_codes = &ir_codes_rc5_tv_table;
+		init_data->ir_codes = &IR_KEYTABLE(rc5_tv);
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
 		init_data->type = IR_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
-		init_data->ir_codes = &ir_codes_hauppauge_new_table;
+		init_data->ir_codes = &IR_KEYTABLE(hauppauge_new);
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type = IR_TYPE_RC5;
 		init_data->name = itv->card_name;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 9e2b32c..aac29a0 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -610,27 +610,27 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_FLYTVPLATINUM_FM:
 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
 	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
-		ir_codes     = &ir_codes_flyvideo_table;
+		ir_codes     = &IR_KEYTABLE(flyvideo);
 		mask_keycode = 0xEC00000;
 		mask_keydown = 0x0040000;
 		break;
 	case SAA7134_BOARD_CINERGY400:
 	case SAA7134_BOARD_CINERGY600:
 	case SAA7134_BOARD_CINERGY600_MK3:
-		ir_codes     = &ir_codes_cinergy_table;
+		ir_codes     = &IR_KEYTABLE(cinergy);
 		mask_keycode = 0x00003f;
 		mask_keyup   = 0x040000;
 		break;
 	case SAA7134_BOARD_ECS_TVP3XP:
 	case SAA7134_BOARD_ECS_TVP3XP_4CB5:
-		ir_codes     = &ir_codes_eztv_table;
+		ir_codes     = &IR_KEYTABLE(eztv);
 		mask_keycode = 0x00017c;
 		mask_keyup   = 0x000002;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_KWORLD_XPERT:
 	case SAA7134_BOARD_AVACSSMARTTV:
-		ir_codes     = &ir_codes_pixelview_table;
+		ir_codes     = &IR_KEYTABLE(pixelview);
 		mask_keycode = 0x00001F;
 		mask_keyup   = 0x000020;
 		polling      = 50; // ms
@@ -647,7 +647,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
 	case SAA7134_BOARD_AVERMEDIA_M102:
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
-		ir_codes     = &ir_codes_avermedia_table;
+		ir_codes     = &IR_KEYTABLE(avermedia);
 		mask_keycode = 0x0007C8;
 		mask_keydown = 0x000010;
 		polling      = 50; // ms
@@ -656,14 +656,14 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS0, 0x4);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M135A:
-		ir_codes     = &ir_codes_avermedia_m135a_rm_jx_table;
+		ir_codes     = &IR_KEYTABLE(avermedia_m135a_rm_jx);
 		mask_keydown = 0x0040000;
 		mask_keycode = 0xffff;
 		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
-		ir_codes     = &ir_codes_avermedia_table;
+		ir_codes     = &IR_KEYTABLE(avermedia);
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; // ms
@@ -672,7 +672,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A16D:
-		ir_codes     = &ir_codes_avermedia_a16d_table;
+		ir_codes     = &IR_KEYTABLE(avermedia_a16d);
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; /* ms */
@@ -681,14 +681,14 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
 		break;
 	case SAA7134_BOARD_KWORLD_TERMINATOR:
-		ir_codes     = &ir_codes_pixelview_table;
+		ir_codes     = &IR_KEYTABLE(pixelview);
 		mask_keycode = 0x00001f;
 		mask_keyup   = 0x000060;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_MANLI_MTV001:
 	case SAA7134_BOARD_MANLI_MTV002:
-		ir_codes     = &ir_codes_manli_table;
+		ir_codes     = &IR_KEYTABLE(manli);
 		mask_keycode = 0x001f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; /* ms */
@@ -708,25 +708,25 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_507_9FM:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
-		ir_codes     = &ir_codes_manli_table;
+		ir_codes     = &IR_KEYTABLE(manli);
 		mask_keycode = 0x003f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; /* ms */
 		break;
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
-		ir_codes     = &ir_codes_behold_columbus_table;
+		ir_codes     = &IR_KEYTABLE(behold_columbus);
 		mask_keycode = 0x003f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_SEDNA_PC_TV_CARDBUS:
-		ir_codes     = &ir_codes_pctv_sedna_table;
+		ir_codes     = &IR_KEYTABLE(pctv_sedna);
 		mask_keycode = 0x001f00;
 		mask_keyup   = 0x004000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_GOTVIEW_7135:
-		ir_codes     = &ir_codes_gotview7135_table;
+		ir_codes     = &IR_KEYTABLE(gotview7135);
 		mask_keycode = 0x0003CC;
 		mask_keydown = 0x000010;
 		polling	     = 5; /* ms */
@@ -735,80 +735,80 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
-		ir_codes     = &ir_codes_videomate_tv_pvr_table;
+		ir_codes     = &IR_KEYTABLE(videomate_tv_pvr);
 		mask_keycode = 0x00003F;
 		mask_keyup   = 0x400000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_PROTEUS_2309:
-		ir_codes     = &ir_codes_proteus_2309_table;
+		ir_codes     = &IR_KEYTABLE(proteus_2309);
 		mask_keycode = 0x00007F;
 		mask_keyup   = 0x000080;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
-		ir_codes     = &ir_codes_videomate_tv_pvr_table;
+		ir_codes     = &IR_KEYTABLE(videomate_tv_pvr);
 		mask_keycode = 0x003F00;
 		mask_keyup   = 0x040000;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
 	case SAA7134_BOARD_FLYDVBT_LR301:
 	case SAA7134_BOARD_FLYDVBTDUO:
-		ir_codes     = &ir_codes_flydvb_table;
+		ir_codes     = &IR_KEYTABLE(flydvb);
 		mask_keycode = 0x0001F00;
 		mask_keydown = 0x0040000;
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
-		ir_codes     = &ir_codes_asus_pc39_table;
+		ir_codes     = &IR_KEYTABLE(asus_pc39);
 		mask_keydown = 0x0040000;
 		rc5_gpio = 1;
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
-		ir_codes     = &ir_codes_encore_enltv_table;
+		ir_codes     = &IR_KEYTABLE(encore_enltv);
 		mask_keycode = 0x00007f;
 		mask_keyup   = 0x040000;
 		polling      = 50; // ms
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV_FM53:
-		ir_codes     = &ir_codes_encore_enltv_fm53_table;
+		ir_codes     = &IR_KEYTABLE(encore_enltv_fm53);
 		mask_keydown = 0x0040000;
 		mask_keycode = 0x00007f;
 		nec_gpio = 1;
 		break;
 	case SAA7134_BOARD_10MOONSTVMASTER3:
-		ir_codes     = &ir_codes_encore_enltv_table;
+		ir_codes     = &IR_KEYTABLE(encore_enltv);
 		mask_keycode = 0x5f80000;
 		mask_keyup   = 0x8000000;
 		polling      = 50; //ms
 		break;
 	case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
-		ir_codes     = &ir_codes_genius_tvgo_a11mce_table;
+		ir_codes     = &IR_KEYTABLE(genius_tvgo_a11mce);
 		mask_keycode = 0xff;
 		mask_keydown = 0xf00000;
 		polling = 50; /* ms */
 		break;
 	case SAA7134_BOARD_REAL_ANGEL_220:
-		ir_codes     = &ir_codes_real_audio_220_32_keys_table;
+		ir_codes     = &IR_KEYTABLE(real_audio_220_32_keys);
 		mask_keycode = 0x3f00;
 		mask_keyup   = 0x4000;
 		polling = 50; /* ms */
 		break;
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
-		ir_codes     = &ir_codes_kworld_plus_tv_analog_table;
+		ir_codes     = &IR_KEYTABLE(kworld_plus_tv_analog);
 		mask_keycode = 0x7f;
 		polling = 40; /* ms */
 		break;
 	case SAA7134_BOARD_VIDEOMATE_S350:
-		ir_codes     = &ir_codes_videomate_s350_table;
+		ir_codes     = &IR_KEYTABLE(videomate_s350);
 		mask_keycode = 0x003f00;
 		mask_keydown = 0x040000;
 		break;
 	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
-		ir_codes     = &ir_codes_winfast_table;
+		ir_codes     = &IR_KEYTABLE(winfast);
 		mask_keycode = 0x5f00;
 		mask_keyup   = 0x020000;
 		polling      = 50; /* ms */
@@ -938,24 +938,24 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "Pinnacle PCTV";
 		if (pinnacle_remote == 0) {
 			dev->init_data.get_key = get_key_pinnacle_color;
-			dev->init_data.ir_codes = &ir_codes_pinnacle_color_table;
+			dev->init_data.ir_codes = &IR_KEYTABLE(pinnacle_color);
 			info.addr = 0x47;
 		} else {
 			dev->init_data.get_key = get_key_pinnacle_grey;
-			dev->init_data.ir_codes = &ir_codes_pinnacle_grey_table;
+			dev->init_data.ir_codes = &IR_KEYTABLE(pinnacle_grey);
 			info.addr = 0x47;
 		}
 		break;
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
 		dev->init_data.name = "Purple TV";
 		dev->init_data.get_key = get_key_purpletv;
-		dev->init_data.ir_codes = &ir_codes_purpletv_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(purpletv);
 		info.addr = 0x7a;
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 		dev->init_data.name = "MSI TV@nywhere Plus";
 		dev->init_data.get_key = get_key_msi_tvanywhere_plus;
-		dev->init_data.ir_codes = &ir_codes_msi_tvanywhere_plus_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(msi_tvanywhere_plus);
 		info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
@@ -969,7 +969,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		dev->init_data.name = "HVR 1110";
 		dev->init_data.get_key = get_key_hvr1110;
-		dev->init_data.ir_codes = &ir_codes_hauppauge_new_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(hauppauge_new);
 		info.addr = 0x71;
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
@@ -987,7 +987,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_X7:
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
-		dev->init_data.ir_codes = &ir_codes_behold_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(behold);
 		dev->init_data.type = IR_TYPE_NEC;
 		info.addr = 0x2d;
 		break;
@@ -998,7 +998,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_FLYDVB_TRIO:
 		dev->init_data.name = "FlyDVB Trio";
 		dev->init_data.get_key = get_key_flydvb_trio;
-		dev->init_data.ir_codes = &ir_codes_flydvb_table;
+		dev->init_data.ir_codes = &IR_KEYTABLE(flydvb);
 		info.addr = 0x0b;
 		break;
 	default:
-- 
1.6.6.1


