Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5HKdOES002772
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 16:39:24 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5HKdARA017698
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 16:39:13 -0400
Message-ID: <4858205B.7070500@gimpelevich.san-francisco.ca.us>
Date: Tue, 17 Jun 2008 13:36:43 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: mchehab@infradead.org
Content-Type: multipart/mixed; boundary="------------080008040309020801010605"
Cc: video4linux-list@redhat.com
Subject: [PATCH resend] Implement proper cx88 deactivation
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------080008040309020801010605
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Also includes full support for the Kworld PlusTV HD PCI 120 card, 
pending a rework of the tuner core.

--------------080008040309020801010605
Content-Type: text/x-patch;
 name="better-cx88.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="better-cx88.patch"

Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>

diff -r 78442352b885 linux/Documentation/video4linux/CARDLIST.cx88
--- a/linux/Documentation/video4linux/CARDLIST.cx88	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.cx88	Tue Jun 17 13:04:00 2008 -0700
@@ -60,7 +60,7 @@
  59 -> DViCO FusionHDTV 5 PCI nano                         [18ac:d530]
  60 -> Pinnacle Hybrid PCTV                                [12ab:1788]
  61 -> Winfast TV2000 XP Global                            [107d:6f18]
- 62 -> PowerColor RA330                                    [14f1:ea3d]
+ 62 -> PowerColor Real Angel 330                           [14f1:ea3d]
  63 -> Geniatech X8000-MT DVBT                             [14f1:8852]
  64 -> DViCO FusionHDTV DVB-T PRO                          [18ac:db30]
  65 -> DViCO FusionHDTV 7 Gold                             [18ac:d610]
diff -r 78442352b885 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Tue Jun 17 13:04:00 2008 -0700
@@ -55,8 +55,11 @@
 MODULE_PARM_DESC(card,"card type");
 
 static unsigned int latency = UNSET;
+static unsigned int tuner_debug;
 module_param(latency,int,0444);
+module_param(tuner_debug, int, 0444);
 MODULE_PARM_DESC(latency,"pci latency timer");
