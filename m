Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaKCJxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 04:53:45 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCHv2] [media] cx231xx: Improve the log message
Date: Mon,  3 Nov 2014 07:53:33 -0200
Message-Id: <5160e17a27683578fae407f1395e04d2f815746b.1415008389.git.mchehab@osg.samsung.com>
In-Reply-To: <58ce9c7298818617bb1f83efd0443384bad816f4.1415005965.git.mchehab@osg.samsung.com>
References: <58ce9c7298818617bb1f83efd0443384bad816f4.1415005965.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunately, on devices that have multiple interfaces, udev->dev
points to the parent device (usb) instead of the cx231xx specific one.

Due to that the logs don't look too nice, as they'll print messages
as if they were produced by USB core:
  usb-1-2: New device Conexant Corporation Polaris AV Capturb @ 480 Mbps (1554:5010) with 7 interfaces

Instead of using the name of the parent device, let's use the name
of the first cx231xx interface for all cx231xx sub-modules.

With this path, the logs will be nicer:

  cx231xx 1-2:1.1: New device Conexant Corporation Polaris AV Capturb @ 480 Mbps (1554:5010) with 7 interfaces

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 0773da4dc29b..8998fa4a43f6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -987,25 +987,25 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 		IVTV_REG_APU, 0);
 
 	if (retval != 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: Error with mc417_register_write\n", __func__);
 		return -1;
 	}
 
 	retval = request_firmware(&firmware, CX231xx_FIRM_IMAGE_NAME,
-				  &dev->udev->dev);
+				  dev->dev);
 
 	if (retval != 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"ERROR: Hotplug firmware request failed (%s).\n",
 			CX231xx_FIRM_IMAGE_NAME);
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"Please fix your hotplug setup, the board will not work without firmware loaded!\n");
 		return -1;
 	}
 
 	if (firmware->size != CX231xx_FIRM_IMAGE_SIZE) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"ERROR: Firmware size mismatch (have %zd, expected %d)\n",
 			firmware->size, CX231xx_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
@@ -1013,7 +1013,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	}
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"ERROR: Firmware magic mismatch, wrong file?\n");
 		release_firmware(firmware);
 		return -1;
@@ -1061,7 +1061,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	retval |= mc417_register_write(dev, IVTV_REG_HW_BLOCKS,
 		IVTV_CMD_HW_BLOCKS_RST);
 	if (retval < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: Error with mc417_register_write\n",
 			__func__);
 		return retval;
@@ -1074,7 +1074,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	retval |= mc417_register_write(dev, IVTV_REG_VPU, value & 0xFFFFFFE8);
 
 	if (retval < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: Error with mc417_register_write\n",
 			__func__);
 		return retval;
@@ -1123,27 +1123,27 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 		dprintk(2, "%s: PING OK\n", __func__);
 		retval = cx231xx_load_firmware(dev);
 		if (retval < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"%s: f/w load failed\n", __func__);
 			return retval;
 		}
 		retval = cx231xx_find_mailbox(dev);
 		if (retval < 0) {
-			dev_err(&dev->udev->dev, "%s: mailbox < 0, error\n",
+			dev_err(dev->dev, "%s: mailbox < 0, error\n",
 				__func__);
 			return -1;
 		}
 		dev->cx23417_mailbox = retval;
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0);
 		if (retval < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"ERROR: cx23417 firmware ping failed!\n");
 			return -1;
 		}
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_GET_VERSION, 0, 1,
 			&version);
 		if (retval < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"ERROR: cx23417 firmware get encoder: version failed!\n");
 			return -1;
 		}
@@ -1425,7 +1425,7 @@ static int bb_buf_prepare(struct videobuf_queue *q,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"urb_init=%d dev->video_mode.max_pkt_size=%d\n",
 		urb_init, dev->video_mode.max_pkt_size);
 	dev->mode_tv = 1;
@@ -1698,7 +1698,7 @@ static int mpeg_open(struct file *file)
 			    sizeof(struct cx231xx_buffer), fh, &dev->lock);
 /*
 	videobuf_queue_sg_init(&fh->vidq, &cx231xx_qops,
-			    &dev->udev->dev, &dev->ts1.slock,
+			    dev->dev, &dev->ts1.slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx231xx_buffer),
diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index a05ae02e5245..6d9a03402faf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -48,7 +48,7 @@ static int cx231xx_isoc_audio_deinit(struct cx231xx *dev)
 {
 	int i;
 
-	dev_dbg(&dev->udev->dev, "Stopping isoc\n");
+	dev_dbg(dev->dev, "Stopping isoc\n");
 
 	for (i = 0; i < CX231XX_AUDIO_BUFS; i++) {
 		if (dev->adev.urb[i]) {
@@ -72,7 +72,7 @@ static int cx231xx_bulk_audio_deinit(struct cx231xx *dev)
 {
 	int i;
 
-	dev_dbg(&dev->udev->dev, "Stopping bulk\n");
+	dev_dbg(dev->dev, "Stopping bulk\n");
 
 	for (i = 0; i < CX231XX_AUDIO_BUFS; i++) {
 		if (dev->adev.urb[i]) {
@@ -116,7 +116,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		dev_dbg(&dev->udev->dev, "urb completition error %d.\n",
+		dev_dbg(dev->dev, "urb completition error %d.\n",
 			urb->status);
 		break;
 	}
@@ -176,7 +176,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"resubmit of audio urb failed (error=%i)\n",
 			status);
 	}
@@ -206,7 +206,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		dev_dbg(&dev->udev->dev, "urb completition error %d.\n",
+		dev_dbg(dev->dev, "urb completition error %d.\n",
 			urb->status);
 		break;
 	}
@@ -262,7 +262,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"resubmit of audio urb failed (error=%i)\n",
 			status);
 	}
@@ -274,7 +274,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"%s: Starting ISO AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
@@ -293,7 +293,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_ISO_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			dev_err(&dev->udev->dev, "usb_alloc_urb failed!\n");
+			dev_err(dev->dev, "usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
@@ -336,7 +336,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 	int i, errCode;
 	int sb_size;
 
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"%s: Starting BULK AUDIO transfers\n", __func__);
 
 	if (dev->state & DEV_DISCONNECTED)
@@ -355,7 +355,7 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			dev_err(&dev->udev->dev, "usb_alloc_urb failed!\n");
+			dev_err(dev->dev, "usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
@@ -393,7 +393,7 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 	struct snd_pcm_runtime *runtime = subs->runtime;
 	struct cx231xx *dev = snd_pcm_substream_chip(subs);
 
-	dev_dbg(&dev->udev->dev, "Allocating vbuffer\n");
+	dev_dbg(dev->dev, "Allocating vbuffer\n");
 	if (runtime->dma_area) {
 		if (runtime->dma_bytes > size)
 			return 0;
@@ -436,17 +436,17 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret = 0;
 
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"opening device and trying to acquire exclusive lock\n");
 
 	if (!dev) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"BUG: cx231xx can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
 	if (dev->state & DEV_DISCONNECTED) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"Can't open. the device was removed.\n");
 		return -ENODEV;
 	}
@@ -460,7 +460,7 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 		ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 0);
 	mutex_unlock(&dev->lock);
 	if (ret < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"failed to set alternate setting !\n");
 
 		return ret;
@@ -487,7 +487,7 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	int ret;
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 
-	dev_dbg(&dev->udev->dev, "closing device\n");
+	dev_dbg(dev->dev, "closing device\n");
 
 	/* inform hardware to stop streaming */
 	mutex_lock(&dev->lock);
@@ -497,7 +497,7 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	/* 1 - 48000 samples per sec */
 	ret = cx231xx_set_alt_setting(dev, INDEX_AUDIO, 0);
 	if (ret < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"failed to set alternate setting !\n");
 
 		mutex_unlock(&dev->lock);
