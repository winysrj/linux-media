Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaFHQzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:55:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/8] au0828/au8522: Add PAL-M support
Date: Sun,  8 Jun 2014 13:54:56 -0300
Message-Id: <1402246498-2532-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 40 +++++++++++++++++++++++-----
 drivers/media/dvb-frontends/au8522_priv.h    |  1 +
 drivers/media/usb/au0828/au0828-video.c      | 10 ++++---
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index b971c20624bf..33aa9410b624 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -248,12 +248,23 @@ static void setup_decoder_defaults(struct au8522_state *state, bool is_svideo)
 			AU8522_TVDEC_COMB_MODE_REG015H_CVBS);
 	au8522_writereg(state, AU8522_TVDED_DBG_MODE_REG060H,
 			AU8522_TVDED_DBG_MODE_REG060H_CVBS);
-	au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL1_REG061H,
-			AU8522_TVDEC_FORMAT_CTRL1_REG061H_FIELD_LEN_525 |
-			AU8522_TVDEC_FORMAT_CTRL1_REG061H_LINE_LEN_63_492 |
-			AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_MN);
-	au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL2_REG062H,
-			AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_NTSC);
+
+	if (state->std == V4L2_STD_PAL_M) {
+		au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL1_REG061H,
+				AU8522_TVDEC_FORMAT_CTRL1_REG061H_FIELD_LEN_525 |
+				AU8522_TVDEC_FORMAT_CTRL1_REG061H_LINE_LEN_63_492 |
+				AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_AUTO);
+		au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL2_REG062H,
+				AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_PAL_M);
+	} else {
+		/* NTSC */
+		au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL1_REG061H,
+				AU8522_TVDEC_FORMAT_CTRL1_REG061H_FIELD_LEN_525 |
+				AU8522_TVDEC_FORMAT_CTRL1_REG061H_LINE_LEN_63_492 |
+				AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_MN);
+		au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL2_REG062H,
+				AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_NTSC);
+	}
 	au8522_writereg(state, AU8522_TVDEC_VCR_DET_LLIM_REG063H,
 			AU8522_TVDEC_VCR_DET_LLIM_REG063H_CVBS);
 	au8522_writereg(state, AU8522_TVDEC_VCR_DET_HLIM_REG064H,
@@ -624,6 +635,21 @@ static int au8522_s_video_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int au8522_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct au8522_state *state = to_state(sd);
+
+	if ((std & (V4L2_STD_PAL_M | V4L2_STD_NTSC_M)) == 0)
+		return -EINVAL;
+
+	state->std = std;
+
+	if (state->operational_mode == AU8522_ANALOG_MODE)
+		au8522_video_set(state);
+
+	return 0;
+}
+
 static int au8522_s_audio_routing(struct v4l2_subdev *sd,
 					u32 input, u32 output, u32 config)
 {
@@ -681,6 +707,7 @@ static const struct v4l2_subdev_audio_ops au8522_audio_ops = {
 static const struct v4l2_subdev_video_ops au8522_video_ops = {
 	.s_routing = au8522_s_video_routing,
 	.s_stream = au8522_s_stream,
+	.s_std = au8522_s_std,
 };
 
 static const struct v4l2_subdev_ops au8522_ops = {
@@ -763,6 +790,7 @@ static int au8522_probe(struct i2c_client *client,
 	}
 
 	state->c = client;
+	state->std = V4L2_STD_NTSC_M;
 	state->vid_input = AU8522_COMPOSITE_CH1;
 	state->aud_input = AU8522_AUDIO_NONE;
 	state->id = 8522;
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index a781489520fb..b8aca1c84786 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -348,6 +348,7 @@ int au8522_led_ctrl(struct au8522_state *state, int led);
 /* Format control 2 */
 #define AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_AUTODETECT	0x00
 #define AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_NTSC		0x01
+#define AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_PAL_M		0x02
 
 
 #define AU8522_INPUT_CONTROL_REG081H_ATSC               	0xC4
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 9038194513c5..4aa1d7a1641b 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1364,9 +1364,11 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 
 	i2c_gate_ctrl(dev, 1);
 
-	/* FIXME: when we support something other than NTSC, we are going to
-	   have to make the au0828 bridge adjust the size of its capture
-	   buffer, which is currently hardcoded at 720x480 */
+	/*
+	 * FIXME: when we support something other than 60Hz standards,
+	 * we are going to have to make the au0828 bridge adjust the size
+	 * of its capture buffer, which is currently hardcoded at 720x480
+	 */
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, norm);
 
@@ -1915,7 +1917,7 @@ static const struct video_device au0828_video_template = {
 	.fops                       = &au0828_v4l_fops,
 	.release                    = video_device_release,
 	.ioctl_ops 		    = &video_ioctl_ops,
-	.tvnorms                    = V4L2_STD_NTSC_M,
+	.tvnorms                    = V4L2_STD_NTSC_M | V4L2_STD_PAL_M,
 };
 
 /**************************************************************************/
-- 
1.9.3

