Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147AbaKANjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 09:39:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/7] [media] cx231xx: Cleanup printk at the driver
Date: Sat,  1 Nov 2014 11:38:55 -0200
Message-Id: <c347502e632c69c80dcf5d4df1396cb59973af2f.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <cover.1414849031.git.mchehab@osg.samsung.com>
References: <cover.1414849031.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of debug printks printed with pr_info. Also, the
printk's data are not too coherent:

- there are duplicated driver name at the print format;
- function name format string differs from function to function;
- long strings broken into multiple lines;
- some printks just produce ugly reports, being almost useless
  as-is.

Do a cleanup on that.

Still, there are much to be done in order to do a better printk
job on this driver, but, at least it will now be a way less
verbose, if debug printks are disabled, and some logs might
actually be useful.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index d678f4587ab4..1bb70f09f722 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -90,10 +90,10 @@ static unsigned int v4l_debug = 1;
 module_param(v4l_debug, int, 0644);
 MODULE_PARM_DESC(v4l_debug, "enable V4L debug messages");
 
-#define dprintk(level, fmt, arg...)\
-	do { if (v4l_debug >= level) \
-		pr_info("%s: " fmt, \
-		(dev) ? dev->name : "cx231xx[?]", ## arg); \
+#define dprintk(level, fmt, arg...)	\
+	do { 				\
+		if (v4l_debug >= level) \
+			printk(KERN_DEBUG pr_fmt(fmt), ## arg); \
 	} while (0)
 
 static struct cx231xx_tvnorm cx231xx_tvnorms[] = {
@@ -1114,15 +1114,15 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 	cx231xx_disable656(dev);
 	retval = cx231xx_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0); /* ping */
 	if (retval < 0) {
-		dprintk(2, "%s() PING OK\n", __func__);
+		dprintk(2, "%s: PING OK\n", __func__);
 		retval = cx231xx_load_firmware(dev);
 		if (retval < 0) {
-			pr_err("%s() f/w load failed\n", __func__);
+			pr_err("%s: f/w load failed\n", __func__);
 			return retval;
 		}
 		retval = cx231xx_find_mailbox(dev);
 		if (retval < 0) {
-			pr_err("%s() mailbox < 0, error\n",
+			pr_err("%s: mailbox < 0, error\n",
 				__func__);
 			return -1;
 		}
@@ -1798,7 +1798,6 @@ static unsigned int mpeg_poll(struct file *file,
 static int mpeg_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct cx231xx_fh *fh = file->private_data;
-	struct cx231xx *dev = fh->dev;
 
 	dprintk(2, "%s()\n", __func__);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 8312388edabb..e96703180c0c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -277,7 +277,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	pr_info("%s: Starting ISO AUDIO transfers\n", __func__);
+	pr_debug("%s: Starting ISO AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
 		return -ENODEV;
@@ -338,7 +338,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	pr_info("%s: Starting BULK AUDIO transfers\n", __func__);
+	pr_debug("%s: Starting BULK AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
 		return -ENODEV;
@@ -439,8 +439,7 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
 	if (!dev) {
-		pr_err("BUG: cx231xx can't find device struct."
-			       " Can't proceed with open\n");
+		pr_err("BUG: cx231xx can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -662,8 +661,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 		return 0;
 	}
 
-	pr_info("cx231xx-audio.c: probing for cx231xx "
-		     "non standard usbaudio\n");
+	pr_debug("probing for cx231xx non standard usbaudio\n");
 
 	err = snd_card_new(&dev->udev->dev, index[devnr], "Cx231xx Audio",
 			   THIS_MODULE, 0, &card);
@@ -707,14 +705,12 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 			bEndpointAddress;
 
 	adev->num_alt = uif->num_altsetting;
-	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
-		     adev->end_point_addr, adev->num_alt);
+	pr_info("audio EndPoint Addr 0x%x, Alternate settings: %i\n",
+		adev->end_point_addr, adev->num_alt);
 	adev->alt_max_pkt_size = kmalloc(32 * adev->num_alt, GFP_KERNEL);
 
-	if (adev->alt_max_pkt_size == NULL) {
-		pr_err("out of memory!\n");
+	if (adev->alt_max_pkt_size == NULL)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < adev->num_alt; i++) {
 		u16 tmp =
@@ -722,7 +718,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 				wMaxPacketSize);
 		adev->alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_info("Alternate setting %i, max size= %i\n", i,
+		pr_debug("audio alternate setting %i, max size= %i\n", i,
 			     adev->alt_max_pkt_size[i]);
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 036ffdde6e89..eca2cceb8eb8 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -83,10 +83,10 @@ void initGPIO(struct cx231xx *dev)
 	cx231xx_send_gpio_cmd(dev, _gpio_direction, (u8 *)&value, 4, 0, 0);
 
 	verve_read_byte(dev, 0x07, &val);
-	pr_info(" verve_read_byte address0x07=0x%x\n", val);
+	pr_debug("verve_read_byte address0x07=0x%x\n", val);
 	verve_write_byte(dev, 0x07, 0xF4);
 	verve_read_byte(dev, 0x07, &val);
-	pr_info(" verve_read_byte address0x07=0x%x\n", val);
+	pr_debug("verve_read_byte address0x07=0x%x\n", val);
 
 	cx231xx_capture_start(dev, 1, Vbi);
 
@@ -156,22 +156,22 @@ int cx231xx_afe_init_super_block(struct cx231xx *dev, u32 ref_count)
 	while (afe_power_status != 0x18) {
 		status = afe_write_byte(dev, SUP_BLK_PWRDN, 0x18);
 		if (status < 0) {
-			pr_info(
-			": Init Super Block failed in send cmd\n");
+			pr_debug("%s: Init Super Block failed in send cmd\n",
+				__func__);
 			break;
 		}
 
 		status = afe_read_byte(dev, SUP_BLK_PWRDN, &afe_power_status);
 		afe_power_status &= 0xff;
 		if (status < 0) {
-			pr_info(
-			": Init Super Block failed in receive cmd\n");
+			pr_debug("%s: Init Super Block failed in receive cmd\n",
+				__func__);
 			break;
 		}
 		i++;
 		if (i == 10) {
-			pr_info(
-			": Init Super Block force break in loop !!!!\n");
+			pr_debug("%s: Init Super Block force break in loop !!!!\n",
+				__func__);
 			status = -1;
 			break;
 		}
@@ -410,7 +410,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 						0x00);
 		} else {
-			pr_info("Invalid AV mode input\n");
+			pr_debug("Invalid AV mode input\n");
 			status = -1;
 		}
 		break;
@@ -467,7 +467,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 							0x40);
 		} else {
-			pr_info("Invalid AV mode input\n");
+			pr_debug("Invalid AV mode input\n");
 			status = -1;
 		}
 	}			/* switch  */
@@ -628,8 +628,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	if (pin_type != dev->video_input) {
 		status = cx231xx_afe_adjust_ref_count(dev, pin_type);
 		if (status < 0) {
-			pr_err("%s: adjust_ref_count :Failed to set"
-				"AFE input mux - errCode [%d]!\n",
+			pr_err("%s: adjust_ref_count :Failed to set AFE input mux - errCode [%d]!\n",
 				__func__, status);
 			return status;
 		}
@@ -638,9 +637,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	/* call afe block to set video inputs */
 	status = cx231xx_afe_set_input_mux(dev, input);
 	if (status < 0) {
-		pr_err("%s: set_input_mux :Failed to set"
-				" AFE input mux - errCode [%d]!\n",
-				__func__, status);
+		pr_err("%s: set_input_mux :Failed to set AFE input mux - errCode [%d]!\n",
+			__func__, status);
 		return status;
 	}
 
@@ -670,8 +668,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode  */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			pr_err("%s: cx231xx_dif set to By pass"
-						   " mode- errCode [%d]!\n",
+			pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
 		}
@@ -715,8 +712,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			pr_err("%s: cx231xx_dif set to By pass"
-						   " mode- errCode [%d]!\n",
+			pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
 		}
@@ -790,9 +786,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			status = cx231xx_dif_set_standard(dev,
 							  DIF_USE_BASEBAND);
 			if (status < 0) {
-				pr_err("%s: cx231xx_dif set to By pass"
-						" mode- errCode [%d]!\n",
-						__func__, status);
+				pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
+				       __func__, status);
 				return status;
 			}
 
@@ -826,9 +821,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			/* Reinitialize the DIF */
 			status = cx231xx_dif_set_standard(dev, dev->norm);
 			if (status < 0) {
-				pr_err("%s: cx231xx_dif set to By pass"
-						" mode- errCode [%d]!\n",
-						__func__, status);
+				pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
+					__func__, status);
 				return status;
 			}
 
@@ -970,14 +964,14 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 {
 	int status = 0;
 
-	pr_info("do_mode_ctrl_overrides : 0x%x\n",
-		     (unsigned int)dev->norm);
+	pr_debug("%s: 0x%x\n",
+		__func__, (unsigned int)dev->norm);
 
 	/* Change the DFE_CTRL3 bp_percent to fix flagging */
 	status = vid_blk_write_word(dev, DFE_CTRL3, 0xCD3F0280);
 
 	if (dev->norm & (V4L2_STD_NTSC | V4L2_STD_PAL_M)) {
-		pr_info("do_mode_ctrl_overrides NTSC\n");
+		pr_debug("%s: NTSC\n", __func__);
 
 		/* Move the close caption lines out of active video,
 		   adjust the active video start point */
@@ -1004,7 +998,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							(FLD_HBLANK_CNT, 0x79));
 
 	} else if (dev->norm & V4L2_STD_SECAM) {
-		pr_info("do_mode_ctrl_overrides SECAM\n");
+		pr_debug("%s: SECAM\n", __func__);
 		status =  cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1031,7 +1025,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							cx231xx_set_field
 							(FLD_HBLANK_CNT, 0x85));
 	} else {
-		pr_info("do_mode_ctrl_overrides PAL\n");
+		pr_debug("%s: PAL\n", __func__);
 		status = cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1331,113 +1325,113 @@ void cx231xx_dump_HH_reg(struct cx231xx *dev)
 
 	for (i = 0x100; i < 0x140; i++) {
 		vid_blk_read_word(dev, i, &value);
-		pr_info("reg0x%x=0x%x\n", i, value);
+		pr_debug("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x300; i < 0x400; i++) {
 		vid_blk_read_word(dev, i, &value);
-		pr_info("reg0x%x=0x%x\n", i, value);
+		pr_debug("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x400; i < 0x440; i++) {
 		vid_blk_read_word(dev, i,  &value);
-		pr_info("reg0x%x=0x%x\n", i, value);
+		pr_debug("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	pr_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	pr_debug("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 	vid_blk_write_word(dev, AFE_CTRL_C2HH_SRC_CTRL, 0x4485D390);
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	pr_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	pr_debug("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 }
 
-void cx231xx_dump_SC_reg(struct cx231xx *dev)
+#if 0
+static void cx231xx_dump_SC_reg(struct cx231xx *dev)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
-	pr_info("cx231xx_dump_SC_reg!\n");
+	pr_debug("%s!\n", __func__);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS_MODE_REG,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_CFG_REG,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_LENGTH_REG,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_CFG_REG,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_LENGTH_REG,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN1,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN2,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN3,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK0,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK1,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK2,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_GAIN,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_CAR_REG,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG1,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG2,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, PWR_CTL_EN,
 				 value, 4);
-	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
+	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
 				 value[1], value[2], value[3]);
-
-
 }
+#endif
 
 void cx231xx_Setup_AFE_for_LowIF(struct cx231xx *dev)
 
@@ -1503,7 +1497,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	u32 standard = 0;
 	u8 value[4] = { 0, 0, 0, 0 };
 
-	pr_info("Enter cx231xx_set_Colibri_For_LowIF()\n");
+	pr_debug("Enter cx231xx_set_Colibri_For_LowIF()\n");
 	value[0] = (u8) 0x6F;
 	value[1] = (u8) 0x6F;
 	value[2] = (u8) 0x6F;
@@ -1523,7 +1517,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	colibri_carrier_offset = cx231xx_Get_Colibri_CarrierOffset(mode,
 								   standard);
 
-	pr_info("colibri_carrier_offset=%d, standard=0x%x\n",
+	pr_debug("colibri_carrier_offset=%d, standard=0x%x\n",
 		     colibri_carrier_offset, standard);
 
 	/* Set the band Pass filter for DIF*/
@@ -1557,7 +1551,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 	u64 pll_freq_u64 = 0;
 	u32 i = 0;
 
-	pr_info("if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
+	pr_debug("if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
 			 if_freq, spectral_invert, mode);
 
 
@@ -1601,7 +1595,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		if_freq = 16000000;
 	}
 
-	pr_info("Enter IF=%zu\n",
+	pr_debug("Enter IF=%zu\n",
 			ARRAY_SIZE(Dif_set_array));
 	for (i = 0; i < ARRAY_SIZE(Dif_set_array); i++) {
 		if (Dif_set_array[i].if_freq == if_freq) {
@@ -1714,7 +1708,7 @@ int cx231xx_dif_set_standard(struct cx231xx *dev, u32 standard)
 	u32 dif_misc_ctrl_value = 0;
 	u32 func_mode = 0;
 
-	pr_info("%s: setStandard to %x\n", __func__, standard);
+	pr_debug("%s: setStandard to %x\n", __func__, standard);
 
 	status = vid_blk_read_word(dev, DIF_MISC_CTRL, &dif_misc_ctrl_value);
 	if (standard != DIF_USE_BASEBAND)
@@ -2117,8 +2111,8 @@ int cx231xx_tuner_post_channel_change(struct cx231xx *dev)
 {
 	int status = 0;
 	u32 dwval;
-	pr_info("cx231xx_tuner_post_channel_change  dev->tuner_type =0%d\n",
-		     dev->tuner_type);
+	pr_debug("%s: dev->tuner_type =0%d\n",
+		     __func__, dev->tuner_type);
 	/* Set the RF and IF k_agc values to 4 for PAL/NTSC and 8 for
 	 * SECAM L/B/D standards */
 	status = vid_blk_read_word(dev, DIF_AGC_IF_REF, &dwval);
@@ -2219,8 +2213,8 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 	if (dev->power_mode != mode)
 		dev->power_mode = mode;
 	else {
-		pr_info(" setPowerMode::mode = %d, No Change req.\n",
-			     mode);
+		pr_debug("%s: mode = %d, No Change req.\n",
+			 __func__, mode);
 		return 0;
 	}
 
@@ -2459,7 +2453,7 @@ int cx231xx_start_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	pr_info("cx231xx_start_stream():: ep_mask = %x\n", ep_mask);
+	pr_debug("%s: ep_mask = %x\n", __func__, ep_mask);
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				       value, 4);
 	if (status < 0)
@@ -2484,7 +2478,7 @@ int cx231xx_stop_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	pr_info("cx231xx_stop_stream():: ep_mask = %x\n", ep_mask);
+	pr_debug("%s: ep_mask = %x\n", __func__, ep_mask);
 	status =
 	    cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET, value, 4);
 	if (status < 0)
@@ -2512,24 +2506,24 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 	if (dev->udev->speed == USB_SPEED_HIGH) {
 		switch (media_type) {
 		case Audio:
-			pr_info("%s: Audio enter HANC\n", __func__);
+			pr_debug("%s: Audio enter HANC\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x9300);
 			break;
 
 		case Vbi:
-			pr_info("%s: set vanc registers\n", __func__);
+			pr_debug("%s: set vanc registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x300);
 			break;
 
 		case Sliced_cc:
-			pr_info("%s: set hanc registers\n", __func__);
+			pr_debug("%s: set hanc registers\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x1300);
 			break;
 
 		case Raw_Video:
-			pr_info("%s: set video registers\n", __func__);
+			pr_debug("%s: set video registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			break;
 
@@ -2564,7 +2558,7 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 			break;
 
 		case TS1_parallel_mode:
-			pr_info("%s: set ts1 parallel mode registers\n",
+			pr_debug("%s: set ts1 parallel mode registers\n",
 				     __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			status = cx231xx_mode_register(dev, TS1_CFG_REG, 0x400);
@@ -2918,7 +2912,7 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 			 (nCnt > 0));
 
 	if (nCnt == 0)
-		pr_info("No ACK after %d msec -GPIO I2C failed!",
+		pr_debug("No ACK after %d msec -GPIO I2C failed!",
 			     nInit * 10);
 
 	/*
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index e104a8d2e6e5..ae10c689678c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -856,8 +856,7 @@ int cx231xx_tuner_callback(void *ptr, int component, int command, int arg)
 
 	if (dev->tuner_type == TUNER_XC5000) {
 		if (command == XC5000_TUNER_RESET) {
-			pr_info
-				("Tuner CB: RESET: cmd %d : tuner type %d \n",
+			pr_debug("Tuner CB: RESET: cmd %d : tuner type %d \n",
 				 command, dev->tuner_type);
 			cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit,
 					       1);
@@ -917,7 +916,7 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
 	cx231xx_set_model(dev);
 
 	pr_info("Identified as %s (card=%d)\n",
-		     dev->board.name, dev->model);
+		dev->board.name, dev->model);
 
 	/* set the direction for GPIO pins */
 	if (dev->board.tuner_gpio) {
@@ -1008,7 +1007,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 	}
 
 	for (i = 0; i + 15 < len; i += 16)
-		pr_info("i2c eeprom %02x: %*ph\n", i, 16, &eedata[i]);
+		pr_debug("i2c eeprom %02x: %*ph\n", i, 16, &eedata[i]);
 
 	return 0;
 }
@@ -1028,7 +1027,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 					cx231xx_get_i2c_adap(dev, I2C_0),
 					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
-			pr_info("cx25840 subdev registration failure\n");
+			pr_err("cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, load_fw);
 
 	}
@@ -1042,7 +1041,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 						    "tuner",
 						    dev->tuner_addr, NULL);
 		if (dev->sd_tuner == NULL)
-			pr_info("tuner subdev registration failure\n");
+			pr_err("tuner subdev registration failure\n");
 		else
 			cx231xx_config_tuner(dev);
 	}
@@ -1290,21 +1289,19 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	dev->video_mode.end_point_addr = uif->altsetting[0].endpoint[isoc_pipe].desc.bEndpointAddress;
 	dev->video_mode.num_alt = uif->num_altsetting;
 
-	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+	pr_info("video EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->video_mode.end_point_addr,
 		     dev->video_mode.num_alt);
 
 	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
-	if (dev->video_mode.alt_max_pkt_size == NULL) {
-		pr_err("out of memory!\n");
+	if (dev->video_mode.alt_max_pkt_size == NULL)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < dev->video_mode.num_alt; i++) {
 		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
 		dev->video_mode.alt_max_pkt_size[i] = (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_info("Alternate setting %i, max size= %i\n", i,
-			     dev->video_mode.alt_max_pkt_size[i]);
+		pr_debug("Alternate setting %i, max size= %i\n", i,
+			 dev->video_mode.alt_max_pkt_size[i]);
 	}
 
 	/* VBI Init */
@@ -1321,16 +1318,14 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->vbi_mode.num_alt = uif->num_altsetting;
-	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+	pr_info("VBI EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->vbi_mode.end_point_addr,
 		     dev->vbi_mode.num_alt);
 
 	/* compute alternate max packet sizes for vbi */
 	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
-	if (dev->vbi_mode.alt_max_pkt_size == NULL) {
-		pr_err("out of memory!\n");
+	if (dev->vbi_mode.alt_max_pkt_size == NULL)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < dev->vbi_mode.num_alt; i++) {
 		u16 tmp =
@@ -1338,8 +1333,8 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 				desc.wMaxPacketSize);
 		dev->vbi_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_info("Alternate setting %i, max size= %i\n", i,
-			     dev->vbi_mode.alt_max_pkt_size[i]);
+		pr_debug("Alternate setting %i, max size= %i\n", i,
+			 dev->vbi_mode.alt_max_pkt_size[i]);
 	}
 
 	/* Sliced CC VBI init */
@@ -1357,23 +1352,20 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->sliced_cc_mode.num_alt = uif->num_altsetting;
-	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
-		     dev->sliced_cc_mode.end_point_addr,
-		     dev->sliced_cc_mode.num_alt);
+	pr_info("sliced CC EndPoint Addr 0x%x, Alternate settings: %i\n",
+		dev->sliced_cc_mode.end_point_addr,
+		dev->sliced_cc_mode.num_alt);
 	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
-
-	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL) {
-		pr_err("out of memory!\n");
+	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < dev->sliced_cc_mode.num_alt; i++) {
 		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
 				desc.wMaxPacketSize);
 		dev->sliced_cc_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_info("Alternate setting %i, max size= %i\n", i,
-			     dev->sliced_cc_mode.alt_max_pkt_size[i]);
+		pr_debug("Alternate setting %i, max size= %i\n", i,
+			 dev->sliced_cc_mode.alt_max_pkt_size[i]);
 	}
 
 	return 0;
@@ -1410,8 +1402,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
 		if (nr >= CX231XX_MAXBOARDS) {
 			/* No free device slots */
-			pr_err(DRIVER_NAME ": Supports only %i devices.\n",
-					CX231XX_MAXBOARDS);
+			pr_err("Supports only %i devices.\n", CX231XX_MAXBOARDS);
 			return -ENOMEM;
 		}
 	} while (test_and_set_bit(nr, &cx231xx_devused));
@@ -1421,7 +1412,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* allocate memory for our device state and initialize it */
 	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		pr_err(DRIVER_NAME ": out of memory!\n");
 		clear_bit(nr, &cx231xx_devused);
 		return -ENOMEM;
 	}
@@ -1468,14 +1458,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	pr_info("New device %s %s @ %s Mbps "
-	     "(%04x:%04x) with %d interfaces\n",
-	     udev->manufacturer ? udev->manufacturer : "",
-	     udev->product ? udev->product : "",
-	     speed,
-	     le16_to_cpu(udev->descriptor.idVendor),
-	     le16_to_cpu(udev->descriptor.idProduct),
-	     dev->max_iad_interface_count);
+	pr_info("New device %s %s @ %s Mbps (%04x:%04x) with %d interfaces\n",
+		udev->manufacturer ? udev->manufacturer : "",
+		udev->product ? udev->product : "",
+		speed,
+		le16_to_cpu(udev->descriptor.idVendor),
+		le16_to_cpu(udev->descriptor.idProduct),
+		dev->max_iad_interface_count);
 
 	/* increment interface count */
 	dev->interface_count++;
@@ -1485,13 +1474,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	assoc_desc = udev->actconfig->intf_assoc[0];
 	if (assoc_desc->bFirstInterface != ifnum) {
-		pr_err(DRIVER_NAME ": Not found "
-			    "matching IAD interface\n");
+		pr_err("Not found matching IAD interface\n");
 		retval = -ENODEV;
 		goto err_if;
 	}
 
-	pr_info("registering interface %d\n", ifnum);
+	pr_debug("registering interface %d\n", ifnum);
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
@@ -1527,13 +1515,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 				desc.bEndpointAddress;
 
 		dev->ts1_mode.num_alt = uif->num_altsetting;
-		pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+		pr_info("TS EndPoint Addr 0x%x, Alternate settings: %i\n",
 			     dev->ts1_mode.end_point_addr,
 			     dev->ts1_mode.num_alt);
 
 		dev->ts1_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->ts1_mode.num_alt, GFP_KERNEL);
 		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
-			pr_err("out of memory!\n");
 			retval = -ENOMEM;
 			goto err_video_alt;
 		}
@@ -1544,7 +1531,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 						wMaxPacketSize);
 			dev->ts1_mode.alt_max_pkt_size[i] =
 			    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-			pr_info("Alternate setting %i, max size= %i\n", i,
+			pr_debug("Alternate setting %i, max size= %i\n", i,
 				     dev->ts1_mode.alt_max_pkt_size[i]);
 		}
 	}
@@ -1609,10 +1596,8 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 	wake_up_interruptible_all(&dev->open);
 
 	if (dev->users) {
-		pr_warn
-		    ("device %s is open! Deregistration and memory "
-		     "deallocation are deferred on close.\n",
-		     video_device_node_name(dev->vdev));
+		pr_warn("device %s is open! Deregistration and memory deallocation are deferred on close.\n",
+			video_device_node_name(dev->vdev));
 
 		/* Even having users, it is safe to remove the RC i2c driver */
 		cx231xx_ir_exit(dev);
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 229e855fc7f2..c5842a1ea104 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -228,9 +228,8 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0) {
-		pr_info
-		    ("UsbInterface::sendCommand, failed with status -%d\n",
-		     status);
+		pr_err("%s: failed with status -%d\n",
+			__func__, status);
 	}
 
 	return status;
@@ -524,9 +523,8 @@ int cx231xx_set_video_alternate(struct cx231xx *dev)
 		    usb_set_interface(dev->udev, usb_interface_index,
 				      dev->video_mode.alt);
 		if (errCode < 0) {
-			pr_err
-			    ("cannot change alt number to %d (error=%i)\n",
-			     dev->video_mode.alt, errCode);
+			pr_err("cannot change alt number to %d (error=%i)\n",
+				dev->video_mode.alt, errCode);
 			return errCode;
 		}
 	}
@@ -600,9 +598,8 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	}
 
 	if (alt > 0 && max_pkt_size == 0) {
-		pr_err
-		("can't change interface %d alt no. to %d: Max. Pkt size = 0\n",
-		usb_interface_index, alt);
+		pr_err("can't change interface %d alt no. to %d: Max. Pkt size = 0\n",
+			usb_interface_index, alt);
 		/*To workaround error number=-71 on EP0 for videograbber,
 		 need add following codes.*/
 		if (dev->board.no_alt_vanc)
@@ -616,9 +613,8 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	if (usb_interface_index > 0) {
 		status = usb_set_interface(dev->udev, usb_interface_index, alt);
 		if (status < 0) {
-			pr_err
-			("can't change interface %d alt no. to %d (err=%i)\n",
-			usb_interface_index, alt, status);
+			pr_err("can't change interface %d alt no. to %d (err=%i)\n",
+				usb_interface_index, alt, status);
 			return status;
 		}
 	}
@@ -767,17 +763,15 @@ int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 	u32 *buffer;
 
 	buffer = kzalloc(4096, GFP_KERNEL);
-	if (buffer == NULL) {
-		pr_info("out of mem\n");
+	if (buffer == NULL)
 		return -ENOMEM;
-	}
 	memcpy(&buffer[0], firmware, 4096);
 
 	ret = usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 5),
 			buffer, 4096, &actlen, 2000);
 
 	if (ret)
-		pr_info("bulk message failed: %d (%d/%d)", ret,
+		pr_err("bulk message failed: %d (%d/%d)", ret,
 				size, actlen);
 	else {
 		errCode = actlen != size ? -1 : 0;
@@ -987,12 +981,8 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	cx231xx_uninit_isoc(dev);
 
 	dma_q->p_left_data = kzalloc(4096, GFP_KERNEL);
-	if (dma_q->p_left_data == NULL) {
-		pr_info("out of mem\n");
+	if (dma_q->p_left_data == NULL)
 		return -ENOMEM;
-	}
-
-
 
 	dev->video_mode.isoc_ctl.isoc_copy = isoc_copy;
 	dev->video_mode.isoc_ctl.num_bufs = num_bufs;
@@ -1055,10 +1045,9 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				       &urb->transfer_dma);
 		if (!dev->video_mode.isoc_ctl.transfer_buffer[i]) {
-			pr_err("unable to allocate %i bytes for transfer"
-				    " buffer %i%s\n",
-				    sb_size, i,
-				    in_interrupt() ? " while in int" : "");
+			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+				sb_size, i,
+				in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_isoc(dev);
 			return -ENOMEM;
 		}
@@ -1091,7 +1080,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 				    GFP_ATOMIC);
 		if (rc) {
 			pr_err("submit of urb %i failed (error=%i)\n", i,
-				    rc);
+				rc);
 			cx231xx_uninit_isoc(dev);
 			return rc;
 		}
@@ -1189,10 +1178,9 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				     &urb->transfer_dma);
 		if (!dev->video_mode.bulk_ctl.transfer_buffer[i]) {
-			pr_err("unable to allocate %i bytes for transfer"
-				    " buffer %i%s\n",
-				    sb_size, i,
-				    in_interrupt() ? " while in int" : "");
+			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+				sb_size, i,
+				in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_bulk(dev);
 			return -ENOMEM;
 		}
@@ -1212,8 +1200,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		rc = usb_submit_urb(dev->video_mode.bulk_ctl.urb[i],
 				    GFP_ATOMIC);
 		if (rc) {
-			pr_err("submit of urb %i failed (error=%i)\n", i,
-				    rc);
+			pr_err("submit of urb %i failed (error=%i)\n", i,rc);
 			cx231xx_uninit_bulk(dev);
 			return rc;
 		}
@@ -1316,18 +1303,16 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ENXTERNAL_AV);
 		if (errCode < 0) {
-			pr_err
-			("%s: Failed to set Power - errCode [%d]!\n",
-			__func__, errCode);
+			pr_err("%s: Failed to set Power - errCode [%d]!\n",
+				__func__, errCode);
 			return errCode;
 		}
 	} else {
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ANALOGT_TV);
 		if (errCode < 0) {
-			pr_err
-			("%s: Failed to set Power - errCode [%d]!\n",
-			__func__, errCode);
+			pr_err("%s: Failed to set Power - errCode [%d]!\n",
+				__func__, errCode);
 			return errCode;
 		}
 	}