@@ -508,10 +508,10 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	mutex_unlock(&dev->lock);
 
 	if (dev->adev.users == 0 && dev->adev.shutdown == 1) {
-		dev_dbg(&dev->udev->dev, "audio users: %d\n", dev->adev.users);
-		dev_dbg(&dev->udev->dev, "disabling audio stream!\n");
+		dev_dbg(dev->dev, "audio users: %d\n", dev->adev.users);
+		dev_dbg(dev->dev, "disabling audio stream!\n");
 		dev->adev.shutdown = 0;
-		dev_dbg(&dev->udev->dev, "released lock\n");
+		dev_dbg(dev->dev, "released lock\n");
 		if (atomic_read(&dev->stream_started) > 0) {
 			atomic_set(&dev->stream_started, 0);
 			schedule_work(&dev->wq_trigger);
@@ -526,7 +526,7 @@ static int snd_cx231xx_hw_capture_params(struct snd_pcm_substream *substream,
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 	int ret;
 
-	dev_dbg(&dev->udev->dev, "Setting capture parameters\n");
+	dev_dbg(dev->dev, "Setting capture parameters\n");
 
 	ret = snd_pcm_alloc_vmalloc_buffer(substream,
 					   params_buffer_bytes(hw_params));
@@ -548,7 +548,7 @@ static int snd_cx231xx_hw_capture_free(struct snd_pcm_substream *substream)
 {
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 
-	dev_dbg(&dev->udev->dev, "Stop capture, if needed\n");
+	dev_dbg(dev->dev, "Stop capture, if needed\n");
 
 	if (atomic_read(&dev->stream_started) > 0) {
 		atomic_set(&dev->stream_started, 0);
@@ -573,7 +573,7 @@ static void audio_trigger(struct work_struct *work)
 	struct cx231xx *dev = container_of(work, struct cx231xx, wq_trigger);
 
 	if (atomic_read(&dev->stream_started)) {
-		dev_dbg(&dev->udev->dev, "starting capture");
+		dev_dbg(dev->dev, "starting capture");
 		if (is_fw_load(dev) == 0)
 			cx25840_call(dev, core, load_fw);
 		if (dev->USE_ISO)
@@ -581,7 +581,7 @@ static void audio_trigger(struct work_struct *work)
 		else
 			cx231xx_init_audio_bulk(dev);
 	} else {
-		dev_dbg(&dev->udev->dev, "stopping capture");
+		dev_dbg(dev->dev, "stopping capture");
 		cx231xx_isoc_audio_deinit(dev);
 	}
 }
@@ -667,10 +667,10 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 		return 0;
 	}
 
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"probing for cx231xx non standard usbaudio\n");
 
-	err = snd_card_new(&dev->udev->dev, index[devnr], "Cx231xx Audio",
+	err = snd_card_new(dev->dev, index[devnr], "Cx231xx Audio",
 			   THIS_MODULE, 0, &card);
 	if (err < 0)
 		return err;
@@ -712,7 +712,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 			bEndpointAddress;
 
 	adev->num_alt = uif->num_altsetting;
-	dev_info(&dev->udev->dev,
+	dev_info(dev->dev,
 		"audio EndPoint Addr 0x%x, Alternate settings: %i\n",
 		adev->end_point_addr, adev->num_alt);
 	adev->alt_max_pkt_size = kmalloc(32 * adev->num_alt, GFP_KERNEL);
@@ -726,7 +726,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 				wMaxPacketSize);
 		adev->alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"audio alternate setting %i, max size= %i\n", i,
 			adev->alt_max_pkt_size[i]);
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index b299242a63dd..39e887925e3d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -82,10 +82,10 @@ void initGPIO(struct cx231xx *dev)
 	cx231xx_send_gpio_cmd(dev, _gpio_direction, (u8 *)&value, 4, 0, 0);
 
 	verve_read_byte(dev, 0x07, &val);
-	dev_dbg(&dev->udev->dev, "verve_read_byte address0x07=0x%x\n", val);
+	dev_dbg(dev->dev, "verve_read_byte address0x07=0x%x\n", val);
 	verve_write_byte(dev, 0x07, 0xF4);
 	verve_read_byte(dev, 0x07, &val);
-	dev_dbg(&dev->udev->dev, "verve_read_byte address0x07=0x%x\n", val);
+	dev_dbg(dev->dev, "verve_read_byte address0x07=0x%x\n", val);
 
 	cx231xx_capture_start(dev, 1, Vbi);
 
@@ -155,7 +155,7 @@ int cx231xx_afe_init_super_block(struct cx231xx *dev, u32 ref_count)
 	while (afe_power_status != 0x18) {
 		status = afe_write_byte(dev, SUP_BLK_PWRDN, 0x18);
 		if (status < 0) {
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: Init Super Block failed in send cmd\n",
 				__func__);
 			break;
@@ -164,14 +164,14 @@ int cx231xx_afe_init_super_block(struct cx231xx *dev, u32 ref_count)
 		status = afe_read_byte(dev, SUP_BLK_PWRDN, &afe_power_status);
 		afe_power_status &= 0xff;
 		if (status < 0) {
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: Init Super Block failed in receive cmd\n",
 				__func__);
 			break;
 		}
 		i++;
 		if (i == 10) {
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: Init Super Block force break in loop !!!!\n",
 				__func__);
 			status = -1;
@@ -412,7 +412,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 						0x00);
 		} else {
-			dev_dbg(&dev->udev->dev, "Invalid AV mode input\n");
+			dev_dbg(dev->dev, "Invalid AV mode input\n");
 			status = -1;
 		}
 		break;
@@ -469,7 +469,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 			status |= afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3,
 							0x40);
 		} else {
-			dev_dbg(&dev->udev->dev, "Invalid AV mode input\n");
+			dev_dbg(dev->dev, "Invalid AV mode input\n");
 			status = -1;
 		}
 	}			/* switch  */
