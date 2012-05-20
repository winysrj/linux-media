Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab2ETBVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 21:21:34 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/6] snd_tea575x: set_freq: update cached freq to the actual achieved frequency
Date: Sun, 20 May 2012 03:25:30 +0200
Message-Id: <1337477131-21578-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
References: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>
---
 sound/i2c/other/tea575x-tuner.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 8c142e5..d16f7b7 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -126,9 +126,9 @@ static u32 snd_tea575x_read(struct snd_tea575x *tea)
 	return data;
 }
 
-static u32 snd_tea575x_get_freq(struct snd_tea575x *tea)
+static u32 snd_tea575x_val_to_freq(struct snd_tea575x *tea, u32 val)
 {
-	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
+	u32 freq = val & TEA575X_BIT_FREQ_MASK;
 
 	if (freq == 0)
 		return freq;
@@ -145,6 +145,11 @@ static u32 snd_tea575x_get_freq(struct snd_tea575x *tea)
 	return clamp(freq * 16, FREQ_LO, FREQ_HI); /* from kHz */
 }
 
+static u32 snd_tea575x_get_freq(struct snd_tea575x *tea)
+{
+	return snd_tea575x_val_to_freq(tea, snd_tea575x_read(tea));
+}
+
 static void snd_tea575x_set_freq(struct snd_tea575x *tea)
 {
 	u32 freq = tea->freq;
@@ -162,6 +167,7 @@ static void snd_tea575x_set_freq(struct snd_tea575x *tea)
 	tea->val &= ~TEA575X_BIT_FREQ_MASK;
 	tea->val |= freq & TEA575X_BIT_FREQ_MASK;
 	snd_tea575x_write(tea, tea->val);
+	tea->freq = snd_tea575x_val_to_freq(tea, tea->val);
 }
 
 /*
-- 
1.7.10