@@ -1340,34 +1325,30 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* initialize Colibri block */
 	errCode = cx231xx_afe_init_super_block(dev, 0x23c);
 	if (errCode < 0) {
-		pr_err
-		    ("%s: cx231xx_afe init super block - errCode [%d]!\n",
-		     __func__, errCode);
+		pr_err("%s: cx231xx_afe init super block - errCode [%d]!\n",
+			__func__, errCode);
 		return errCode;
 	}
 	errCode = cx231xx_afe_init_channels(dev);
 	if (errCode < 0) {
-		pr_err
-		    ("%s: cx231xx_afe init channels - errCode [%d]!\n",
-		     __func__, errCode);
+		pr_err("%s: cx231xx_afe init channels - errCode [%d]!\n",
+			__func__, errCode);
 		return errCode;
 	}
 
 	/* Set DIF in By pass mode */
 	errCode = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 	if (errCode < 0) {
-		pr_err
-		    ("%s: cx231xx_dif set to By pass mode - errCode [%d]!\n",
-		     __func__, errCode);
+		pr_err("%s: cx231xx_dif set to By pass mode - errCode [%d]!\n",
+			__func__, errCode);
 		return errCode;
 	}
 
 	/* I2S block related functions */
 	errCode = cx231xx_i2s_blk_initialize(dev);
 	if (errCode < 0) {
-		pr_err
-		    ("%s: cx231xx_i2s block initialize - errCode [%d]!\n",
-		     __func__, errCode);
+		pr_err("%s: cx231xx_i2s block initialize - errCode [%d]!\n",
+			__func__, errCode);
 		return errCode;
 	}
 
