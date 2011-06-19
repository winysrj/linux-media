Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab1FSRny (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:54 -0400
Date: Sun, 19 Jun 2011 14:42:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: [PATCH 05/11] [media] em28xx-audio: add support for mute controls
Message-ID: <20110619144242.77aec488@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index a75c779..c7b96b4 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -448,8 +448,6 @@ static int em28xx_vol_info(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-/* FIXME: should also add mute controls for each */
-
 static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
@@ -463,7 +461,7 @@ static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
 	if (rc < 0)
 		goto err;
 
-	val |= rc & 0x8080;	/* Preserve the mute flags */
+	val |= rc & 0x8000;	/* Preserve the mute flag */
 
 	rc = em28xx_write_ac97(dev, kcontrol->private_value, val);
 
@@ -490,25 +488,87 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+static int em28xx_vol_put_mute(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *value)
+{
+	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
+	u16 val = value->value.integer.value[0];
+	int rc;
+
+	mutex_lock(&dev->lock);
+	rc = em28xx_read_ac97(dev, kcontrol->private_value);
+	if (rc < 0)
+		goto err;
+
+	if (val)
+		rc |= 0x8000;
+	else
+		rc &= 0x7f7f;
+
+	rc = em28xx_write_ac97(dev, kcontrol->private_value, rc);
+
+err:
+	mutex_unlock(&dev->lock);
+	return rc;
+}
+
+static int em28xx_vol_get_mute(struct snd_kcontrol *kcontrol,
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
+	if (val & 0x8000)
+		value->value.integer.value[0] = 1;
+	else
+		value->value.integer.value[0] = 0;
+
+	return 0;
+}
+
 static const DECLARE_TLV_DB_SCALE(em28xx_db_scale, -3450, 150, 0);
 
 static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 			   char *name, int id)
 {
 	int err;
+	char ctl_name[44];
 	struct snd_kcontrol *kctl;
-	struct snd_kcontrol_new tmp = {
-		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		.name  = name,
-		.info  = em28xx_vol_info,
-		.get   = em28xx_vol_get,
-		.put   = em28xx_vol_put,
-		.private_value = id,
-		.tlv.p = em28xx_db_scale,
-	};
+	struct snd_kcontrol_new tmp;
 
+	memset (&tmp, 0, sizeof(tmp));
+	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	tmp.private_value = id,
+	tmp.name  = ctl_name,
+
+	/* Add Mute Control */
+	sprintf(ctl_name, "%s Switch", name);
+	tmp.get  = em28xx_vol_get_mute;
+	tmp.put  = em28xx_vol_put_mute;
+	tmp.info = snd_ctl_boolean_mono_info;
 	kctl = snd_ctl_new1(&tmp, dev);
+	err = snd_ctl_add(card, kctl);
+	if (err < 0)
+		return err;
+
+	memset (&tmp, 0, sizeof(tmp));
+	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	tmp.private_value = id,
+	tmp.name  = ctl_name,
 
+	/* Add Volume Control */
+	sprintf(ctl_name, "%s Volume", name);
+	tmp.get   = em28xx_vol_get;
+	tmp.put   = em28xx_vol_put;
+	tmp.info  = em28xx_vol_info;
+	tmp.tlv.p = em28xx_db_scale,
+	kctl = snd_ctl_new1(&tmp, dev);
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)
 		return err;
@@ -516,7 +576,6 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 	return 0;
 }
 
-
 /*
  * register/unregister code and data
  */
-- 
1.7.1


