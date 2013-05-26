Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1189 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3EZN1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/24] cx88: remove g_chip_ident.
Date: Sun, 26 May 2013 15:27:02 +0200
Message-Id: <1369574839-6687-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove g_chip_ident from cx88. Also remove the v4l2-chip-ident.h include.
The board code used defines from v4l2-chip-ident.h to tell the driver which
audio chip is used. Replace this with a cx88-specific enum.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-alsa.c  |    6 +++---
 drivers/media/pci/cx88/cx88-cards.c |   12 ++++++------
 drivers/media/pci/cx88/cx88-video.c |   27 +++++----------------------
 drivers/media/pci/cx88/cx88.h       |    8 ++++++--
 4 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 27d6262..ce02105 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -615,7 +615,7 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 	int changed = 0;
 	u32 old;
 
-	if (core->board.audio_chip == V4L2_IDENT_WM8775)
+	if (core->board.audio_chip == CX88_AUDIO_WM8775)
 		snd_cx88_wm8775_volume_put(kcontrol, value);
 
 	left = value->value.integer.value[0] & 0x3f;
@@ -682,7 +682,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 		vol ^= bit;
 		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
 		/* Pass mute onto any WM8775 */
-		if ((core->board.audio_chip == V4L2_IDENT_WM8775) &&
+		if ((core->board.audio_chip == CX88_AUDIO_WM8775) &&
 		    ((1<<6) == bit))
 			wm8775_s_ctrl(core, V4L2_CID_AUDIO_MUTE, 0 != (vol & bit));
 		ret = 1;
@@ -903,7 +903,7 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 		goto error;
 
 	/* If there's a wm8775 then add a Line-In ALC switch */
-	if (core->board.audio_chip == V4L2_IDENT_WM8775)
+	if (core->board.audio_chip == CX88_AUDIO_WM8775)
 		snd_ctl_add(card, snd_ctl_new1(&snd_cx88_alc_switch, chip));
 
 	strcpy (card->driver, "CX88x");
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index a87a0e1..e18a7ac 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -744,7 +744,7 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		/* Some variants use a tda9874 and so need the tvaudio module. */
-		.audio_chip     = V4L2_IDENT_TVAUDIO,
+		.audio_chip     = CX88_AUDIO_TVAUDIO,
 		.input          = {{
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -976,7 +976,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.audio_chip	= V4L2_IDENT_WM8775,
+		.audio_chip	= CX88_AUDIO_WM8775,
 		.i2sinputcntl   = 2,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
@@ -1014,7 +1014,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.audio_chip = V4L2_IDENT_WM8775,
+		.audio_chip = CX88_AUDIO_WM8775,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
@@ -1376,7 +1376,7 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.audio_chip     = V4L2_IDENT_WM8775,
+		.audio_chip     = CX88_AUDIO_WM8775,
 		.input          = {{
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -1461,7 +1461,7 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.audio_chip     = V4L2_IDENT_WM8775,
+		.audio_chip     = CX88_AUDIO_WM8775,
 		/*
 		 * gpio0 as reported by Mike Crash <mike AT mikecrash.com>
 		 */
@@ -1929,7 +1929,7 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.audio_chip     = V4L2_IDENT_WM8775,
+		.audio_chip     = CX88_AUDIO_WM8775,
 		/*
 		 * GPIO0 (WINTV2000)
 		 *
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 1b00615..6b3a9ae 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -386,7 +386,7 @@ int cx88_video_mux(struct cx88_core *core, unsigned int input)
 		   the initialization. Some boards may use different
 		   routes for different inputs. HVR-1300 surely does */
 		if (core->board.audio_chip &&
-		    core->board.audio_chip == V4L2_IDENT_WM8775) {
+		    core->board.audio_chip == CX88_AUDIO_WM8775) {
 			call_all(core, audio, s_routing,
 				 INPUT(input).audioroute, 0, 0);
 		}
@@ -772,7 +772,7 @@ static int video_open(struct file *file)
 		cx_write(MO_GP2_IO, core->board.radio.gpio2);
 		if (core->board.radio.audioroute) {
 			if(core->board.audio_chip &&
-				core->board.audio_chip == V4L2_IDENT_WM8775) {
+				core->board.audio_chip == CX88_AUDIO_WM8775) {
 				call_all(core, audio, s_routing,
 					core->board.radio.audioroute, 0, 0);
 			}
@@ -959,7 +959,7 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 	u32 value,mask;
 
 	/* Pass changes onto any WM8775 */
-	if (core->board.audio_chip == V4L2_IDENT_WM8775) {
+	if (core->board.audio_chip == CX88_AUDIO_WM8775) {
 		switch (ctrl->id) {
 		case V4L2_CID_AUDIO_MUTE:
 			wm8775_s_ctrl(core, ctrl->id, ctrl->val);
@@ -1355,24 +1355,12 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	return cx88_set_freq(core, f);
 }
 
-static int vidioc_g_chip_ident(struct file *file, void *priv,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	if (!v4l2_chip_match_host(&chip->match))
-		return -EINVAL;
-	chip->revision = 0;
-	chip->ident = V4L2_IDENT_UNKNOWN;
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register (struct file *file, void *fh,
 				struct v4l2_dbg_register *reg)
 {
 	struct cx88_core *core = ((struct cx8800_fh*)fh)->dev->core;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
 	/* cx2388x has a 24-bit register space */
 	reg->val = cx_read(reg->reg & 0xffffff);
 	reg->size = 4;
@@ -1384,8 +1372,6 @@ static int vidioc_s_register (struct file *file, void *fh,
 {
 	struct cx88_core *core = ((struct cx8800_fh*)fh)->dev->core;
 
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
 	cx_write(reg->reg & 0xffffff, reg->val);
 	return 0;
 }
@@ -1580,7 +1566,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1614,7 +1599,6 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1645,7 +1629,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
-	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1796,7 +1779,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* load and configure helper modules */
 
-	if (core->board.audio_chip == V4L2_IDENT_WM8775) {
+	if (core->board.audio_chip == CX88_AUDIO_WM8775) {
 		struct i2c_board_info wm8775_info = {
 			.type = "wm8775",
 			.addr = 0x36 >> 1,
@@ -1817,7 +1800,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		}
 	}
 
-	if (core->board.audio_chip == V4L2_IDENT_TVAUDIO) {
+	if (core->board.audio_chip == CX88_AUDIO_TVAUDIO) {
 		/* This probes for a tda9874 as is used on some
 		   Pixelview Ultra boards. */
 		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 51ce2c0..afe0eae 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -30,7 +30,6 @@
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/cx2341x.h>
 #include <media/videobuf-dvb.h>
 #include <media/ir-kbd-i2c.h>
@@ -259,6 +258,11 @@ struct cx88_input {
 	unsigned int    audioroute:4;
 };
 
+enum cx88_audio_chip {
+	CX88_AUDIO_WM8775,
+	CX88_AUDIO_TVAUDIO,
+};
+
 struct cx88_board {
 	const char              *name;
 	unsigned int            tuner_type;
@@ -269,7 +273,7 @@ struct cx88_board {
 	struct cx88_input       input[MAX_CX88_INPUT];
 	struct cx88_input       radio;
 	enum cx88_board_type    mpeg;
-	unsigned int            audio_chip;
+	enum cx88_audio_chip	audio_chip;
 	int			num_frontends;
 
 	/* Used for I2S devices */
-- 
1.7.10.4