@@ -1375,7 +1356,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	errCode = cx231xx_init_ctrl_pin_status(dev);
 	if (errCode < 0) {
 		pr_err("%s: cx231xx_init ctrl pins - errCode [%d]!\n",
-			       __func__, errCode);
+			__func__, errCode);
 		return errCode;
 	}
 
@@ -1400,9 +1381,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		break;
 	}
 	if (errCode < 0) {
-		pr_err
-		    ("%s: cx231xx_AGC mode to Analog - errCode [%d]!\n",
-		     __func__, errCode);
+		pr_err("%s: cx231xx_AGC mode to Analog - errCode [%d]!\n",
+			__func__, errCode);
 		return errCode;
 	}
 
@@ -1477,9 +1457,8 @@ int cx231xx_send_gpio_cmd(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0) {
-		pr_info
-		    ("UsbInterface::sendCommand, failed with status -%d\n",
-		     status);
+		pr_err("%s: failed with status -%d\n",
+			__func__, status);
 	}
 
 	return status;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index a743865b40c0..b6af923eb5a3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -265,7 +265,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 	struct cx231xx *dev = dvb->adapter.priv;
 
 	if (dev->USE_ISO) {
-		pr_info("DVB transfer mode is ISO.\n");
+		pr_debug("DVB transfer mode is ISO.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -276,7 +276,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 					dev->ts1_mode.max_pkt_size,
 					dvb_isoc_copy);
 	} else {
-		pr_info("DVB transfer mode is BULK.\n");
+		pr_debug("DVB transfer mode is BULK.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -430,16 +430,14 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev)
 
 		if (dops->init != NULL && !dev->xc_fw_load_done) {
 
-			pr_info("Reloading firmware for XC5000\n");
+			pr_debug("Reloading firmware for XC5000\n");
 			status = dops->init(dev->dvb->frontend);
 			if (status == 0) {
 				dev->xc_fw_load_done = 1;
-				pr_info
-				    ("XC5000 firmware download completed\n");
+				pr_debug("XC5000 firmware download completed\n");
 			} else {
 				dev->xc_fw_load_done = 0;
-				pr_info
-				    ("XC5000 firmware download failed !!!\n");
+				pr_debug("XC5000 firmware download failed !!!\n");
 			}
 		}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index d4a468a60bd0..1a0d9efeb209 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -498,17 +498,18 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	memset(&client, 0, sizeof(client));
 	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
 
-	pr_info(": Checking for I2C devices on port=%d ..\n", i2c_port);
+	pr_info("i2c_scan: checking for I2C devices on port=%d ..\n",
+		i2c_port);
 	for (i = 0; i < 128; i++) {
 		client.addr = i;
 		rc = i2c_master_recv(&client, &buf, 0);
 		if (rc < 0)
 			continue;
-		pr_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
-			     dev->name, i << 1,
-			     i2c_devs[i] ? i2c_devs[i] : "???");
+		pr_info("i2c scan: found device @ 0x%x  [%s]\n",
+			i << 1,
+			i2c_devs[i] ? i2c_devs[i] : "???");
 	}
-	pr_info(": Completed Checking for I2C devices on port=%d.\n",
+	pr_info("i2c scan: Completed Checking for I2C devices on port=%d.\n",
 		i2c_port);
 }
 
@@ -532,8 +533,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	i2c_add_adapter(&bus->i2c_adap);
 
 	if (0 != bus->i2c_rc)
-		pr_warn("%s: i2c bus %d register FAILED\n",
-			     dev->name, bus->nr);
+		pr_warn("i2c bus %d register FAILED\n", bus->nr);
 
 	return bus->i2c_rc;
 }
