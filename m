Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4046 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DWLvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:51:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/8] cx231xx: fix compiler warnings
Date: Mon, 23 Apr 2012 13:51:22 +0200
Message-Id: <a57fe13abc06ff18c4a7a4e653f6f228bb4ea533.1335181658.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
References: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-audio.c: In function ‘snd_cx231xx_hw_capture_params’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-audio.c:527:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-audio.c:526:31: warning: variable ‘format’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-audio.c:526:25: warning: variable ‘rate’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-audio.c:526:15: warning: variable ‘channels’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-audio.c: In function ‘snd_cx231xx_capture_trigger’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-audio.c:589:6: warning: variable ‘retval’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-video.c: In function ‘cx231xx_isoc_copy’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-video.c:331:17: warning: variable ‘outp’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-video.c: In function ‘cx231xx_bulk_copy’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-video.c:434:17: warning: variable ‘outp’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-video.c: In function ‘cx231xx_reset_video_buffer’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-video.c:704:7: warning: variable ‘outp’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c: In function ‘cx231xx_set_mode’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c:699:6: warning: variable ‘errCode’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c: In function ‘cx231xx_ep5_bulkout’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c:763:6: warning: variable ‘errCode’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c: In function ‘cx231xx_isoc_irq_callback’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c:800:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c: In function ‘cx231xx_bulk_irq_callback’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c:846:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c: In function ‘cx231xx_stop_TS1’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c:1234:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c: In function ‘cx231xx_start_TS1’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-core.c:1254:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_enable656’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:937:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_disable656’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:955:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_dump_HH_reg’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:1323:5: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_dump_SC_reg’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:1358:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_Setup_AFE_for_LowIF’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:1444:5: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_set_Colibri_For_LowIF’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:1504:5: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_set_DIF_bandpass’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:1559:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c: In function ‘cx231xx_gpio_i2c_write’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-avcore.c:3093:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-417.c: In function ‘cx231xx_initialize_codec’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-417.c:1098:9: warning: variable ‘data’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-417.c: In function ‘vidioc_streamon’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-417.c:1795:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-vbi.c: In function ‘cx231xx_isoc_vbi_copy’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-vbi.c:86:25: warning: variable ‘buf’ set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-vbi.c: In function ‘cx231xx_irq_vbi_callback’:
v4l-dvb-git/drivers/media/video/cx231xx/cx231xx-vbi.c:313:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx231xx/cx231xx-417.c    |   16 +--
 drivers/media/video/cx231xx/cx231xx-audio.c  |   17 +--
 drivers/media/video/cx231xx/cx231xx-avcore.c |  144 ++++++++++++--------------
 drivers/media/video/cx231xx/cx231xx-core.c   |   76 +++++++-------
 drivers/media/video/cx231xx/cx231xx-vbi.c    |    6 +-
 drivers/media/video/cx231xx/cx231xx-video.c  |   16 ---
 6 files changed, 121 insertions(+), 154 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index d4327da..4a03616c 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -1095,7 +1095,8 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 {
 	int version;
 	int retval;
-	u32 i, data[7];
+	u32 i;
+	/* u32 data[7]; */
 	u32 val = 0;
 
 	dprintk(1, "%s()\n", __func__);
@@ -1154,6 +1155,8 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 		CX231xx_CUSTOM_EXTENSION_USR_DATA, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		0, 0);
 */
+
+#if 0
 	/* Setup to capture VBI */
 	data[0] = 0x0001BD00;
 	data[1] = 1;          /* frames per interrupt */
@@ -1162,7 +1165,7 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 	data[4] = 0x206080C0; /* stop codes */
 	data[5] = 6;          /* lines */
 	data[6] = 64;         /* BPL */
