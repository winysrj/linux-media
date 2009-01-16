Return-path: <linux-media-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:11493 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936121AbZAPOYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 09:24:44 -0500
Received: by nf-out-0910.google.com with SMTP id d3so262290nfc.21
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 06:24:40 -0800 (PST)
Message-ID: <b24e53350901160624i12d26151va879d817ea354c63@mail.gmail.com>
Date: Fri, 16 Jan 2009 09:24:40 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] em28xx: Clock (XCLK) Cleanup
In-Reply-To: <b24e53350901141118h5e969j36b796245e646461@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b24e53350901141020s5dbe45b5g42f1d5c3e7a81b40@mail.gmail.com>
	 <b24e53350901141117h79f900b8t3fc28c10b4a12bb9@mail.gmail.com>
	 <b24e53350901141118h5e969j36b796245e646461@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: Clock (XCLK) Cleanup

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Clock (XCLK) Cleanupt

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