@@ -575,7 +575,7 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 			status = cx231xx_set_power_mode(dev,
 					POLARIS_AVMODE_ENXTERNAL_AV);
 			if (status < 0) {
-				dev_err(&dev->udev->dev,
+				dev_err(dev->dev,
 					"%s: Failed to set Power - errCode [%d]!\n",
 					__func__, status);
 				return status;
@@ -593,7 +593,7 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 			status = cx231xx_set_power_mode(dev,
 						POLARIS_AVMODE_ANALOGT_TV);
 			if (status < 0) {
-				dev_err(&dev->udev->dev,
+				dev_err(dev->dev,
 					"%s: Failed to set Power - errCode [%d]!\n",
 					__func__, status);
 				return status;
@@ -610,7 +610,7 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 
 		break;
 	default:
-		dev_err(&dev->udev->dev, "%s: Unknown Input %d !\n",
+		dev_err(dev->dev, "%s: Unknown Input %d !\n",
 			__func__, INPUT(input)->type);
 		break;
 	}
@@ -630,7 +630,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	if (pin_type != dev->video_input) {
 		status = cx231xx_afe_adjust_ref_count(dev, pin_type);
 		if (status < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"%s: adjust_ref_count :Failed to set AFE input mux - errCode [%d]!\n",
 				__func__, status);
 			return status;
@@ -640,7 +640,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	/* call afe block to set video inputs */
 	status = cx231xx_afe_set_input_mux(dev, input);
 	if (status < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: set_input_mux :Failed to set AFE input mux - errCode [%d]!\n",
 			__func__, status);
 		return status;
@@ -672,7 +672,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode  */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
@@ -717,7 +717,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 		/* Tell DIF object to go to baseband mode */
 		status = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 		if (status < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				__func__, status);
 			return status;
@@ -792,7 +792,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			status = cx231xx_dif_set_standard(dev,
 							  DIF_USE_BASEBAND);
 			if (status < 0) {
-				dev_err(&dev->udev->dev,
+				dev_err(dev->dev,
 					"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 				       __func__, status);
 				return status;
@@ -828,7 +828,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 			/* Reinitialize the DIF */
 			status = cx231xx_dif_set_standard(dev, dev->norm);
 			if (status < 0) {
-				dev_err(&dev->udev->dev,
+				dev_err(dev->dev,
 					"%s: cx231xx_dif set to By pass mode- errCode [%d]!\n",
 					__func__, status);
 				return status;
@@ -972,14 +972,14 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 {
 	int status = 0;
 
-	dev_dbg(&dev->udev->dev, "%s: 0x%x\n",
+	dev_dbg(dev->dev, "%s: 0x%x\n",
 		__func__, (unsigned int)dev->norm);
 
 	/* Change the DFE_CTRL3 bp_percent to fix flagging */
 	status = vid_blk_write_word(dev, DFE_CTRL3, 0xCD3F0280);
 
 	if (dev->norm & (V4L2_STD_NTSC | V4L2_STD_PAL_M)) {
-		dev_dbg(&dev->udev->dev, "%s: NTSC\n", __func__);
+		dev_dbg(dev->dev, "%s: NTSC\n", __func__);
 
 		/* Move the close caption lines out of active video,
 		   adjust the active video start point */
@@ -1006,7 +1006,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							(FLD_HBLANK_CNT, 0x79));
 
 	} else if (dev->norm & V4L2_STD_SECAM) {
-		dev_dbg(&dev->udev->dev, "%s: SECAM\n", __func__);
+		dev_dbg(dev->dev, "%s: SECAM\n", __func__);
 		status =  cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1033,7 +1033,7 @@ int cx231xx_do_mode_ctrl_overrides(struct cx231xx *dev)
 							cx231xx_set_field
 							(FLD_HBLANK_CNT, 0x85));
 	} else {
-		dev_dbg(&dev->udev->dev, "%s: PAL\n", __func__);
+		dev_dbg(dev->dev, "%s: PAL\n", __func__);
 		status = cx231xx_read_modify_write_i2c_dword(dev,
 							VID_BLK_I2C_ADDRESS,
 							VERT_TIM_CTRL,
@@ -1208,7 +1208,7 @@ int cx231xx_set_audio_decoder_input(struct cx231xx *dev,
 			/* This is just a casual suggestion to people adding
 			   new boards in case they use a tuner type we don't
 			   currently know about */
-			dev_info(&dev->udev->dev,
+			dev_info(dev->dev,
 				 "Unknown tuner type configuring SIF");
 			break;
 		}
@@ -1334,127 +1334,127 @@ void cx231xx_dump_HH_reg(struct cx231xx *dev)
 
 	for (i = 0x100; i < 0x140; i++) {
 		vid_blk_read_word(dev, i, &value);
-		dev_dbg(&dev->udev->dev, "reg0x%x=0x%x\n", i, value);
+		dev_dbg(dev->dev, "reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x300; i < 0x400; i++) {
 		vid_blk_read_word(dev, i, &value);
-		dev_dbg(&dev->udev->dev, "reg0x%x=0x%x\n", i, value);
+		dev_dbg(dev->dev, "reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x400; i < 0x440; i++) {
 		vid_blk_read_word(dev, i,  &value);
-		dev_dbg(&dev->udev->dev, "reg0x%x=0x%x\n", i, value);
+		dev_dbg(dev->dev, "reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	dev_dbg(&dev->udev->dev, "AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	dev_dbg(dev->dev, "AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 	vid_blk_write_word(dev, AFE_CTRL_C2HH_SRC_CTRL, 0x4485D390);
 	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
-	dev_dbg(&dev->udev->dev, "AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
+	dev_dbg(dev->dev, "AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 }
 
 #if 0
 static void cx231xx_dump_SC_reg(struct cx231xx *dev)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
-	dev_dbg(&dev->udev->dev, "%s!\n", __func__);
+	dev_dbg(dev->dev, "%s!\n", __func__);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS_MODE_REG,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
 		 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_CFG_REG,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
 		 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_LENGTH_REG,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
 		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_CFG_REG,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_LENGTH_REG,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
 		 value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN1,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
 		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN2,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN3,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK0,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK1,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
 		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK2,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_GAIN,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_CAR_REG,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG1,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
 		value[1], value[2], value[3]);
 
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG2,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
 		value[1], value[2], value[3]);
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, PWR_CTL_EN,
 				 value, 4);
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
 		value[1], value[2], value[3]);
 }
@@ -1524,7 +1524,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	u32 standard = 0;
 	u8 value[4] = { 0, 0, 0, 0 };
 
-	dev_dbg(&dev->udev->dev, "Enter cx231xx_set_Colibri_For_LowIF()\n");
+	dev_dbg(dev->dev, "Enter cx231xx_set_Colibri_For_LowIF()\n");
 	value[0] = (u8) 0x6F;
 	value[1] = (u8) 0x6F;
 	value[2] = (u8) 0x6F;
@@ -1544,7 +1544,7 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	colibri_carrier_offset = cx231xx_Get_Colibri_CarrierOffset(mode,
 								   standard);
 
-	dev_dbg(&dev->udev->dev, "colibri_carrier_offset=%d, standard=0x%x\n",
+	dev_dbg(dev->dev, "colibri_carrier_offset=%d, standard=0x%x\n",
 		     colibri_carrier_offset, standard);
 
 	/* Set the band Pass filter for DIF*/
@@ -1578,7 +1578,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 	u64 pll_freq_u64 = 0;
 	u32 i = 0;
 
-	dev_dbg(&dev->udev->dev, "if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
+	dev_dbg(dev->dev, "if_freq=%d;spectral_invert=0x%x;mode=0x%x\n",
 		if_freq, spectral_invert, mode);
 
 
@@ -1622,7 +1622,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		if_freq = 16000000;
 	}
 
-	dev_dbg(&dev->udev->dev, "Enter IF=%zu\n", ARRAY_SIZE(Dif_set_array));
+	dev_dbg(dev->dev, "Enter IF=%zu\n", ARRAY_SIZE(Dif_set_array));
 	for (i = 0; i < ARRAY_SIZE(Dif_set_array); i++) {
 		if (Dif_set_array[i].if_freq == if_freq) {
 			vid_blk_write_word(dev,
@@ -1734,7 +1734,7 @@ int cx231xx_dif_set_standard(struct cx231xx *dev, u32 standard)
 	u32 dif_misc_ctrl_value = 0;
 	u32 func_mode = 0;
 
-	dev_dbg(&dev->udev->dev, "%s: setStandard to %x\n", __func__, standard);
+	dev_dbg(dev->dev, "%s: setStandard to %x\n", __func__, standard);
 
 	status = vid_blk_read_word(dev, DIF_MISC_CTRL, &dif_misc_ctrl_value);
 	if (standard != DIF_USE_BASEBAND)
@@ -2137,7 +2137,7 @@ int cx231xx_tuner_post_channel_change(struct cx231xx *dev)
 {
 	int status = 0;
 	u32 dwval;
-	dev_dbg(&dev->udev->dev, "%s: dev->tuner_type =0%d\n",
+	dev_dbg(dev->dev, "%s: dev->tuner_type =0%d\n",
 		__func__, dev->tuner_type);
 	/* Set the RF and IF k_agc values to 4 for PAL/NTSC and 8 for
 	 * SECAM L/B/D standards */
@@ -2239,7 +2239,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 	if (dev->power_mode != mode)
 		dev->power_mode = mode;
 	else {
-		dev_dbg(&dev->udev->dev, "%s: mode = %d, No Change req.\n",
+		dev_dbg(dev->dev, "%s: mode = %d, No Change req.\n",
 			 __func__, mode);
 		return 0;
 	}
@@ -2479,7 +2479,7 @@ int cx231xx_start_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	dev_dbg(&dev->udev->dev, "%s: ep_mask = %x\n", __func__, ep_mask);
+	dev_dbg(dev->dev, "%s: ep_mask = %x\n", __func__, ep_mask);
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				       value, 4);
 	if (status < 0)
@@ -2504,7 +2504,7 @@ int cx231xx_stop_stream(struct cx231xx *dev, u32 ep_mask)
 	u32 tmp = 0;
 	int status = 0;
 
-	dev_dbg(&dev->udev->dev, "%s: ep_mask = %x\n", __func__, ep_mask);
+	dev_dbg(dev->dev, "%s: ep_mask = %x\n", __func__, ep_mask);
 	status =
 	    cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET, value, 4);
 	if (status < 0)
@@ -2532,37 +2532,37 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 	if (dev->udev->speed == USB_SPEED_HIGH) {
 		switch (media_type) {
 		case Audio:
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: Audio enter HANC\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x9300);
 			break;
 
 		case Vbi:
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: set vanc registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x300);
 			break;
 
 		case Sliced_cc:
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: set hanc registers\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x1300);
 			break;
 
 		case Raw_Video:
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: set video registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			break;
 
 		case TS1_serial_mode:
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: set ts1 registers", __func__);
 
 			if (dev->board.has_417) {
-				dev_dbg(&dev->udev->dev,
+				dev_dbg(dev->dev,
 					"%s: MPEG\n", __func__);
 				value &= 0xFFFFFFFC;
 				value |= 0x3;
@@ -2586,7 +2586,7 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 							VRT_SET_REGISTER,
 							TS1_LENGTH_REG, val, 4);
 			} else {
-				dev_dbg(&dev->udev->dev, "%s: BDA\n", __func__);
+				dev_dbg(dev->dev, "%s: BDA\n", __func__);
 				status = cx231xx_mode_register(dev,
 							 TS_MODE_REG, 0x101);
 				status = cx231xx_mode_register(dev,
@@ -2595,7 +2595,7 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 			break;
 
 		case TS1_parallel_mode:
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"%s: set ts1 parallel mode registers\n",
 				__func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
@@ -2950,7 +2950,7 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 			 (nCnt > 0));
 
 	if (nCnt == 0)
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"No ACK after %d msec -GPIO I2C failed!",
 			nInit * 10);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 7156344e7022..ae05d591f228 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -855,7 +855,7 @@ int cx231xx_tuner_callback(void *ptr, int component, int command, int arg)
 
 	if (dev->tuner_type == TUNER_XC5000) {
 		if (command == XC5000_TUNER_RESET) {
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"Tuner CB: RESET: cmd %d : tuner type %d\n",
 				command, dev->tuner_type);
 			cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit,
@@ -915,7 +915,7 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
 
 	cx231xx_set_model(dev);
 
-	dev_info(&dev->udev->dev, "Identified as %s (card=%d)\n",
+	dev_info(dev->dev, "Identified as %s (card=%d)\n",
 		dev->board.name, dev->model);
 
 	/* set the direction for GPIO pins */
@@ -989,7 +989,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 	/* start reading at offset 0 */
 	ret = i2c_transfer(client->adapter, &msg_write, 1);
 	if (ret < 0) {
-		dev_err(&dev->udev->dev, "Can't read eeprom\n");
+		dev_err(dev->dev, "Can't read eeprom\n");
 		return ret;
 	}
 
@@ -999,7 +999,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 
 		ret = i2c_transfer(client->adapter, &msg_read, 1);
 		if (ret < 0) {
-			dev_err(&dev->udev->dev, "Can't read eeprom\n");
+			dev_err(dev->dev, "Can't read eeprom\n");
 			return ret;
 		}
 		eedata_cur += msg_read.len;
@@ -1007,7 +1007,7 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 	}
 
 	for (i = 0; i + 15 < len; i += 16)
-		dev_dbg(&dev->udev->dev, "i2c eeprom %02x: %*ph\n",
+		dev_dbg(dev->dev, "i2c eeprom %02x: %*ph\n",
 			i, 16, &eedata[i]);
 
 	return 0;
@@ -1028,7 +1028,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 					cx231xx_get_i2c_adap(dev, I2C_0),
 					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, load_fw);
 
@@ -1043,7 +1043,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 						    "tuner",
 						    dev->tuner_addr, NULL);
 		if (dev->sd_tuner == NULL)
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"tuner subdev registration failure\n");
 		else
 			cx231xx_config_tuner(dev);
@@ -1150,7 +1150,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/* Query cx231xx to find what pcb config it is related to */
 	retval = initialize_cx231xx(dev);
 	if (retval < 0) {
-		dev_err(&udev->dev, "Failed to read PCB config\n");
+		dev_err(dev->dev, "Failed to read PCB config\n");
 		return retval;
 	}
 
@@ -1166,7 +1166,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 
 	retval = cx231xx_config(dev);
 	if (retval) {
-		dev_err(&udev->dev, "error configuring device\n");
+		dev_err(dev->dev, "error configuring device\n");
 		return -ENOMEM;
 	}
 
@@ -1176,7 +1176,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/* register i2c bus */
 	retval = cx231xx_dev_init(dev);
 	if (retval) {
-		dev_err(&udev->dev,
+		dev_err(dev->dev,
 			"%s: cx231xx_i2c_register - errCode [%d]!\n",
 			__func__, retval);
 		goto err_dev_init;
@@ -1199,8 +1199,8 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 
 	retval = cx231xx_config(dev);
 	if (retval) {
-		dev_err(&udev->dev, "%s: cx231xx_config - errCode [%d]!\n",
-			       __func__, retval);
+		dev_err(dev->dev, "%s: cx231xx_config - errCode [%d]!\n",
+			__func__, retval);
 		goto err_dev_init;
 	}
 
@@ -1216,9 +1216,9 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	cx231xx_add_into_devlist(dev);
 
 	if (dev->board.has_417) {
-		dev_info(&udev->dev, "attach 417 %d\n", dev->model);
+		dev_info(dev->dev, "attach 417 %d\n", dev->model);
 		if (cx231xx_417_register(dev) < 0) {
-			dev_err(&udev->dev,
+			dev_err(dev->dev,
 				"%s() Failed to register 417 on VID_B\n",
 				__func__);
 		}
@@ -1284,7 +1284,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	/* compute alternate max packet sizes for video */
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.video_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"Video PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
@@ -1294,7 +1294,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	dev->video_mode.end_point_addr = uif->altsetting[0].endpoint[isoc_pipe].desc.bEndpointAddress;
 	dev->video_mode.num_alt = uif->num_altsetting;
 
-	dev_info(&dev->udev->dev,
+	dev_info(dev->dev,
 		 "video EndPoint Addr 0x%x, Alternate settings: %i\n",
 		 dev->video_mode.end_point_addr,
 		 dev->video_mode.num_alt);
@@ -1306,7 +1306,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	for (i = 0; i < dev->video_mode.num_alt; i++) {
 		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
 		dev->video_mode.alt_max_pkt_size[i] = (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"Alternate setting %i, max size= %i\n", i,
 			dev->video_mode.alt_max_pkt_size[i]);
 	}
@@ -1315,7 +1315,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.vanc_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"VBI PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
@@ -1326,7 +1326,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->vbi_mode.num_alt = uif->num_altsetting;
-	dev_info(&dev->udev->dev,
+	dev_info(dev->dev,
 		 "VBI EndPoint Addr 0x%x, Alternate settings: %i\n",
 		 dev->vbi_mode.end_point_addr,
 		 dev->vbi_mode.num_alt);
@@ -1342,7 +1342,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 				desc.wMaxPacketSize);
 		dev->vbi_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"Alternate setting %i, max size= %i\n", i,
 			dev->vbi_mode.alt_max_pkt_size[i]);
 	}
@@ -1352,7 +1352,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	/* compute alternate max packet sizes for sliced CC */
 	idx = dev->current_pcb_config.hs_config_info[0].interface_info.hanc_index + 1;
 	if (idx >= dev->max_iad_interface_count) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"Sliced CC PCB interface #%d doesn't exist\n", idx);
 		return -ENODEV;
 	}
@@ -1363,7 +1363,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 			bEndpointAddress;
 
 	dev->sliced_cc_mode.num_alt = uif->num_altsetting;
-	dev_info(&dev->udev->dev,
+	dev_info(dev->dev,
 		 "sliced CC EndPoint Addr 0x%x, Alternate settings: %i\n",
 		 dev->sliced_cc_mode.end_point_addr,
 		 dev->sliced_cc_mode.num_alt);
@@ -1376,7 +1376,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 				desc.wMaxPacketSize);
 		dev->sliced_cc_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"Alternate setting %i, max size= %i\n", i,
 			dev->sliced_cc_mode.alt_max_pkt_size[i]);
 	}
@@ -1392,6 +1392,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 			     const struct usb_device_id *id)
 {
 	struct usb_device *udev;
+	struct device *d = &interface->dev;
 	struct usb_interface *uif;
 	struct cx231xx *dev = NULL;
 	int retval = -ENODEV;
@@ -1416,7 +1417,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		nr = find_first_zero_bit(&cx231xx_devused, CX231XX_MAXBOARDS);
 		if (nr >= CX231XX_MAXBOARDS) {
 			/* No free device slots */
-			dev_err(&udev->dev,
+			dev_err(d,
 				"Supports only %i devices.\n",
 				CX231XX_MAXBOARDS);
 			return -ENOMEM;
@@ -1434,6 +1435,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->video_mode.alt = -1;
+	dev->dev = d;
 
 	dev->interface_count++;
 	/* reset gpio dir and value */
@@ -1472,7 +1474,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		speed = "unknown";
 	}
 
-	dev_info(&udev->dev,
+	dev_info(d,
 		 "New device %s %s @ %s Mbps (%04x:%04x) with %d interfaces\n",
 		 udev->manufacturer ? udev->manufacturer : "",
 		 udev->product ? udev->product : "",
@@ -1489,12 +1491,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	assoc_desc = udev->actconfig->intf_assoc[0];
 	if (assoc_desc->bFirstInterface != ifnum) {
-		dev_err(&udev->dev, "Not found matching IAD interface\n");
+		dev_err(d, "Not found matching IAD interface\n");
 		retval = -ENODEV;
 		goto err_if;
 	}
 
-	dev_dbg(&udev->dev, "registering interface %d\n", ifnum);
+	dev_dbg(d, "registering interface %d\n", ifnum);
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
@@ -1502,7 +1504,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* Create v4l2 device */
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
-		dev_err(&udev->dev, "v4l2_device_register failed\n");
+		dev_err(d, "v4l2_device_register failed\n");
 		goto err_v4l2;
 	}
 
@@ -1519,8 +1521,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		/* compute alternate max packet sizes for TS1 */
 		idx = dev->current_pcb_config.hs_config_info[0].interface_info.ts1_index + 1;
 		if (idx >= dev->max_iad_interface_count) {
-			dev_err(&udev->dev,
-				"TS1 PCB interface #%d doesn't exist\n", idx);
+			dev_err(d, "TS1 PCB interface #%d doesn't exist\n",
+				idx);
 			retval = -ENODEV;
 			goto err_video_alt;
 		}
@@ -1531,7 +1533,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 				desc.bEndpointAddress;
 
 		dev->ts1_mode.num_alt = uif->num_altsetting;
-		dev_info(&udev->dev,
+		dev_info(d,
 			 "TS EndPoint Addr 0x%x, Alternate settings: %i\n",
 			 dev->ts1_mode.end_point_addr,
 			 dev->ts1_mode.num_alt);
@@ -1548,9 +1550,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 						wMaxPacketSize);
 			dev->ts1_mode.alt_max_pkt_size[i] =
 			    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-			dev_dbg(&udev->dev,
-				"Alternate setting %i, max size= %i\n", i,
-				dev->ts1_mode.alt_max_pkt_size[i]);
+			dev_dbg(d, "Alternate setting %i, max size= %i\n",
+				i, dev->ts1_mode.alt_max_pkt_size[i]);
 		}
 	}
 
@@ -1614,7 +1615,7 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 	wake_up_interruptible_all(&dev->open);
 
 	if (dev->users) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 			 "device %s is open! Deregistration and memory deallocation are deferred on close.\n",
 			 video_device_node_name(dev->vdev));
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 64e907f02a02..4a3f28c4e8d3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -100,7 +100,7 @@ int cx231xx_register_extension(struct cx231xx_ops *ops)
 	list_add_tail(&ops->next, &cx231xx_extension_devlist);
 	list_for_each_entry(dev, &cx231xx_devlist, devlist) {
 		ops->init(dev);
-		dev_info(&dev->udev->dev, "%s initialized\n", ops->name);
+		dev_info(dev->dev, "%s initialized\n", ops->name);
 	}
 	mutex_unlock(&cx231xx_devlist_mutex);
 	return 0;
@@ -114,7 +114,7 @@ void cx231xx_unregister_extension(struct cx231xx_ops *ops)
 	mutex_lock(&cx231xx_devlist_mutex);
 	list_for_each_entry(dev, &cx231xx_devlist, devlist) {
 		ops->fini(dev);
-		dev_info(&dev->udev->dev, "%s removed\n", ops->name);
+		dev_info(dev->dev, "%s removed\n", ops->name);
 	}
 
 	list_del(&ops->next);
@@ -227,7 +227,7 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0 && !dev->i2c_scan_running) {
-		dev_err(&dev->udev->dev, "%s: failed with status -%d\n",
+		dev_err(dev->dev, "%s: failed with status -%d\n",
 			__func__, status);
 	}
 
@@ -522,7 +522,7 @@ int cx231xx_set_video_alternate(struct cx231xx *dev)
 		    usb_set_interface(dev->udev, usb_interface_index,
 				      dev->video_mode.alt);
 		if (errCode < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"cannot change alt number to %d (error=%i)\n",
 				dev->video_mode.alt, errCode);
 			return errCode;
@@ -598,7 +598,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	}
 
 	if (alt > 0 && max_pkt_size == 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"can't change interface %d alt no. to %d: Max. Pkt size = 0\n",
 			usb_interface_index, alt);
 		/*To workaround error number=-71 on EP0 for videograbber,
@@ -614,7 +614,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 	if (usb_interface_index > 0) {
 		status = usb_set_interface(dev->udev, usb_interface_index, alt);
 		if (status < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"can't change interface %d alt no. to %d (err=%i)\n",
 				usb_interface_index, alt, status);
 			return status;
@@ -773,7 +773,7 @@ int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 			buffer, 4096, &actlen, 2000);
 
 	if (ret)
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"bulk message failed: %d (%d/%d)", ret,
 			size, actlen);
 	else {
@@ -1011,7 +1011,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	dev->video_mode.isoc_ctl.urb =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.isoc_ctl.urb) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
@@ -1019,7 +1019,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	dev->video_mode.isoc_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.isoc_ctl.transfer_buffer) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.isoc_ctl.urb);
 		return -ENOMEM;
@@ -1040,7 +1040,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.isoc_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
 		if (!urb) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"cannot alloc isoc_ctl.urb %i\n", i);
 			cx231xx_uninit_isoc(dev);
 			return -ENOMEM;
@@ -1051,7 +1051,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				       &urb->transfer_dma);
 		if (!dev->video_mode.isoc_ctl.transfer_buffer[i]) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"unable to allocate %i bytes for transfer buffer %i%s\n",
 				sb_size, i,
 				in_interrupt() ? " while in int" : "");
@@ -1086,7 +1086,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		rc = usb_submit_urb(dev->video_mode.isoc_ctl.urb[i],
 				    GFP_ATOMIC);
 		if (rc) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"submit of urb %i failed (error=%i)\n", i,
 				rc);
 			cx231xx_uninit_isoc(dev);
@@ -1148,7 +1148,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	dev->video_mode.bulk_ctl.urb =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.bulk_ctl.urb) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
@@ -1156,7 +1156,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	dev->video_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.bulk_ctl.transfer_buffer) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.bulk_ctl.urb);
 		return -ENOMEM;
@@ -1177,7 +1177,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.bulk_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_bulk(dev);
 			return -ENOMEM;
@@ -1189,7 +1189,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		    usb_alloc_coherent(dev->udev, sb_size, GFP_KERNEL,
 				     &urb->transfer_dma);
 		if (!dev->video_mode.bulk_ctl.transfer_buffer[i]) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"unable to allocate %i bytes for transfer buffer %i%s\n",
 				sb_size, i,
 				in_interrupt() ? " while in int" : "");
@@ -1212,7 +1212,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 		rc = usb_submit_urb(dev->video_mode.bulk_ctl.urb[i],
 				    GFP_ATOMIC);
 		if (rc) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"submit of urb %i failed (error=%i)\n", i, rc);
 			cx231xx_uninit_bulk(dev);
 			return rc;
@@ -1316,7 +1316,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ENXTERNAL_AV);
 		if (errCode < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"%s: Failed to set Power - errCode [%d]!\n",
 				__func__, errCode);
 			return errCode;
@@ -1325,7 +1325,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ANALOGT_TV);
 		if (errCode < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"%s: Failed to set Power - errCode [%d]!\n",
 				__func__, errCode);
 			return errCode;
@@ -1340,14 +1340,14 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* initialize Colibri block */
 	errCode = cx231xx_afe_init_super_block(dev, 0x23c);
 	if (errCode < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: cx231xx_afe init super block - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
 	}
 	errCode = cx231xx_afe_init_channels(dev);
 	if (errCode < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: cx231xx_afe init channels - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
@@ -1356,7 +1356,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* Set DIF in By pass mode */
 	errCode = cx231xx_dif_set_standard(dev, DIF_USE_BASEBAND);
 	if (errCode < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: cx231xx_dif set to By pass mode - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
@@ -1365,7 +1365,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* I2S block related functions */
 	errCode = cx231xx_i2s_blk_initialize(dev);
 	if (errCode < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: cx231xx_i2s block initialize - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
@@ -1374,7 +1374,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* init control pins */
 	errCode = cx231xx_init_ctrl_pin_status(dev);
 	if (errCode < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: cx231xx_init ctrl pins - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
@@ -1401,7 +1401,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		break;
 	}
 	if (errCode < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: cx231xx_AGC mode to Analog - errCode [%d]!\n",
 			__func__, errCode);
 		return errCode;
@@ -1478,7 +1478,7 @@ int cx231xx_send_gpio_cmd(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val,
 	/* call common vendor command request */
 	status = cx231xx_send_vendor_cmd(dev, &ven_req);
 	if (status < 0) {
-		dev_err(&dev->udev->dev, "%s: failed with status -%d\n",
+		dev_err(dev->dev, "%s: failed with status -%d\n",
 			__func__, status);
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index a0d40bda718d..dd600b994e69 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -191,10 +191,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 		break;
 	}
 	if (packet < 0) {
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"URB status %d [%s].\n", status, errmsg);
 	} else {
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"URB packet %d, status %d [%s].\n",
 			packet, status, errmsg);
 	}
@@ -261,7 +261,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 	struct cx231xx *dev = dvb->adapter.priv;
 
 	if (dev->USE_ISO) {
-		dev_dbg(&dev->udev->dev, "DVB transfer mode is ISO.\n");
+		dev_dbg(dev->dev, "DVB transfer mode is ISO.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -272,7 +272,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 					dev->ts1_mode.max_pkt_size,
 					dvb_isoc_copy);
 	} else {
-		dev_dbg(&dev->udev->dev, "DVB transfer mode is BULK.\n");
+		dev_dbg(dev->dev, "DVB transfer mode is BULK.\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
@@ -374,21 +374,20 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 	cfg.i2c_addr = addr;
 
 	if (!dev->dvb->frontend) {
-		dev_err(&dev->udev->dev, "%s/2: dvb frontend not attached. "
+		dev_err(dev->dev, "%s/2: dvb frontend not attached. "
 		       "Can't attach xc5000\n", dev->name);
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc5000_attach, dev->dvb->frontend, &cfg);
 	if (!fe) {
-		dev_err(&dev->udev->dev,
-			"%s/2: xc5000 attach failed\n", dev->name);
+		dev_err(dev->dev, "%s/2: xc5000 attach failed\n", dev->name);
 		dvb_frontend_detach(dev->dvb->frontend);
 		dev->dvb->frontend = NULL;
 		return -EINVAL;
 	}
 
-	dev_info(&dev->udev->dev, "%s/2: xc5000 attached\n", dev->name);
+	dev_info(dev->dev, "%s/2: xc5000 attached\n", dev->name);
 
 	return 0;
 }
@@ -427,16 +426,16 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev)
 
 		if (dops->init != NULL && !dev->xc_fw_load_done) {
 
-			dev_dbg(&dev->udev->dev,
+			dev_dbg(dev->dev,
 				"Reloading firmware for XC5000\n");
 			status = dops->init(dev->dvb->frontend);
 			if (status == 0) {
 				dev->xc_fw_load_done = 1;
-				dev_dbg(&dev->udev->dev,
+				dev_dbg(dev->dev,
 					"XC5000 firmware download completed\n");
 			} else {
 				dev->xc_fw_load_done = 0;
-				dev_dbg(&dev->udev->dev,
+				dev_dbg(dev->dev,
 					"XC5000 firmware download failed !!!\n");
 			}
 		}
@@ -460,7 +459,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	result = dvb_register_adapter(&dvb->adapter, dev->name, module, device,
 				      adapter_nr);
 	if (result < 0) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 		       "%s: dvb_register_adapter failed (errno = %d)\n",
 		       dev->name, result);
 		goto fail_adapter;
@@ -474,7 +473,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->frontend);
 	if (result < 0) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 		       "%s: dvb_register_frontend failed (errno = %d)\n",
 		       dev->name, result);
 		goto fail_frontend;
@@ -492,7 +491,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 
 	result = dvb_dmx_init(&dvb->demux);
 	if (result < 0) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 			 "%s: dvb_dmx_init failed (errno = %d)\n",
 		       dev->name, result);
 		goto fail_dmx;
@@ -503,7 +502,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	dvb->dmxdev.capabilities = 0;
 	result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
 	if (result < 0) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 			 "%s: dvb_dmxdev_init failed (errno = %d)\n",
 			 dev->name, result);
 		goto fail_dmxdev;
@@ -512,7 +511,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	dvb->fe_hw.source = DMX_FRONTEND_0;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 		       "%s: add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
 		       dev->name, result);
 		goto fail_fe_hw;
@@ -521,7 +520,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	dvb->fe_mem.source = DMX_MEMORY_FE;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	if (result < 0) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 			 "%s: add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
 			 dev->name, result);
 		goto fail_fe_mem;
@@ -529,7 +528,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 
 	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 			 "%s: connect_frontend failed (errno = %d)\n",
 			 dev->name, result);
 		goto fail_fe_conn;
@@ -590,7 +589,7 @@ static int dvb_init(struct cx231xx *dev)
 	dvb = kzalloc(sizeof(struct cx231xx_dvb), GFP_KERNEL);
 
 	if (dvb == NULL) {
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "cx231xx_dvb: memory allocation failed\n");
 		return -ENOMEM;
 	}
@@ -613,7 +612,7 @@ static int dvb_init(struct cx231xx *dev)
 					demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach s5h1432 front end\n");
 			result = -EINVAL;
 			goto out_free;
@@ -638,7 +637,7 @@ static int dvb_init(struct cx231xx *dev)
 					       demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
 			goto out_free;
@@ -661,7 +660,7 @@ static int dvb_init(struct cx231xx *dev)
 					demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach s5h1432 front end\n");
 			result = -EINVAL;
 			goto out_free;
@@ -685,7 +684,7 @@ static int dvb_init(struct cx231xx *dev)
 					       demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
 			goto out_free;
@@ -703,7 +702,7 @@ static int dvb_init(struct cx231xx *dev)
 		break;
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "%s: looking for tuner / demod on i2c bus: %d\n",
 		       __func__, i2c_adapter_id(tuner_i2c));
 
@@ -712,7 +711,7 @@ static int dvb_init(struct cx231xx *dev)
 						tuner_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach LG3305 front end\n");
 			result = -EINVAL;
 			goto out_free;
@@ -734,7 +733,7 @@ static int dvb_init(struct cx231xx *dev)
 			);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
@@ -767,7 +766,7 @@ static int dvb_init(struct cx231xx *dev)
 			);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
@@ -812,7 +811,7 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "%s: looking for demod on i2c bus: %d\n",
 			 __func__, i2c_adapter_id(tuner_i2c));
 
@@ -821,7 +820,7 @@ static int dvb_init(struct cx231xx *dev)
 						demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"Failed to attach mb86a20s demod\n");
 			result = -EINVAL;
 			goto out_free;
@@ -836,26 +835,26 @@ static int dvb_init(struct cx231xx *dev)
 		break;
 
 	default:
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
 			dev->name);
 		break;
 	}
 	if (NULL == dvb->frontend) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 		       "%s/2: frontend initialization failed\n", dev->name);
 		result = -EINVAL;
 		goto out_free;
 	}
 
 	/* register everything */
-	result = register_dvb(dvb, THIS_MODULE, dev, &dev->udev->dev);
+	result = register_dvb(dvb, THIS_MODULE, dev, dev->dev);
 
 	if (result < 0)
 		goto out_free;
 
 
-	dev_info(&dev->udev->dev, "Successfully loaded cx231xx-dvb\n");
+	dev_info(dev->dev, "Successfully loaded cx231xx-dvb\n");
 
 ret:
 	cx231xx_set_mode(dev, CX231XX_SUSPEND);
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 7ccc33d33664..a29c345b027d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -507,7 +507,7 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 		rc = i2c_master_recv(&client, &buf, 0);
 		if (rc < 0)
 			continue;
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "i2c scan: found device @ port %d addr 0x%x  [%s]\n",
 			 i2c_port,
 			 i << 1,
@@ -528,7 +528,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	BUG_ON(!dev->cx231xx_send_usb_command);
 
 	bus->i2c_adap = cx231xx_adap_template;
-	bus->i2c_adap.dev.parent = &dev->udev->dev;
+	bus->i2c_adap.dev.parent = dev->dev;
 
 	snprintf(bus->i2c_adap.name, sizeof(bus->i2c_adap.name), "%s-%d", bus->dev->name, bus->nr);
 
@@ -537,7 +537,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	i2c_add_adapter(&bus->i2c_adap);
 
 	if (0 != bus->i2c_rc)
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 			 "i2c bus %d register FAILED\n", bus->nr);
 
 	return bus->i2c_rc;
@@ -569,7 +569,7 @@ int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 {
 	struct i2c_adapter *i2c_parent = &dev->i2c_bus[1].i2c_adap;
 	/* what is the correct mux_dev? */
-	struct device *mux_dev = &dev->udev->dev;
+	struct device *mux_dev = dev->dev;
 
 	dev->i2c_mux_adap[mux_no] = i2c_add_mux_adapter(i2c_parent,
 				mux_dev,
@@ -581,7 +581,7 @@ int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 				NULL);
 
 	if (!dev->i2c_mux_adap[mux_no])
-		dev_warn(&dev->udev->dev,
+		dev_warn(dev->dev,
 			 "i2c mux %d register FAILED\n", mux_no);
 
 	return 0;
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index f954da6abf31..15d8d1b5f05c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -62,7 +62,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	struct i2c_board_info info;
 	u8 ir_i2c_bus;
 
-	dev_dbg(&dev->udev->dev, "%s\n", __func__);
+	dev_dbg(dev->dev, "%s\n", __func__);
 
 	/* Only initialize if a rc keycode map is defined */
 	if (!cx231xx_boards[dev->model].rc_map_name)
@@ -97,7 +97,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 
 	/* Load and bind ir-kbd-i2c */
 	ir_i2c_bus = cx231xx_boards[dev->model].ir_i2c_master;
-	dev_dbg(&dev->udev->dev, "Trying to bind ir at bus %d, addr 0x%02x\n",
+	dev_dbg(dev->dev, "Trying to bind ir at bus %d, addr 0x%02x\n",
 		ir_i2c_bus, info.addr);
 	dev->ir_i2c_client = i2c_new_device(
 		cx231xx_get_i2c_adap(dev, ir_i2c_bus), &info);
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index ee9d6225236a..5bc74149fcb9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -703,7 +703,7 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_BUSPOWER_DIF_ONLY;
 			break;
 		default:
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"bad config in buspower!!!!\nconfig_info=%x\n",
 				config_info & BUSPOWER_MASK);
 			return 1;
@@ -768,7 +768,7 @@ int initialize_cx231xx(struct cx231xx *dev)
 			_current_scenario_idx = INDEX_SELFPOWER_COMPRESSOR;
 			break;
 		default:
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"bad senario!!!!!\nconfig_info=%x\n",
 				config_info & SELFPOWER_MASK);
 			return -ENODEV;
@@ -781,27 +781,27 @@ int initialize_cx231xx(struct cx231xx *dev)
 		   sizeof(struct pcb_config));
 
 	if (pcb_debug) {
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "SC(0x00) register = 0x%x\n", config_info);
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "scenario %d\n",
 			 (dev->current_pcb_config.index) + 1);
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			"type=%x\n",
 			 dev->current_pcb_config.type);
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "mode=%x\n",
 			 dev->current_pcb_config.mode);
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "speed=%x\n",
 			 dev->current_pcb_config.speed);
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "ts1_source=%x\n",
 			 dev->current_pcb_config.ts1_source);
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "ts2_source=%x\n",
 			 dev->current_pcb_config.ts2_source);
