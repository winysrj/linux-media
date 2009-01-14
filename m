Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EJJBpn027158
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:19:11 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0EJIlWt010383
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:18:47 -0500
Received: by ewy14 with SMTP id 14so796543ewy.3
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 11:18:46 -0800 (PST)
Message-ID: <b24e53350901141118h5e969j36b796245e646461@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:18:46 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com
In-Reply-To: <b24e53350901141117h79f900b8t3fc28c10b4a12bb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b24e53350901141020s5dbe45b5g42f1d5c3e7a81b40@mail.gmail.com>
	<b24e53350901141117h79f900b8t3fc28c10b4a12bb9@mail.gmail.com>
Subject: [PATCH 2/4] em28xx: Clock (XCLK) Cleanup
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



-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
