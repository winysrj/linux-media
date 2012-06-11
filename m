Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63231 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2FKTSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 15:18:09 -0400
Received: by yhmm54 with SMTP id m54so2841759yhm.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 12:18:08 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
	Gianluca Gennari <gennarone@gmail.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 2/3] em28xx: Rename AC97 registers to use sound/ac97_codec.h definitions
Date: Mon, 11 Jun 2012 16:17:23 -0300
Message-Id: <1339442244-11546-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1339442244-11546-1-git-send-email-elezegarcia@gmail.com>
References: <1339442244-11546-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-audio.c |   27 ++++++++++++-----------
 drivers/media/video/em28xx/em28xx-core.c  |   33 +++++++++++++++--------------
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index e2a7a00..07dc594 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -42,6 +42,7 @@
 #include <sound/initval.h>
 #include <sound/control.h>
 #include <sound/tlv.h>
+#include <sound/ac97_codec.h>
 #include <media/v4l2-common.h>
 #include "em28xx.h"
 
@@ -679,19 +680,19 @@ static int em28xx_audio_init(struct em28xx *dev)
 	INIT_WORK(&dev->wq_trigger, audio_trigger);
 
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
-		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO_VOL);
-		em28xx_cvol_new(card, dev, "Line In", AC97_LINEIN_VOL);
-		em28xx_cvol_new(card, dev, "Phone", AC97_PHONE_VOL);
-		em28xx_cvol_new(card, dev, "Microphone", AC97_MIC_VOL);
-		em28xx_cvol_new(card, dev, "CD", AC97_CD_VOL);
-		em28xx_cvol_new(card, dev, "AUX", AC97_AUX_VOL);
-		em28xx_cvol_new(card, dev, "PCM", AC97_PCM_OUT_VOL);
-
-		em28xx_cvol_new(card, dev, "Master", AC97_MASTER_VOL);
-		em28xx_cvol_new(card, dev, "Line", AC97_LINE_LEVEL_VOL);
-		em28xx_cvol_new(card, dev, "Mono", AC97_MASTER_MONO_VOL);
-		em28xx_cvol_new(card, dev, "LFE", AC97_LFE_MASTER_VOL);
-		em28xx_cvol_new(card, dev, "Surround", AC97_SURR_MASTER_VOL);
+		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO);
+		em28xx_cvol_new(card, dev, "Line In", AC97_LINE);
+		em28xx_cvol_new(card, dev, "Phone", AC97_PHONE);
+		em28xx_cvol_new(card, dev, "Microphone", AC97_MIC);
+		em28xx_cvol_new(card, dev, "CD", AC97_CD);
+		em28xx_cvol_new(card, dev, "AUX", AC97_AUX);
+		em28xx_cvol_new(card, dev, "PCM", AC97_PCM);
+
+		em28xx_cvol_new(card, dev, "Master", AC97_MASTER);
+		em28xx_cvol_new(card, dev, "Line", AC97_HEADPHONE);
+		em28xx_cvol_new(card, dev, "Mono", AC97_MASTER_MONO);
+		em28xx_cvol_new(card, dev, "LFE", AC97_CENTER_LFE_MASTER);
+		em28xx_cvol_new(card, dev, "Surround", AC97_SURROUND_MASTER);
 	}
 
 	err = snd_card_register(card);
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 5717bde..181443c 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
+#include <sound/ac97_codec.h>
 #include <media/v4l2-common.h>
 
 #include "em28xx.h"
@@ -326,13 +327,13 @@ struct em28xx_vol_itable {
 };
 
 static struct em28xx_vol_itable inputs[] = {
-	{ EM28XX_AMUX_VIDEO, 	AC97_VIDEO_VOL   },
-	{ EM28XX_AMUX_LINE_IN,	AC97_LINEIN_VOL  },
-	{ EM28XX_AMUX_PHONE,	AC97_PHONE_VOL   },
-	{ EM28XX_AMUX_MIC,	AC97_MIC_VOL     },
-	{ EM28XX_AMUX_CD,	AC97_CD_VOL      },
-	{ EM28XX_AMUX_AUX,	AC97_AUX_VOL     },
-	{ EM28XX_AMUX_PCM_OUT,	AC97_PCM_OUT_VOL },
+	{ EM28XX_AMUX_VIDEO,	AC97_VIDEO	},
+	{ EM28XX_AMUX_LINE_IN,	AC97_LINE	},
+	{ EM28XX_AMUX_PHONE,	AC97_PHONE	},
+	{ EM28XX_AMUX_MIC,	AC97_MIC	},
+	{ EM28XX_AMUX_CD,	AC97_CD		},
+	{ EM28XX_AMUX_AUX,	AC97_AUX	},
+	{ EM28XX_AMUX_PCM_OUT,	AC97_PCM	},
 };
 
 static int set_ac97_input(struct em28xx *dev)
@@ -415,11 +416,11 @@ struct em28xx_vol_otable {
 };
 
 static const struct em28xx_vol_otable outputs[] = {
-	{ EM28XX_AOUT_MASTER, AC97_MASTER_VOL      },
-	{ EM28XX_AOUT_LINE,   AC97_LINE_LEVEL_VOL  },
-	{ EM28XX_AOUT_MONO,   AC97_MASTER_MONO_VOL },
-	{ EM28XX_AOUT_LFE,    AC97_LFE_MASTER_VOL  },
-	{ EM28XX_AOUT_SURR,   AC97_SURR_MASTER_VOL },
+	{ EM28XX_AOUT_MASTER, AC97_MASTER		},
+	{ EM28XX_AOUT_LINE,   AC97_HEADPHONE		},
+	{ EM28XX_AOUT_MONO,   AC97_MASTER_MONO		},
+	{ EM28XX_AOUT_LFE,    AC97_CENTER_LFE_MASTER	},
+	{ EM28XX_AOUT_SURR,   AC97_SURROUND_MASTER	},
 };
 
 int em28xx_audio_analog_set(struct em28xx *dev)
@@ -459,9 +460,9 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
 		int vol;
 
-		em28xx_write_ac97(dev, AC97_POWER_DOWN_CTRL, 0x4200);
-		em28xx_write_ac97(dev, AC97_EXT_AUD_CTRL, 0x0031);
-		em28xx_write_ac97(dev, AC97_PCM_IN_SRATE, 0xbb80);
+		em28xx_write_ac97(dev, AC97_POWERDOWN, 0x4200);
+		em28xx_write_ac97(dev, AC97_EXTENDED_STATUS, 0x0031);
+		em28xx_write_ac97(dev, AC97_PCM_LR_ADC_RATE, 0xbb80);
 
 		/* LSB: left channel - both channels with the same level */
 		vol = (0x1f - dev->volume) | ((0x1f - dev->volume) << 8);
@@ -487,7 +488,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 			   channels */
 			sel |= (sel << 8);
 
-			em28xx_write_ac97(dev, AC97_RECORD_SELECT, sel);
+			em28xx_write_ac97(dev, AC97_REC_SEL, sel);
 		}
 	}
 
-- 
1.7.4.4