@@ -576,8 +576,7 @@ int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 				NULL);
 
 	if (!dev->i2c_mux_adap[mux_no])
-		pr_warn("%s: i2c mux %d register FAILED\n",
-			     dev->name, mux_no);
+		pr_warn("i2c mux %d register FAILED\n", mux_no);
 
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index 4666e533fe0a..2f8dc6afac54 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -703,9 +703,9 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_BUSPOWER_DIF_ONLY;
 			break;
 		default:
-			pr_info("bad config in buspower!!!!\n");
-			pr_info("config_info=%x\n",
-				     (config_info & BUSPOWER_MASK));
+			pr_err("bad config in buspower!!!!\n");
+			pr_err("config_info=%x\n",
+				config_info & BUSPOWER_MASK);
 			return 1;
 		}
 	} else {		/* self-power */
@@ -768,9 +768,9 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_SELFPOWER_COMPRESSOR;
 			break;
 		default:
-			pr_info("bad senario!!!!!\n");
-			pr_info("config_info=%x\n",
-				     (config_info & SELFPOWER_MASK));
+			pr_err("bad senario!!!!!\n");
+			pr_err("config_info=%x\n",
+				config_info & SELFPOWER_MASK);
 			return -ENODEV;
 		}
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index f80126d3525a..14e1eb7f2128 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -69,11 +69,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 		break;
 	}
 	if (packet < 0) {
-		pr_err("URB status %d [%s].\n", status,
-			    errmsg);
+		pr_err("URB status %d [%s].\n", status, errmsg);
 	} else {
 		pr_err("URB packet %d, status %d [%s].\n",
-			    packet, status, errmsg);
+			packet, status, errmsg);
 	}
 }
 