-/*
+
 	cx231xx_api_cmd(dev, CX2341X_ENC_SET_VBI_CONFIG, 7, 0, data[0], data[1],
 		data[2], data[3], data[4], data[5], data[6]);
 
@@ -1175,7 +1178,7 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 		cx231xx_api_cmd(dev, CX2341X_ENC_SET_VBI_LINE, 5, 0,
 				i | 0x80000000, valid, 0, 0, 0);
 	}
-*/
+#endif
 /*	cx231xx_api_cmd(dev, CX2341X_ENC_MUTE_AUDIO, 1, 0, CX231xx_UNMUTE);
 	msleep(60);
 */
@@ -1792,17 +1795,16 @@ static int vidioc_streamon(struct file *file, void *priv,
 	struct cx231xx_fh  *fh  = file->private_data;
 
 	struct cx231xx *dev = fh->dev;
-	int rc = 0;
 	dprintk(3, "enter vidioc_streamon()\n");
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
-		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
+		cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (dev->USE_ISO)
-			rc = cx231xx_init_isoc(dev, CX231XX_NUM_PACKETS,
+			cx231xx_init_isoc(dev, CX231XX_NUM_PACKETS,
 				       CX231XX_NUM_BUFS,
 				       dev->video_mode.max_pkt_size,
 				       cx231xx_isoc_copy);
 		else {
-			rc = cx231xx_init_bulk(dev, 320,
+			cx231xx_init_bulk(dev, 320,
 				       5,
 				       dev->ts1_mode.max_pkt_size,
 				       cx231xx_bulk_copy);
diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/video/cx231xx/cx231xx-audio.c
index a2c2b7d..04af095 100644
--- a/drivers/media/video/cx231xx/cx231xx-audio.c
+++ b/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -523,21 +523,23 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 static int snd_cx231xx_hw_capture_params(struct snd_pcm_substream *substream,
 					 struct snd_pcm_hw_params *hw_params)
 {
-	unsigned int channels, rate, format;
+	/* unsigned int channels, rate, format; */
 	int ret;
 
 	dprintk("Setting capture parameters\n");
 
 	ret = snd_pcm_alloc_vmalloc_buffer(substream,
 					   params_buffer_bytes(hw_params));
+	/* TODO: set up cx231xx audio chip to deliver the correct audio format,
+	   current default is 48000hz multiplexed => 96000hz mono
+	   which shouldn't matter since analogue TV only supports mono
+
 	format = params_format(hw_params);
 	rate = params_rate(hw_params);
 	channels = params_channels(hw_params);
+	*/
 
-	/* TODO: set up cx231xx audio chip to deliver the correct audio format,
-	   current default is 48000hz multiplexed => 96000hz mono
-	   which shouldn't matter since analogue TV only supports mono */
-	return 0;
+	return ret;
 }
 
 static int snd_cx231xx_hw_capture_free(struct snd_pcm_substream *substream)
@@ -586,7 +588,7 @@ static int snd_cx231xx_capture_trigger(struct snd_pcm_substream *substream,
 				       int cmd)
 {
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
-	int retval;
+	int retval = 0;
 
 	if (dev->state & DEV_DISCONNECTED)
 		return -ENODEV;
@@ -601,12 +603,13 @@ static int snd_cx231xx_capture_trigger(struct snd_pcm_substream *substream,
 		break;
 	default:
 		retval = -EINVAL;
+		break;
 	}
 	spin_unlock(&dev->adev.slock);
 
 	schedule_work(&dev->wq_trigger);
 
-	return 0;
+	return retval;
 }
 
 static snd_pcm_uframes_t snd_cx231xx_capture_pointer(struct snd_pcm_substream
diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 53ff26e..6e4bca2 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -934,33 +934,29 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 void cx231xx_enable656(struct cx231xx *dev)
 {
 	u8 temp = 0;
-	int status;
 	/*enable TS1 data[0:7] as output to export 656*/
 
-	status = vid_blk_write_byte(dev, TS1_PIN_CTL0, 0xFF);
+	vid_blk_write_byte(dev, TS1_PIN_CTL0, 0xFF);
 
 	/*enable TS1 clock as output to export 656*/
 
-	status = vid_blk_read_byte(dev, TS1_PIN_CTL1, &temp);
+	vid_blk_read_byte(dev, TS1_PIN_CTL1, &temp);
 	temp = temp|0x04;
 
-	status = vid_blk_write_byte(dev, TS1_PIN_CTL1, temp);
-
+	vid_blk_write_byte(dev, TS1_PIN_CTL1, temp);
 }
 EXPORT_SYMBOL_GPL(cx231xx_enable656);
 
 void cx231xx_disable656(struct cx231xx *dev)
 {
 	u8 temp = 0;
-	int status;
-
 
-	status = vid_blk_write_byte(dev, TS1_PIN_CTL0, 0x00);
+	vid_blk_write_byte(dev, TS1_PIN_CTL0, 0x00);
 
-	status = vid_blk_read_byte(dev, TS1_PIN_CTL1, &temp);
+	vid_blk_read_byte(dev, TS1_PIN_CTL1, &temp);
 	temp = temp&0xFB;
 
-	status = vid_blk_write_byte(dev, TS1_PIN_CTL1, temp);
+	vid_blk_write_byte(dev, TS1_PIN_CTL1, temp);
 }
 EXPORT_SYMBOL_GPL(cx231xx_disable656);
 
@@ -1320,117 +1316,115 @@ void update_HH_register_after_set_DIF(struct cx231xx *dev)
 
 void cx231xx_dump_HH_reg(struct cx231xx *dev)
 {
-	u8 status = 0;
 	u32 value = 0;
 	u16  i = 0;
 
 	value = 0x45005390;
-	status = vid_blk_write_word(dev, 0x104, value);
+	vid_blk_write_word(dev, 0x104, value);
 
 	for (i = 0x100; i < 0x140; i++) {
-		status = vid_blk_read_word(dev, i, &value);
+		vid_blk_read_word(dev, i, &value);
 		cx231xx_info("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x300; i < 0x400; i++) {
-		status = vid_blk_read_word(dev, i, &value);
+		vid_blk_read_word(dev, i, &value);
 		cx231xx_info("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
 	for (i = 0x400; i < 0x440; i++) {
-		status = vid_blk_read_word(dev, i,  &value);
+		vid_blk_read_word(dev, i,  &value);
 		cx231xx_info("reg0x%x=0x%x\n", i, value);
 		i = i+3;
 	}
 
-	status = vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
+	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
 	cx231xx_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 	vid_blk_write_word(dev, AFE_CTRL_C2HH_SRC_CTRL, 0x4485D390);
-	status = vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
+	vid_blk_read_word(dev, AFE_CTRL_C2HH_SRC_CTRL, &value);
 	cx231xx_info("AFE_CTRL_C2HH_SRC_CTRL=0x%x\n", value);
 }
 
 void cx231xx_dump_SC_reg(struct cx231xx *dev)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
-	int status = 0;
 	cx231xx_info("cx231xx_dump_SC_reg!\n");
 
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", BOARD_CFG_STAT, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS_MODE_REG,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS_MODE_REG,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS_MODE_REG, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_CFG_REG,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_CFG_REG,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_CFG_REG, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_LENGTH_REG,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS1_LENGTH_REG,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS1_LENGTH_REG, value[0],
 				 value[1], value[2], value[3]);
 
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_CFG_REG,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_CFG_REG,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_CFG_REG, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_LENGTH_REG,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, TS2_LENGTH_REG,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", TS2_LENGTH_REG, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, EP_MODE_SET,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", EP_MODE_SET, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN1,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN1,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN1, value[0],
 				 value[1], value[2], value[3]);
 
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN2,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN2,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN2, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN3,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_PTN3,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_PTN3, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK0,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK0,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK0, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK1,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK1,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK1, value[0],
 				 value[1], value[2], value[3]);
 
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK2,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_PWR_MASK2,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_PWR_MASK2, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_GAIN,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_GAIN,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_GAIN, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_CAR_REG,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_CAR_REG,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_CAR_REG, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG1,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG1,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG1, value[0],
 				 value[1], value[2], value[3]);
 
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG2,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, CIR_OT_CFG2,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", CIR_OT_CFG2, value[0],
 				 value[1], value[2], value[3]);
-	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, PWR_CTL_EN,
+	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, PWR_CTL_EN,
 				 value, 4);
 	cx231xx_info("reg0x%x=0x%x 0x%x 0x%x 0x%x\n", PWR_CTL_EN, value[0],
 				 value[1], value[2], value[3]);
@@ -1441,18 +1435,15 @@ void cx231xx_dump_SC_reg(struct cx231xx *dev)
 void cx231xx_Setup_AFE_for_LowIF(struct cx231xx *dev)
 
 {
-	u8 status = 0;
 	u8 value = 0;
 
-
-
-	status = afe_read_byte(dev, ADC_STATUS2_CH3, &value);
+	afe_read_byte(dev, ADC_STATUS2_CH3, &value);
 	value = (value & 0xFE)|0x01;
-	status = afe_write_byte(dev, ADC_STATUS2_CH3, value);
+	afe_write_byte(dev, ADC_STATUS2_CH3, value);
 
-	status = afe_read_byte(dev, ADC_STATUS2_CH3, &value);
+	afe_read_byte(dev, ADC_STATUS2_CH3, &value);
 	value = (value & 0xFE)|0x00;
-	status = afe_write_byte(dev, ADC_STATUS2_CH3, value);
+	afe_write_byte(dev, ADC_STATUS2_CH3, value);
 
 
 /*
@@ -1464,44 +1455,43 @@ void cx231xx_Setup_AFE_for_LowIF(struct cx231xx *dev)
 		for low-if agc defect
 */
 
-	status = afe_read_byte(dev, ADC_NTF_PRECLMP_EN_CH3, &value);
+	afe_read_byte(dev, ADC_NTF_PRECLMP_EN_CH3, &value);
 	value = (value & 0xFC)|0x00;
-	status = afe_write_byte(dev, ADC_NTF_PRECLMP_EN_CH3, value);
+	afe_write_byte(dev, ADC_NTF_PRECLMP_EN_CH3, value);
 
-	status = afe_read_byte(dev, ADC_INPUT_CH3, &value);
+	afe_read_byte(dev, ADC_INPUT_CH3, &value);
 	value = (value & 0xF9)|0x02;
-	status = afe_write_byte(dev, ADC_INPUT_CH3, value);
+	afe_write_byte(dev, ADC_INPUT_CH3, value);
 
-	status = afe_read_byte(dev, ADC_FB_FRCRST_CH3, &value);
+	afe_read_byte(dev, ADC_FB_FRCRST_CH3, &value);
 	value = (value & 0xFB)|0x04;
-	status = afe_write_byte(dev, ADC_FB_FRCRST_CH3, value);
+	afe_write_byte(dev, ADC_FB_FRCRST_CH3, value);
 
-	status = afe_read_byte(dev, ADC_DCSERVO_DEM_CH3, &value);
+	afe_read_byte(dev, ADC_DCSERVO_DEM_CH3, &value);
 	value = (value & 0xFC)|0x03;
-	status = afe_write_byte(dev, ADC_DCSERVO_DEM_CH3, value);
+	afe_write_byte(dev, ADC_DCSERVO_DEM_CH3, value);
 
-	status = afe_read_byte(dev, ADC_CTRL_DAC1_CH3, &value);
+	afe_read_byte(dev, ADC_CTRL_DAC1_CH3, &value);
 	value = (value & 0xFB)|0x04;
-	status = afe_write_byte(dev, ADC_CTRL_DAC1_CH3, value);
+	afe_write_byte(dev, ADC_CTRL_DAC1_CH3, value);
 
-	status = afe_read_byte(dev, ADC_CTRL_DAC23_CH3, &value);
+	afe_read_byte(dev, ADC_CTRL_DAC23_CH3, &value);
 	value = (value & 0xF8)|0x06;
-	status = afe_write_byte(dev, ADC_CTRL_DAC23_CH3, value);
+	afe_write_byte(dev, ADC_CTRL_DAC23_CH3, value);
 
-	status = afe_read_byte(dev, ADC_CTRL_DAC23_CH3, &value);
+	afe_read_byte(dev, ADC_CTRL_DAC23_CH3, &value);
 	value = (value & 0x8F)|0x40;
-	status = afe_write_byte(dev, ADC_CTRL_DAC23_CH3, value);
+	afe_write_byte(dev, ADC_CTRL_DAC23_CH3, value);
 
-	status = afe_read_byte(dev, ADC_PWRDN_CLAMP_CH3, &value);
+	afe_read_byte(dev, ADC_PWRDN_CLAMP_CH3, &value);
 	value = (value & 0xDF)|0x20;
-	status = afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3, value);
+	afe_write_byte(dev, ADC_PWRDN_CLAMP_CH3, value);
 }
 
 void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 		 u8 spectral_invert, u32 mode)
 {
 	u32 colibri_carrier_offset = 0;
-	u8 status = 0;
 	u32 func_mode = 0x01; /* Device has a DIF if this function is called */
 	u32 standard = 0;
 	u8 value[4] = { 0, 0, 0, 0 };
@@ -1511,15 +1501,15 @@ void cx231xx_set_Colibri_For_LowIF(struct cx231xx *dev, u32 if_freq,
 	value[1] = (u8) 0x6F;
 	value[2] = (u8) 0x6F;
 	value[3] = (u8) 0x6F;
-	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+	cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
 					PWR_CTL_EN, value, 4);
 
 	/*Set colibri for low IF*/
-	status = cx231xx_afe_set_mode(dev, AFE_MODE_LOW_IF);
+	cx231xx_afe_set_mode(dev, AFE_MODE_LOW_IF);
 
 	/* Set C2HH for low IF operation.*/
 	standard = dev->norm;
-	status = cx231xx_dif_configure_C2HH_for_low_IF(dev, dev->active_mode,
+	cx231xx_dif_configure_C2HH_for_low_IF(dev, dev->active_mode,
 						       func_mode, standard);
 
 	/* Get colibri offsets.*/
@@ -1556,7 +1546,6 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		 u8 spectral_invert, u32 mode)
 {
 	unsigned long pll_freq_word;
-	int status = 0;
 	u32 dif_misc_ctrl_value = 0;
 	u64 pll_freq_u64 = 0;
 	u32 i = 0;
@@ -1567,7 +1556,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 
 	if (mode == TUNER_MODE_FM_RADIO) {
 		pll_freq_word = 0x905A1CAC;
-		status = vid_blk_write_word(dev, DIF_PLL_FREQ_WORD,  pll_freq_word);
+		vid_blk_write_word(dev, DIF_PLL_FREQ_WORD,  pll_freq_word);
 
 	} else /*KSPROPERTY_TUNER_MODE_TV*/{
 		/* Calculate the PLL frequency word based on the adjusted if_freq*/
@@ -1576,23 +1565,23 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		do_div(pll_freq_u64, 50000000);
 		pll_freq_word = (u32)pll_freq_u64;
 		/*pll_freq_word = 0x3463497;*/
-		status = vid_blk_write_word(dev, DIF_PLL_FREQ_WORD,  pll_freq_word);
+		vid_blk_write_word(dev, DIF_PLL_FREQ_WORD,  pll_freq_word);
 
 	if (spectral_invert) {
 		if_freq -= 400000;
 		/* Enable Spectral Invert*/
-		status = vid_blk_read_word(dev, DIF_MISC_CTRL,
+		vid_blk_read_word(dev, DIF_MISC_CTRL,
 					&dif_misc_ctrl_value);
 		dif_misc_ctrl_value = dif_misc_ctrl_value | 0x00200000;
-		status = vid_blk_write_word(dev, DIF_MISC_CTRL,
+		vid_blk_write_word(dev, DIF_MISC_CTRL,
 					dif_misc_ctrl_value);
 	} else {
 		if_freq += 400000;
 		/* Disable Spectral Invert*/
-		status = vid_blk_read_word(dev, DIF_MISC_CTRL,
+		vid_blk_read_word(dev, DIF_MISC_CTRL,
 					&dif_misc_ctrl_value);
 		dif_misc_ctrl_value = dif_misc_ctrl_value & 0xFFDFFFFF;
-		status = vid_blk_write_word(dev, DIF_MISC_CTRL,
+		vid_blk_write_word(dev, DIF_MISC_CTRL,
 					dif_misc_ctrl_value);
 	}
 
@@ -1609,7 +1598,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 			sizeof(Dif_set_array)/sizeof(struct dif_settings));
 	for (i = 0; i < sizeof(Dif_set_array)/sizeof(struct dif_settings); i++) {
 		if (Dif_set_array[i].if_freq == if_freq) {
-			status = vid_blk_write_word(dev,
+			vid_blk_write_word(dev,
 			Dif_set_array[i].register_address, Dif_set_array[i].value);
 		}
 	}
@@ -3090,31 +3079,30 @@ int cx231xx_gpio_i2c_read(struct cx231xx *dev, u8 dev_addr, u8 *buf, u8 len)
  */
 int cx231xx_gpio_i2c_write(struct cx231xx *dev, u8 dev_addr, u8 *buf, u8 len)
 {
-	int status = 0;
 	int i = 0;
 
 	/* get the lock */
 	mutex_lock(&dev->gpio_i2c_lock);
 
 	/* start */
-	status = cx231xx_gpio_i2c_start(dev);
+	cx231xx_gpio_i2c_start(dev);
 
 	/* write dev_addr */
-	status = cx231xx_gpio_i2c_write_byte(dev, dev_addr << 1);
+	cx231xx_gpio_i2c_write_byte(dev, dev_addr << 1);
 
 	/* read Ack */
-	status = cx231xx_gpio_i2c_read_ack(dev);
+	cx231xx_gpio_i2c_read_ack(dev);
 
 	for (i = 0; i < len; i++) {
 		/* Write data */
-		status = cx231xx_gpio_i2c_write_byte(dev, buf[i]);
+		cx231xx_gpio_i2c_write_byte(dev, buf[i]);
 
 		/* read Ack */
-		status = cx231xx_gpio_i2c_read_ack(dev);
+		cx231xx_gpio_i2c_read_ack(dev);
 	}
 
 	/* write End */
-	status = cx231xx_gpio_i2c_end(dev);
+	cx231xx_gpio_i2c_end(dev);
 
 	/* release the lock */
 	mutex_unlock(&dev->gpio_i2c_lock);
diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index 08dd930..05358d4 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -754,7 +754,7 @@ int cx231xx_set_mode(struct cx231xx *dev, enum cx231xx_mode set_mode)
 		}
 	}
 
-	return 0;
+	return errCode ? -EINVAL : 0;
 }
 EXPORT_SYMBOL_GPL(cx231xx_set_mode);
 
@@ -764,7 +764,7 @@ int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 	int actlen, ret = -ENOMEM;
 	u32 *buffer;
 
-buffer = kzalloc(4096, GFP_KERNEL);
+	buffer = kzalloc(4096, GFP_KERNEL);
 	if (buffer == NULL) {
 		cx231xx_info("out of mem\n");
 		return -ENOMEM;
@@ -772,16 +772,16 @@ buffer = kzalloc(4096, GFP_KERNEL);
 	memcpy(&buffer[0], firmware, 4096);
 
 	ret = usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 5),
-				 buffer, 4096, &actlen, 2000);
+			buffer, 4096, &actlen, 2000);
 
 	if (ret)
 		cx231xx_info("bulk message failed: %d (%d/%d)", ret,
-				 size, actlen);
+				size, actlen);
 	else {
 		errCode = actlen != size ? -1 : 0;
 	}
-kfree(buffer);
-	return 0;
+	kfree(buffer);
+	return errCode;
 }
 
 /*****************************************************************
@@ -797,7 +797,7 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev = container_of(vmode, struct cx231xx, video_mode);
-	int rc, i;
+	int i;
 
 	switch (urb->status) {
 	case 0:		/* success */
@@ -814,7 +814,7 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
 
 	/* Copy data from URB */
 	spin_lock(&dev->video_mode.slock);
-	rc = dev->video_mode.isoc_ctl.isoc_copy(dev, urb);
+	dev->video_mode.isoc_ctl.isoc_copy(dev, urb);
 	spin_unlock(&dev->video_mode.slock);
 
 	/* Reset urb buffers */
@@ -822,7 +822,6 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
 		urb->iso_frame_desc[i].status = 0;
 		urb->iso_frame_desc[i].actual_length = 0;
 	}
