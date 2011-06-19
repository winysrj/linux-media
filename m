Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab1FSRnt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:49 -0400
Date: Sun, 19 Jun 2011 14:42:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: [PATCH 07/11] [media] em28xx-audio: add debug info for the volume
 control
Message-ID: <20110619144238.213f02d5@pedra>
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
index 302553a..56739a4 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -464,6 +464,13 @@ static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
 	val |= rc & 0x8000;	/* Preserve the mute flag */
 
 	rc = em28xx_write_ac97(dev, kcontrol->private_value, val);
+	if (rc < 0)
+		goto err;
+
+	dprintk("%sleft vol %d, right vol %d (0x%04x) to ac97 volume control 0x%04x\n",
+		(val & 0x8000) ? "muted " : "",
+		0x1f - ((val >> 8) & 0x1f), 0x1f - (val & 0x1f),
+		val, (int)kcontrol->private_value);
 
 err:
 	mutex_unlock(&dev->lock);
@@ -482,6 +489,11 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 	if (val < 0)
 		return val;
 
+	dprintk("%sleft vol %d, right vol %d (0x%04x) from ac97 volume control 0x%04x\n",
+		(val & 0x8000) ? "muted " : "",
+		0x1f - ((val >> 8) & 0x1f), 0x1f - (val & 0x1f),
+		val, (int)kcontrol->private_value);
+
 	value->value.integer.value[0] = 0x1f - (val & 0x1f);
 	value->value.integer.value[1] = 0x1f - ((val << 8) & 0x1f);
 
@@ -506,6 +518,13 @@ static int em28xx_vol_put_mute(struct snd_kcontrol *kcontrol,
 		rc |= 0x8000;
 
 	rc = em28xx_write_ac97(dev, kcontrol->private_value, rc);
+	if (rc < 0)
+		goto err;
+
+	dprintk("%sleft vol %d, right vol %d (0x%04x) to ac97 volume control 0x%04x\n",
+		(val & 0x8000) ? "muted " : "",
+		0x1f - ((val >> 8) & 0x1f), 0x1f - (val & 0x1f),
+		val, (int)kcontrol->private_value);
 
 err:
 	mutex_unlock(&dev->lock);
@@ -529,6 +548,11 @@ static int em28xx_vol_get_mute(struct snd_kcontrol *kcontrol,
 	else
 		value->value.integer.value[0] = 1;
 
+	dprintk("%sleft vol %d, right vol %d (0x%04x) from ac97 volume control 0x%04x\n",
+		(val & 0x8000) ? "muted " : "",
+		0x1f - ((val >> 8) & 0x1f), 0x1f - (val & 0x1f),
+		val, (int)kcontrol->private_value);
+
 	return 0;
 }
 
@@ -556,6 +580,8 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)
 		return err;
+	dprintk("Added control %s for ac97 volume control 0x%04x\n",
+		ctl_name, id);
 
 	memset (&tmp, 0, sizeof(tmp));
 	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -572,6 +598,8 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)
 		return err;
+	dprintk("Added control %s for ac97 volume control 0x%04x\n",
+		ctl_name, id);
 
 	return 0;
 }
-- 
1.7.1