-		dev_info(&dev->udev->dev,
+		dev_info(dev->dev,
 			 "analog_source=%x\n",
 			 dev->current_pcb_config.analog_source);
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 9a562c80e0b1..80261ac40208 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -68,10 +68,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 		break;
 	}
 	if (packet < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"URB status %d [%s].\n", status, errmsg);
 	} else {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"URB packet %d, status %d [%s].\n",
 			packet, status, errmsg);
 	}
@@ -316,7 +316,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"urb completition error %d.\n",	urb->status);
 		break;
 	}
@@ -331,7 +331,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (urb->status) {
-		dev_err(&dev->udev->dev, "urb resubmit failed (error=%i)\n",
+		dev_err(dev->dev, "urb resubmit failed (error=%i)\n",
 			urb->status);
 	}
 }
@@ -344,7 +344,7 @@ void cx231xx_uninit_vbi_isoc(struct cx231xx *dev)
 	struct urb *urb;
 	int i;
 
-	dev_dbg(&dev->udev->dev, "called cx231xx_uninit_vbi_isoc\n");
+	dev_dbg(dev->dev, "called cx231xx_uninit_vbi_isoc\n");
 
 	dev->vbi_mode.bulk_ctl.nfields = -1;
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
@@ -393,7 +393,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	struct urb *urb;
 	int rc;
 
