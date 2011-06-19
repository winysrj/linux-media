Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1FSRnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:52 -0400
Date: Sun, 19 Jun 2011 14:42:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: [PATCH 04/11] [media] em28xx-alsa: add mixer support for AC97
 volume controls
Message-ID: <20110619144241.23d8078d@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Export ac97 volume controls via mixer.

Pulseaudio will probably handle it very badly, as it has
no idea about how volumes are wired, and how are they
associated with each TV input. Those wirings are
card model dependent, and we don't have the wiring mappings
for each supported device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index a24e177..a75c779 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -41,6 +41,7 @@
 #include <sound/info.h>
 #include <sound/initval.h>
 #include <sound/control.h>
+#include <sound/tlv.h>
 #include <media/v4l2-common.h>
 #include "em28xx.h"
 
@@ -433,6 +434,92 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
 	return vmalloc_to_page(pageptr);
 }
 
+/*
+ * AC97 volume control support
+ */
+static int em28xx_vol_info(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_info *info)
+{
+	info->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	info->count = 2;
+	info->value.integer.min = 0;
+	info->value.integer.max = 0x1f;
+
+	return 0;
+}
+
+/* FIXME: should also add mute controls for each */
+
+static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *value)
+{
+	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
+	u16 val = (value->value.integer.value[0] & 0x1f) |
+		  (value->value.integer.value[1] & 0x1f) << 8;
+	int rc;
+
+	mutex_lock(&dev->lock);
+	rc = em28xx_read_ac97(dev, kcontrol->private_value);
+	if (rc < 0)
+		goto err;
+
+	val |= rc & 0x8080;	/* Preserve the mute flags */
+
+	rc = em28xx_write_ac97(dev, kcontrol->private_value, val);
+
+err:
+	mutex_unlock(&dev->lock);
+	return rc;
+}
+
+static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *value)
+{
+	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
+	int val;
+
+	mutex_lock(&dev->lock);
+	val = em28xx_read_ac97(dev, kcontrol->private_value);
+	mutex_unlock(&dev->lock);
+	if (val < 0)
+		return val;
+
+	value->value.integer.value[0] = val & 0x1f;
+	value->value.integer.value[1] = (val << 8) & 0x1f;
+
+	return 0;
+}
+
+static const DECLARE_TLV_DB_SCALE(em28xx_db_scale, -3450, 150, 0);
+
+static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
+			   char *name, int id)
+{
+	int err;
+	struct snd_kcontrol *kctl;
+	struct snd_kcontrol_new tmp = {
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name  = name,
+		.info  = em28xx_vol_info,
+		.get   = em28xx_vol_get,
+		.put   = em28xx_vol_put,
+		.private_value = id,
+		.tlv.p = em28xx_db_scale,
+	};
+
+	kctl = snd_ctl_new1(&tmp, dev);
+
+	err = snd_ctl_add(card, kctl);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+
+/*
+ * register/unregister code and data
+ */
 static struct snd_pcm_ops snd_em28xx_pcm_capture = {
 	.open      = snd_em28xx_capture_open,
 	.close     = snd_em28xx_pcm_close,
@@ -489,6 +576,22 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	INIT_WORK(&dev->wq_trigger, audio_trigger);
 
+	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO_VOL);
+		em28xx_cvol_new(card, dev, "Line In", AC97_LINEIN_VOL);
+		em28xx_cvol_new(card, dev, "Phone", AC97_PHONE_VOL);
+		em28xx_cvol_new(card, dev, "Microphone", AC97_PHONE_VOL);
+		em28xx_cvol_new(card, dev, "CD", AC97_CD_VOL);
+		em28xx_cvol_new(card, dev, "AUX", AC97_AUX_VOL);
+		em28xx_cvol_new(card, dev, "PCM", AC97_PCM_OUT_VOL);
+
+		em28xx_cvol_new(card, dev, "Master", AC97_MASTER_VOL);
+		em28xx_cvol_new(card, dev, "Line", AC97_LINE_LEVEL_VOL);
+		em28xx_cvol_new(card, dev, "Mono", AC97_MASTER_MONO_VOL);
+		em28xx_cvol_new(card, dev, "LFE", AC97_LFE_MASTER_VOL);
+		em28xx_cvol_new(card, dev, "Surround", AC97_SURR_MASTER_VOL);
+	}
+
 	err = snd_card_register(card);
 	if (err < 0) {
 		snd_card_free(card);
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 7bf3a86..752d4ed 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -286,6 +286,7 @@ int em28xx_read_ac97(struct em28xx *dev, u8 reg)
 		return ret;
 	return le16_to_cpu(val);
 }
+EXPORT_SYMBOL_GPL(em28xx_read_ac97);
 
 /*
  * em28xx_write_ac97()
@@ -313,6 +314,7 @@ int em28xx_write_ac97(struct em28xx *dev, u8 reg, u16 val)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(em28xx_write_ac97);
 
 struct em28xx_vol_itable {
 	enum em28xx_amux mux;
-- 
1.7.1