@@ -317,7 +316,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 		return;
 	default:		/* error */
 		pr_err("urb completition error %d.\n",
-			    urb->status);
+			urb->status);
 		break;
 	}
 
@@ -332,7 +331,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (urb->status) {
 		pr_err("urb resubmit failed (error=%i)\n",
-			    urb->status);
+			urb->status);
 	}
 }
 
@@ -344,7 +343,7 @@ void cx231xx_uninit_vbi_isoc(struct cx231xx *dev)
 	struct urb *urb;
 	int i;
 
-	pr_info("called cx231xx_uninit_vbi_isoc\n");
+	pr_debug("called cx231xx_uninit_vbi_isoc\n");
 
 	dev->vbi_mode.bulk_ctl.nfields = -1;
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
@@ -393,7 +392,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	struct urb *urb;
 	int rc;
 
-	pr_info("called cx231xx_vbi_isoc\n");
+	pr_debug("called cx231xx_vbi_isoc\n");
 
 	/* De-allocates all pending stuff */
 	cx231xx_uninit_vbi_isoc(dev);
@@ -451,9 +450,9 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);
 		if (!dev->vbi_mode.bulk_ctl.transfer_buffer[i]) {
-			pr_err("unable to allocate %i bytes for transfer"
-				    " buffer %i%s\n", sb_size, i,
-				    in_interrupt() ? " while in int" : "");
+			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+				sb_size, i,
+				in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_vbi_isoc(dev);
 			return -ENOMEM;
 		}