+MODULE_PARM_DESC(tuner_debug, "enable debug messages [tuner]");
 
 #define info_printk(core, fmt, arg...) \
 	printk(KERN_INFO "%s: " fmt, core->name , ## arg)
@@ -66,6 +69,10 @@
 
 #define err_printk(core, fmt, arg...) \
 	printk(KERN_ERR "%s: " fmt, core->name , ## arg)
+
+#define dprintk(core, fmt, arg...) do {\
+	if (tuner_debug)\
+	printk(KERN_DEBUG "%s: " fmt, core->name , ## arg); } while (0)
 
 
 /* ------------------------------------------------------------------ */
@@ -1425,10 +1432,6 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.input          = {{
-			.type   = CX88_VMUX_DEBUG,
-			.vmux   = 3,
-			.gpio0  = 0x04ff,
-		},{
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x07fa,
@@ -1437,6 +1440,10 @@
 			.vmux   = 2,
 			.gpio0  = 0x07fa,
 		}},
+		.off = {
+			.type   = CX88_OFF,
+			.gpio0  = 0x04ff,
+		},
 	},
 	[CX88_BOARD_PINNACLE_PCTV_HD_800i] = {
 		.name           = "Pinnacle PCTV HD 800i",
@@ -1547,35 +1554,39 @@
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
 		.input          = { {
-			.type   = CX88_VMUX_DEBUG,
-			.vmux   = 3,		/* Due to the way the cx88 driver is written,	*/
-			.gpio0 = 0x00ff,	/* there is no way to deactivate audio pass-	*/
-			.gpio1 = 0xf39d,	/* through without this entry. Furthermore, if	*/
-			.gpio3 = 0x0000,	/* the TV mux entry is first, you get audio	*/
-		}, {				/* from the tuner on boot for a little while.	*/
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
-			.gpio0 = 0x00ff,
-			.gpio1 = 0xf35d,
-			.gpio3 = 0x0000,
+			.gpio0  = 0x00ff,
+			.gpio1  = 0xf35d,
+			.gpio3  = 0x0000,
+			.audioroute = 1,
 		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
-			.gpio0 = 0x00ff,
-			.gpio1 = 0xf37d,
-			.gpio3 = 0x0000,
+			.gpio0  = 0x00ff,
+			.gpio1  = 0xf37d,
+			.gpio3  = 0x0000,
+			.audioroute = 1,
 		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x000ff,
 			.gpio1  = 0x0f37d,
 			.gpio3  = 0x00000,
+			.audioroute = 1,
 		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x000ff,
 			.gpio1  = 0x0f35d,
 			.gpio3  = 0x00000,
+			.audioroute = 1,
+		},
+		.off = {
+			.type   = CX88_OFF,
+			.gpio0  = 0x00ff,
+			.gpio1  = 0xf39d,
+			.gpio3  = 0x0000,
 		},
 	},
 	[CX88_BOARD_GENIATECH_X8000_MT] = {
@@ -1682,7 +1693,7 @@
 	   tuner-xc3028 without doing an i2c probe.
 	 */
 	[CX88_BOARD_KWORLD_ATSC_120] = {
-		.name           = "Kworld PlusTV HD PCI 120 (ATSC 120)",
+		.name           = "Kworld ATSC 120",
 		.tuner_type     = TUNER_XC2028,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
@@ -1692,25 +1703,40 @@
 			.vmux   = 0,
 			.gpio0  = 0x000000ff,
 			.gpio1  = 0x0000f35d,
-			.gpio2  = 0x00000000,
+			.gpio3  = 0x00000000,
+			.audioroute = 1,
 		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x000000ff,
 			.gpio1  = 0x0000f37e,
-			.gpio2  = 0x00000000,
+			.gpio3  = 0x00000000,
+			.audioroute = 1,
 		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x000000ff,
 			.gpio1  = 0x0000f37e,
-			.gpio2  = 0x00000000,
+			.gpio3  = 0x00000000,
+			.audioroute = 1,
+		}, {
+			.type   = CX88_VMUX_DVB,
+			.gpio0  = 0x000000ff,
+			.gpio1  = 0x0000f39e,
+			.gpio3  = 0x00000000,
 		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x000000ff,
 			.gpio1  = 0x0000f35d,
-			.gpio2  = 0x00000000,
+			.gpio3  = 0x00000000,
+			.audioroute = 1,
+		},
+		.off = {
+			.type   = CX88_OFF,
+			.gpio0  = 0x000000ff,
+			.gpio1  = 0x0000f39e,
+			.gpio3  = 0x00000000,
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
@@ -2396,10 +2422,10 @@
 
 	switch (core->board.tuner_type) {
 		case TUNER_XC2028:
-			info_printk(core, "Calling XC2028/3028 callback\n");
+			dprintk(core, "Calling XC2028/3028 callback\n");
 			return cx88_xc2028_tuner_callback(core, command, arg);
 		case TUNER_XC5000:
-			info_printk(core, "Calling XC5000 callback\n");
+			dprintk(core, "Calling XC5000 callback\n");
 			return cx88_xc5000_tuner_callback(core, command, arg);
 	}
 	err_printk(core, "Error: Calling callback for tuner %d\n",
diff -r 78442352b885 linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Tue Jun 17 13:04:00 2008 -0700
@@ -605,6 +605,9 @@
 int cx88_reset(struct cx88_core *core)
 {
 	dprintk(1,"%s\n",__func__);
+	core->i2c_algo.data = core;
+	if (core->board.tuner_type == TUNER_XC2028)
+		cx88_tuner_callback(&(core->i2c_algo), XC2028_TUNER_RESET, 0);
 	cx88_shutdown(core);
 
 	/* clear irq status */
@@ -854,10 +857,11 @@
 {
 	v4l2_std_id norm = core->tvnorm;
 
-	if (CX88_VMUX_TELEVISION != INPUT(core->input).type)
+	if (CX88_VMUX_TELEVISION != INPUT(core->input).type) {
+		core->tvaudio = WW_NONE;
 		return 0;
 
-	if (V4L2_STD_PAL_BG & norm) {
+	} else if (V4L2_STD_PAL_BG & norm) {
 		core->tvaudio = WW_BG;
 
 	} else if (V4L2_STD_PAL_DK & norm) {
@@ -882,7 +886,7 @@
 	} else {
 		printk("%s/0: tvaudio support needs work for this tv norm [%s], sorry\n",
 		       core->name, v4l2_norm_to_name(core->tvnorm));
-		core->tvaudio = 0;
+		core->tvaudio = WW_NONE;
 		return 0;
 	}
 
diff -r 78442352b885 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Tue Jun 17 13:04:00 2008 -0700
@@ -336,6 +336,11 @@
 		ir->mask_keycode = 0x7e;
 		ir->polling = 100; /* ms */
 		break;
+	case CX88_BOARD_KWORLD_ATSC_120:
+		ir_codes = ir_codes_powercolor_real_angel;
+		ir_type = IR_TYPE_RC5;
+		ir->sampling = 1;
+		break;
 	}
 
 	if (NULL == ir_codes) {
@@ -445,9 +450,8 @@
 		ir_dump_samples(ir->samples, ir->scount);
 
 	/* decode it */
-	switch (core->boardnr) {
-	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
-	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
+	switch (ir->ir.ir_type) {
+	case IR_TYPE_PD:
 		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);
 
 		if (ircode == 0xffffffff) { /* decoding error */
@@ -478,13 +482,7 @@
 		ir_input_keydown(ir->input, &ir->ir, (ircode >> 16) & 0x7f, (ircode >> 16) & 0xff);
 		ir->release = jiffies + msecs_to_jiffies(120);
 		break;
-	case CX88_BOARD_HAUPPAUGE:
-	case CX88_BOARD_HAUPPAUGE_DVB_T1:
-	case CX88_BOARD_HAUPPAUGE_NOVASE2_S1:
-	case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
-	case CX88_BOARD_HAUPPAUGE_HVR1100:
-	case CX88_BOARD_HAUPPAUGE_HVR3000:
-	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
+	case IR_TYPE_RC5:
 		ircode = ir_decode_biphase(ir->samples, ir->scount, 5, 7);
 		ir_dprintk("biphase decoded: %x\n", ircode);
 		if ((ircode & 0xfffff000) != 0x3000)
diff -r 78442352b885 linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jun 17 13:04:00 2008 -0700
@@ -665,13 +665,21 @@
 static int cx8802_request_acquire(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
+	unsigned int input;
 
 	/* Fail a request for hardware if the device is busy. */
 	if (core->active_type_id != CX88_BOARD_NONE &&
 	    core->active_type_id != drv->type_id)
 		return -EBUSY;
 
-	core->input = CX88_VMUX_DVB;
+	for (input = 0; input < MAX_CX88_INPUT; input++)
+		if (INPUT(input).type == CX88_VMUX_DVB)
+			break;
+
+	if (input == MAX_CX88_INPUT)
+		return -EINVAL;
+
+	cx88_video_mux(core, input);
 
 	if (drv->advise_acquire)
 	{
diff -r 78442352b885 linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Tue Jun 17 13:04:00 2008 -0700
@@ -774,6 +774,7 @@
 		set_audio_standard_FM(core, radio_deemphasis);
 		break;
 	case WW_NONE:
+		break;
 	default:
 		printk("%s/0: unknown tv audio mode [%d]\n",
 		       core->name, core->tvaudio);
diff -r 78442352b885 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Tue Jun 17 13:04:00 2008 -0700
@@ -418,25 +418,23 @@
 		INPUT(input).gpio0,INPUT(input).gpio1,
 		INPUT(input).gpio2,INPUT(input).gpio3);
 	core->input = input;
-	cx_andor(MO_INPUT_FORMAT, 0x03 << 14, INPUT(input).vmux << 14);
+	if (!(input & ~0xFF))
+		cx_andor(MO_INPUT_FORMAT, 0x03 << 14, INPUT(input).vmux << 14);
 	cx_write(MO_GP3_IO, INPUT(input).gpio3);
 	cx_write(MO_GP0_IO, INPUT(input).gpio0);
 	cx_write(MO_GP1_IO, INPUT(input).gpio1);
 	cx_write(MO_GP2_IO, INPUT(input).gpio2);
 
-	switch (INPUT(input).type) {
-	case CX88_VMUX_SVIDEO:
+	if (INPUT(input).type == CX88_VMUX_SVIDEO) {
 		cx_set(MO_AFECFG_IO,    0x00000001);
 		cx_set(MO_INPUT_FORMAT, 0x00010010);
 		cx_set(MO_FILTER_EVEN,  0x00002020);
 		cx_set(MO_FILTER_ODD,   0x00002020);
-		break;
-	default:
+	} else {
 		cx_clear(MO_AFECFG_IO,    0x00000001);
 		cx_clear(MO_INPUT_FORMAT, 0x00010010);
 		cx_clear(MO_FILTER_EVEN,  0x00002020);
 		cx_clear(MO_FILTER_ODD,   0x00002020);
-		break;
 	}
 
 	/* if there are audioroutes defined, we have an external
@@ -448,15 +446,17 @@
 		   When used with S-Video, that ADC is busy dealing with
 		   chroma, so an external must be used for baseband audio */
 
-		if (INPUT(input).type != CX88_VMUX_TELEVISION &&
-			INPUT(input).type != CX88_RADIO) {
+		switch (INPUT(input).type) {
+		case CX88_VMUX_TELEVISION:
+		case CX88_RADIO:
+			/* Normal mode */
+			cx_write(AUD_I2SCNTL, 0x0);
+			cx_clear(AUD_CTL, EN_I2SIN_ENABLE);
+			break;
+		default:
 			/* "ADC mode" */
 			cx_write(AUD_I2SCNTL, 0x1);
 			cx_set(AUD_CTL, EN_I2SIN_ENABLE);
-		} else {
-			/* Normal mode */
-			cx_write(AUD_I2SCNTL, 0x0);
-			cx_clear(AUD_CTL, EN_I2SIN_ENABLE);
 		}
 
 		/* The wm8775 module has the "2" route hardwired into
@@ -1033,6 +1033,9 @@
 
 	core = dev->core;
 
+	if (radio?core->vinst:core->rinst)
+		return -EBUSY;
+
 	dprintk(1,"open minor=%d radio=%d type=%s\n",
 		minor,radio,v4l2_type_names[type]);
 
@@ -1061,17 +1064,16 @@
 			    sizeof(struct cx88_buffer),
 			    fh);
 
-	if (fh->radio) {
+	if (radio) {
 		dprintk(1,"video_open: setting radio device\n");
-		cx_write(MO_GP3_IO, core->board.radio.gpio3);
-		cx_write(MO_GP0_IO, core->board.radio.gpio0);
-		cx_write(MO_GP1_IO, core->board.radio.gpio1);
-		cx_write(MO_GP2_IO, core->board.radio.gpio2);
+		core->rinst++;
+		cx88_video_mux(core, CX88_RADIO<<8);
 		core->tvaudio = WW_FM;
 		cx88_set_tvaudio(core);
 		cx88_set_stereo(core,V4L2_TUNER_MODE_STEREO,1);
 		cx88_call_i2c_clients(core,AUDC_SET_RADIO,NULL);
-	}
+	} else
+		core->vinst++;
 
 	return 0;
 }
@@ -1130,8 +1132,14 @@
 
 static int video_release(struct inode *inode, struct file *file)
 {
-	struct cx8800_fh  *fh  = file->private_data;
-	struct cx8800_dev *dev = fh->dev;
+	struct cx8800_fh  *fh   = file->private_data;
+	struct cx8800_dev *dev  = fh->dev;
+	struct cx88_core  *core = dev->core;
+
+	if (fh->radio)
+		core->rinst--;
+	else
+		core->vinst--;
 
 	/* turn off overlay */
 	if (res_check(fh, RESOURCE_OVERLAY)) {
@@ -1159,6 +1167,12 @@
 	videobuf_mmap_free(&fh->vbiq);
 	file->private_data = NULL;
 	kfree(fh);
+
+	if (core->vinst || core->rinst || core->input == CX88_RADIO<<8)
+		return 0;
+
+	if (core->board.off.type == CX88_OFF)
+		cx88_video_mux(core, CX88_OFF<<8);
 
 	cx88_call_i2c_clients (dev->core, TUNER_SET_STANDBY, NULL);
 
@@ -1507,7 +1521,7 @@
 	unsigned int n;
 
 	n = i->index;
-	if (n >= 4)
+	if (n >= MAX_CX88_INPUT)
 		return -EINVAL;
 	if (0 == INPUT(n).type)
 		return -EINVAL;
@@ -1802,6 +1816,12 @@
 	return 0;
 }
 
+static int radio_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
 static int radio_s_input (struct file *file, void *fh, unsigned int i)
 {
 	return 0;
@@ -1815,7 +1835,7 @@
 	if (c->id <  V4L2_CID_BASE ||
 		c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
-	if (c->id == V4L2_CID_AUDIO_MUTE) {
+	if (c->id == V4L2_CID_AUDIO_MUTE || c->id == V4L2_CID_AUDIO_VOLUME) {
 		for (i = 0; i < CX8800_CTLS; i++)
 			if (cx8800_ctls[i].v.id == c->id)
 				break;
@@ -2036,6 +2056,7 @@
 	.vidioc_g_audio       = radio_g_audio,
 	.vidioc_s_tuner       = radio_s_tuner,
 	.vidioc_s_audio       = radio_s_audio,
+	.vidioc_g_input       = radio_g_input,
 	.vidioc_s_input       = radio_s_input,
 	.vidioc_queryctrl     = radio_queryctrl,
 	.vidioc_g_ctrl        = vidioc_g_ctrl,
@@ -2215,9 +2236,8 @@
 
 	/* initial device configuration */
 	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core,core->tvnorm);
 	init_controls(core);
-	cx88_video_mux(core,0);
+	core->input = CX88_OFF<<8;
 	mutex_unlock(&core->lock);
 
 	/* start tvaudio thread */
diff -r 78442352b885 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Tue Jun 17 13:04:00 2008 -0700
@@ -236,6 +236,7 @@
 	CX88_VMUX_DVB,
 	CX88_VMUX_DEBUG,
 	CX88_RADIO,
+	CX88_OFF,
 };
 
 struct cx88_input {
@@ -253,7 +254,7 @@
 	unsigned char		radio_addr;
 	int                     tda9887_conf;
 	struct cx88_input       input[MAX_CX88_INPUT];
-	struct cx88_input       radio;
+	struct cx88_input       radio, off;
 	enum cx88_board_type    mpeg;
 	enum audiochip          audio_chip;
 };
@@ -264,7 +265,8 @@
 	u32     card;
 };
 
-#define INPUT(nr) (core->board.input[nr])
+#define INPUT(nr) ((nr & ~0xFF)?(nr == CX88_RADIO<<8?\
+	core->board.radio:core->board.off):core->board.input[nr])
 
 /* ----------------------------------------------------------- */
 /* device / file handle status                                 */
@@ -341,6 +343,7 @@
 	u32                        input;
 	u32                        astat;
 	u32			   use_nicam;
+	u32			   vinst, rinst;
 
 	/* IR remote control state */
 	struct cx88_IR             *ir;
@@ -643,15 +646,15 @@
 /* ----------------------------------------------------------- */
 /* cx88-tvaudio.c                                              */
 
-#define WW_NONE		 1
-#define WW_BTSC		 2
-#define WW_BG		 3
-#define WW_DK		 4
-#define WW_I		 5
-#define WW_L		 6
-#define WW_EIAJ		 7
-#define WW_I2SPT	 8
-#define WW_FM		 9
+#define WW_NONE		 0
+#define WW_BTSC		 1
+#define WW_BG		 2
+#define WW_DK		 3
+#define WW_I		 4
+#define WW_L		 5
+#define WW_EIAJ		 6
+#define WW_I2SPT	 7
+#define WW_FM		 8
 
 void cx88_set_tvaudio(struct cx88_core *core);
 void cx88_newstation(struct cx88_core *core);

--------------080008040309020801010605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080008040309020801010605--
