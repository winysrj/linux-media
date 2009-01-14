Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EICkGv020659
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 13:12:46 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0EICVUC008772
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 13:12:31 -0500
Received: by ewy14 with SMTP id 14so759186ewy.3
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 10:12:31 -0800 (PST)
Message-ID: <b24e53350901141012x2d417e1cka675b61e44221013@mail.gmail.com>
Date: Wed, 14 Jan 2009 13:12:31 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: [PATCH 2.6.27.8 1/1] em28xx: Clock (XCLK) Cleanup
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

Developer's Certificate of Origin 1.1

       By making a contribution to this project, I certify that:

       (a) The contribution was created in whole or in part by me and I
           have the right to submit it under the open source license
           indicated in the file; or

       (b) The contribution is based upon previous work that, to the best
           of my knowledge, is covered under an appropriate open source
           license and I have the right under that license to submit that
           work with modifications, whether created in whole or in part
           by me, under the same open source license (unless I am
           permitted to submit under a different license), as indicated
           in the file; or

       (c) The contribution was provided directly to me by some other
           person who certified (a), (b) or (c) and I have not modified
           it.

       (d) I understand and agree that this project and the contribution
           are public and that a record of the contribution (including all
           personal information I submit with it, including my sign-off) is
           maintained indefinitely and may be redistributed consistent with
           this project or the open source license(s) involved.

Signed-off-by: Robert V. Krakora <rob.krakora@messagenetsystems.com>

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