@@ -470,8 +469,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
 		rc = usb_submit_urb(dev->vbi_mode.bulk_ctl.urb[i], GFP_ATOMIC);
 		if (rc) {
-			pr_err("submit of urb %i failed (error=%i)\n", i,
-				    rc);
+			pr_err("submit of urb %i failed (error=%i)\n", i, rc);
 			cx231xx_uninit_vbi_isoc(dev);
 			return rc;
 		}
@@ -522,7 +520,7 @@ static inline void vbi_buffer_filled(struct cx231xx *dev,
 				     struct cx231xx_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	/* pr_info("[%p/%d] wakeup\n", buf, buf->vb.i); */
+	/* pr_debug("[%p/%d] wakeup\n", buf, buf->vb.i); */
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index bda5597b5eff..4d1d750ab38d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -737,7 +737,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
-	/*pr_info("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
+	/*pr_debug("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
 		urb_init, dev->video_mode.max_pkt_size);*/
 	if (urb_init) {
 		dev->mode_tv = 0;
@@ -809,7 +809,7 @@ void video_mux(struct cx231xx *dev, int index)
 
 	cx231xx_set_audio_input(dev, dev->ctl_ainput);
 
-	pr_info("video_mux : %d\n", index);
+	pr_debug("video_mux : %d\n", index);
 
 	/* do mode control overrides if required */
 	cx231xx_do_mode_ctrl_overrides(dev);
@@ -953,12 +953,12 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		pr_err("%s queue busy\n", __func__);
+		pr_err("%s: queue busy\n", __func__);
 		return -EBUSY;
 	}
 
 	if (dev->stream_on && !fh->stream_on) {
-		pr_err("%s device in use by another fh\n", __func__);
+		pr_err("%s: device in use by another fh\n", __func__);
 		return -EBUSY;
 	}
 
@@ -1176,9 +1176,8 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	int rc;
 	u32 if_frequency = 5400000;
 
-	pr_info("Enter vidioc_s_frequency()f->frequency=%d;f->type=%d\n",
+	pr_debug("Enter vidioc_s_frequency()f->frequency=%d;f->type=%d\n",
 		 f->frequency, f->type);
-	/*pr_info("f->type:  1-radio 2-analogTV 3-digitalTV\n");*/
 
 	rc = check_dev(dev);
 	if (rc < 0)
@@ -1213,13 +1212,13 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 		else if (dev->norm & V4L2_STD_SECAM_LC)
 			if_frequency = 1250000;  /*1.25MHz	*/
 
-		pr_info("if_frequency is set to %d\n", if_frequency);
+		pr_debug("if_frequency is set to %d\n", if_frequency);
 		cx231xx_set_Colibri_For_LowIF(dev, if_frequency, 1, 1);
 
 		update_HH_register_after_set_DIF(dev);
 	}
 
-	pr_info("Set New FREQUENCY to %d\n", f->frequency);
+	pr_debug("Set New FREQUENCY to %d\n", f->frequency);
 
 	return rc;
 }
