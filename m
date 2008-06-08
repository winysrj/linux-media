Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58KnVwI009687
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 16:49:31 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m58Kmfmp008360
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 16:48:41 -0400
Message-ID: <484C459B.7030201@gimpelevich.san-francisco.ca.us>
Date: Sun, 08 Jun 2008 13:48:27 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------020205090802090701090604"
Subject: [PATCH] Implement proper cx88 deactivation
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
--------------020205090802090701090604
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

As it stands, the cx88 driver has no framework for keeping track of 
card's GPIO settings for when the card is not used. The settings are 
left in the state of the last used input, and if that input supplies 
audio, that audio persists. Also, the cx88 chip cannot handle more than 
one input at a time, so the /dev/radio and /dev/video devices may step 
on each other. The audio standard setting from the last used tuner input 
is preserved for non-tuner inputs, which is incorrect, and the default 
standard is undefined rather than WW_NONE. Resetting the cx88 does not 
send a reset callback to the tuner, which may leave the tuner 
unresponsive to i2c under certain circumstances. The tuner is needlessly 
activated on boot. This patch, which is intended to be atomic, aims to 
fix all those issues. I have added the deactivation GPIO values for the 
cards I have previously examined, and more can be added later. I don't 
expect this patch to break anything, but if it does, I'm sure it can be 
taken care of easily. I hope it may be committed so that it may gain the 
widest possible stress testing. Thank you.

--------------020205090802090701090604
Content-Type: text/x-patch;
 name="better-cx88.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="better-cx88.patch"

Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>

diff -r 3f7d664a285d linux/Documentation/video4linux/CARDLIST.cx88
--- a/linux/Documentation/video4linux/CARDLIST.cx88	Sun Jun 08 07:26:00 2008 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.cx88	Sun Jun 08 13:19:53 2008 -0700
@@ -60,7 +60,7 @@
  59 -> DViCO FusionHDTV 5 PCI nano                         [18ac:d530]
  60 -> Pinnacle Hybrid PCTV                                [12ab:1788]
  61 -> Winfast TV2000 XP Global                            [107d:6f18]
- 62 -> PowerColor RA330                                    [14f1:ea3d]
+ 62 -> PowerColor Real Angel 330                           [14f1:ea3d]
  63 -> Geniatech X8000-MT DVBT                             [14f1:8852]
  64 -> DViCO FusionHDTV DVB-T PRO                          [18ac:db30]
  65 -> DViCO FusionHDTV 7 Gold                             [18ac:d610]
diff -r 3f7d664a285d linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Sun Jun 08 07:26:00 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Sun Jun 08 13:19:53 2008 -0700
@@ -1425,10 +1425,6 @@
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
@@ -1437,6 +1433,10 @@
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
@@ -1547,35 +1547,39 @@
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
@@ -2396,14 +2400,20 @@
 
 	switch (core->board.tuner_type) {
 		case TUNER_XC2028:
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 			info_printk(core, "Calling XC2028/3028 callback\n");
+#endif
 			return cx88_xc2028_tuner_callback(core, command, arg);
 		case TUNER_XC5000:
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 			info_printk(core, "Calling XC5000 callback\n");
+#endif
 			return cx88_xc5000_tuner_callback(core, command, arg);
 	}
+#if 0
 	err_printk(core, "Error: Calling callback for tuner %d\n",
 		   core->board.tuner_type);
+#endif
 	return -EINVAL;
 }
 EXPORT_SYMBOL(cx88_tuner_callback);
diff -r 3f7d664a285d linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Sun Jun 08 07:26:00 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Sun Jun 08 13:19:53 2008 -0700
@@ -605,6 +605,8 @@
 int cx88_reset(struct cx88_core *core)
 {
 	dprintk(1,"%s\n",__func__);
+	core->i2c_algo.data = core;
+	cx88_tuner_callback(&(core->i2c_algo), 0, 0);
 	cx88_shutdown(core);
 
 	/* clear irq status */
@@ -854,10 +856,11 @@
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
@@ -882,7 +885,7 @@
 	} else {
 		printk("%s/0: tvaudio support needs work for this tv norm [%s], sorry\n",
 		       core->name, v4l2_norm_to_name(core->tvnorm));
-		core->tvaudio = 0;
+		core->tvaudio = WW_NONE;
 		return 0;
 	}
 
diff -r 3f7d664a285d linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Sun Jun 08 07:26:00 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Sun Jun 08 13:19:53 2008 -0700
@@ -774,6 +774,7 @@
 		set_audio_standard_FM(core, radio_deemphasis);
 		break;
 	case WW_NONE:
+		break;
 	default:
 		printk("%s/0: unknown tv audio mode [%d]\n",
 		       core->name, core->tvaudio);
diff -r 3f7d664a285d linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sun Jun 08 07:26:00 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sun Jun 08 13:19:53 2008 -0700
@@ -1033,6 +1033,9 @@
 
 	core = dev->core;
 
+	if (radio?core->vinst:core->rinst)
+		return -EBUSY;
+
 	dprintk(1,"open minor=%d radio=%d type=%s\n",
 		minor,radio,v4l2_type_names[type]);
 
@@ -1063,6 +1066,7 @@
 
 	if (fh->radio) {
 		dprintk(1,"video_open: setting radio device\n");
+		core->rinst++;
 		cx_write(MO_GP3_IO, core->board.radio.gpio3);
 		cx_write(MO_GP0_IO, core->board.radio.gpio0);
 		cx_write(MO_GP1_IO, core->board.radio.gpio1);
@@ -1071,7 +1075,8 @@
 		cx88_set_tvaudio(core);
 		cx88_set_stereo(core,V4L2_TUNER_MODE_STEREO,1);
 		cx88_call_i2c_clients(core,AUDC_SET_RADIO,NULL);
-	}
+	} else
+		core->vinst++;
 
 	return 0;
 }
@@ -1130,8 +1135,14 @@
 
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
@@ -1160,6 +1171,15 @@
 	file->private_data = NULL;
 	kfree(fh);
 
+	if (core->vinst || core->rinst)
+		return 0;
+
+	if (core->board.off.type == CX88_OFF) {
+		cx_write(MO_GP3_IO, core->board.off.gpio3);
+		cx_write(MO_GP0_IO, core->board.off.gpio0);
+		cx_write(MO_GP1_IO, core->board.off.gpio1);
+		cx_write(MO_GP2_IO, core->board.off.gpio2);
+	}
 	cx88_call_i2c_clients (dev->core, TUNER_SET_STANDBY, NULL);
 
 	return 0;
@@ -2215,9 +2235,7 @@
 
 	/* initial device configuration */
 	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core,core->tvnorm);
 	init_controls(core);
-	cx88_video_mux(core,0);
 	mutex_unlock(&core->lock);
 
 	/* start tvaudio thread */
diff -r 3f7d664a285d linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Sun Jun 08 07:26:00 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Sun Jun 08 13:19:53 2008 -0700
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
@@ -341,6 +342,7 @@
 	u32                        input;
 	u32                        astat;
 	u32			   use_nicam;
+	u32			   vinst, rinst;
 
 	/* IR remote control state */
 	struct cx88_IR             *ir;
@@ -643,15 +645,15 @@
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

--------------020205090802090701090604
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------020205090802090701090604--
