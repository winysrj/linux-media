Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:64939 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935790AbZAPO10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 09:27:26 -0500
Received: by ewy10 with SMTP id 10so1921154ewy.13
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 06:27:24 -0800 (PST)
Message-ID: <b24e53350901160627g3f93814ep9ed8da5ac9f70dd6@mail.gmail.com>
Date: Fri, 16 Jan 2009 09:27:23 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] em28xx: Fix for KWorld 330U AC97
In-Reply-To: <b24e53350901141134h7457a69eq4d72713e686d5745@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b24e53350901141134h7457a69eq4d72713e686d5745@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: Fix for KWorld 330U AC97

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Fix for KWorld 330U AC97

Many thanks to Devin and Mauro again!!!

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-core.c
--- a/linux/drivers/media/video/em28xx/em28xx-core.c    Wed Jan 14
10:06:12 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c    Wed Jan 14
12:47:00 2009 -0500
@@ -424,7 +424,7 @@

       xclk = dev->board.xclk & 0x7f;
       if (!dev->mute)
-               xclk |= 0x80;
+               xclk |= EM28XX_XCLK_AUDIO_UNMUTE;

       ret = em28xx_write_reg(dev, EM28XX_R0F_XCLK, xclk);
       if (ret < 0)
@@ -437,6 +437,10 @@
       /* Sets volume */
       if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
               int vol;
+
+               em28xx_write_ac97(dev, AC97_POWER_DOWN_CTRL, 0x4200);
+               em28xx_write_ac97(dev, AC97_EXT_AUD_CTRL, 0x0031);
+               em28xx_write_ac97(dev, AC97_PCM_IN_SRATE, 0xbb80);

               /* LSB: left channel - both channels with the same level */
               vol = (0x1f - dev->volume) | ((0x1f - dev->volume) << 8);
