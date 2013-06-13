Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:50853 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab3FMVk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 17:40:26 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 1/2] tea575x: Move header from sound to media
Date: Thu, 13 Jun 2013 23:39:49 +0200
Cc: alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306132339.50554.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move include/sound/tea575x-tuner.h to include/media/tea575x.h and update files that include it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-maxiradio.c |    2 +-
 drivers/media/radio/radio-sf16fmr2.c  |    2 +-
 drivers/media/radio/radio-shark.c     |    2 +-
 include/media/tea575x.h               |   78 +++++++++++++++++++++++++++++++++
 include/sound/tea575x-tuner.h         |   78 ---------------------------------
 sound/i2c/other/tea575x-tuner.c       |    2 +-
 sound/pci/es1968.c                    |    2 +-
 sound/pci/fm801.c                     |    2 +-
 8 files changed, 84 insertions(+), 84 deletions(-)
 create mode 100644 include/media/tea575x.h
 delete mode 100644 include/sound/tea575x-tuner.h

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index bd4d3a7..a76712a 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -42,7 +42,7 @@
 #include <linux/videodev2.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <sound/tea575x-tuner.h>
+#include <media/tea575x.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 9c09904..f1e3714 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -14,7 +14,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <linux/isa.h>
 #include <linux/pnp.h>