@@ -1642,8 +1641,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 #if 0
 	errCode = cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);
 	if (errCode < 0) {
-		pr_err
-		    ("Device locked on digital mode. Can't open analog\n");
+		pr_err("Device locked on digital mode. Can't open analog\n");
 		return -EBUSY;
 	}
 #endif
@@ -1737,7 +1735,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 	}
 	if (dev->vbi_dev) {
 		pr_info("V4L2 device %s deregistered\n",
-			     video_device_node_name(dev->vbi_dev));
+			video_device_node_name(dev->vbi_dev));
 		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
 		else
@@ -1746,7 +1744,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 	}
 	if (dev->vdev) {
 		pr_info("V4L2 device %s deregistered\n",
-			     video_device_node_name(dev->vdev));
+			video_device_node_name(dev->vdev));
 
 		if (dev->board.has_417)
 			cx231xx_417_unregister(dev);
@@ -2080,8 +2078,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 {
 	int ret;
 
-	pr_info("%s: v4l2 driver version %s\n",
-		     dev->name, CX231XX_VERSION);
+	pr_info("v4l2 driver version %s\n", CX231XX_VERSION);
 
 	/* set default norm */
 	dev->norm = V4L2_STD_PAL;
@@ -2129,12 +2126,12 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 				    video_nr[dev->devno]);
 	if (ret) {
 		pr_err("unable to register video device (error=%i).\n",
-			       ret);
+			ret);
 		return ret;
 	}
 
