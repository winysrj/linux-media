Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaKBMcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:50 -0500
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
	=?UTF-8?q?=5C=22David=20H=C3=A4rdeman=5C=22?= <david@hardeman.nu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCHv2 08/14] [media] cx231xx: convert from pr_foo to dev_foo
Date: Sun,  2 Nov 2014 10:32:31 -0200
Message-Id: <d47b6be9f1e401036ef8bc2a05d96004db7dc72a.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace all pr_foo occurrences by dev_foo, as this is
the recommended way for drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index a0d1156d1df1..0773da4dc29b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -39,7 +39,6 @@
 #include <media/v4l2-event.h>
 #include <media/cx2341x.h>
 #include <media/tuner.h>
-#include <linux/usb.h>
 
 #define CX231xx_FIRM_IMAGE_SIZE 376836
 #define CX231xx_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
@@ -988,7 +987,8 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 		IVTV_REG_APU, 0);
 
 	if (retval != 0) {
-		pr_err("%s: Error with mc417_register_write\n", __func__);
+		dev_err(&dev->udev->dev,
+			"%s: Error with mc417_register_write\n", __func__);
 		return -1;
 	}
 
@@ -996,21 +996,25 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 				  &dev->udev->dev);
 
 	if (retval != 0) {
-		pr_err("ERROR: Hotplug firmware request failed (%s).\n",
+		dev_err(&dev->udev->dev,
+			"ERROR: Hotplug firmware request failed (%s).\n",
 			CX231xx_FIRM_IMAGE_NAME);
-		pr_err("Please fix your hotplug setup, the board will not work without firmware loaded!\n");
+		dev_err(&dev->udev->dev,
+			"Please fix your hotplug setup, the board will not work without firmware loaded!\n");
 		return -1;
 	}
 
 	if (firmware->size != CX231xx_FIRM_IMAGE_SIZE) {
-		pr_err("ERROR: Firmware size mismatch (have %zd, expected %d)\n",
+		dev_err(&dev->udev->dev,
+			"ERROR: Firmware size mismatch (have %zd, expected %d)\n",
 			firmware->size, CX231xx_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -1;
 	}
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
-		pr_err("ERROR: Firmware magic mismatch, wrong file?\n");
+		dev_err(&dev->udev->dev,
+			"ERROR: Firmware magic mismatch, wrong file?\n");
 		release_firmware(firmware);
 		return -1;
 	}
@@ -1057,7 +1061,8 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	retval |= mc417_register_write(dev, IVTV_REG_HW_BLOCKS,
 		IVTV_CMD_HW_BLOCKS_RST);
 	if (retval < 0) {
-		pr_err("%s: Error with mc417_register_write\n",
+		dev_err(&dev->udev->dev,
+			"%s: Error with mc417_register_write\n",
 			__func__);
 		return retval;
 	}
@@ -1069,7 +1074,8 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	retval |= mc417_register_write(dev, IVTV_REG_VPU, value & 0xFFFFFFE8);
 
 	if (retval < 0) {
-		pr_err("%s: Error with mc417_register_write\n",
+		dev_err(&dev->udev->dev,
+			"%s: Error with mc417_register_write\n",
 			__func__);
 		return retval;
 	}
@@ -1117,25 +1123,28 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 		dprintk(2, "%s: PING OK\n", __func__);
 		retval = cx231xx_load_firmware(dev);
 		if (retval < 0) {
-			pr_err("%s: f/w load failed\n", __func__);
+			dev_err(&dev->udev->dev,
+				"%s: f/w load failed\n", __func__);
 			return retval;
 		}
 		retval = cx231xx_find_mailbox(dev);
 		if (retval < 0) {
-			pr_err("%s: mailbox < 0, error\n",
+			dev_err(&dev->udev->dev, "%s: mailbox < 0, error\n",
 				__func__);
 			return -1;
 		}
 		dev->cx23417_mailbox = retval;
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0);
 		if (retval < 0) {
-			pr_err("ERROR: cx23417 firmware ping failed!\n");
+			dev_err(&dev->udev->dev,
+				"ERROR: cx23417 firmware ping failed!\n");
 			return -1;
 		}
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_GET_VERSION, 0, 1,
 			&version);
 		if (retval < 0) {
-			pr_err("ERROR: cx23417 firmware get encoder: version failed!\n");
+			dev_err(&dev->udev->dev,
+				"ERROR: cx23417 firmware get encoder: version failed!\n");
 			return -1;
 		}
 		dprintk(1, "cx23417 firmware version is 0x%08x\n", version);
@@ -1416,8 +1425,9 @@ static int bb_buf_prepare(struct videobuf_queue *q,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
-	/*pr_info("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
-		urb_init, dev->video_mode.max_pkt_size);*/
+	dev_dbg(&dev->udev->dev,
+		"urb_init=%d dev->video_mode.max_pkt_size=%d\n",
+		urb_init, dev->video_mode.max_pkt_size);
 	dev->mode_tv = 1;
 
 	if (urb_init) {
diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index e96703180c0c..1c3f68179fc9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -22,7 +22,6 @@
 
 #include "cx231xx.h"
 #include <linux/kernel.h>
-#include <linux/usb.h>
 #include <linux/init.h>
 #include <linux/sound.h>
 #include <linux/spinlock.h>
@@ -182,8 +181,9 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0) {
-		pr_err("resubmit of audio urb failed (error=%i)\n",
-			       status);
+		dev_err(&dev->udev->dev,
+			"resubmit of audio urb failed (error=%i)\n",
+			status);
 	}
 	return;
 }
@@ -266,8 +266,9 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0) {
-		pr_err("resubmit of audio urb failed (error=%i)\n",
-			       status);
+		dev_err(&dev->udev->dev,
+			"resubmit of audio urb failed (error=%i)\n",
+			status);
 	}
 	return;
 }
@@ -277,7 +278,8 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	pr_debug("%s: Starting ISO AUDIO transfers\n", __func__);
+	dev_dbg(&dev->udev->dev,
+		"%s: Starting ISO AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
 		return -ENODEV;
@@ -295,7 +297,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_ISO_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			pr_err("usb_alloc_urb failed!\n");
+			dev_err(&dev->udev->dev, "usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
@@ -338,7 +340,8 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	pr_debug("%s: Starting BULK AUDIO transfers\n", __func__);
+	dev_dbg(&dev->udev->dev,
+		"%s: Starting BULK AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
 		return -ENODEV;
@@ -356,7 +359,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			pr_err("usb_alloc_urb failed!\n");
+			dev_err(&dev->udev->dev, "usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
@@ -439,12 +442,14 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
 	if (!dev) {
-		pr_err("BUG: cx231xx can't find device struct. Can't proceed with open\n");
+		dev_err(&dev->udev->dev,
+			"BUG: cx231xx can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
 	if (dev->state & DEV_DISCONNECTED) {
-		pr_err("Can't open. the device was removed.\n");
+		dev_err(&dev->udev->dev,
+			"Can't open. the device was removed.\n");
 		return -ENODEV;
 	}
 
@@ -457,7 +462,8 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 		ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 0);
 	mutex_unlock(&dev->lock);
 	if (ret < 0) {
-		pr_err("failed to set alternate setting !\n");
+		dev_err(&dev->udev->dev,
+			"failed to set alternate setting !\n");
 
 		return ret;
 	}
@@ -493,7 +499,8 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	/* 1 - 48000 samples per sec */
 	ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 0);
 	if (ret < 0) {
-		pr_err("failed to set alternate setting !\n");
+		dev_err(&dev->udev->dev,
+			"failed to set alternate setting !\n");
 
 		mutex_unlock(&dev->lock);
 		return ret;
@@ -661,7 +668,8 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 		return 0;
 	}
 
-	pr_debug("probing for cx231xx non standard usbaudio\n");
+	dev_dbg(&dev->udev->dev,
+		"probing for cx231xx non standard usbaudio\n");
 
 	err = snd_card_new(&dev->udev->dev, index[devnr], "Cx231xx Audio",
 			   THIS_MODULE, 0, &card);
@@ -705,7 +713,8 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 			bEndpointAddress;
 
 	adev->num_alt = uif->num_altsetting;
-	pr_info("audio EndPoint Addr 0x%x, Alternate settings: %i\n",
+	dev_info(&dev->udev->dev,
+		"audio EndPoint Addr 0x%x, Alternate settings: %i\n",
 		adev->end_point_addr, adev->num_alt);
 	adev->alt_max_pkt_size = kmalloc(32 * adev->num_alt, GFP_KERNEL);
 
@@ -718,8 +727,9 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 				wMaxPacketSize);
 		adev->alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_debug("audio alternate setting %i, max size= %i\n", i,
-			     adev->alt_max_pkt_size[i]);
+		dev_dbg(&dev->udev->dev,
+			"audio alternate setting %i, max size= %i\n", i,
+			adev->alt_max_pkt_size[i]);
 	}
 
 	return 0;
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 62c63b9e2291..9088a32db2d1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/bitmap.h>
-#include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
@@ -83,10 +82,10 @@ void initGPIO(struct cx231xx *dev)
 	cx231xx_send_gpio_cmd(dev, _gpio_direction, (u8 *)&value, 4, 0, 0);
 
 	verve_read_byte(dev, 0x07, &val);
-	pr_debug("verve_read_byte address0x07=0x%x\n", val);
+	dev_dbg(&dev->udev->dev, "verve_read_byte address0x07=0x%x\n", val);
 	verve_write_byte(dev, 0x07, 0xF4);
 	verve_read_byte(dev, 0x07, &val);
-	pr_debug("verve_read_byte address0x07=0x%x\n", val);
+	dev_dbg(&dev->udev->dev, "verve_read_byte address0x07=0x%x\n", val);
 
 	cx231xx_capture_start(dev, 1, Vbi);
 
@@ -156,7 +155,8 @@ int cx231xx_afe_init_super_block(struct cx231xx *dev, u32 ref_count)
 	while (afe_power_status != 0x18) {
 		status = afe_write_byte(dev, SUP_BLK_PWRDN, 0x18);
 		if (status < 0) {
-			pr_debug("%s: Init Super Block failed in send cmd\n",
+			dev_dbg(&dev->udev->dev,
+				"%s: Init Super Block failed in send cmd\n",
 				__func__);
 			break;
 		}
@@ -164,13 +164,15 @@ int cx231xx_afe_init_super_block(struct cx231xx *dev, u32 ref_count)
 		status = afe_read_byte(dev, SUP_BLK_PWRDN, &afe_power_status);
 		afe_power_status &= 0xff;
 		if (status < 0) {
-			pr_debug("%s: Init Super Block failed in receive cmd\n",
+			dev_dbg(&dev->udev->dev,
+				"%s: Init Super Block failed in receive cmd\n",
 				__func__);
 			break;
 		}
 		i++;
 		if (i == 10) {
-			pr_debug("%s: Init Super Block force break in loop !!!!\n",
+			dev_dbg(&dev->udev->dev,
+				"%s: Init Super Block force break in loop !!!!\n",
 				__func__);
 			status = -1;
 			break;
@@ -410,7 +412,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 						0x00);
 		} else {
-			pr_debug("Invalid AV mode input\n");
+			dev_dbg(&dev->udev->dev, "Invalid AV mode input\n");
 			status = -1;
 		}
 		break;
@@ -467,7 +469,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 							0x40);
 		} else {
-			pr_debug("Invalid AV mode input\n");
+			dev_dbg(&dev->udev->dev, "Invalid AV mode input\n");
 			status = -1;
 		}
 	}			/* switch  */
@@ -573,9 +575,9 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 			status = cx231xx_set_power_mode(dev,
 					POLARIS_AVMODE_ENXTERNAL_AV);
 			if (status < 0) {
-				pr_err("%s: set_power_mode : Failed to"
-						" set Power - errCode [%d]!\n",
-						__func__, status);
+				dev_err(&dev->udev->dev,
+					"%s: Failed to set Power - errCode [%d]!\n",
+					__func__, status);
 				return status;
 			}
 		}
@@ -591,8 +593,8 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 			status = cx231xx_set_power_mode(dev,
 						POLARIS_AVMODE_ANALOGT_TV);
 			if (status < 0) {
-				pr_err("%s: set_power_mode:Failed"
-					" to set Power - errCode [%d]!\n",
+				dev_err(&dev->udev->dev,
+					"%s: Failed to set Power - errCode [%d]!\n",
 					__func__, status);
 				return status;
 			}
@@ -608,8 +610,8 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 
 		break;
 	default:
-		pr_err("%s: set_power_mode : Unknown Input %d !\n",
-		     __func__, INPUT(input)->type);
+		dev_err(&dev->udev->dev, "%s: Unknown Input %d !\n",
+			__func__, INPUT(input)->type);
 		break;
 	}
 
@@ -628,7 +630,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	if (pin_type != dev->video_input) {
 		status = cx231xx_afe_adjust_ref_count(dev, pin_type);
 		if (status < 0) {
-			pr_err("%s: adjust_ref_count :Failed to set AFE input mux - errCode [%d]!\n",
+			dev_err(&dev->udev->dev,
+				"%s: adjust_ref_count :Failed to set AFE input mux - errCode [%d]!\n",
 				__func__, status);
 			return status;
 		}
@@ -637,7 +640,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	/* call afe block to set video inputs */
 	status = cx231xx_afe_set_input_mux(dev, input);
 	if (status < 0) {
-		pr_err("%s: set_input_mux :Failed to set AFE input mux - errCode [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: set_input_mux :Failed to set AFE input mux - errCode [%d]!\n",
 			__func__, status);
 		return status;
 	}
@@ -668,7 +672,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode  */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
+			dev_err(&dev->udev->dev,
+				"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
 		}
@@ -712,7 +717,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
+			dev_err(&dev->udev->dev,
+				"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
 		}
@@ -786,7 +792,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			status = cx231xx_dif_set_standard(dev,
 							  DIF_USE_BASEBAND);
 			if (status < 0) {
-				pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
+				dev_err(&dev->udev->dev,
+					"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				       __func__, status);
 				return status;
 			}
@@ -821,7 +828,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			/* Reinitialize the DIF */
 			status = cx231xx_dif_set_standard(dev, dev->norm);
 			if (status < 0) {
-				pr_err("%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
+				dev_err(&dev->udev->dev,
+					"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 					__func__, status);
 				return status;
 			}
@@ -964,14 +972,14 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 {
 	int status = 0;
 
-	pr_debug("%s: 0x%x\n",
+	dev_dbg(&dev->udev->dev, "%s: 0x%x\n",
 		__func__, (unsigned int)dev->norm);
 
 	/* Change the DFE_CTRL3 bp_percent to fix flagging */
 	status = vid_blk_write_word(dev, DFE_CTRL3, 0xCD3F0280);
 
 	if (dev->norm & (V4L2_STD_NTSC | V4L2_STD_PAL_M)) {
-		pr_debug("%s: NTSC\n", __func__);
+		dev_dbg(&dev->udev->dev, "%s: NTSC\n", __func__);
 
 		/* Move the close caption lines out of active video,
 		   adjust the active video start point */
@@ -998,7 +1006,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							(FLD_HBLANK_CNT, 0x79));
 
 	} else if (dev->norm & V4L2_STD_SECAM) {
-		pr_debug("%s: SECAM\n", __func__);
+		dev_dbg(&dev->udev->dev, "%s: SECAM\n", __func__);
 		status =  cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1025,7 +1033,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							cx231xx_set_field
 							(FLD_HBLANK_CNT, 0x85));
 	} else {
-		pr_debug("%s: PAL\n", __func__);
+		dev_dbg(&dev->udev->dev, "%s: PAL\n", __func__);
 		status = cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1325,111 +1333,129 @@ void cx231xx_dump_HH_reg(struct cx231xx *dev)
 
 	for (i = 0x100; i < 0x140; i++) {
 		vid_blk_read_word(dev, i, &value);
-		pr_debug("reg0x%x=0x%x\n", i, value);
+		dev_dbg(&dev->udev->dev, "reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x300; i < 0x400; i++) {
 		vid_blk_read_word(dev, i, &value);
-		pr_debug("reg0x%x=0x%x\n", i, value);
+		dev_dbg(&dev->udev->dev, "reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x400; i < 0x440; i++) {
 		vid_blk_read_word(dev, i,  &value);
-		pr_debug("reg0x%x=0x%x\n", i, value);
+		dev_dbg(&dev->udev->dev, "reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	pr_debug("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	dev_dbg(&dev->udev->dev, "AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 	vid_blk_write_word(dev, AFE_CTRL_C2HH_SRC_CTRL, 0x4485D390);
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	pr_debug("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	dev_dbg(&dev->udev->dev, "AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 }
 
 #if 0
 static void cx231xx_dump_SC_reg(struct cx231xx *dev)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
-	pr_debug("%s!\n", __func__);
+	dev_dbg(&dev->udev->dev, "%s!\n", __func__);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS_MODE_REG,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
+		 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_CFG_REG,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
+		 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_LENGTH_REG,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
+		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_CFG_REG,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_LENGTH_REG,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
+		 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN1,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
+		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN2,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN3,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK0,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK1,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
+		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK2,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_GAIN,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_CAR_REG,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG1,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
+		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG2,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
+		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, PWR_CTL_EN,
 				 value, 4);
-	pr_debug("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
-				 value[1], value[2], value[3]);
+	dev_dbg(&dev->udev->dev,
+		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
+		value[1], value[2], value[3]);
 }
 #endif
 
@@ -1497,7 +1523,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	u32 standard = 0;
 	u8 value[4] = { 0, 0, 0, 0 };
 
-	pr_debug("Enter cx231xx_set_Colibri_For_LowIF()\n");
+	dev_dbg(&dev->udev->dev, "Enter cx231xx_set_Colibri_For_LowIF()\n");
 	value[0] = (u8) 0x6F;
 	value[1] = (u8) 0x6F;
 	value[2] = (u8) 0x6F;
@@ -1517,7 +1543,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	colibri_carrier_offset = cx231xx_Get_Colibri_CarrierOffset(mode,
 								   standard);
 
-	pr_debug("colibri_carrier_offset=%d, standard=0x%x\n",
+	dev_dbg(&dev->udev->dev, "colibri_carrier_offset=%d, standard=0x%x\n",
 		     colibri_carrier_offset, standard);
 
 	/* Set the band Pass filter for DIF*/
@@ -1551,8 +1577,8 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 	u64 pll_freq_u64 = 0;
 	u32 i = 0;
 
-	pr_debug("if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
-			 if_freq, spectral_invert, mode);
+	dev_dbg(&dev->udev->dev, "if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
+		if_freq, spectral_invert, mode);
 
 
 	if (mode == TUNER_MODE_FM_RADIO) {
@@ -1595,8 +1621,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		if_freq = 16000000;
 	}
 
-	pr_debug("Enter IF=%zu\n",
-			ARRAY_SIZE(Dif_set_array));
+	dev_dbg(&dev->udev->dev, "Enter IF=%zu\n", ARRAY_SIZE(Dif_set_array));
 	for (i = 0; i < ARRAY_SIZE(Dif_set_array); i++) {
 		if (Dif_set_array[i].if_freq == if_freq) {
 			vid_blk_write_word(dev,
@@ -1708,7 +1733,7 @@ int cx231xx_dif_set_standard(struct cx231xx *dev, u32 standard)
 	u32 dif_misc_ctrl_value = 0;
 	u32 func_mode = 0;
 
-	pr_debug("%s: setStandard to %x\n", __func__, standard);
+	dev_dbg(&dev->udev->dev, "%s: setStandard to %x\n", __func__, standard);
 
 	status = vid_blk_read_word(dev, DIF_MISC_CTRL, &dif_misc_ctrl_value);
 	if (standard != DIF_USE_BASEBAND)
@@ -2111,8 +2136,8 @@ int cx231xx_tuner_post_channel_change(struct cx231xx *dev)
 {
 	int status = 0;
 	u32 dwval;
-	pr_debug("%s: dev->tuner_type =0%d\n",
-		     __func__, dev->tuner_type);
+	dev_dbg(&dev->udev->dev, "%s: dev->tuner_type =0%d\n",
+		__func__, dev->tuner_type);
 	/* Set the RF and IF k_agc values to 4 for PAL/NTSC and 8 for
 	 * SECAM L/B/D standards */
 	status = vid_blk_read_word(dev, DIF_AGC_IF_REF, &dwval);
@@ -2213,7 +2238,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 	if (dev->power_mode != mode)
 		dev->power_mode = mode;
 	else {
-		pr_debug("%s: mode = %d, No Change req.\n",
+		dev_dbg(&dev->udev->dev, "%s: mode = %d, No Change req.\n",
 			 __func__, mode);
 		return 0;
 	}
@@ -2453,7 +2478,7 @@ int cx231xx_start_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	pr_debug("%s: ep_mask = %x\n", __func__, ep_mask);
+	dev_dbg(&dev->udev->dev, "%s: ep_mask = %x\n", __func__, ep_mask);
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				       value, 4);
 	if (status < 0)
@@ -2478,7 +2503,7 @@ int cx231xx_stop_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	pr_debug("%s: ep_mask = %x\n", __func__, ep_mask);
+	dev_dbg(&dev->udev->dev, "%s: ep_mask = %x\n", __func__, ep_mask);
 	status =
 	    cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET, value, 4);
 	if (status < 0)
@@ -2506,32 +2531,38 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 	if (dev->udev->speed == USB_SPEED_HIGH) {
 		switch (media_type) {
 		case Audio:
-			pr_debug("%s: Audio enter HANC\n", __func__);
+			dev_dbg(&dev->udev->dev,
+				"%s: Audio enter HANC\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x9300);
 			break;
 
 		case Vbi:
-			pr_debug("%s: set vanc registers\n", __func__);
+			dev_dbg(&dev->udev->dev,
+				"%s: set vanc registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x300);
 			break;
 
 		case Sliced_cc:
-			pr_debug("%s: set hanc registers\n", __func__);
+			dev_dbg(&dev->udev->dev,
+				"%s: set hanc registers\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x1300);
 			break;
 
 		case Raw_Video:
-			pr_debug("%s: set video registers\n", __func__);
+			dev_dbg(&dev->udev->dev,
+				"%s: set video registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			break;
 
 		case TS1_serial_mode:
-			pr_debug("%s: set ts1 registers", __func__);
+			dev_dbg(&dev->udev->dev,
+				"%s: set ts1 registers", __func__);
 
 			if (dev->board.has_417) {
-				pr_debug("%s: MPEG\n", __func__);
+				dev_dbg(&dev->udev->dev,
+					"%s: MPEG\n", __func__);
 				value &= 0xFFFFFFFC;
 				value |= 0x3;
 
@@ -2554,7 +2585,7 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 							VRT_SET_REGISTER,
 							TS1_LENGTH_REG, val, 4);
 			} else {
-				pr_debug("%s: BDA\n", __func__);
+				dev_dbg(&dev->udev->dev, "%s: BDA\n", __func__);
 				status = cx231xx_mode_register(dev,
 							 TS_MODE_REG, 0x101);
 				status = cx231xx_mode_register(dev,
@@ -2563,8 +2594,9 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 			break;
 
 		case TS1_parallel_mode:
-			pr_debug("%s: set ts1 parallel mode registers\n",
-				     __func__);
+			dev_dbg(&dev->udev->dev,
+				"%s: set ts1 parallel mode registers\n",
+				__func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			status = cx231xx_mode_register(dev, TS1_CFG_REG, 0x400);
 			break;
@@ -2917,8 +2949,9 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 			 (nCnt > 0));
 
 	if (nCnt == 0)
-		pr_debug("No ACK after %d msec -GPIO I2C failed!",
-			     nInit * 10);
+		dev_dbg(&dev->udev->dev,
+			"No ACK after %d msec -GPIO I2C failed!",
+			nInit * 10);
 
 	/*
 	 * readAck
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index d59f483102d2..2e8741314bce 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/usb.h>
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
@@ -856,8 +855,9 @@ int cx231xx_tuner_callback(void *ptr, int component, int command, int arg)
 
 	if (dev->tuner_type == TUNER_XC5000) {
 		if (command == XC5000_TUNER_RESET) {
-			pr_debug("Tuner CB: RESET: cmd %d : tuner type %d \n",
-				 command, dev->tuner_type);
+			dev_dbg(&dev->udev->dev,
+				"Tuner CB: RESET: cmd %d : tuner type %d\n",
+				command, dev->tuner_type);
 			cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit,
 					       1);
 			msleep(10);
@@ -915,7 +915,7 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
 
 	cx231xx_set_model(dev);
 
-	pr_info("Identified as %s (card=%d)\n",
+	dev_info(&dev->udev->dev, "Identified as %s (card=%d)\n",
 		dev->board.name, dev->model);
 
 	/* set the direction for GPIO pins */
@@ -989,7 +989,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 	/* start reading at offset 0 */
 	ret = i2c_transfer(client->adapter, &msg_write, 1);
 	if (ret < 0) {
-		pr_err("Can't read eeprom\n");
+		dev_err(&dev->udev->dev, "Can't read eeprom\n");
 		return ret;
 	}
 
@@ -999,7 +999,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 
 		ret = i2c_transfer(client->adapter, &msg_read, 1);
 		if (ret < 0) {
-			pr_err("Can't read eeprom\n");
+			dev_err(&dev->udev->dev, "Can't read eeprom\n");
 			return ret;
 		}
 		eedata_cur += msg_read.len;
@@ -1007,7 +1007,8 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 	}
 
 	for (i = 0; i + 15 < len; i += 16)
-		pr_debug("i2c eeprom %02x: %*ph\n", i, 16, &eedata[i]);
+		dev_dbg(&dev->udev->dev, "i2c eeprom %02x: %*ph\n",
+			i, 16, &eedata[i]);
 
 	return 0;
 }
@@ -1027,7 +1028,8 @@ void cx231xx_card_setup(struct cx231xx *dev)
 					cx231xx_get_i2c_adap(dev, I2C_0),
 					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
-			pr_err("cx25840 subdev registration failure\n");
+			dev_err(&dev->udev->dev,
+				"cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, load_fw);
 
 	}
@@ -1041,7 +1043,8 @@ void cx231xx_card_setup(struct cx231xx *dev)
 						    "tuner",
 						    dev->tuner_addr, NULL);
 		if (dev->sd_tuner == NULL)
-			pr_err("tuner subdev registration failure\n");
+			dev_err(&dev->udev->dev,
+				"tuner subdev registration failure\n");
 		else
 			cx231xx_config_tuner(dev);
 	}
@@ -1147,7 +1150,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/* Query cx231xx to find what pcb config it is related to */
 	retval = initialize_cx231xx(dev);
 	if (retval < 0) {
-		pr_err("Failed to read PCB config\n");
+		dev_err(&udev->dev, "Failed to read PCB config\n");
 		return retval;
 	}
 
@@ -1163,7 +1166,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 
 	retval = cx231xx_config(dev);
 	if (retval) {
-		pr_err("error configuring device\n");
+		dev_err(&udev->dev, "error configuring device\n");
 		return -ENOMEM;
 	}
 
@@ -1173,8 +1176,9 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/* register i2c bus */
 	retval = cx231xx_dev_init(dev);
 	if (retval) {
-		pr_err("%s: cx231xx_i2c_register - errCode [%d]!\n",
-			       __func__, retval);
+		dev_err(&udev->dev,
+			"%s: cx231xx_i2c_register - errCode [%d]!\n",
+			__func__, retval);
 		goto err_dev_init;
 	}
 
@@ -1195,7 +1199,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 
 	retval = cx231xx_config(dev);
 	if (retval) {
-		pr_err("%s: cx231xx_config - errCode [%d]!\n",
+		dev_err(&udev->dev, "%s: cx231xx_config - errCode [%d]!\n",
 			       __func__, retval);
 		goto err_dev_init;
 	}
@@ -1280,7 +1284,8 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	/* compute alternate max packet sizes for video */
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.video_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		pr_err("Video PCB interface #%d doesn't exist\n", idx);
+		dev_err(&dev->udev->dev,
+			"Video PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
 
@@ -1289,9 +1294,10 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	dev->video_mode.end_point_addr = uif->altsetting[0].endpoint[isoc_pipe].desc.bEndpointAddress;
 	dev->video_mode.num_alt = uif->num_altsetting;
 
-	pr_info("video EndPoint Addr 0x%x, Alternate settings: %i\n",
-		     dev->video_mode.end_point_addr,
-		     dev->video_mode.num_alt);
+	dev_info(&dev->udev->dev,
+		 "video EndPoint Addr 0x%x, Alternate settings: %i\n",
+		 dev->video_mode.end_point_addr,
+		 dev->video_mode.num_alt);
 
 	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
 	if (dev->video_mode.alt_max_pkt_size == NULL)
@@ -1300,15 +1306,17 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	for (i = 0; i < dev->video_mode.num_alt; i++) {
 		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
 		dev->video_mode.alt_max_pkt_size[i] = (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_debug("Alternate setting %i, max size= %i\n", i,
-			 dev->video_mode.alt_max_pkt_size[i]);
+		dev_dbg(&dev->udev->dev,
+			"Alternate setting %i, max size= %i\n", i,
+			dev->video_mode.alt_max_pkt_size[i]);
 	}
 
 	/* VBI Init */
 
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.vanc_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		pr_err("VBI PCB interface #%d doesn't exist\n", idx);
+		dev_err(&dev->udev->dev,
+			"VBI PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
 	uif = udev->actconfig->interface[idx];
@@ -1318,9 +1326,10 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->vbi_mode.num_alt = uif->num_altsetting;
-	pr_info("VBI EndPoint Addr 0x%x, Alternate settings: %i\n",
-		     dev->vbi_mode.end_point_addr,
-		     dev->vbi_mode.num_alt);
+	dev_info(&dev->udev->dev,
+		 "VBI EndPoint Addr 0x%x, Alternate settings: %i\n",
+		 dev->vbi_mode.end_point_addr,
+		 dev->vbi_mode.num_alt);
 
 	/* compute alternate max packet sizes for vbi */
 	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
@@ -1333,8 +1342,9 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 				desc.wMaxPacketSize);
 		dev->vbi_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_debug("Alternate setting %i, max size= %i\n", i,
-			 dev->vbi_mode.alt_max_pkt_size[i]);
+		dev_dbg(&dev->udev->dev,
+			"Alternate setting %i, max size= %i\n", i,
+			dev->vbi_mode.alt_max_pkt_size[i]);
 	}
 
 	/* Sliced CC VBI init */
@@ -1342,7 +1352,8 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	/* compute alternate max packet sizes for sliced CC */
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.hanc_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		pr_err("Sliced CC PCB interface #%d doesn't exist\n", idx);
+		dev_err(&dev->udev->dev,
+			"Sliced CC PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
 	uif = udev->actconfig->interface[idx];
@@ -1352,9 +1363,10 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->sliced_cc_mode.num_alt = uif->num_altsetting;
-	pr_info("sliced CC EndPoint Addr 0x%x, Alternate settings: %i\n",
-		dev->sliced_cc_mode.end_point_addr,
-		dev->sliced_cc_mode.num_alt);
+	dev_info(&dev->udev->dev,
+		 "sliced CC EndPoint Addr 0x%x, Alternate settings: %i\n",
+		 dev->sliced_cc_mode.end_point_addr,
+		 dev->sliced_cc_mode.num_alt);
 	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
 	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL)
 		return -ENOMEM;
@@ -1364,8 +1376,9 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 				desc.wMaxPacketSize);
 		dev->sliced_cc_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		pr_debug("Alternate setting %i, max size= %i\n", i,
-			 dev->sliced_cc_mode.alt_max_pkt_size[i]);
+		dev_dbg(&dev->udev->dev,
+			"Alternate setting %i, max size= %i\n", i,
+			dev->sliced_cc_mode.alt_max_pkt_size[i]);
 	}
 
 	return 0;
@@ -1389,6 +1402,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	struct usb_interface_assoc_descriptor *assoc_desc;
 
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
+	udev = usb_get_dev(interface_to_usbdev(interface));
 
 	/*
 	 * Interface number 0 - IR interface (handled by mceusb driver)
@@ -1402,13 +1416,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
 		if (nr >= CX231XX_MAXBOARDS) {
 			/* No free device slots */
-			pr_err("Supports only %i devices.\n", CX231XX_MAXBOARDS);
+			dev_err(&udev->dev,
+				"Supports only %i devices.\n",
+				CX231XX_MAXBOARDS);
 			return -ENOMEM;
 		}
 	} while (test_and_set_bit(nr, &cx231xx_devused));
 
-	udev = usb_get_dev(interface_to_usbdev(interface));
-
 	/* allocate memory for our device state and initialize it */
 	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
@@ -1458,13 +1472,14 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	pr_info("New device %s %s @ %s Mbps (%04x:%04x) with %d interfaces\n",
-		udev->manufacturer ? udev->manufacturer : "",
-		udev->product ? udev->product : "",
-		speed,
-		le16_to_cpu(udev->descriptor.idVendor),
-		le16_to_cpu(udev->descriptor.idProduct),
-		dev->max_iad_interface_count);
+	dev_info(&udev->dev,
+		 "New device %s %s @ %s Mbps (%04x:%04x) with %d interfaces\n",
+		 udev->manufacturer ? udev->manufacturer : "",
+		 udev->product ? udev->product : "",
+		 speed,
+		 le16_to_cpu(udev->descriptor.idVendor),
+		 le16_to_cpu(udev->descriptor.idProduct),
+		 dev->max_iad_interface_count);
 
 	/* increment interface count */
 	dev->interface_count++;
@@ -1474,12 +1489,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	assoc_desc = udev->actconfig->intf_assoc[0];
 	if (assoc_desc->bFirstInterface != ifnum) {
-		pr_err("Not found matching IAD interface\n");
+		dev_err(&udev->dev, "Not found matching IAD interface\n");
 		retval = -ENODEV;
 		goto err_if;
 	}
 
-	pr_debug("registering interface %d\n", ifnum);
+	dev_dbg(&udev->dev, "registering interface %d\n", ifnum);
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
@@ -1487,7 +1502,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* Create v4l2 device */
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
-		pr_err("v4l2_device_register failed\n");
+		dev_err(&udev->dev, "v4l2_device_register failed\n");
 		goto err_v4l2;
 	}
 
@@ -1504,7 +1519,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		/* compute alternate max packet sizes for TS1 */
 		idx = dev->current_pcb_config.hs_config_info[0].interface_info.ts1_index + 1;
 		if (idx >= dev->max_iad_interface_count) {
-			pr_err("TS1 PCB interface #%d doesn't exist\n", idx);
+			dev_err(&udev->dev,
+				"TS1 PCB interface #%d doesn't exist\n", idx);
 			retval = -ENODEV;
 			goto err_video_alt;
 		}
@@ -1515,9 +1531,10 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 				desc.bEndpointAddress;
 
 		dev->ts1_mode.num_alt = uif->num_altsetting;
-		pr_info("TS EndPoint Addr 0x%x, Alternate settings: %i\n",
-			     dev->ts1_mode.end_point_addr,
-			     dev->ts1_mode.num_alt);
+		dev_info(&udev->dev,
+			 "TS EndPoint Addr 0x%x, Alternate settings: %i\n",
+			 dev->ts1_mode.end_point_addr,
+			 dev->ts1_mode.num_alt);
 
 		dev->ts1_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->ts1_mode.num_alt, GFP_KERNEL);
 		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
@@ -1531,8 +1548,9 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 						wMaxPacketSize);
 			dev->ts1_mode.alt_max_pkt_size[i] =
 			    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-			pr_debug("Alternate setting %i, max size= %i\n", i,
-				     dev->ts1_mode.alt_max_pkt_size[i]);
+			dev_dbg(&udev->dev,
+				"Alternate setting %i, max size= %i\n", i,
+				dev->ts1_mode.alt_max_pkt_size[i]);
 		}
 	}
 
@@ -1596,8 +1614,9 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 	wake_up_interruptible_all(&dev->open);
 
 	if (dev->users) {
-		pr_warn("device %s is open! Deregistration and memory deallocation are deferred on close.\n",
-			video_device_node_name(dev->vdev));
+		dev_warn(&dev->udev->dev,
+			 "device %s is open! Deregistration and memory deallocation are deferred on close.\n",
+			 video_device_node_name(dev->vdev));
 
 		/* Even having users, it is safe to remove the RC i2c driver */
 		cx231xx_ir_exit(dev);
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 66e8f8ae9be4..36c3ecf204c1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -25,7 +25,6 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
@@ -228,7 +227,7 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0 && !dev->i2c_scan_running) {
-		pr_err("%s: failed with status -%d\n",
+		dev_err(&dev->udev->dev, "%s: failed with status -%d\n",
 			__func__, status);
 	}
 
@@ -523,7 +522,8 @@ int cx231xx_set_video_alternate(struct cx231xx *dev)
 		    usb_set_interface(dev->udev, usb_interface_index,
 				      dev->video_mode.alt);
 		if (errCode < 0) {
-			pr_err("cannot change alt number to %d (error=%i)\n",
+			dev_err(&dev->udev->dev,
+				"cannot change alt number to %d (error=%i)\n",
 				dev->video_mode.alt, errCode);
 			return errCode;
 		}
@@ -598,7 +598,8 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	}
 
 	if (alt > 0 && max_pkt_size == 0) {
-		pr_err("can't change interface %d alt no. to %d: Max. Pkt size = 0\n",
+		dev_err(&dev->udev->dev,
+			"can't change interface %d alt no. to %d: Max. Pkt size = 0\n",
 			usb_interface_index, alt);
 		/*To workaround error number=-71 on EP0 for videograbber,
 		 need add following codes.*/
@@ -613,7 +614,8 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	if (usb_interface_index > 0) {
 		status = usb_set_interface(dev->udev, usb_interface_index, alt);
 		if (status < 0) {
-			pr_err("can't change interface %d alt no. to %d (err=%i)\n",
+			dev_err(&dev->udev->dev,
+				"can't change interface %d alt no. to %d (err=%i)\n",
 				usb_interface_index, alt, status);
 			return status;
 		}
@@ -771,8 +773,9 @@ int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 			buffer, 4096, &actlen, 2000);
 
 	if (ret)
-		pr_err("bulk message failed: %d (%d/%d)", ret,
-				size, actlen);
+		dev_err(&dev->udev->dev,
+			"bulk message failed: %d (%d/%d)", ret,
+			size, actlen);
 	else {
 		errCode = actlen != size ? -1 : 0;
 	}
@@ -1008,14 +1011,16 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	dev->video_mode.isoc_ctl.urb =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.isoc_ctl.urb) {
-		pr_err("cannot alloc memory for usb buffers\n");
+		dev_err(&dev->udev->dev,
+			"cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
 	dev->video_mode.isoc_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.isoc_ctl.transfer_buffer) {
-		pr_err("cannot allocate memory for usbtransfer\n");
+		dev_err(&dev->udev->dev,
+			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.isoc_ctl.urb);
 		return -ENOMEM;
 	}
@@ -1035,7 +1040,8 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.isoc_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
 		if (!urb) {
-			pr_err("cannot alloc isoc_ctl.urb %i\n", i);
+			dev_err(&dev->udev->dev,
+				"cannot alloc isoc_ctl.urb %i\n", i);
 			cx231xx_uninit_isoc(dev);
 			return -ENOMEM;
 		}
@@ -1045,7 +1051,8 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				       &urb->transfer_dma);
 		if (!dev->video_mode.isoc_ctl.transfer_buffer[i]) {
-			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+			dev_err(&dev->udev->dev,
+				"unable to allocate %i bytes for transfer buffer %i%s\n",
 				sb_size, i,
 				in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_isoc(dev);
@@ -1079,7 +1086,8 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		rc = usb_submit_urb(dev->video_mode.isoc_ctl.urb[i],
 				    GFP_ATOMIC);
 		if (rc) {
-			pr_err("submit of urb %i failed (error=%i)\n", i,
+			dev_err(&dev->udev->dev,
+				"submit of urb %i failed (error=%i)\n", i,
 				rc);
 			cx231xx_uninit_isoc(dev);
 			return rc;
@@ -1140,14 +1148,16 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	dev->video_mode.bulk_ctl.urb =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.bulk_ctl.urb) {
-		pr_err("cannot alloc memory for usb buffers\n");
+		dev_err(&dev->udev->dev,
+			"cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
 	dev->video_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.bulk_ctl.transfer_buffer) {
-		pr_err("cannot allocate memory for usbtransfer\n");
+		dev_err(&dev->udev->dev,
+			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.bulk_ctl.urb);
 		return -ENOMEM;
 	}
@@ -1167,7 +1177,8 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.bulk_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			pr_err("cannot alloc bulk_ctl.urb %i\n", i);
+			dev_err(&dev->udev->dev,
+				"cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_bulk(dev);
 			return -ENOMEM;
 		}
@@ -1178,7 +1189,8 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				     &urb->transfer_dma);
 		if (!dev->video_mode.bulk_ctl.transfer_buffer[i]) {
-			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+			dev_err(&dev->udev->dev,
+				"unable to allocate %i bytes for transfer buffer %i%s\n",
 				sb_size, i,
 				in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_bulk(dev);
@@ -1200,7 +1212,8 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		rc = usb_submit_urb(dev->video_mode.bulk_ctl.urb[i],
 				    GFP_ATOMIC);
 		if (rc) {
-			pr_err("submit of urb %i failed (error=%i)\n", i,rc);
+			dev_err(&dev->udev->dev,
+				"submit of urb %i failed (error=%i)\n", i, rc);
 			cx231xx_uninit_bulk(dev);
 			return rc;
 		}
@@ -1303,7 +1316,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ENXTERNAL_AV);
 		if (errCode < 0) {
-			pr_err("%s: Failed to set Power - errCode [%d]!\n",
+			dev_err(&dev->udev->dev,
+				"%s: Failed to set Power - errCode [%d]!\n",
 				__func__, errCode);
 			return errCode;
 		}
@@ -1311,7 +1325,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ANALOGT_TV);
 		if (errCode < 0) {
-			pr_err("%s: Failed to set Power - errCode [%d]!\n",
+			dev_err(&dev->udev->dev,
+				"%s: Failed to set Power - errCode [%d]!\n",
 				__func__, errCode);
 			return errCode;
 		}
@@ -1325,13 +1340,15 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* initialize Colibri block */
 	errCode = cx231xx_afe_init_super_block(dev, 0x23c);
 	if (errCode < 0) {
-		pr_err("%s: cx231xx_afe init super block - errCode [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: cx231xx_afe init super block - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
 	}
 	errCode = cx231xx_afe_init_channels(dev);
 	if (errCode < 0) {
-		pr_err("%s: cx231xx_afe init channels - errCode [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: cx231xx_afe init channels - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
 	}
@@ -1339,7 +1356,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* Set DIF in By pass mode */
 	errCode = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 	if (errCode < 0) {
-		pr_err("%s: cx231xx_dif set to By pass mode - errCode [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: cx231xx_dif set to By pass mode - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
 	}
@@ -1347,7 +1365,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* I2S block related functions */
 	errCode = cx231xx_i2s_blk_initialize(dev);
 	if (errCode < 0) {
-		pr_err("%s: cx231xx_i2s block initialize - errCode [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: cx231xx_i2s block initialize - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
 	}
@@ -1355,7 +1374,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* init control pins */
 	errCode = cx231xx_init_ctrl_pin_status(dev);
 	if (errCode < 0) {
-		pr_err("%s: cx231xx_init ctrl pins - errCode [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: cx231xx_init ctrl pins - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
 	}
@@ -1381,7 +1401,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		break;
 	}
 	if (errCode < 0) {
-		pr_err("%s: cx231xx_AGC mode to Analog - errCode [%d]!\n",
+		dev_err(&dev->udev->dev,
+			"%s: cx231xx_AGC mode to Analog - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
 	}
@@ -1457,7 +1478,7 @@ int cx231xx_send_gpio_cmd(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0) {
-		pr_err("%s: failed with status -%d\n",
+		dev_err(&dev->udev->dev, "%s: failed with status -%d\n",
 			__func__, status);
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index b6af923eb5a3..044ad353d09b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -22,7 +22,6 @@
 #include "cx231xx.h"
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 
 #include <media/v4l2-common.h>
 #include <media/videobuf-vmalloc.h>
@@ -265,7 +264,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 	struct cx231xx *dev = dvb->adapter.priv;
 
 	if (dev->USE_ISO) {
-		pr_debug("DVB transfer mode is ISO.\n");
+		dev_dbg(&dev->udev->dev, "DVB transfer mode is ISO.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -276,7 +275,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 					dev->ts1_mode.max_pkt_size,
 					dvb_isoc_copy);
 	} else {
-		pr_debug("DVB transfer mode is BULK.\n");
+		dev_dbg(&dev->udev->dev, "DVB transfer mode is BULK.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -430,14 +429,17 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev)
 
 		if (dops->init != NULL && !dev->xc_fw_load_done) {
 
-			pr_debug("Reloading firmware for XC5000\n");
+			dev_dbg(&dev->udev->dev,
+				"Reloading firmware for XC5000\n");
 			status = dops->init(dev->dvb->frontend);
 			if (status == 0) {
 				dev->xc_fw_load_done = 1;
-				pr_debug("XC5000 firmware download completed\n");
+				dev_dbg(&dev->udev->dev,
+					"XC5000 firmware download completed\n");
 			} else {
 				dev->xc_fw_load_done = 0;
-				pr_debug("XC5000 firmware download failed !!!\n");
+				dev_dbg(&dev->udev->dev,
+					"XC5000 firmware download failed !!!\n");
 			}
 		}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index f99857e6c842..c4dc13afbe05 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -23,7 +23,6 @@
 #include "cx231xx.h"
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
 #include <media/v4l2-common.h>
@@ -502,18 +501,20 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	memset(&client, 0, sizeof(client));
 	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
 
-	pr_info("i2c_scan: checking for I2C devices on port=%d ..\n",
+	dev_info(&dev->udev->dev,
+		"i2c_scan: checking for I2C devices on port=%d ..\n",
 		i2c_port);
 	for (i = 0; i < 128; i++) {
 		client.addr = i;
 		rc = i2c_master_recv(&client, &buf, 0);
 		if (rc < 0)
 			continue;
-		pr_info("i2c scan: found device @ 0x%x  [%s]\n",
-			i << 1,
-			i2c_devs[i] ? i2c_devs[i] : "???");
+		dev_info(&dev->udev->dev,
+			 "i2c scan: found device @ 0x%x  [%s]\n",
+			 i << 1,
+			 i2c_devs[i] ? i2c_devs[i] : "???");
 	}
-	pr_info("i2c scan: Completed Checking for I2C devices on port=%d.\n",
+	dev_info(&dev->udev->dev, "i2c scan: Completed Checking for I2C devices on port=%d.\n",
 		i2c_port);
 
 	dev->i2c_scan_running = false;
@@ -539,7 +540,8 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	i2c_add_adapter(&bus->i2c_adap);
 
 	if (0 != bus->i2c_rc)
-		pr_warn("i2c bus %d register FAILED\n", bus->nr);
+		dev_warn(&dev->udev->dev,
+			 "i2c bus %d register FAILED\n", bus->nr);
 
 	return bus->i2c_rc;
 }
@@ -582,7 +584,8 @@ int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 				NULL);
 
 	if (!dev->i2c_mux_adap[mux_no])
-		pr_warn("i2c mux %d register FAILED\n", mux_no);
+		dev_warn(&dev->udev->dev,
+			 "i2c mux %d register FAILED\n", mux_no);
 
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 5ae2ce3f51b1..f954da6abf31 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -19,7 +19,6 @@
  */
 
 #include "cx231xx.h"
-#include <linux/usb.h>
 #include <linux/slab.h>
 #include <linux/bitrev.h>
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index 2f8dc6afac54..ee9d6225236a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -703,8 +703,8 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_BUSPOWER_DIF_ONLY;
 			break;
 		default:
-			pr_err("bad config in buspower!!!!\n");
-			pr_err("config_info=%x\n",
+			dev_err(&dev->udev->dev,
+				"bad config in buspower!!!!\nconfig_info=%x\n",
 				config_info & BUSPOWER_MASK);
 			return 1;
 		}
@@ -768,8 +768,8 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_SELFPOWER_COMPRESSOR;
 			break;
 		default:
-			pr_err("bad senario!!!!!\n");
-			pr_err("config_info=%x\n",
+			dev_err(&dev->udev->dev,
+				"bad senario!!!!!\nconfig_info=%x\n",
 				config_info & SELFPOWER_MASK);
 			return -ENODEV;
 		}
@@ -781,18 +781,29 @@ int initialize_cx231xx(struct cx231xx *dev)
 		   sizeof(struct pcb_config));
 
 	if (pcb_debug) {
-		pr_info("SC(0x00) register = 0x%x\n", config_info);
-		pr_info("scenario %d\n",
-			    (dev->current_pcb_config.index) + 1);
-		pr_info("type=%x\n", dev->current_pcb_config.type);
-		pr_info("mode=%x\n", dev->current_pcb_config.mode);
-		pr_info("speed=%x\n", dev->current_pcb_config.speed);
-		pr_info("ts1_source=%x\n",
-			     dev->current_pcb_config.ts1_source);
-		pr_info("ts2_source=%x\n",
-			     dev->current_pcb_config.ts2_source);
-		pr_info("analog_source=%x\n",
-			     dev->current_pcb_config.analog_source);
+		dev_info(&dev->udev->dev,
+			 "SC(0x00) register = 0x%x\n", config_info);
+		dev_info(&dev->udev->dev,
+			 "scenario %d\n",
+			 (dev->current_pcb_config.index) + 1);
+		dev_info(&dev->udev->dev,
+			"type=%x\n",
+			 dev->current_pcb_config.type);
+		dev_info(&dev->udev->dev,
+			 "mode=%x\n",
+			 dev->current_pcb_config.mode);
+		dev_info(&dev->udev->dev,
+			 "speed=%x\n",
+			 dev->current_pcb_config.speed);
+		dev_info(&dev->udev->dev,
+			 "ts1_source=%x\n",
+			 dev->current_pcb_config.ts1_source);
+		dev_info(&dev->udev->dev,
+			 "ts2_source=%x\n",
+			 dev->current_pcb_config.ts2_source);
+		dev_info(&dev->udev->dev,
+			 "analog_source=%x\n",
+			 dev->current_pcb_config.analog_source);
 	}
 
 	return 0;
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 14e1eb7f2128..9a562c80e0b1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/bitmap.h>
-#include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
@@ -69,9 +68,11 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 		break;
 	}
 	if (packet < 0) {
-		pr_err("URB status %d [%s].\n", status, errmsg);
+		dev_err(&dev->udev->dev,
+			"URB status %d [%s].\n", status, errmsg);
 	} else {
-		pr_err("URB packet %d, status %d [%s].\n",
+		dev_err(&dev->udev->dev,
+			"URB packet %d, status %d [%s].\n",
 			packet, status, errmsg);
 	}
 }
@@ -315,8 +316,8 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		pr_err("urb completition error %d.\n",
-			urb->status);
+		dev_err(&dev->udev->dev,
+			"urb completition error %d.\n",	urb->status);
 		break;
 	}
 
@@ -330,7 +331,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (urb->status) {
-		pr_err("urb resubmit failed (error=%i)\n",
+		dev_err(&dev->udev->dev, "urb resubmit failed (error=%i)\n",
 			urb->status);
 	}
 }
@@ -343,7 +344,7 @@ void cx231xx_uninit_vbi_isoc(struct cx231xx *dev)
 	struct urb *urb;
 	int i;
 
-	pr_debug("called cx231xx_uninit_vbi_isoc\n");
+	dev_dbg(&dev->udev->dev, "called cx231xx_uninit_vbi_isoc\n");
 
 	dev->vbi_mode.bulk_ctl.nfields = -1;
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
@@ -392,7 +393,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	struct urb *urb;
 	int rc;
 
-	pr_debug("called cx231xx_vbi_isoc\n");
+	dev_dbg(&dev->udev->dev, "called cx231xx_vbi_isoc\n");
 
 	/* De-allocates all pending stuff */
 	cx231xx_uninit_vbi_isoc(dev);
@@ -418,14 +419,16 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	dev->vbi_mode.bulk_ctl.urb = kzalloc(sizeof(void *) * num_bufs,
 					     GFP_KERNEL);
 	if (!dev->vbi_mode.bulk_ctl.urb) {
-		pr_err("cannot alloc memory for usb buffers\n");
+		dev_err(&dev->udev->dev,
+			"cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
 
 	dev->vbi_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->vbi_mode.bulk_ctl.transfer_buffer) {
-		pr_err("cannot allocate memory for usbtransfer\n");
+		dev_err(&dev->udev->dev,
+			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->vbi_mode.bulk_ctl.urb);
 		return -ENOMEM;
 	}
@@ -440,7 +443,8 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			pr_err("cannot alloc bulk_ctl.urb %i\n", i);
+			dev_err(&dev->udev->dev,
+				"cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_vbi_isoc(dev);
 			return -ENOMEM;
 		}
@@ -450,7 +454,8 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);
 		if (!dev->vbi_mode.bulk_ctl.transfer_buffer[i]) {
-			pr_err("unable to allocate %i bytes for transfer buffer %i%s\n",
+			dev_err(&dev->udev->dev,
+				"unable to allocate %i bytes for transfer buffer %i%s\n",
 				sb_size, i,
 				in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_vbi_isoc(dev);
@@ -469,7 +474,8 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
 		rc = usb_submit_urb(dev->vbi_mode.bulk_ctl.urb[i], GFP_ATOMIC);
 		if (rc) {
-			pr_err("submit of urb %i failed (error=%i)\n", i, rc);
+			dev_err(&dev->udev->dev,
+				"submit of urb %i failed (error=%i)\n", i, rc);
 			cx231xx_uninit_vbi_isoc(dev);
 			return rc;
 		}
@@ -520,7 +526,7 @@ static inline void vbi_buffer_filled(struct cx231xx *dev,
 				     struct cx231xx_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	/* pr_debug("[%p/%d] wakeup\n", buf, buf->vb.i); */
+	/* dev_dbg(&dev->udev->dev, "[%p/%d] wakeup\n", buf, buf->vb.i); */
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
@@ -612,7 +618,7 @@ static inline void get_next_vbi_buf(struct cx231xx_dmaqueue *dma_q,
 	char *outp;
 
 	if (list_empty(&dma_q->active)) {
-		pr_err("No active queue to serve\n");
+		dev_err(&dev->udev->dev, "No active queue to serve\n");
 		dev->vbi_mode.bulk_ctl.buf = NULL;
 		*buf = NULL;
 		return;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 4d1d750ab38d..5ea8124f5d20 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/bitmap.h>
-#include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
@@ -737,8 +736,9 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
-	/*pr_debug("urb_init=%d dev->video_mode.max_pkt_size=%d\n",
-		urb_init, dev->video_mode.max_pkt_size);*/
+	dev_dbg(&dev->udev->dev,
+		"urb_init=%d dev->video_mode.max_pkt_size=%d\n",
+		urb_init, dev->video_mode.max_pkt_size);
 	if (urb_init) {
 		dev->mode_tv = 0;
 		if (dev->USE_ISO)
@@ -809,7 +809,7 @@ void video_mux(struct cx231xx *dev, int index)
 
 	cx231xx_set_audio_input(dev, dev->ctl_ainput);
 
-	pr_debug("video_mux : %d\n", index);
+	dev_dbg(&dev->udev->dev, "video_mux : %d\n", index);
 
 	/* do mode control overrides if required */
 	cx231xx_do_mode_ctrl_overrides(dev);
@@ -861,7 +861,7 @@ static void res_free(struct cx231xx_fh *fh)
 static int check_dev(struct cx231xx *dev)
 {
 	if (dev->state & DEV_DISCONNECTED) {
-		pr_err("v4l2 ioctl: device not present\n");
+		dev_err(&dev->udev->dev, "v4l2 ioctl: device not present\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -953,12 +953,13 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		pr_err("%s: queue busy\n", __func__);
+		dev_err(&dev->udev->dev, "%s: queue busy\n", __func__);
 		return -EBUSY;
 	}
 
 	if (dev->stream_on && !fh->stream_on) {
-		pr_err("%s: device in use by another fh\n", __func__);
+		dev_err(&dev->udev->dev,
+			"%s: device in use by another fh\n", __func__);
 		return -EBUSY;
 	}
 
@@ -1176,8 +1177,9 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	int rc;
 	u32 if_frequency = 5400000;
 
-	pr_debug("Enter vidioc_s_frequency()f->frequency=%d;f->type=%d\n",
-		 f->frequency, f->type);
+	dev_dbg(&dev->udev->dev,
+		"Enter vidioc_s_frequency()f->frequency=%d;f->type=%d\n",
+		f->frequency, f->type);
 
 	rc = check_dev(dev);
 	if (rc < 0)
@@ -1212,13 +1214,14 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 		else if (dev->norm & V4L2_STD_SECAM_LC)
 			if_frequency = 1250000;  /*1.25MHz	*/
 
-		pr_debug("if_frequency is set to %d\n", if_frequency);
+		dev_dbg(&dev->udev->dev,
+			"if_frequency is set to %d\n", if_frequency);
 		cx231xx_set_Colibri_For_LowIF(dev, if_frequency, 1, 1);
 
 		update_HH_register_after_set_DIF(dev);
 	}
 
-	pr_debug("Set New FREQUENCY to %d\n", f->frequency);
+	dev_dbg(&dev->udev->dev, "Set New FREQUENCY to %d\n", f->frequency);
 
 	return rc;
 }
@@ -1522,7 +1525,8 @@ static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
 	struct cx231xx *dev = fh->dev;
 
 	if (dev->vbi_stream_on && !fh->stream_on) {
-		pr_err("%s device in use by another fh\n", __func__);
+		dev_err(&dev->udev->dev,
+			"%s device in use by another fh\n", __func__);
 		return -EBUSY;
 	}
 	return vidioc_try_fmt_vbi_cap(file, priv, f);
@@ -1641,16 +1645,15 @@ static int cx231xx_v4l2_open(struct file *filp)
 #if 0
 	errCode = cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);
 	if (errCode < 0) {
-		pr_err("Device locked on digital mode. Can't open analog\n");
+		dev_err(&dev->udev->dev,
+			"Device locked on digital mode. Can't open analog\n");
 		return -EBUSY;
 	}
 #endif
 
 	fh = kzalloc(sizeof(struct cx231xx_fh), GFP_KERNEL);
-	if (!fh) {
-		pr_err("cx231xx-video.c: Out of memory?!\n");
+	if (!fh)
 		return -ENOMEM;
-	}
 	if (mutex_lock_interruptible(&dev->lock)) {
 		kfree(fh);
 		return -ERESTARTSYS;
@@ -1734,7 +1737,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 		dev->radio_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		pr_info("V4L2 device %s deregistered\n",
+		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
 			video_device_node_name(dev->vbi_dev));
 		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
@@ -1743,7 +1746,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 		dev->vbi_dev = NULL;
 	}
 	if (dev->vdev) {
-		pr_info("V4L2 device %s deregistered\n",
+		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
 			video_device_node_name(dev->vdev));
 
 		if (dev->board.has_417)
@@ -2078,7 +2081,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 {
 	int ret;
 
-	pr_info("v4l2 driver version %s\n", CX231XX_VERSION);
+	dev_info(&dev->udev->dev, "v4l2 driver version %s\n", CX231XX_VERSION);
 
 	/* set default norm */
 	dev->norm = V4L2_STD_PAL;
@@ -2116,7 +2119,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* allocate and fill video video_device struct */
 	dev->vdev = cx231xx_vdev_init(dev, &cx231xx_video_template, "video");
 	if (!dev->vdev) {
-		pr_err("cannot allocate video_device.\n");
+		dev_err(&dev->udev->dev, "cannot allocate video_device.\n");
 		return -ENODEV;
 	}
 
@@ -2125,12 +2128,13 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
-		pr_err("unable to register video device (error=%i).\n",
+		dev_err(&dev->udev->dev,
+			"unable to register video device (error=%i).\n",
 			ret);
 		return ret;
 	}
 
-	pr_info("Registered video device %s [v4l2]\n",
+	dev_info(&dev->udev->dev, "Registered video device %s [v4l2]\n",
 		video_device_node_name(dev->vdev));
 
 	/* Initialize VBI template */
@@ -2141,7 +2145,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	dev->vbi_dev = cx231xx_vdev_init(dev, &cx231xx_vbi_template, "vbi");
 
 	if (!dev->vbi_dev) {
-		pr_err("cannot allocate video_device.\n");
+		dev_err(&dev->udev->dev, "cannot allocate video_device.\n");
 		return -ENODEV;
 	}
 	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
@@ -2149,28 +2153,30 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[dev->devno]);
 	if (ret < 0) {
-		pr_err("unable to register vbi device\n");
+		dev_err(&dev->udev->dev, "unable to register vbi device\n");
 		return ret;
 	}
 
-	pr_info("Registered VBI device %s\n",
+	dev_info(&dev->udev->dev, "Registered VBI device %s\n",
 		video_device_node_name(dev->vbi_dev));
 
 	if (cx231xx_boards[dev->model].radio.type == CX231XX_RADIO) {
 		dev->radio_dev = cx231xx_vdev_init(dev, &cx231xx_radio_template,
 						   "radio");
 		if (!dev->radio_dev) {
-			pr_err("cannot allocate video_device.\n");
+			dev_err(&dev->udev->dev,
+				"cannot allocate video_device.\n");
 			return -ENODEV;
 		}
 		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
 		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
-			pr_err("can't register radio device\n");
+			dev_err(&dev->udev->dev,
+				"can't register radio device\n");
 			return ret;
 		}
-		pr_info("Registered radio device as %s\n",
+		dev_info(&dev->udev->dev, "Registered radio device as %s\n",
 			video_device_node_name(dev->radio_dev));
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 253f2437c0f1..1a850da4e8c0 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -22,14 +22,13 @@
 #ifndef _CX231XX_H
 #define _CX231XX_H
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/videodev2.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/usb.h>
 
 #include <media/cx2341x.h>
 
-- 
1.9.3

