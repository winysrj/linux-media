Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab2ETBVa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 21:21:30 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/6] snd_tea575x: Add a cannot_mute flag
Date: Sun, 20 May 2012 03:25:27 +0200
Message-Id: <1337477131-21578-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
References: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices which use the tea575x tuner chip don't allow direct control
over the IO pins, and thus cannot mute the audio output.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>
---
 include/sound/tea575x-tuner.h   |    1 +
 sound/i2c/other/tea575x-tuner.c |   35 +++++++++++++++++++----------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/sound/tea575x-tuner.h b/include/sound/tea575x-tuner.h
index 1ae933f..af58ad2 100644
--- a/include/sound/tea575x-tuner.h
+++ b/include/sound/tea575x-tuner.h
@@ -52,6 +52,7 @@ struct snd_tea575x {
 	int radio_nr;			/* radio_nr */
 	bool tea5759;			/* 5759 chip is present */
 	bool cannot_read_data;		/* Device cannot read the data pin */
+	bool cannot_mute;		/* Device cannot mute */
 	bool mute;			/* Device is muted? */
 	bool stereo;			/* receiving stereo */
 	bool tuned;			/* tuned to a station */
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index b74fc63..da49dd4 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -379,35 +379,38 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 	strlcpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
 	tea->vd.lock = &tea->mutex;
 	tea->vd.v4l2_dev = tea->v4l2_dev;
-	tea->vd.ctrl_handler = &tea->ctrl_handler;
 	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
 	/* disable hw_freq_seek if we can't use it */
 	if (tea->cannot_read_data)
 		v4l2_disable_ioctl(&tea->vd, VIDIOC_S_HW_FREQ_SEEK);
 
-	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
-	v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops, V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
-	retval = tea->ctrl_handler.error;
-	if (retval) {
-		v4l2_err(tea->v4l2_dev, "can't initialize controls\n");
-		v4l2_ctrl_handler_free(&tea->ctrl_handler);
-		return retval;
-	}
-
-	if (tea->ext_init) {
-		retval = tea->ext_init(tea);
+	if (!tea->cannot_mute) {
+		tea->vd.ctrl_handler = &tea->ctrl_handler;
+		v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
+		v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops,
+				  V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+		retval = tea->ctrl_handler.error;
 		if (retval) {
+			v4l2_err(tea->v4l2_dev, "can't initialize controls\n");
 			v4l2_ctrl_handler_free(&tea->ctrl_handler);
 			return retval;
 		}
-	}
 
-	v4l2_ctrl_handler_setup(&tea->ctrl_handler);
+		if (tea->ext_init) {
+			retval = tea->ext_init(tea);
+			if (retval) {
+				v4l2_ctrl_handler_free(&tea->ctrl_handler);
+				return retval;
+			}
+		}
+
+		v4l2_ctrl_handler_setup(&tea->ctrl_handler);
+	}
 
 	retval = video_register_device(&tea->vd, VFL_TYPE_RADIO, tea->radio_nr);
 	if (retval) {
 		v4l2_err(tea->v4l2_dev, "can't register video device!\n");
-		v4l2_ctrl_handler_free(&tea->ctrl_handler);
+		v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
 		return retval;
 	}
 
@@ -417,7 +420,7 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 void snd_tea575x_exit(struct snd_tea575x *tea)
 {
 	video_unregister_device(&tea->vd);
-	v4l2_ctrl_handler_free(&tea->ctrl_handler);
+	v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
 }
 
 static int __init alsa_tea575x_module_init(void)
-- 
1.7.10