-	dev_dbg(&dev->udev->dev, "called cx231xx_vbi_isoc\n");
+	dev_dbg(dev->dev, "called cx231xx_vbi_isoc\n");
 
 	/* De-allocates all pending stuff */
 	cx231xx_uninit_vbi_isoc(dev);
@@ -419,7 +419,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	dev->vbi_mode.bulk_ctl.urb = kzalloc(sizeof(void *) * num_bufs,
 					     GFP_KERNEL);
 	if (!dev->vbi_mode.bulk_ctl.urb) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"cannot alloc memory for usb buffers\n");
 		return -ENOMEM;
 	}
@@ -427,7 +427,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	dev->vbi_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->vbi_mode.bulk_ctl.transfer_buffer) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->vbi_mode.bulk_ctl.urb);
 		return -ENOMEM;
@@ -443,7 +443,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_vbi_isoc(dev);
 			return -ENOMEM;
@@ -454,7 +454,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);
 		if (!dev->vbi_mode.bulk_ctl.transfer_buffer[i]) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"unable to allocate %i bytes for transfer buffer %i%s\n",
 				sb_size, i,
 				in_interrupt() ? " while in int" : "");
@@ -474,7 +474,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
 		rc = usb_submit_urb(dev->vbi_mode.bulk_ctl.urb[i], GFP_ATOMIC);
 		if (rc) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"submit of urb %i failed (error=%i)\n", i, rc);
 			cx231xx_uninit_vbi_isoc(dev);
 			return rc;
