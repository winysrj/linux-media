Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EJZagi005184
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:35:36 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0EJYqRE012182
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:34:52 -0500
Received: by ewy14 with SMTP id 14so805595ewy.3
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 11:34:51 -0800 (PST)
Message-ID: <b24e53350901141134h7457a69eq4d72713e686d5745@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:34:51 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [PATCH 4/4] em28xx: Fix for KWorld 330U AC97
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
