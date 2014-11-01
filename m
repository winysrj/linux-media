Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbaKANjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 09:39:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/7] [media] cx231xx: get rid of driver-defined printk macros
Date: Sat,  1 Nov 2014 11:38:53 -0200
Message-Id: <ca7e852b01ef3ea425d242ab98ea0b94289bb877.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <cover.1414849031.git.mchehab@osg.samsung.com>
References: <cover.1414849031.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It currently does just like what pr_foo() macros do. So,
replace them.

A deeper cleanup is needed, as there are lots of debug macros
printed with pr_info.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 459bb0e98971..d678f4587ab4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -24,6 +24,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -39,8 +41,6 @@
 #include <media/tuner.h>
 #include <linux/usb.h>
 
-#include "cx231xx.h"
-
 #define CX231xx_FIRM_IMAGE_SIZE 376836
 #define CX231xx_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
 
@@ -1416,7 +1416,7 @@ static int bb_buf_prepare(struct videobuf_queue *q,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
-	/*cx231xx_info("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
+	/*pr_info("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
 		urb_init, dev->video_mode.max_pkt_size);*/
 	dev->mode_tv = 1;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 9b925874d392..8312388edabb 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -20,6 +20,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <linux/init.h>
@@ -37,7 +38,6 @@
 #include <sound/initval.h>
 #include <sound/control.h>
 #include <media/v4l2-common.h>
-#include "cx231xx.h"
 
 static int debug;
 module_param(debug, int, 0644);
@@ -182,7 +182,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0) {
-		cx231xx_errdev("resubmit of audio urb failed (error=%i)\n",
+		pr_err("resubmit of audio urb failed (error=%i)\n",
 			       status);
 	}
 	return;
@@ -266,7 +266,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0) {
-		cx231xx_errdev("resubmit of audio urb failed (error=%i)\n",
+		pr_err("resubmit of audio urb failed (error=%i)\n",
 			       status);
 	}
 	return;
@@ -277,7 +277,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	cx231xx_info("%s: Starting ISO AUDIO transfers\n", __func__);
+	pr_info("%s: Starting ISO AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
 		return -ENODEV;
@@ -295,7 +295,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_ISO_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			cx231xx_errdev("usb_alloc_urb failed!\n");
+			pr_err("usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
@@ -338,7 +338,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	cx231xx_info("%s: Starting BULK AUDIO transfers\n", __func__);
+	pr_info("%s: Starting BULK AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
 		return -ENODEV;
@@ -356,7 +356,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			cx231xx_errdev("usb_alloc_urb failed!\n");
+			pr_err("usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
@@ -439,13 +439,13 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
 	if (!dev) {
-		cx231xx_errdev("BUG: cx231xx can't find device struct."
+		pr_err("BUG: cx231xx can't find device struct."
 			       " Can't proceed with open\n");
 		return -ENODEV;
 	}
 
 	if (dev->state & DEV_DISCONNECTED) {
-		cx231xx_errdev("Can't open. the device was removed.\n");
+		pr_err("Can't open. the device was removed.\n");
 		return -ENODEV;
 	}
 
@@ -458,7 +458,7 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 		ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 0);
 	mutex_unlock(&dev->lock);
 	if (ret < 0) {
-		cx231xx_errdev("failed to set alternate setting !\n");
+		pr_err("failed to set alternate setting !\n");
 
 		return ret;
 	}
@@ -494,7 +494,7 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	/* 1 - 48000 samples per sec */
 	ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 0);
 	if (ret < 0) {
-		cx231xx_errdev("failed to set alternate setting !\n");
+		pr_err("failed to set alternate setting !\n");
 
 		mutex_unlock(&dev->lock);
 		return ret;
@@ -662,7 +662,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 		return 0;
 	}
 
-	cx231xx_info("cx231xx-audio.c: probing for cx231xx "
+	pr_info("cx231xx-audio.c: probing for cx231xx "
 		     "non standard usbaudio\n");
 
 	err = snd_card_new(&dev->udev->dev, index[devnr], "Cx231xx Audio",
@@ -707,12 +707,12 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 			bEndpointAddress;
 
 	adev->num_alt = uif->num_altsetting;
-	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     adev->end_point_addr, adev->num_alt);
 	adev->alt_max_pkt_size = kmalloc(32 * adev->num_alt, GFP_KERNEL);
 
 	if (adev->alt_max_pkt_size == NULL) {
-		cx231xx_errdev("out of memory!\n");
+		pr_err("out of memory!\n");
 		return -ENOMEM;
 	}
 
@@ -722,7 +722,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 				wMaxPacketSize);
 		adev->alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		cx231xx_info("Alternate setting %i, max size= %i\n", i,
+		pr_info("Alternate setting %i, max size= %i\n", i,
 			     adev->alt_max_pkt_size[i]);
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 781908b5a1a3..9185b05b4fbe 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -22,6 +22,7 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -36,7 +37,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 
-#include "cx231xx.h"
 #include "cx231xx-dif.h"
 
 #define TUNER_MODE_FM_RADIO 0
@@ -83,10 +83,10 @@ void initGPIO(struct cx231xx *dev)
 	cx231xx_send_gpio_cmd(dev, _gpio_direction, (u8 *)&value, 4, 0, 0);
 
 	verve_read_byte(dev, 0x07, &val);
-	cx231xx_info(" verve_read_byte address0x07=0x%x\n", val);
+	pr_info(" verve_read_byte address0x07=0x%x\n", val);
 	verve_write_byte(dev, 0x07, 0xF4);
 	verve_read_byte(dev, 0x07, &val);
-	cx231xx_info(" verve_read_byte address0x07=0x%x\n", val);
+	pr_info(" verve_read_byte address0x07=0x%x\n", val);
 
 	cx231xx_capture_start(dev, 1, Vbi);
 
@@ -156,7 +156,7 @@ int cx231xx_afe_init_super_block(struct cx231xx *dev, u32 ref_count)
 	while (afe_power_status != 0x18) {
 		status = afe_write_byte(dev, SUP_BLK_PWRDN, 0x18);
 		if (status < 0) {
-			cx231xx_info(
+			pr_info(
 			": Init Super Block failed in send cmd\n");
 			break;
 		}
@@ -164,13 +164,13 @@ int cx231xx_afe_init_super_block(struct cx231xx *dev, u32 ref_count)
 		status = afe_read_byte(dev, SUP_BLK_PWRDN, &afe_power_status);
 		afe_power_status &= 0xff;
 		if (status < 0) {
-			cx231xx_info(
+			pr_info(
 			": Init Super Block failed in receive cmd\n");
 			break;
 		}
 		i++;
 		if (i == 10) {
-			cx231xx_info(
+			pr_info(
 			": Init Super Block force break in loop !!!!\n");
 			status = -1;
 			break;
@@ -410,7 +410,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 						0x00);
 		} else {
-			cx231xx_info("Invalid AV mode input\n");
+			pr_info("Invalid AV mode input\n");
 			status = -1;
 		}
 		break;
@@ -467,7 +467,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 							0x40);
 		} else {
-			cx231xx_info("Invalid AV mode input\n");
+			pr_info("Invalid AV mode input\n");
 			status = -1;
 		}
 	}			/* switch  */
@@ -573,7 +573,7 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 			status = cx231xx_set_power_mode(dev,
 					POLARIS_AVMODE_ENXTERNAL_AV);
 			if (status < 0) {
-				cx231xx_errdev("%s: set_power_mode : Failed to"
+				pr_err("%s: set_power_mode : Failed to"
 						" set Power - errCode [%d]!\n",
 						__func__, status);
 				return status;
@@ -591,7 +591,7 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 			status = cx231xx_set_power_mode(dev,
 						POLARIS_AVMODE_ANALOGT_TV);
 			if (status < 0) {
-				cx231xx_errdev("%s: set_power_mode:Failed"
+				pr_err("%s: set_power_mode:Failed"
 					" to set Power - errCode [%d]!\n",
 					__func__, status);
 				return status;
@@ -608,7 +608,7 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 
 		break;
 	default:
-		cx231xx_errdev("%s: set_power_mode : Unknown Input %d !\n",
+		pr_err("%s: set_power_mode : Unknown Input %d !\n",
 		     __func__, INPUT(input)->type);
 		break;
 	}
@@ -628,7 +628,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	if (pin_type != dev->video_input) {
 		status = cx231xx_afe_adjust_ref_count(dev, pin_type);
 		if (status < 0) {
-			cx231xx_errdev("%s: adjust_ref_count :Failed to set"
+			pr_err("%s: adjust_ref_count :Failed to set"
 				"AFE input mux - errCode [%d]!\n",
 				__func__, status);
 			return status;
@@ -638,7 +638,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	/* call afe block to set video inputs */
 	status = cx231xx_afe_set_input_mux(dev, input);
 	if (status < 0) {
-		cx231xx_errdev("%s: set_input_mux :Failed to set"
+		pr_err("%s: set_input_mux :Failed to set"
 				" AFE input mux - errCode [%d]!\n",
 				__func__, status);
 		return status;
@@ -670,7 +670,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode  */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			cx231xx_errdev("%s: cx231xx_dif set to By pass"
+			pr_err("%s: cx231xx_dif set to By pass"
 						   " mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
@@ -715,7 +715,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			cx231xx_errdev("%s: cx231xx_dif set to By pass"
+			pr_err("%s: cx231xx_dif set to By pass"
 						   " mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
@@ -790,7 +790,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			status = cx231xx_dif_set_standard(dev,
 							  DIF_USE_BASEBAND);
 			if (status < 0) {
-				cx231xx_errdev("%s: cx231xx_dif set to By pass"
+				pr_err("%s: cx231xx_dif set to By pass"
 						" mode- errCode [%d]!\n",
 						__func__, status);
 				return status;
@@ -826,7 +826,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			/* Reinitialize the DIF */
 			status = cx231xx_dif_set_standard(dev, dev->norm);
 			if (status < 0) {
-				cx231xx_errdev("%s: cx231xx_dif set to By pass"
+				pr_err("%s: cx231xx_dif set to By pass"
 						" mode- errCode [%d]!\n",
 						__func__, status);
 				return status;
@@ -970,14 +970,14 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 {
 	int status = 0;
 
-	cx231xx_info("do_mode_ctrl_overrides : 0x%x\n",
+	pr_info("do_mode_ctrl_overrides : 0x%x\n",
 		     (unsigned int)dev->norm);
 
 	/* Change the DFE_CTRL3 bp_percent to fix flagging */
 	status = vid_blk_write_word(dev, DFE_CTRL3, 0xCD3F0280);
 
 	if (dev->norm & (V4L2_STD_NTSC | V4L2_STD_PAL_M)) {
-		cx231xx_info("do_mode_ctrl_overrides NTSC\n");
+		pr_info("do_mode_ctrl_overrides NTSC\n");
 
 		/* Move the close caption lines out of active video,
 		   adjust the active video start point */
@@ -1004,7 +1004,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							(FLD_HBLANK_CNT, 0x79));
 
 	} else if (dev->norm & V4L2_STD_SECAM) {
-		cx231xx_info("do_mode_ctrl_overrides SECAM\n");
+		pr_info("do_mode_ctrl_overrides SECAM\n");
 		status =  cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1031,7 +1031,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							cx231xx_set_field
 							(FLD_HBLANK_CNT, 0x85));
 	} else {
-		cx231xx_info("do_mode_ctrl_overrides PAL\n");
+		pr_info("do_mode_ctrl_overrides PAL\n");
 		status = cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1331,109 +1331,109 @@ void cx231xx_dump_HH_reg(struct cx231xx *dev)
 
 	for (i = 0x100; i < 0x140; i++) {
 		vid_blk_read_word(dev, i, &value);
-		cx231xx_info("reg0x%x=0x%x\n", i, value);
+		pr_info("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x300; i < 0x400; i++) {
 		vid_blk_read_word(dev, i, &value);
-		cx231xx_info("reg0x%x=0x%x\n", i, value);
+		pr_info("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x400; i < 0x440; i++) {
 		vid_blk_read_word(dev, i,  &value);
-		cx231xx_info("reg0x%x=0x%x\n", i, value);
+		pr_info("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	cx231xx_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	pr_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 	vid_blk_write_word(dev, AFE_CTRL_C2HH_SRC_CTRL, 0x4485D390);
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	cx231xx_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	pr_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 }
 
 void cx231xx_dump_SC_reg(struct cx231xx *dev)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
-	cx231xx_info("cx231xx_dump_SC_reg!\n");
+	pr_info("cx231xx_dump_SC_reg!\n");
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS_MODE_REG,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_CFG_REG,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_LENGTH_REG,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_CFG_REG,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_LENGTH_REG,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN1,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN2,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN3,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK0,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK1,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK2,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_GAIN,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_CAR_REG,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG1,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
 				 value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG2,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
 				 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, PWR_CTL_EN,
 				 value, 4);
-	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
+	pr_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
 				 value[1], value[2], value[3]);
 
 
@@ -1503,7 +1503,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	u32 standard = 0;
 	u8 value[4] = { 0, 0, 0, 0 };
 
-	cx231xx_info("Enter cx231xx_set_Colibri_For_LowIF()\n");
+	pr_info("Enter cx231xx_set_Colibri_For_LowIF()\n");
 	value[0] = (u8) 0x6F;
 	value[1] = (u8) 0x6F;
 	value[2] = (u8) 0x6F;
@@ -1523,7 +1523,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	colibri_carrier_offset = cx231xx_Get_Colibri_CarrierOffset(mode,
 								   standard);
 
-	cx231xx_info("colibri_carrier_offset=%d, standard=0x%x\n",
+	pr_info("colibri_carrier_offset=%d, standard=0x%x\n",
 		     colibri_carrier_offset, standard);
 
 	/* Set the band Pass filter for DIF*/
@@ -1557,7 +1557,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 	u64 pll_freq_u64 = 0;
 	u32 i = 0;
 
-	cx231xx_info("if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
+	pr_info("if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
 			 if_freq, spectral_invert, mode);
 
 
@@ -1601,7 +1601,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		if_freq = 16000000;
 	}
 
-	cx231xx_info("Enter IF=%zu\n",
+	pr_info("Enter IF=%zu\n",
 			ARRAY_SIZE(Dif_set_array));
 	for (i = 0; i < ARRAY_SIZE(Dif_set_array); i++) {
 		if (Dif_set_array[i].if_freq == if_freq) {
@@ -1714,7 +1714,7 @@ int cx231xx_dif_set_standard(struct cx231xx *dev, u32 standard)
 	u32 dif_misc_ctrl_value = 0;
 	u32 func_mode = 0;
 
-	cx231xx_info("%s: setStandard to %x\n", __func__, standard);
+	pr_info("%s: setStandard to %x\n", __func__, standard);
 
 	status = vid_blk_read_word(dev, DIF_MISC_CTRL, &dif_misc_ctrl_value);
 	if (standard != DIF_USE_BASEBAND)
@@ -2117,7 +2117,7 @@ int cx231xx_tuner_post_channel_change(struct cx231xx *dev)
 {
 	int status = 0;
 	u32 dwval;
-	cx231xx_info("cx231xx_tuner_post_channel_change  dev->tuner_type =0%d\n",
+	pr_info("cx231xx_tuner_post_channel_change  dev->tuner_type =0%d\n",
 		     dev->tuner_type);
 	/* Set the RF and IF k_agc values to 4 for PAL/NTSC and 8 for
 	 * SECAM L/B/D standards */
@@ -2219,7 +2219,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 	if (dev->power_mode != mode)
 		dev->power_mode = mode;
 	else {
-		cx231xx_info(" setPowerMode::mode = %d, No Change req.\n",
+		pr_info(" setPowerMode::mode = %d, No Change req.\n",
 			     mode);
 		return 0;
 	}
@@ -2459,7 +2459,7 @@ int cx231xx_start_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	cx231xx_info("cx231xx_start_stream():: ep_mask = %x\n", ep_mask);
+	pr_info("cx231xx_start_stream():: ep_mask = %x\n", ep_mask);
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				       value, 4);
 	if (status < 0)
@@ -2484,7 +2484,7 @@ int cx231xx_stop_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	cx231xx_info("cx231xx_stop_stream():: ep_mask = %x\n", ep_mask);
+	pr_info("cx231xx_stop_stream():: ep_mask = %x\n", ep_mask);
 	status =
 	    cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET, value, 4);
 	if (status < 0)
@@ -2512,32 +2512,32 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 	if (dev->udev->speed == USB_SPEED_HIGH) {
 		switch (media_type) {
 		case Audio:
-			cx231xx_info("%s: Audio enter HANC\n", __func__);
+			pr_info("%s: Audio enter HANC\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x9300);
 			break;
 
 		case Vbi:
-			cx231xx_info("%s: set vanc registers\n", __func__);
+			pr_info("%s: set vanc registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x300);
 			break;
 
 		case Sliced_cc:
-			cx231xx_info("%s: set hanc registers\n", __func__);
+			pr_info("%s: set hanc registers\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x1300);
 			break;
 
 		case Raw_Video:
-			cx231xx_info("%s: set video registers\n", __func__);
+			pr_info("%s: set video registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			break;
 
 		case TS1_serial_mode:
-			cx231xx_info("%s: set ts1 registers", __func__);
+			pr_info("%s: set ts1 registers", __func__);
 
 		if (dev->board.has_417) {
-			cx231xx_info(" MPEG\n");
+			pr_info(" MPEG\n");
 			value &= 0xFFFFFFFC;
 			value |= 0x3;
 
@@ -2558,14 +2558,14 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 				 TS1_LENGTH_REG, val, 4);
 
 		} else {
-			cx231xx_info(" BDA\n");
+			pr_info(" BDA\n");
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x101);
 			status = cx231xx_mode_register(dev, TS1_CFG_REG, 0x010);
 		}
 			break;
 
 		case TS1_parallel_mode:
-			cx231xx_info("%s: set ts1 parallel mode registers\n",
+			pr_info("%s: set ts1 parallel mode registers\n",
 				     __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			status = cx231xx_mode_register(dev, TS1_CFG_REG, 0x400);
@@ -2919,7 +2919,7 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 			 (nCnt > 0));
 
 	if (nCnt == 0)
-		cx231xx_info("No ACK after %d msec -GPIO I2C failed!",
+		pr_info("No ACK after %d msec -GPIO I2C failed!",
 			     nInit * 10);
 
 	/*
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 432cbcf8ce43..e104a8d2e6e5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -20,6 +20,7 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -35,7 +36,6 @@
 #include "xc5000.h"
 #include "tda18271.h"
 
-#include "cx231xx.h"
 
 static int tuner = -1;
 module_param(tuner, int, 0444);
@@ -856,7 +856,7 @@ int cx231xx_tuner_callback(void *ptr, int component, int command, int arg)
 
 	if (dev->tuner_type == TUNER_XC5000) {
 		if (command == XC5000_TUNER_RESET) {
-			cx231xx_info
+			pr_info
 				("Tuner CB: RESET: cmd %d : tuner type %d \n",
 				 command, dev->tuner_type);
 			cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit,
@@ -916,7 +916,7 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
 
 	cx231xx_set_model(dev);
 
-	cx231xx_info("Identified as %s (card=%d)\n",
+	pr_info("Identified as %s (card=%d)\n",
 		     dev->board.name, dev->model);
 
 	/* set the direction for GPIO pins */
@@ -990,7 +990,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 	/* start reading at offset 0 */
 	ret = i2c_transfer(client->adapter, &msg_write, 1);
 	if (ret < 0) {
-		cx231xx_err("Can't read eeprom\n");
+		pr_err("Can't read eeprom\n");
 		return ret;
 	}
 
@@ -1000,7 +1000,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 
 		ret = i2c_transfer(client->adapter, &msg_read, 1);
 		if (ret < 0) {
-			cx231xx_err("Can't read eeprom\n");
+			pr_err("Can't read eeprom\n");
 			return ret;
 		}
 		eedata_cur += msg_read.len;
@@ -1008,7 +1008,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 	}
 
 	for (i = 0; i + 15 < len; i += 16)
-		cx231xx_info("i2c eeprom %02x: %*ph\n", i, 16, &eedata[i]);
+		pr_info("i2c eeprom %02x: %*ph\n", i, 16, &eedata[i]);
 
 	return 0;
 }
@@ -1028,7 +1028,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 					cx231xx_get_i2c_adap(dev, I2C_0),
 					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
-			cx231xx_info("cx25840 subdev registration failure\n");
+			pr_info("cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, load_fw);
 
 	}
@@ -1042,7 +1042,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 						    "tuner",
 						    dev->tuner_addr, NULL);
 		if (dev->sd_tuner == NULL)
-			cx231xx_info("tuner subdev registration failure\n");
+			pr_info("tuner subdev registration failure\n");
 		else
 			cx231xx_config_tuner(dev);
 	}
@@ -1148,7 +1148,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/* Query cx231xx to find what pcb config it is related to */
 	retval = initialize_cx231xx(dev);
 	if (retval < 0) {
-		cx231xx_errdev("Failed to read PCB config\n");
+		pr_err("Failed to read PCB config\n");
 		return retval;
 	}
 
@@ -1164,7 +1164,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 
 	retval = cx231xx_config(dev);
 	if (retval) {
-		cx231xx_errdev("error configuring device\n");
+		pr_err("error configuring device\n");
 		return -ENOMEM;
 	}
 
@@ -1174,7 +1174,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/* register i2c bus */
 	retval = cx231xx_dev_init(dev);
 	if (retval) {
-		cx231xx_errdev("%s: cx231xx_i2c_register - errCode [%d]!\n",
+		pr_err("%s: cx231xx_i2c_register - errCode [%d]!\n",
 			       __func__, retval);
 		goto err_dev_init;
 	}
@@ -1196,7 +1196,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 
 	retval = cx231xx_config(dev);
 	if (retval) {
-		cx231xx_errdev("%s: cx231xx_config - errCode [%d]!\n",
+		pr_err("%s: cx231xx_config - errCode [%d]!\n",
 			       __func__, retval);
 		goto err_dev_init;
 	}
@@ -1281,7 +1281,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	/* compute alternate max packet sizes for video */
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.video_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		cx231xx_errdev("Video PCB interface #%d doesn't exist\n", idx);
+		pr_err("Video PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
 
@@ -1290,20 +1290,20 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	dev->video_mode.end_point_addr = uif->altsetting[0].endpoint[isoc_pipe].desc.bEndpointAddress;
 	dev->video_mode.num_alt = uif->num_altsetting;
 
-	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->video_mode.end_point_addr,
 		     dev->video_mode.num_alt);
 
 	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
 	if (dev->video_mode.alt_max_pkt_size == NULL) {
-		cx231xx_errdev("out of memory!\n");
+		pr_err("out of memory!\n");
 		return -ENOMEM;
 	}
 
 	for (i = 0; i < dev->video_mode.num_alt; i++) {
 		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
 		dev->video_mode.alt_max_pkt_size[i] = (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		cx231xx_info("Alternate setting %i, max size= %i\n", i,
+		pr_info("Alternate setting %i, max size= %i\n", i,
 			     dev->video_mode.alt_max_pkt_size[i]);
 	}
 
@@ -1311,7 +1311,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.vanc_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		cx231xx_errdev("VBI PCB interface #%d doesn't exist\n", idx);
+		pr_err("VBI PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
 	uif = udev->actconfig->interface[idx];
@@ -1321,14 +1321,14 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->vbi_mode.num_alt = uif->num_altsetting;
-	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->vbi_mode.end_point_addr,
 		     dev->vbi_mode.num_alt);
 
 	/* compute alternate max packet sizes for vbi */
 	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
 	if (dev->vbi_mode.alt_max_pkt_size == NULL) {
-		cx231xx_errdev("out of memory!\n");
+		pr_err("out of memory!\n");
 		return -ENOMEM;
 	}
 
@@ -1338,7 +1338,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 				desc.wMaxPacketSize);
 		dev->vbi_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		cx231xx_info("Alternate setting %i, max size= %i\n", i,
+		pr_info("Alternate setting %i, max size= %i\n", i,
 			     dev->vbi_mode.alt_max_pkt_size[i]);
 	}
 
@@ -1347,7 +1347,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	/* compute alternate max packet sizes for sliced CC */
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.hanc_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		cx231xx_errdev("Sliced CC PCB interface #%d doesn't exist\n", idx);
+		pr_err("Sliced CC PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
 	uif = udev->actconfig->interface[idx];
@@ -1357,13 +1357,13 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->sliced_cc_mode.num_alt = uif->num_altsetting;
-	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+	pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 		     dev->sliced_cc_mode.end_point_addr,
 		     dev->sliced_cc_mode.num_alt);
 	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
 
 	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL) {
-		cx231xx_errdev("out of memory!\n");
+		pr_err("out of memory!\n");
 		return -ENOMEM;
 	}
 
@@ -1372,7 +1372,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 				desc.wMaxPacketSize);
 		dev->sliced_cc_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		cx231xx_info("Alternate setting %i, max size= %i\n", i,
+		pr_info("Alternate setting %i, max size= %i\n", i,
 			     dev->sliced_cc_mode.alt_max_pkt_size[i]);
 	}
 
@@ -1410,7 +1410,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
 		if (nr >= CX231XX_MAXBOARDS) {
 			/* No free device slots */
-			cx231xx_err(DRIVER_NAME ": Supports only %i devices.\n",
+			pr_err(DRIVER_NAME ": Supports only %i devices.\n",
 					CX231XX_MAXBOARDS);
 			return -ENOMEM;
 		}
@@ -1421,7 +1421,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* allocate memory for our device state and initialize it */
 	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		cx231xx_err(DRIVER_NAME ": out of memory!\n");
+		pr_err(DRIVER_NAME ": out of memory!\n");
 		clear_bit(nr, &cx231xx_devused);
 		return -ENOMEM;
 	}
@@ -1468,7 +1468,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	cx231xx_info("New device %s %s @ %s Mbps "
+	pr_info("New device %s %s @ %s Mbps "
 	     "(%04x:%04x) with %d interfaces\n",
 	     udev->manufacturer ? udev->manufacturer : "",
 	     udev->product ? udev->product : "",
@@ -1485,13 +1485,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	assoc_desc = udev->actconfig->intf_assoc[0];
 	if (assoc_desc->bFirstInterface != ifnum) {
-		cx231xx_err(DRIVER_NAME ": Not found "
+		pr_err(DRIVER_NAME ": Not found "
 			    "matching IAD interface\n");
 		retval = -ENODEV;
 		goto err_if;
 	}
 
-	cx231xx_info("registering interface %d\n", ifnum);
+	pr_info("registering interface %d\n", ifnum);
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
@@ -1499,7 +1499,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* Create v4l2 device */
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
-		cx231xx_errdev("v4l2_device_register failed\n");
+		pr_err("v4l2_device_register failed\n");
 		goto err_v4l2;
 	}
 
@@ -1516,7 +1516,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		/* compute alternate max packet sizes for TS1 */
 		idx = dev->current_pcb_config.hs_config_info[0].interface_info.ts1_index + 1;
 		if (idx >= dev->max_iad_interface_count) {
-			cx231xx_errdev("TS1 PCB interface #%d doesn't exist\n", idx);
+			pr_err("TS1 PCB interface #%d doesn't exist\n", idx);
 			retval = -ENODEV;
 			goto err_video_alt;
 		}
@@ -1527,13 +1527,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 				desc.bEndpointAddress;
 
 		dev->ts1_mode.num_alt = uif->num_altsetting;
-		cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+		pr_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
 			     dev->ts1_mode.end_point_addr,
 			     dev->ts1_mode.num_alt);
 
 		dev->ts1_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->ts1_mode.num_alt, GFP_KERNEL);
 		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
-			cx231xx_errdev("out of memory!\n");
+			pr_err("out of memory!\n");
 			retval = -ENOMEM;
 			goto err_video_alt;
 		}
@@ -1544,7 +1544,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 						wMaxPacketSize);
 			dev->ts1_mode.alt_max_pkt_size[i] =
 			    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-			cx231xx_info("Alternate setting %i, max size= %i\n", i,
+			pr_info("Alternate setting %i, max size= %i\n", i,
 				     dev->ts1_mode.alt_max_pkt_size[i]);
 		}
 	}
@@ -1609,7 +1609,7 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 	wake_up_interruptible_all(&dev->open);
 
 	if (dev->users) {
-		cx231xx_warn
+		pr_warn
 		    ("device %s is open! Deregistration and memory "
 		     "deallocation are deferred on close.\n",
 		     video_device_node_name(dev->vdev));
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 9b5cd9e9b169..229e855fc7f2 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -20,6 +20,7 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -29,7 +30,6 @@
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
-#include "cx231xx.h"
 #include "cx231xx-reg.h"
 
 /* #define ENABLE_DEBUG_ISOC_FRAMES */
@@ -228,7 +228,7 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0) {
-		cx231xx_info
+		pr_info
 		    ("UsbInterface::sendCommand, failed with status -%d\n",
 		     status);
 	}
@@ -524,7 +524,7 @@ int cx231xx_set_video_alternate(struct cx231xx *dev)
 		    usb_set_interface(dev->udev, usb_interface_index,
 				      dev->video_mode.alt);
 		if (errCode < 0) {
-			cx231xx_errdev
+			pr_err
 			    ("cannot change alt number to %d (error=%i)\n",
 			     dev->video_mode.alt, errCode);
 			return errCode;
@@ -600,7 +600,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	}
 
 	if (alt > 0 && max_pkt_size == 0) {
-		cx231xx_errdev
+		pr_err
 		("can't change interface %d alt no. to %d: Max. Pkt size = 0\n",
 		usb_interface_index, alt);
 		/*To workaround error number=-71 on EP0 for videograbber,
@@ -616,7 +616,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	if (usb_interface_index > 0) {
 		status = usb_set_interface(dev->udev, usb_interface_index, alt);
 		if (status < 0) {
-			cx231xx_errdev
+			pr_err
 			("can't change interface %d alt no. to %d (err=%i)\n",
 			usb_interface_index, alt, status);
 			return status;
@@ -768,7 +768,7 @@ int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 
 	buffer = kzalloc(4096, GFP_KERNEL);
 	if (buffer == NULL) {
-		cx231xx_info("out of mem\n");
+		pr_info("out of mem\n");
 		return -ENOMEM;
 	}
 	memcpy(&buffer[0], firmware, 4096);
@@ -777,7 +777,7 @@ int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 			buffer, 4096, &actlen, 2000);
 
 	if (ret)
-		cx231xx_info("bulk message failed: %d (%d/%d)", ret,
+		pr_info("bulk message failed: %d (%d/%d)", ret,
 				size, actlen);
 	else {
 		errCode = actlen != size ? -1 : 0;
@@ -988,7 +988,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 
 	dma_q->p_left_data = kzalloc(4096, GFP_KERNEL);
 	if (dma_q->p_left_data == NULL) {
-		cx231xx_info("out of mem\n");
+		pr_info("out of mem\n");
 		return -ENOMEM;
 	}
 
@@ -1018,14 +1018,14 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	dev->video_mode.isoc_ctl.urb =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.isoc_ctl.urb) {
-		cx231xx_errdev("cannot alloc memory for usb buffers\n");
+		pr_err("cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
 	dev->video_mode.isoc_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.isoc_ctl.transfer_buffer) {
-		cx231xx_errdev("cannot allocate memory for usbtransfer\n");
+		pr_err("cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.isoc_ctl.urb);
 		return -ENOMEM;
 	}
@@ -1045,7 +1045,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.isoc_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
 		if (!urb) {
-			cx231xx_err("cannot alloc isoc_ctl.urb %i\n", i);
+			pr_err("cannot alloc isoc_ctl.urb %i\n", i);
 			cx231xx_uninit_isoc(dev);
 			return -ENOMEM;
 		}
@@ -1055,7 +1055,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				       &urb->transfer_dma);
 		if (!dev->video_mode.isoc_ctl.transfer_buffer[i]) {
-			cx231xx_err("unable to allocate %i bytes for transfer"
+			pr_err("unable to allocate %i bytes for transfer"
 				    " buffer %i%s\n",
 				    sb_size, i,
 				    in_interrupt() ? " while in int" : "");
@@ -1090,7 +1090,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		rc = usb_submit_urb(dev->video_mode.isoc_ctl.urb[i],
 				    GFP_ATOMIC);
 		if (rc) {
-			cx231xx_err("submit of urb %i failed (error=%i)\n", i,
+			pr_err("submit of urb %i failed (error=%i)\n", i,
 				    rc);
 			cx231xx_uninit_isoc(dev);
 			return rc;
@@ -1151,14 +1151,14 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	dev->video_mode.bulk_ctl.urb =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.bulk_ctl.urb) {
-		cx231xx_errdev("cannot alloc memory for usb buffers\n");
+		pr_err("cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
 	dev->video_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.bulk_ctl.transfer_buffer) {
-		cx231xx_errdev("cannot allocate memory for usbtransfer\n");
+		pr_err("cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.bulk_ctl.urb);
 		return -ENOMEM;
 	}
@@ -1178,7 +1178,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.bulk_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			cx231xx_err("cannot alloc bulk_ctl.urb %i\n", i);
+			pr_err("cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_bulk(dev);
 			return -ENOMEM;
 		}
@@ -1189,7 +1189,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				     &urb->transfer_dma);
 		if (!dev->video_mode.bulk_ctl.transfer_buffer[i]) {
-			cx231xx_err("unable to allocate %i bytes for transfer"
+			pr_err("unable to allocate %i bytes for transfer"
 				    " buffer %i%s\n",
 				    sb_size, i,
 				    in_interrupt() ? " while in int" : "");
@@ -1212,7 +1212,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		rc = usb_submit_urb(dev->video_mode.bulk_ctl.urb[i],
 				    GFP_ATOMIC);
 		if (rc) {
-			cx231xx_err("submit of urb %i failed (error=%i)\n", i,
+			pr_err("submit of urb %i failed (error=%i)\n", i,
 				    rc);
 			cx231xx_uninit_bulk(dev);
 			return rc;
@@ -1316,7 +1316,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ENXTERNAL_AV);
 		if (errCode < 0) {
-			cx231xx_errdev
+			pr_err
 			("%s: Failed to set Power - errCode [%d]!\n",
 			__func__, errCode);
 			return errCode;
@@ -1325,7 +1325,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ANALOGT_TV);
 		if (errCode < 0) {
-			cx231xx_errdev
+			pr_err
 			("%s: Failed to set Power - errCode [%d]!\n",
 			__func__, errCode);
 			return errCode;
@@ -1340,14 +1340,14 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* initialize Colibri block */
 	errCode = cx231xx_afe_init_super_block(dev, 0x23c);
 	if (errCode < 0) {
-		cx231xx_errdev
+		pr_err
 		    ("%s: cx231xx_afe init super block - errCode [%d]!\n",
 		     __func__, errCode);
 		return errCode;
 	}
 	errCode = cx231xx_afe_init_channels(dev);
 	if (errCode < 0) {
-		cx231xx_errdev
+		pr_err
 		    ("%s: cx231xx_afe init channels - errCode [%d]!\n",
 		     __func__, errCode);
 		return errCode;
@@ -1356,7 +1356,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* Set DIF in By pass mode */
 	errCode = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 	if (errCode < 0) {
-		cx231xx_errdev
+		pr_err
 		    ("%s: cx231xx_dif set to By pass mode - errCode [%d]!\n",
 		     __func__, errCode);
 		return errCode;
@@ -1365,7 +1365,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* I2S block related functions */
 	errCode = cx231xx_i2s_blk_initialize(dev);
 	if (errCode < 0) {
-		cx231xx_errdev
+		pr_err
 		    ("%s: cx231xx_i2s block initialize - errCode [%d]!\n",
 		     __func__, errCode);
 		return errCode;
@@ -1374,7 +1374,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* init control pins */
 	errCode = cx231xx_init_ctrl_pin_status(dev);
 	if (errCode < 0) {
-		cx231xx_errdev("%s: cx231xx_init ctrl pins - errCode [%d]!\n",
+		pr_err("%s: cx231xx_init ctrl pins - errCode [%d]!\n",
 			       __func__, errCode);
 		return errCode;
 	}
@@ -1400,7 +1400,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		break;
 	}
 	if (errCode < 0) {
-		cx231xx_errdev
+		pr_err
 		    ("%s: cx231xx_AGC mode to Analog - errCode [%d]!\n",
 		     __func__, errCode);
 		return errCode;
@@ -1477,7 +1477,7 @@ int cx231xx_send_gpio_cmd(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0) {
-		cx231xx_info
+		pr_info
 		    ("UsbInterface::sendCommand, failed with status -%d\n",
 		     status);
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 2ea69469e74b..a743865b40c0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -19,11 +19,11 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
 
-#include "cx231xx.h"
 #include <media/v4l2-common.h>
 #include <media/videobuf-vmalloc.h>
 
@@ -265,7 +265,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 	struct cx231xx *dev = dvb->adapter.priv;
 
 	if (dev->USE_ISO) {
-		cx231xx_info("DVB transfer mode is ISO.\n");
+		pr_info("DVB transfer mode is ISO.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -276,7 +276,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 					dev->ts1_mode.max_pkt_size,
 					dvb_isoc_copy);
 	} else {
-		cx231xx_info("DVB transfer mode is BULK.\n");
+		pr_info("DVB transfer mode is BULK.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -430,15 +430,15 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev)
 
 		if (dops->init != NULL && !dev->xc_fw_load_done) {
 
-			cx231xx_info("Reloading firmware for XC5000\n");
+			pr_info("Reloading firmware for XC5000\n");
 			status = dops->init(dev->dvb->frontend);
 			if (status == 0) {
 				dev->xc_fw_load_done = 1;
-				cx231xx_info
+				pr_info
 				    ("XC5000 firmware download completed\n");
 			} else {
 				dev->xc_fw_load_done = 0;
-				cx231xx_info
+				pr_info
 				    ("XC5000 firmware download failed !!!\n");
 			}
 		}
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index d1003c703fb5..d4a468a60bd0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -20,6 +20,7 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/usb.h>
@@ -28,7 +29,6 @@
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
-#include "cx231xx.h"
 
 /* ----------------------------------------------------------- */
 
@@ -498,17 +498,17 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	memset(&client, 0, sizeof(client));
 	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
 
-	cx231xx_info(": Checking for I2C devices on port=%d ..\n", i2c_port);
+	pr_info(": Checking for I2C devices on port=%d ..\n", i2c_port);
 	for (i = 0; i < 128; i++) {
 		client.addr = i;
 		rc = i2c_master_recv(&client, &buf, 0);
 		if (rc < 0)
 			continue;
-		cx231xx_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
+		pr_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
 			     dev->name, i << 1,
 			     i2c_devs[i] ? i2c_devs[i] : "???");
 	}
-	cx231xx_info(": Completed Checking for I2C devices on port=%d.\n",
+	pr_info(": Completed Checking for I2C devices on port=%d.\n",
 		i2c_port);
 }
 
@@ -532,7 +532,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	i2c_add_adapter(&bus->i2c_adap);
 
 	if (0 != bus->i2c_rc)
-		cx231xx_warn("%s: i2c bus %d register FAILED\n",
+		pr_warn("%s: i2c bus %d register FAILED\n",
 			     dev->name, bus->nr);
 
 	return bus->i2c_rc;
@@ -576,7 +576,7 @@ int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 				NULL);
 
 	if (!dev->i2c_mux_adap[mux_no])
-		cx231xx_warn("%s: i2c mux %d register FAILED\n",
+		pr_warn("%s: i2c mux %d register FAILED\n",
 			     dev->name, mux_no);
 
 	return 0;
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index 3052c4c20229..4666e533fe0a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -703,8 +703,8 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_BUSPOWER_DIF_ONLY;
 			break;
 		default:
-			cx231xx_info("bad config in buspower!!!!\n");
-			cx231xx_info("config_info=%x\n",
+			pr_info("bad config in buspower!!!!\n");
+			pr_info("config_info=%x\n",
 				     (config_info & BUSPOWER_MASK));
 			return 1;
 		}
@@ -768,8 +768,8 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_SELFPOWER_COMPRESSOR;
 			break;
 		default:
-			cx231xx_info("bad senario!!!!!\n");
-			cx231xx_info("config_info=%x\n",
+			pr_info("bad senario!!!!!\n");
+			pr_info("config_info=%x\n",
 				     (config_info & SELFPOWER_MASK));
 			return -ENODEV;
 		}
@@ -781,17 +781,17 @@ int initialize_cx231xx(struct cx231xx *dev)
 		   sizeof(struct pcb_config));
 
 	if (pcb_debug) {
-		cx231xx_info("SC(0x00) register = 0x%x\n", config_info);
-		cx231xx_info("scenario %d\n",
+		pr_info("SC(0x00) register = 0x%x\n", config_info);
+		pr_info("scenario %d\n",
 			    (dev->current_pcb_config.index) + 1);
-		cx231xx_info("type=%x\n", dev->current_pcb_config.type);
-		cx231xx_info("mode=%x\n", dev->current_pcb_config.mode);
-		cx231xx_info("speed=%x\n", dev->current_pcb_config.speed);
-		cx231xx_info("ts1_source=%x\n",
+		pr_info("type=%x\n", dev->current_pcb_config.type);
+		pr_info("mode=%x\n", dev->current_pcb_config.mode);
+		pr_info("speed=%x\n", dev->current_pcb_config.speed);
+		pr_info("ts1_source=%x\n",
 			     dev->current_pcb_config.ts1_source);
-		cx231xx_info("ts2_source=%x\n",
+		pr_info("ts2_source=%x\n",
 			     dev->current_pcb_config.ts2_source);
-		cx231xx_info("analog_source=%x\n",
+		pr_info("analog_source=%x\n",
 			     dev->current_pcb_config.analog_source);
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index c02794274f51..f80126d3525a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -19,6 +19,7 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -35,7 +36,6 @@
 #include <media/msp3400.h>
 #include <media/tuner.h>
 
-#include "cx231xx.h"
 #include "cx231xx-vbi.h"
 
 static inline void print_err_status(struct cx231xx *dev, int packet, int status)
@@ -69,10 +69,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 		break;
 	}
 	if (packet < 0) {
-		cx231xx_err("URB status %d [%s].\n", status,
+		pr_err("URB status %d [%s].\n", status,
 			    errmsg);
 	} else {
-		cx231xx_err("URB packet %d, status %d [%s].\n",
+		pr_err("URB packet %d, status %d [%s].\n",
 			    packet, status, errmsg);
 	}
 }
@@ -316,7 +316,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		cx231xx_err("urb completition error %d.\n",
+		pr_err("urb completition error %d.\n",
 			    urb->status);
 		break;
 	}
@@ -331,7 +331,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (urb->status) {
-		cx231xx_err("urb resubmit failed (error=%i)\n",
+		pr_err("urb resubmit failed (error=%i)\n",
 			    urb->status);
 	}
 }
@@ -344,7 +344,7 @@ void cx231xx_uninit_vbi_isoc(struct cx231xx *dev)
 	struct urb *urb;
 	int i;
 
-	cx231xx_info("called cx231xx_uninit_vbi_isoc\n");
+	pr_info("called cx231xx_uninit_vbi_isoc\n");
 
 	dev->vbi_mode.bulk_ctl.nfields = -1;
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
@@ -393,7 +393,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	struct urb *urb;
 	int rc;
 
-	cx231xx_info("called cx231xx_vbi_isoc\n");
+	pr_info("called cx231xx_vbi_isoc\n");
 
 	/* De-allocates all pending stuff */
 	cx231xx_uninit_vbi_isoc(dev);
@@ -419,14 +419,14 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	dev->vbi_mode.bulk_ctl.urb = kzalloc(sizeof(void *) * num_bufs,
 					     GFP_KERNEL);
 	if (!dev->vbi_mode.bulk_ctl.urb) {
-		cx231xx_errdev("cannot alloc memory for usb buffers\n");
+		pr_err("cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
 	dev->vbi_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->vbi_mode.bulk_ctl.transfer_buffer) {
-		cx231xx_errdev("cannot allocate memory for usbtransfer\n");
+		pr_err("cannot allocate memory for usbtransfer\n");
 		kfree(dev->vbi_mode.bulk_ctl.urb);
 		return -ENOMEM;
 	}
@@ -441,7 +441,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			cx231xx_err("cannot alloc bulk_ctl.urb %i\n", i);
+			pr_err("cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_vbi_isoc(dev);
 			return -ENOMEM;
 		}
@@ -451,7 +451,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);
 		if (!dev->vbi_mode.bulk_ctl.transfer_buffer[i]) {
-			cx231xx_err("unable to allocate %i bytes for transfer"
+			pr_err("unable to allocate %i bytes for transfer"
 				    " buffer %i%s\n", sb_size, i,
 				    in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_vbi_isoc(dev);
@@ -470,7 +470,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
 		rc = usb_submit_urb(dev->vbi_mode.bulk_ctl.urb[i], GFP_ATOMIC);
 		if (rc) {
-			cx231xx_err("submit of urb %i failed (error=%i)\n", i,
+			pr_err("submit of urb %i failed (error=%i)\n", i,
 				    rc);
 			cx231xx_uninit_vbi_isoc(dev);
 			return rc;
@@ -522,7 +522,7 @@ static inline void vbi_buffer_filled(struct cx231xx *dev,
 				     struct cx231xx_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	/* cx231xx_info("[%p/%d] wakeup\n", buf, buf->vb.i); */
+	/* pr_info("[%p/%d] wakeup\n", buf, buf->vb.i); */
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
@@ -614,7 +614,7 @@ static inline void get_next_vbi_buf(struct cx231xx_dmaqueue *dma_q,
 	char *outp;
 
 	if (list_empty(&dma_q->active)) {
-		cx231xx_err("No active queue to serve\n");
+		pr_err("No active queue to serve\n");
 		dev->vbi_mode.bulk_ctl.buf = NULL;
 		*buf = NULL;
 		return;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 3b3ada6562ca..bda5597b5eff 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -22,6 +22,7 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx231xx.h"
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -41,7 +42,6 @@
 
 #include "dvb_frontend.h"
 
-#include "cx231xx.h"
 #include "cx231xx-vbi.h"
 
 #define CX231XX_VERSION "0.0.2"
@@ -737,7 +737,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
-	/*cx231xx_info("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
+	/*pr_info("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
 		urb_init, dev->video_mode.max_pkt_size);*/
 	if (urb_init) {
 		dev->mode_tv = 0;
@@ -809,7 +809,7 @@ void video_mux(struct cx231xx *dev, int index)
 
 	cx231xx_set_audio_input(dev, dev->ctl_ainput);
 
-	cx231xx_info("video_mux : %d\n", index);
+	pr_info("video_mux : %d\n", index);
 
 	/* do mode control overrides if required */
 	cx231xx_do_mode_ctrl_overrides(dev);
@@ -861,7 +861,7 @@ static void res_free(struct cx231xx_fh *fh)
 static int check_dev(struct cx231xx *dev)
 {
 	if (dev->state & DEV_DISCONNECTED) {
-		cx231xx_errdev("v4l2 ioctl: device not present\n");
+		pr_err("v4l2 ioctl: device not present\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -953,12 +953,12 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		cx231xx_errdev("%s queue busy\n", __func__);
+		pr_err("%s queue busy\n", __func__);
 		return -EBUSY;
 	}
 
 	if (dev->stream_on && !fh->stream_on) {
-		cx231xx_errdev("%s device in use by another fh\n", __func__);
+		pr_err("%s device in use by another fh\n", __func__);
 		return -EBUSY;
 	}
 
@@ -1176,9 +1176,9 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	int rc;
 	u32 if_frequency = 5400000;
 
-	cx231xx_info("Enter vidioc_s_frequency()f->frequency=%d;f->type=%d\n",
+	pr_info("Enter vidioc_s_frequency()f->frequency=%d;f->type=%d\n",
 		 f->frequency, f->type);
-	/*cx231xx_info("f->type:  1-radio 2-analogTV 3-digitalTV\n");*/
+	/*pr_info("f->type:  1-radio 2-analogTV 3-digitalTV\n");*/
 
 	rc = check_dev(dev);
 	if (rc < 0)
@@ -1213,13 +1213,13 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 		else if (dev->norm & V4L2_STD_SECAM_LC)
 			if_frequency = 1250000;  /*1.25MHz	*/
 
-		cx231xx_info("if_frequency is set to %d\n", if_frequency);
+		pr_info("if_frequency is set to %d\n", if_frequency);
 		cx231xx_set_Colibri_For_LowIF(dev, if_frequency, 1, 1);
 
 		update_HH_register_after_set_DIF(dev);
 	}
 
-	cx231xx_info("Set New FREQUENCY to %d\n", f->frequency);
+	pr_info("Set New FREQUENCY to %d\n", f->frequency);
 
 	return rc;
 }
@@ -1523,7 +1523,7 @@ static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
 	struct cx231xx *dev = fh->dev;
 
 	if (dev->vbi_stream_on && !fh->stream_on) {
-		cx231xx_errdev("%s device in use by another fh\n", __func__);
+		pr_err("%s device in use by another fh\n", __func__);
 		return -EBUSY;
 	}
 	return vidioc_try_fmt_vbi_cap(file, priv, f);
@@ -1642,7 +1642,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 #if 0
 	errCode = cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);
 	if (errCode < 0) {
-		cx231xx_errdev
+		pr_err
 		    ("Device locked on digital mode. Can't open analog\n");
 		return -EBUSY;
 	}
@@ -1650,7 +1650,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 
 	fh = kzalloc(sizeof(struct cx231xx_fh), GFP_KERNEL);
 	if (!fh) {
-		cx231xx_errdev("cx231xx-video.c: Out of memory?!\n");
+		pr_err("cx231xx-video.c: Out of memory?!\n");
 		return -ENOMEM;
 	}
 	if (mutex_lock_interruptible(&dev->lock)) {
@@ -1736,7 +1736,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 		dev->radio_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		cx231xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			     video_device_node_name(dev->vbi_dev));
 		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
@@ -1745,7 +1745,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 		dev->vbi_dev = NULL;
 	}
 	if (dev->vdev) {
-		cx231xx_info("V4L2 device %s deregistered\n",
+		pr_info("V4L2 device %s deregistered\n",
 			     video_device_node_name(dev->vdev));
 
 		if (dev->board.has_417)
@@ -2080,7 +2080,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 {
 	int ret;
 
-	cx231xx_info("%s: v4l2 driver version %s\n",
+	pr_info("%s: v4l2 driver version %s\n",
 		     dev->name, CX231XX_VERSION);
 
 	/* set default norm */
@@ -2119,7 +2119,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* allocate and fill video video_device struct */
 	dev->vdev = cx231xx_vdev_init(dev, &cx231xx_video_template, "video");
 	if (!dev->vdev) {
-		cx231xx_errdev("cannot allocate video_device.\n");
+		pr_err("cannot allocate video_device.\n");
 		return -ENODEV;
 	}
 
@@ -2128,12 +2128,12 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
-		cx231xx_errdev("unable to register video device (error=%i).\n",
+		pr_err("unable to register video device (error=%i).\n",
 			       ret);
 		return ret;
 	}
 
-	cx231xx_info("%s/0: registered device %s [v4l2]\n",
+	pr_info("%s/0: registered device %s [v4l2]\n",
 		     dev->name, video_device_node_name(dev->vdev));
 
 	/* Initialize VBI template */
@@ -2144,7 +2144,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	dev->vbi_dev = cx231xx_vdev_init(dev, &cx231xx_vbi_template, "vbi");
 
 	if (!dev->vbi_dev) {
-		cx231xx_errdev("cannot allocate video_device.\n");
+		pr_err("cannot allocate video_device.\n");
 		return -ENODEV;
 	}
 	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
@@ -2152,32 +2152,32 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[dev->devno]);
 	if (ret < 0) {
-		cx231xx_errdev("unable to register vbi device\n");
+		pr_err("unable to register vbi device\n");
 		return ret;
 	}
 
-	cx231xx_info("%s/0: registered device %s\n",
+	pr_info("%s/0: registered device %s\n",
 		     dev->name, video_device_node_name(dev->vbi_dev));
 
 	if (cx231xx_boards[dev->model].radio.type == CX231XX_RADIO) {
 		dev->radio_dev = cx231xx_vdev_init(dev, &cx231xx_radio_template,
 						   "radio");
 		if (!dev->radio_dev) {
-			cx231xx_errdev("cannot allocate video_device.\n");
+			pr_err("cannot allocate video_device.\n");
 			return -ENODEV;
 		}
 		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
 		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
-			cx231xx_errdev("can't register radio device\n");
+			pr_err("can't register radio device\n");
 			return ret;
 		}
-		cx231xx_info("Registered radio device as %s\n",
+		pr_info("Registered radio device as %s\n",
 			     video_device_node_name(dev->radio_dev));
 	}
 
-	cx231xx_info("V4L2 device registered as %s and %s\n",
+	pr_info("V4L2 device registered as %s and %s\n",
 		     video_device_node_name(dev->vdev),
 		     video_device_node_name(dev->vbi_dev));
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index a0ec24176522..fa27e0c2accb 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -22,6 +22,8 @@
 #ifndef _CX231XX_H
 #define _CX231XX_H
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/videodev2.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
@@ -981,23 +983,6 @@ void cx231xx_ir_exit(struct cx231xx *dev);
 #define cx231xx_ir_exit(dev)	(0)
 #endif
 
-
-/* printk macros */
-
-#define cx231xx_err(fmt, arg...) do {\
-	printk(KERN_ERR fmt , ##arg); } while (0)
-
-#define cx231xx_errdev(fmt, arg...) do {\
-	printk(KERN_ERR "%s: "fmt,\
-			dev->name , ##arg); } while (0)
-
-#define cx231xx_info(fmt, arg...) do {\
-	printk(KERN_INFO "%s: "fmt,\
-			dev->name , ##arg); } while (0)
-#define cx231xx_warn(fmt, arg...) do {\
-	printk(KERN_WARNING "%s: "fmt,\
-			dev->name , ##arg); } while (0)
-
 static inline unsigned int norm_maxw(struct cx231xx *dev)
 {
 	if (dev->board.max_range_640_480)
-- 
1.9.3