@@ -526,7 +526,7 @@ static inline void vbi_buffer_filled(struct cx231xx *dev,
 				     struct cx231xx_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	/* dev_dbg(&dev->udev->dev, "[%p/%d] wakeup\n", buf, buf->vb.i); */
+	/* dev_dbg(dev->dev, "[%p/%d] wakeup\n", buf, buf->vb.i); */
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
@@ -618,7 +618,7 @@ static inline void get_next_vbi_buf(struct cx231xx_dmaqueue *dma_q,
 	char *outp;
 
 	if (list_empty(&dma_q->active)) {
-		dev_err(&dev->udev->dev, "No active queue to serve\n");
+		dev_err(dev->dev, "No active queue to serve\n");
 		dev->vbi_mode.bulk_ctl.buf = NULL;
 		*buf = NULL;
 		return;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index c5b5e9541669..4c5bba2e89f4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -736,7 +736,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"urb_init=%d dev->video_mode.max_pkt_size=%d\n",
 		urb_init, dev->video_mode.max_pkt_size);
 	if (urb_init) {
@@ -809,7 +809,7 @@ void video_mux(struct cx231xx *dev, int index)
 
 	cx231xx_set_audio_input(dev, dev->ctl_ainput);
 
-	dev_dbg(&dev->udev->dev, "video_mux : %d\n", index);
+	dev_dbg(dev->dev, "video_mux : %d\n", index);
 
 	/* do mode control overrides if required */
 	cx231xx_do_mode_ctrl_overrides(dev);
@@ -861,7 +861,7 @@ static void res_free(struct cx231xx_fh *fh)
 static int check_dev(struct cx231xx *dev)
 {
 	if (dev->state & DEV_DISCONNECTED) {
-		dev_err(&dev->udev->dev, "v4l2 ioctl: device not present\n");
+		dev_err(dev->dev, "v4l2 ioctl: device not present\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -953,12 +953,12 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		dev_err(&dev->udev->dev, "%s: queue busy\n", __func__);
+		dev_err(dev->dev, "%s: queue busy\n", __func__);
 		return -EBUSY;
 	}
 
 	if (dev->stream_on && !fh->stream_on) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s: device in use by another fh\n", __func__);
 		return -EBUSY;
 	}
@@ -1177,7 +1177,7 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	int rc;
 	u32 if_frequency = 5400000;
 
-	dev_dbg(&dev->udev->dev,
+	dev_dbg(dev->dev,
 		"Enter vidioc_s_frequency()f->frequency=%d;f->type=%d\n",
 		f->frequency, f->type);
 
@@ -1214,14 +1214,14 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 		else if (dev->norm & V4L2_STD_SECAM_LC)
 			if_frequency = 1250000;  /*1.25MHz	*/
 
-		dev_dbg(&dev->udev->dev,
+		dev_dbg(dev->dev,
 			"if_frequency is set to %d\n", if_frequency);
 		cx231xx_set_Colibri_For_LowIF(dev, if_frequency, 1, 1);
 
 		update_HH_register_after_set_DIF(dev);
 	}
 
-	dev_dbg(&dev->udev->dev, "Set New FREQUENCY to %d\n", f->frequency);
+	dev_dbg(dev->dev, "Set New FREQUENCY to %d\n", f->frequency);
 
 	return rc;
 }
@@ -1525,7 +1525,7 @@ static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
 	struct cx231xx *dev = fh->dev;
 
 	if (dev->vbi_stream_on && !fh->stream_on) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"%s device in use by another fh\n", __func__);
 		return -EBUSY;
 	}
@@ -1645,7 +1645,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 #if 0
 	errCode = cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);
 	if (errCode < 0) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"Device locked on digital mode. Can't open analog\n");
 		return -EBUSY;
 	}
