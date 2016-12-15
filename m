Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36834 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752219AbcLOWNM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:13:12 -0500
Received: by mail-wm0-f68.google.com with SMTP id m203so909386wma.3
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 14:13:11 -0800 (PST)
Date: Thu, 15 Dec 2016 23:13:05 +0100
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 1/3] stk1160: Remove stk1160-mixer and setup internal AC97
 codec
Message-ID: <20161215221305.GA7793@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

automatically.
Reply-To: 
In-Reply-To: <20161215221146.GA9398@arch-desktop>

Exposing all the channels of the device's internal AC97 codec to userspace is unnecessary and
confusing. Instead the driver should setup the codec with proper values. This patch removes the
mixer and sets up the codec using optimal values, i.e. the same values set by the Windows
driver. This also makes the device work out-of-the-box, without the need for the user to
reconfigure the device every time it's plugged in.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/Kconfig        |  10 +--
 drivers/media/usb/stk1160/Makefile       |   4 +-
 drivers/media/usb/stk1160/stk1160-ac97.c | 126 +++++++++++--------------------
 drivers/media/usb/stk1160/stk1160-core.c |   5 +-
 drivers/media/usb/stk1160/stk1160.h      |   9 +--
 5 files changed, 50 insertions(+), 104 deletions(-)

diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
index 95584c1..22dff4f 100644
--- a/drivers/media/usb/stk1160/Kconfig
+++ b/drivers/media/usb/stk1160/Kconfig
@@ -8,17 +8,9 @@ config VIDEO_STK1160_COMMON
 	  To compile this driver as a module, choose M here: the
 	  module will be called stk1160
 
-config VIDEO_STK1160_AC97
-	bool "STK1160 AC97 codec support"
-	depends on VIDEO_STK1160_COMMON && SND
-
-	---help---
-	  Enables AC97 codec support for stk1160 driver.
-
 config VIDEO_STK1160
 	tristate
-	depends on (!VIDEO_STK1160_AC97 || (SND='n') || SND) && VIDEO_STK1160_COMMON
+	depends on VIDEO_STK1160_COMMON
 	default y
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_SAA711X
-	select SND_AC97_CODEC if SND
diff --git a/drivers/media/usb/stk1160/Makefile b/drivers/media/usb/stk1160/Makefile
index dfe3e90..42d0546 100644
--- a/drivers/media/usb/stk1160/Makefile
+++ b/drivers/media/usb/stk1160/Makefile
@@ -1,10 +1,8 @@
-obj-stk1160-ac97-$(CONFIG_VIDEO_STK1160_AC97) := stk1160-ac97.o
-
 stk1160-y := 	stk1160-core.o \
 		stk1160-v4l.o \
 		stk1160-video.o \
 		stk1160-i2c.o \
-		$(obj-stk1160-ac97-y)
+		stk1160-ac97.o
 
 obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
 
diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index 2dd308f..502fc8e 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -4,6 +4,9 @@
  * Copyright (C) 2012 Ezequiel Garcia
  * <elezegarcia--a.t--gmail.com>
  *
+ * Copyright (C) 2016 Marcel Hasler
+ * <mahasler--a.t--gmail.com>
+ *
  * Based on Easycap driver by R.M. Thomas
  *	Copyright (C) 2010 R.M. Thomas
  *	<rmthomas--a.t--sciolus.org>
@@ -20,20 +23,11 @@
  *
  */
 
-#include <linux/module.h>
-#include <sound/core.h>
-#include <sound/initval.h>
-#include <sound/ac97_codec.h>
-
 #include "stk1160.h"
 #include "stk1160-reg.h"
 
-static struct snd_ac97 *stk1160_ac97;
-
-static void stk1160_write_ac97(struct snd_ac97 *ac97, u16 reg, u16 value)
+static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value)
 {
-	struct stk1160 *dev = ac97->private_data;
-
 	/* Set codec register address */
 	stk1160_write_reg(dev, STK1160_AC97_ADDR, reg);
 
@@ -48,9 +42,9 @@ static void stk1160_write_ac97(struct snd_ac97 *ac97, u16 reg, u16 value)
 	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
 }
 
-static u16 stk1160_read_ac97(struct snd_ac97 *ac97, u16 reg)
+#ifdef DEBUG
+static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
 {
-	struct stk1160 *dev = ac97->private_data;
 	u8 vall = 0;
 	u8 valh = 0;
 
@@ -70,81 +64,53 @@ static u16 stk1160_read_ac97(struct snd_ac97 *ac97, u16 reg)
 	return (valh << 8) | vall;
 }
 
-static void stk1160_reset_ac97(struct snd_ac97 *ac97)
+void stk1160_ac97_dump_regs(struct stk1160 *dev)
 {
-	struct stk1160 *dev = ac97->private_data;
-	/* Two-step reset AC97 interface and hardware codec */
-	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x94);
-	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x88);
+	u16 value;
 
-	/* Set 16-bit audio data and choose L&R channel*/
-	stk1160_write_reg(dev, STK1160_AC97CTL_1 + 2, 0x01);
-}
+	value = stk1160_read_ac97(dev, 0x12); /* CD volume */
+	stk1160_dbg("0x12 == 0x%04x", value);
 
-static struct snd_ac97_bus_ops stk1160_ac97_ops = {
-	.read	= stk1160_read_ac97,
-	.write	= stk1160_write_ac97,
-	.reset	= stk1160_reset_ac97,
-};
+	value = stk1160_read_ac97(dev, 0x10); /* Line-in volume */
+	stk1160_dbg("0x10 == 0x%04x", value);
 