-	urb->status = 0;
 
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (urb->status) {
@@ -843,7 +842,6 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev = container_of(vmode, struct cx231xx, video_mode);
-	int rc;
 
 	switch (urb->status) {
 	case 0:		/* success */
@@ -860,12 +858,10 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
 
 	/* Copy data from URB */
 	spin_lock(&dev->video_mode.slock);
-	rc = dev->video_mode.bulk_ctl.bulk_copy(dev, urb);
+	dev->video_mode.bulk_ctl.bulk_copy(dev, urb);
 	spin_unlock(&dev->video_mode.slock);
 
 	/* Reset urb buffers */
-	urb->status = 0;
-
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (urb->status) {
 		cx231xx_isocdbg("urb resubmit failed (error=%i)\n",
@@ -1231,42 +1227,40 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 EXPORT_SYMBOL_GPL(cx231xx_init_bulk);
 void cx231xx_stop_TS1(struct cx231xx *dev)
 {
-	int status = 0;
 	u8 val[4] = { 0, 0, 0, 0 };
 
-			val[0] = 0x00;
-			val[1] = 0x03;
-			val[2] = 0x00;
-			val[3] = 0x00;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-				 TS_MODE_REG, val, 4);
-
-			val[0] = 0x00;
-			val[1] = 0x70;
-			val[2] = 0x04;
-			val[3] = 0x00;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-				 TS1_CFG_REG, val, 4);
+	val[0] = 0x00;
+	val[1] = 0x03;
+	val[2] = 0x00;
+	val[3] = 0x00;
+	cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+			TS_MODE_REG, val, 4);
+
+	val[0] = 0x00;
+	val[1] = 0x70;
+	val[2] = 0x04;
+	val[3] = 0x00;
+	cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+			TS1_CFG_REG, val, 4);
 }
 /* EXPORT_SYMBOL_GPL(cx231xx_stop_TS1); */
 void cx231xx_start_TS1(struct cx231xx *dev)
 {
-	int status = 0;
 	u8 val[4] = { 0, 0, 0, 0 };
 
-			val[0] = 0x03;
-			val[1] = 0x03;
-			val[2] = 0x00;
-			val[3] = 0x00;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-				 TS_MODE_REG, val, 4);
-
-			val[0] = 0x04;
-			val[1] = 0xA3;
-			val[2] = 0x3B;
-			val[3] = 0x00;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-				 TS1_CFG_REG, val, 4);
+	val[0] = 0x03;
+	val[1] = 0x03;
+	val[2] = 0x00;
+	val[3] = 0x00;
+	cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+			TS_MODE_REG, val, 4);
+
+	val[0] = 0x04;
+	val[1] = 0xA3;
+	val[2] = 0x3B;
+	val[3] = 0x00;
+	cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+			TS1_CFG_REG, val, 4);
 }
 /* EXPORT_SYMBOL_GPL(cx231xx_start_TS1); */
 /*****************************************************************
diff --git a/drivers/media/video/cx231xx/cx231xx-vbi.c b/drivers/media/video/cx231xx/cx231xx-vbi.c
index 8cdee5f..3d15314 100644
--- a/drivers/media/video/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/video/cx231xx/cx231xx-vbi.c
@@ -83,7 +83,6 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
  */
 static inline int cx231xx_isoc_vbi_copy(struct cx231xx *dev, struct urb *urb)
 {
-	struct cx231xx_buffer *buf;
 	struct cx231xx_dmaqueue *dma_q = urb->context;
 	int rc = 1;
 	unsigned char *p_buffer;
@@ -102,8 +101,6 @@ static inline int cx231xx_isoc_vbi_copy(struct cx231xx *dev, struct urb *urb)
 			return 0;
 	}
 
