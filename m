Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:51673 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1B1LDP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:03:15 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v20 3/3] ASoC: WL1273 FM radio: Access I2C IO functions through pointers.
Date: Mon, 28 Feb 2011 13:02:31 +0200
Message-Id: <1298890951-23339-4-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1298890951-23339-3-git-send-email-matti.j.aaltonen@nokia.com>
References: <1298890951-23339-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1298890951-23339-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1298890951-23339-3-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

These changes are needed to keep up with the changes in the
MFD core and V4L2 parts of the wl1273 FM radio driver.

Use function pointers instead of exported functions for I2C IO.
Also move all preprocessor constants from the wl1273.h to
include/linux/mfd/wl1273-core.h.

Also update the year in the copyright statement.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 sound/soc/codecs/Kconfig  |    2 +-
 sound/soc/codecs/wl1273.c |   11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index c48b23c..9726d6e 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -44,7 +44,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_TWL6040 if TWL4030_CORE
 	select SND_SOC_UDA134X
 	select SND_SOC_UDA1380 if I2C
-	select SND_SOC_WL1273 if RADIO_WL1273
+	select SND_SOC_WL1273 if MFD_WL1273_CORE
 	select SND_SOC_WM2000 if I2C
 	select SND_SOC_WM8350 if MFD_WM8350
 	select SND_SOC_WM8400 if MFD_WM8400
diff --git a/sound/soc/codecs/wl1273.c b/sound/soc/codecs/wl1273.c
index 861b28f..3c27fed 100644
--- a/sound/soc/codecs/wl1273.c
+++ b/sound/soc/codecs/wl1273.c
@@ -3,7 +3,7 @@
  *
  * Author:      Matti Aaltonen, <matti.j.aaltonen@nokia.com>
  *
- * Copyright:   (C) 2010 Nokia Corporation
+ * Copyright:   (C) 2011 Nokia Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -179,7 +179,12 @@ static int snd_wl1273_get_audio_route(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const char *wl1273_audio_route[] = { "Bt", "FmRx", "FmTx" };
+/*
+ * TODO: Implement the audio routing in the driver. Now this control
+ * only indicates the setting that has been done elsewhere (in the user
+ * space).
+ */
+static const char * const wl1273_audio_route[] = { "Bt", "FmRx", "FmTx" };
 
 static int snd_wl1273_set_audio_route(struct snd_kcontrol *kcontrol,
 				      struct snd_ctl_elem_value *ucontrol)
@@ -239,7 +244,7 @@ static int snd_wl1273_fm_audio_put(struct snd_kcontrol *kcontrol,
 	return 1;
 }
 
-static const char *wl1273_audio_strings[] = { "Digital", "Analog" };
+static const char * const wl1273_audio_strings[] = { "Digital", "Analog" };
 
 static const struct soc_enum wl1273_audio_enum =
 	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_audio_strings),
-- 
1.6.1.3

