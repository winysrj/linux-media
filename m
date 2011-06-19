Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab1FSRn5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:57 -0400
Date: Sun, 19 Jun 2011 14:42:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: [PATCH 06/11] [media] em28xx-audio: volumes are inverted
Message-ID: <20110619144244.36da0948@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

While here, fix volume mask to 5 bits

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index c7b96b4..302553a 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -452,8 +452,8 @@ static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
 	struct em28xx *dev = snd_kcontrol_chip(kcontrol);
-	u16 val = (value->value.integer.value[0] & 0x1f) |
-		  (value->value.integer.value[1] & 0x1f) << 8;
+	u16 val = (0x1f - (value->value.integer.value[0] & 0x1f)) |
+		  (0x1f - (value->value.integer.value[1] & 0x1f)) << 8;
 	int rc;
 
 	mutex_lock(&dev->lock);
@@ -482,8 +482,8 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 	if (val < 0)
 		return val;
 
-	value->value.integer.value[0] = val & 0x1f;
-	value->value.integer.value[1] = (val << 8) & 0x1f;
+	value->value.integer.value[0] = 0x1f - (val & 0x1f);
+	value->value.integer.value[1] = 0x1f - ((val << 8) & 0x1f);
 
 	return 0;
 }
@@ -501,9 +501,9 @@ static int em28xx_vol_put_mute(struct snd_kcontrol *kcontrol,
 		goto err;
 
 	if (val)
+		rc &= 0x1f1f;
+	else
 		rc |= 0x8000;
-	else
-		rc &= 0x7f7f;
 
 	rc = em28xx_write_ac97(dev, kcontrol->private_value, rc);
 
@@ -525,9 +525,9 @@ static int em28xx_vol_get_mute(struct snd_kcontrol *kcontrol,
 		return val;
 
 	if (val & 0x8000)
-		value->value.integer.value[0] = 1;
-	else
 		value->value.integer.value[0] = 0;
+	else
+		value->value.integer.value[0] = 1;
 
 	return 0;
 }
-- 
1.7.1