@@ -1737,7 +1737,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 		dev->radio_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
+		dev_info(dev->dev, "V4L2 device %s deregistered\n",
 			video_device_node_name(dev->vbi_dev));
 		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
@@ -1746,7 +1746,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 		dev->vbi_dev = NULL;
 	}
 	if (dev->vdev) {
-		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
+		dev_info(dev->dev, "V4L2 device %s deregistered\n",
 			video_device_node_name(dev->vdev));
 
 		if (dev->board.has_417)
@@ -2081,7 +2081,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 {
 	int ret;
 
-	dev_info(&dev->udev->dev, "v4l2 driver version %s\n", CX231XX_VERSION);
+	dev_info(dev->dev, "v4l2 driver version %s\n", CX231XX_VERSION);
 
 	/* set default norm */
 	dev->norm = V4L2_STD_PAL;
@@ -2119,7 +2119,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* allocate and fill video video_device struct */
 	dev->vdev = cx231xx_vdev_init(dev, &cx231xx_video_template, "video");
 	if (!dev->vdev) {
-		dev_err(&dev->udev->dev, "cannot allocate video_device.\n");
+		dev_err(dev->dev, "cannot allocate video_device.\n");
 		return -ENODEV;
 	}
 
@@ -2128,13 +2128,13 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
 	if (ret) {
-		dev_err(&dev->udev->dev,
+		dev_err(dev->dev,
 			"unable to register video device (error=%i).\n",
 			ret);
 		return ret;
 	}
 
-	dev_info(&dev->udev->dev, "Registered video device %s [v4l2]\n",
+	dev_info(dev->dev, "Registered video device %s [v4l2]\n",
 		video_device_node_name(dev->vdev));
 
 	/* Initialize VBI template */
@@ -2145,7 +2145,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	dev->vbi_dev = cx231xx_vdev_init(dev, &cx231xx_vbi_template, "vbi");
 
 	if (!dev->vbi_dev) {
-		dev_err(&dev->udev->dev, "cannot allocate video_device.\n");
+		dev_err(dev->dev, "cannot allocate video_device.\n");
 		return -ENODEV;
 	}
 	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
@@ -2153,18 +2153,18 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[dev->devno]);
 	if (ret < 0) {
-		dev_err(&dev->udev->dev, "unable to register vbi device\n");
+		dev_err(dev->dev, "unable to register vbi device\n");
 		return ret;
 	}
 
-	dev_info(&dev->udev->dev, "Registered VBI device %s\n",
+	dev_info(dev->dev, "Registered VBI device %s\n",
 		video_device_node_name(dev->vbi_dev));
 
 	if (cx231xx_boards[dev->model].radio.type == CX231XX_RADIO) {
 		dev->radio_dev = cx231xx_vdev_init(dev, &cx231xx_radio_template,
 						   "radio");
 		if (!dev->radio_dev) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"cannot allocate video_device.\n");
 			return -ENODEV;
 		}
@@ -2172,11 +2172,11 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
-			dev_err(&dev->udev->dev,
+			dev_err(dev->dev,
 				"can't register radio device\n");
 			return ret;
 		}
-		dev_info(&dev->udev->dev, "Registered radio device as %s\n",
+		dev_info(dev->dev, "Registered radio device as %s\n",
 			video_device_node_name(dev->radio_dev));
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 1a850da4e8c0..f9e262eb0db9 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -597,6 +597,7 @@ struct cx231xx {
 	char name[30];		/* name (including minor) of the device */
 	int model;		/* index in the device_data struct */
 	int devno;		/* marks the number of this device */
+	struct device *dev;	/* pointer to USB interface's dev */
 
 	struct cx231xx_board board;
 
-- 
1.9.3