-	buf = dev->vbi_mode.bulk_ctl.buf;
-
 	/* get buffer pointer and length */
 	p_buffer = urb->transfer_buffer;
 	buffer_size = urb->actual_length;
@@ -310,7 +307,6 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	struct cx231xx_video_mode *vmode =
 	    container_of(dma_q, struct cx231xx_video_mode, vidq);
 	struct cx231xx *dev = container_of(vmode, struct cx231xx, vbi_mode);
-	int rc;
 
 	switch (urb->status) {
 	case 0:		/* success */
@@ -328,7 +324,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 
 	/* Copy data from URB */
 	spin_lock(&dev->vbi_mode.slock);
-	rc = dev->vbi_mode.bulk_ctl.bulk_copy(dev, urb);
+	dev->vbi_mode.bulk_ctl.bulk_copy(dev, urb);
 	spin_unlock(&dev->vbi_mode.slock);
 
 	/* Reset status */
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 7f916f0..32dd518 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -326,9 +326,7 @@ static inline void get_next_buf(struct cx231xx_dmaqueue *dma_q,
  */
 static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 {
-	struct cx231xx_buffer *buf;
 	struct cx231xx_dmaqueue *dma_q = urb->context;
-	unsigned char *outp = NULL;
 	int i, rc = 1;
 	unsigned char *p_buffer;
 	u32 bytes_parsed = 0, buffer_size = 0;
@@ -346,10 +344,6 @@ static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 			return 0;
 	}
 
-	buf = dev->video_mode.isoc_ctl.buf;
-	if (buf != NULL)
-		outp = videobuf_to_vmalloc(&buf->vb);
-
 	for (i = 0; i < urb->number_of_packets; i++) {
 		int status = urb->iso_frame_desc[i].status;
 
@@ -429,9 +423,7 @@ static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 
 static inline int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
 {
-	struct cx231xx_buffer *buf;
 	struct cx231xx_dmaqueue *dma_q = urb->context;
-	unsigned char *outp = NULL;
 	int rc = 1;
 	unsigned char *p_buffer;
 	u32 bytes_parsed = 0, buffer_size = 0;
@@ -449,10 +441,6 @@ static inline int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
 			return 0;
 	}
 
-	buf = dev->video_mode.bulk_ctl.buf;
-	if (buf != NULL)
-		outp = videobuf_to_vmalloc(&buf->vb);
-
 	if (1) {
 
 		/*  get buffer pointer and length */
@@ -701,13 +689,9 @@ void cx231xx_reset_video_buffer(struct cx231xx *dev,
 		buf = dev->video_mode.bulk_ctl.buf;
 
 	if (buf == NULL) {
-		u8 *outp = NULL;
 		/* first try to get the buffer */
 		get_next_buf(dma_q, &buf);
 
-		if (buf)
-			outp = videobuf_to_vmalloc(&buf->vb);
-
 		dma_q->pos = 0;
 		dma_q->field1_done = 0;
 		dma_q->current_field = -1;
-- 
1.7.10