-int stk1160_ac97_register(struct stk1160 *dev)
-{
-	struct snd_card *card = NULL;
-	struct snd_ac97_bus *ac97_bus;
-	struct snd_ac97_template ac97_template;
-	int rc;
+	value = stk1160_read_ac97(dev, 0x0e); /* MIC volume (mono) */
+	stk1160_dbg("0x0e == 0x%04x", value);
 
-	/*
-	 * Just want a card to access ac96 controls,
-	 * the actual capture interface will be handled by snd-usb-audio
-	 */
-	rc = snd_card_new(dev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
-			  THIS_MODULE, 0, &card);
-	if (rc < 0)
-		return rc;
-
-	/* TODO: I'm not sure where should I get these names :-( */
-	snprintf(card->shortname, sizeof(card->shortname),
-		 "stk1160-mixer");
-	snprintf(card->longname, sizeof(card->longname),
-		 "stk1160 ac97 codec mixer control");
-	strlcpy(card->driver, dev->dev->driver->name, sizeof(card->driver));
-
-	rc = snd_ac97_bus(card, 0, &stk1160_ac97_ops, NULL, &ac97_bus);
-	if (rc)
-		goto err;
-
-	/* We must set private_data before calling snd_ac97_mixer */
-	memset(&ac97_template, 0, sizeof(ac97_template));
-	ac97_template.private_data = dev;
-	ac97_template.scaps = AC97_SCAP_SKIP_MODEM;
-	rc = snd_ac97_mixer(ac97_bus, &ac97_template, &stk1160_ac97);
-	if (rc)
-		goto err;
-
-	dev->snd_card = card;
-	rc = snd_card_register(card);
-	if (rc)
-		goto err;
-
-	return 0;
-
-err:
-	dev->snd_card = NULL;
-	snd_card_free(card);
-	return rc;
+	value = stk1160_read_ac97(dev, 0x16); /* Aux volume */
+	stk1160_dbg("0x16 == 0x%04x", value);
+
+	value = stk1160_read_ac97(dev, 0x1a); /* Record select */
+	stk1160_dbg("0x1a == 0x%04x", value);
+
+	value = stk1160_read_ac97(dev, 0x02); /* Master volume */
+	stk1160_dbg("0x02 == 0x%04x", value);
+
+	value = stk1160_read_ac97(dev, 0x1c); /* Record gain */
+	stk1160_dbg("0x1c == 0x%04x", value);
 }
+#endif
 
-int stk1160_ac97_unregister(struct stk1160 *dev)
+void stk1160_ac97_setup(struct stk1160 *dev)
 {
-	struct snd_card *card = dev->snd_card;
-
-	/*
-	 * We need to check usb_device,
-	 * because ac97 release attempts to communicate with codec
-	 */
-	if (card && dev->udev)
-		snd_card_free(card);
+	/* Two-step reset AC97 interface and hardware codec */
+	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x94);
+	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
 
-	return 0;
+	/* Set 16-bit audio data and choose L&R channel*/
+	stk1160_write_reg(dev, STK1160_AC97CTL_1 + 2, 0x01);
+	stk1160_write_reg(dev, STK1160_AC97CTL_1 + 3, 0x00);
+
+	/* Setup channels */
+	stk1160_write_ac97(dev, 0x12, 0x8808); /* CD volume */
+	stk1160_write_ac97(dev, 0x10, 0x0808); /* Line-in volume */
+	stk1160_write_ac97(dev, 0x0e, 0x0008); /* MIC volume (mono) */
+	stk1160_write_ac97(dev, 0x16, 0x0808); /* Aux volume */
+	stk1160_write_ac97(dev, 0x1a, 0x0404); /* Record select */
+	stk1160_write_ac97(dev, 0x02, 0x0000); /* Master volume */
+	stk1160_write_ac97(dev, 0x1c, 0x0808); /* Record gain */
+
+#ifdef DEBUG
+	stk1160_ac97_dump_regs(dev);
+#endif
 }
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index bc02947..f3c9b8a 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -373,7 +373,7 @@ static int stk1160_probe(struct usb_interface *interface,
 	/* select default input */
 	stk1160_select_input(dev);
 
-	stk1160_ac97_register(dev);
+	stk1160_ac97_setup(dev);
 
 	rc = stk1160_video_register(dev);
 	if (rc < 0)
@@ -411,9 +411,6 @@ static void stk1160_disconnect(struct usb_interface *interface)
 	/* Here is the only place where isoc get released */
 	stk1160_uninit_isoc(dev);
 
-	/* ac97 unregister needs to be done before usb_device is cleared */
-	stk1160_ac97_unregister(dev);
-
 	stk1160_clear_queue(dev);
 
 	video_unregister_device(&dev->vdev);
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 1ed1cc4..e85e12e 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -197,11 +197,4 @@ int stk1160_read_reg_req_len(struct stk1160 *dev, u8 req, u16 reg,
 void stk1160_select_input(struct stk1160 *dev);
 
 /* Provided by stk1160-ac97.c */
-#ifdef CONFIG_VIDEO_STK1160_AC97
-int stk1160_ac97_register(struct stk1160 *dev);
-int stk1160_ac97_unregister(struct stk1160 *dev);
-#else
-static inline int stk1160_ac97_register(struct stk1160 *dev) { return 0; }
-static inline int stk1160_ac97_unregister(struct stk1160 *dev) { return 0; }
-#endif
-
+void stk1160_ac97_setup(struct stk1160 *dev);
-- 
2.10.2