-	pr_info("%s/0: registered device %s [v4l2]\n",
-		     dev->name, video_device_node_name(dev->vdev));
+	pr_info("Registered video device %s [v4l2]\n",
+		video_device_node_name(dev->vdev));
 
 	/* Initialize VBI template */
 	cx231xx_vbi_template = cx231xx_video_template;
@@ -2156,8 +2153,8 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 		return ret;
 	}
 
-	pr_info("%s/0: registered device %s\n",
-		     dev->name, video_device_node_name(dev->vbi_dev));
+	pr_info("Registered VBI device %s\n",
+		video_device_node_name(dev->vbi_dev));
 
 	if (cx231xx_boards[dev->model].radio.type == CX231XX_RADIO) {
 		dev->radio_dev = cx231xx_vdev_init(dev, &cx231xx_radio_template,
@@ -2174,12 +2171,8 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 			return ret;
 		}
 		pr_info("Registered radio device as %s\n",
-			     video_device_node_name(dev->radio_dev));
+			video_device_node_name(dev->radio_dev));
 	}
 
-	pr_info("V4L2 device registered as %s and %s\n",
-		     video_device_node_name(dev->vdev),
-		     video_device_node_name(dev->vbi_dev));
-
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index fa27e0c2accb..aeee721a8eef 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -809,7 +809,6 @@ void cx231xx_Setup_AFE_for_LowIF(struct cx231xx *dev);
 void reset_s5h1432_demod(struct cx231xx *dev);
 void cx231xx_dump_HH_reg(struct cx231xx *dev);
 void update_HH_register_after_set_DIF(struct cx231xx *dev);
-void cx231xx_dump_SC_reg(struct cx231xx *dev);
 
 
 
-- 
1.9.3