-#include <sound/tea575x-tuner.h>
+#include <media/tea575x.h>
 
 MODULE_AUTHOR("Ondrej Zary");
 MODULE_DESCRIPTION("MediaForte SF16-FMR2 and SF16-FMD2 FM radio card driver");
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 8fa18ab..b914772 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -33,7 +33,7 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-device.h>
-#include <sound/tea575x-tuner.h>
+#include <media/tea575x.h>
 
 #if defined(CONFIG_LEDS_CLASS) || \
     (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
diff --git a/include/media/tea575x.h b/include/media/tea575x.h
new file mode 100644
index 0000000..098c4de
--- /dev/null
+++ b/include/media/tea575x.h
@@ -0,0 +1,78 @@
+#ifndef __SOUND_TEA575X_TUNER_H
+#define __SOUND_TEA575X_TUNER_H
+
+/*
+ *   ALSA driver for TEA5757/5759 Philips AM/FM tuner chips
+ *
+ *	Copyright (c) 2004 Jaroslav Kysela <perex@perex.cz>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+
+#define TEA575X_FMIF	10700
+#define TEA575X_AMIF	  450
+
+#define TEA575X_DATA	(1 << 0)
+#define TEA575X_CLK	(1 << 1)
+#define TEA575X_WREN	(1 << 2)
+#define TEA575X_MOST	(1 << 3)
+
+struct snd_tea575x;
+
+struct snd_tea575x_ops {
+	/* Drivers using snd_tea575x must either define read_ and write_val */
+	void (*write_val)(struct snd_tea575x *tea, u32 val);
+	u32 (*read_val)(struct snd_tea575x *tea);
+	/* Or define the 3 pin functions */
+	void (*set_pins)(struct snd_tea575x *tea, u8 pins);
+	u8 (*get_pins)(struct snd_tea575x *tea);
+	void (*set_direction)(struct snd_tea575x *tea, bool output);
+};
+
+struct snd_tea575x {
+	struct v4l2_device *v4l2_dev;
+	struct v4l2_file_operations fops;
+	struct video_device vd;		/* video device */
+	int radio_nr;			/* radio_nr */
+	bool tea5759;			/* 5759 chip is present */
+	bool has_am;			/* Device can tune to AM freqs */
+	bool cannot_read_data;		/* Device cannot read the data pin */
+	bool cannot_mute;		/* Device cannot mute */
+	bool mute;			/* Device is muted? */
+	bool stereo;			/* receiving stereo */
+	bool tuned;			/* tuned to a station */
+	unsigned int val;		/* hw value */
+	u32 band;			/* 0: FM, 1: FM-Japan, 2: AM */
+	u32 freq;			/* frequency */
+	struct mutex mutex;
+	struct snd_tea575x_ops *ops;
+	void *private_data;
+	u8 card[32];
+	u8 bus_info[32];
+	struct v4l2_ctrl_handler ctrl_handler;
+	int (*ext_init)(struct snd_tea575x *tea);
+};
+
+int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner);
+void snd_tea575x_exit(struct snd_tea575x *tea);
+void snd_tea575x_set_freq(struct snd_tea575x *tea);
+
+#endif /* __SOUND_TEA575X_TUNER_H */
diff --git a/include/sound/tea575x-tuner.h b/include/sound/tea575x-tuner.h
deleted file mode 100644
index 098c4de..0000000
--- a/include/sound/tea575x-tuner.h
+++ /dev/null
@@ -1,78 +0,0 @@
-#ifndef __SOUND_TEA575X_TUNER_H
-#define __SOUND_TEA575X_TUNER_H
-
-/*
- *   ALSA driver for TEA5757/5759 Philips AM/FM tuner chips
- *
- *	Copyright (c) 2004 Jaroslav Kysela <perex@perex.cz>
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation; either version 2 of the License, or
- *   (at your option) any later version.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *   GNU General Public License for more details.
- *
- *   You should have received a copy of the GNU General Public License
- *   along with this program; if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- *
- */
-
-#include <linux/videodev2.h>
-#include <media/v4l2-ctrls.h>
-#include <media/v4l2-dev.h>
-#include <media/v4l2-device.h>
-
-#define TEA575X_FMIF	10700
-#define TEA575X_AMIF	  450
-
-#define TEA575X_DATA	(1 << 0)
-#define TEA575X_CLK	(1 << 1)
-#define TEA575X_WREN	(1 << 2)
-#define TEA575X_MOST	(1 << 3)
-
-struct snd_tea575x;
-
-struct snd_tea575x_ops {
-	/* Drivers using snd_tea575x must either define read_ and write_val */
-	void (*write_val)(struct snd_tea575x *tea, u32 val);
-	u32 (*read_val)(struct snd_tea575x *tea);
-	/* Or define the 3 pin functions */
-	void (*set_pins)(struct snd_tea575x *tea, u8 pins);
-	u8 (*get_pins)(struct snd_tea575x *tea);
-	void (*set_direction)(struct snd_tea575x *tea, bool output);
-};
-
-struct snd_tea575x {
-	struct v4l2_device *v4l2_dev;
-	struct v4l2_file_operations fops;
-	struct video_device vd;		/* video device */
-	int radio_nr;			/* radio_nr */
-	bool tea5759;			/* 5759 chip is present */
-	bool has_am;			/* Device can tune to AM freqs */
-	bool cannot_read_data;		/* Device cannot read the data pin */
-	bool cannot_mute;		/* Device cannot mute */
-	bool mute;			/* Device is muted? */
-	bool stereo;			/* receiving stereo */
-	bool tuned;			/* tuned to a station */
-	unsigned int val;		/* hw value */
-	u32 band;			/* 0: FM, 1: FM-Japan, 2: AM */
-	u32 freq;			/* frequency */
-	struct mutex mutex;
-	struct snd_tea575x_ops *ops;
-	void *private_data;
-	u8 card[32];
-	u8 bus_info[32];
-	struct v4l2_ctrl_handler ctrl_handler;
-	int (*ext_init)(struct snd_tea575x *tea);
-};
-
-int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner);
-void snd_tea575x_exit(struct snd_tea575x *tea);
-void snd_tea575x_set_freq(struct snd_tea575x *tea);
-
-#endif /* __SOUND_TEA575X_TUNER_H */
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 8a36a1d..a1cb208 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <sound/tea575x-tuner.h>
+#include <media/tea575x.h>
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index a1f32b5..c7c23b3 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -113,7 +113,7 @@
 #include <sound/initval.h>
 
 #ifdef CONFIG_SND_ES1968_RADIO
-#include <sound/tea575x-tuner.h>
+#include <media/tea575x.h>
 #endif
 
 #define CARD_NAME "ESS Maestro1/2"
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 4f07fda..b1c8ce2 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -37,7 +37,7 @@
 #include <asm/io.h>
 
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
-#include <sound/tea575x-tuner.h>
+#include <media/tea575x.h>
 #endif
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");

-- 
Ondrej Zary
