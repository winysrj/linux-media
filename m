Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2965 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966095Ab3E2Oog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:44:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.10] cx88: fix NULL pointer dereference
Date: Wed, 29 May 2013 16:44:22 +0200
Cc: Sebastian Frei <sebastian@familie-frei.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305291644.22498.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a NULL pointer deference when loading the cx88_dvb module for a
Hauppauge HVR4000.

The bugzilla bug report is here:

https://bugzilla.kernel.org/show_bug.cgi?id=56271

The cause is that the wm8775 is optional, so even though the board info says
there is one, it doesn't have to be there. Checking whether the module was
actually loaded is much safer.

Note that this driver is quite buggy when it comes to unloading and reloading
modules. Unloading cx8800 and reloading it again will still cause a crash,
most likely because either the i2c bus isn't unloaded at the right time and/or
the v4l2_device_unregister isn't called at the right time.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Sebastian Frei <sebastian@familie-frei.net>

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 27d6262..aba5b1c 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -615,7 +615,7 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 	int changed = 0;
 	u32 old;
 
-	if (core->board.audio_chip == V4L2_IDENT_WM8775)
+	if (core->sd_wm8775)
 		snd_cx88_wm8775_volume_put(kcontrol, value);
 
 	left = value->value.integer.value[0] & 0x3f;
@@ -682,8 +682,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 		vol ^= bit;
 		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
 		/* Pass mute onto any WM8775 */
-		if ((core->board.audio_chip == V4L2_IDENT_WM8775) &&
-		    ((1<<6) == bit))
+		if (core->sd_wm8775 && ((1<<6) == bit))
 			wm8775_s_ctrl(core, V4L2_CID_AUDIO_MUTE, 0 != (vol & bit));
 		ret = 1;
 	}
@@ -903,7 +902,7 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 		goto error;
 
 	/* If there's a wm8775 then add a Line-In ALC switch */
-	if (core->board.audio_chip == V4L2_IDENT_WM8775)
+	if (core->sd_wm8775)
 		snd_ctl_add(card, snd_ctl_new1(&snd_cx88_alc_switch, chip));
 
 	strcpy (card->driver, "CX88x");
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index e3f6181..62255bf 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -385,8 +385,7 @@ int cx88_video_mux(struct cx88_core *core, unsigned int input)
 		/* The wm8775 module has the "2" route hardwired into
 		   the initialization. Some boards may use different
 		   routes for different inputs. HVR-1300 surely does */
-		if (core->board.audio_chip &&
-		    core->board.audio_chip == V4L2_IDENT_WM8775) {
+		if (core->sd_wm8775) {
 			call_all(core, audio, s_routing,
 				 INPUT(input).audioroute, 0, 0);
 		}
@@ -771,8 +770,7 @@ static int video_open(struct file *file)
 		cx_write(MO_GP1_IO, core->board.radio.gpio1);
 		cx_write(MO_GP2_IO, core->board.radio.gpio2);
 		if (core->board.radio.audioroute) {
-			if(core->board.audio_chip &&
-				core->board.audio_chip == V4L2_IDENT_WM8775) {
+			if (core->sd_wm8775) {
 				call_all(core, audio, s_routing,
 					core->board.radio.audioroute, 0, 0);
 			}
@@ -959,7 +957,7 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 	u32 value,mask;
 
 	/* Pass changes onto any WM8775 */
-	if (core->board.audio_chip == V4L2_IDENT_WM8775) {
+	if (core->sd_wm8775) {
 		switch (ctrl->id) {
 		case V4L2_CID_AUDIO_MUTE:
 			wm8775_s_ctrl(core, ctrl->id, ctrl->val);
