Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51439 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3GXPb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 11:31:26 -0400
Received: by mail-ee0-f54.google.com with SMTP id t10so325642eei.13
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 08:31:24 -0700 (PDT)
Message-ID: <51EFF3D3.1070603@googlemail.com>
Date: Wed, 24 Jul 2013 17:33:39 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Alban Browaeys <alban.browaeys@gmail.com>
CC: m.chehab@samsung.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 2/4] [media] em28xx: i2s 5 sample rates is a subset of
 3 one.
References: <1374015941-27538-1-git-send-email-prahal@yahoo.com> <51E8072C.5070600@googlemail.com> <CAMhY2AXP=B=+Tu90q3tYQKq3Nw8fyR0+Am4OAmusCT-CyoH6Cg@mail.gmail.com>
In-Reply-To: <CAMhY2AXP=B=+Tu90q3tYQKq3Nw8fyR0+Am4OAmusCT-CyoH6Cg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[2nd try - vger.kernel.org rejects html content]


Please, don't top-post and don't drop any recipients.


Am 24.07.2013 15:40, schrieb Alban Browaeys:
> if 0xf0 , then the if (0x20 == ) else if (0x30 ==) first match 0x20
> succeed and bail out . 0x20 is a subset if 0x30.

(chipcfg & EM28XX_CHIPCFG_AUDIOMASK) = 0x30, and the if - else if
statements compares this with ==.
So how can 0x30 be 0x20 ???

Regards,
Frank

>
>
> 2013/7/18 Frank Schäfer <fschaefer.oss@googlemail.com
> <mailto:fschaefer.oss@googlemail.com>>
>
>     Am 17.07.2013 01:05, schrieb Alban Browaeys:
>     > As:
>     > EM28XX_CHIPCFG_I2S_3_SAMPRATES 0x20
>     > EM28XX_CHIPCFG_I2S_5_SAMPRATES 0x30
>     >
>     > the board chipcfg is 0xf0 thus if 3_SAMPRATES is tested
>     > first and matches while it is a 5_SAMPRATES.
>     >
>     > Signed-off-by: Alban Browaeys <prahal@yahoo.com
>     <mailto:prahal@yahoo.com>>
>     > ---
>     >  drivers/media/usb/em28xx/em28xx-core.c | 8 ++++----
>     >  1 file changed, 4 insertions(+), 4 deletions(-)
>     >
>     > diff --git a/drivers/media/usb/em28xx/em28xx-core.c
>     b/drivers/media/usb/em28xx/em28xx-core.c
>     > index fc157af..3c0c5e9 100644
>     > --- a/drivers/media/usb/em28xx/em28xx-core.c
>     > +++ b/drivers/media/usb/em28xx/em28xx-core.c
>     > @@ -505,13 +505,13 @@ int em28xx_audio_setup(struct em28xx *dev)
>     >               dev->audio_mode.has_audio = false;
>     >               return 0;
>     >       } else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
>     > -                EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
>     > -             em28xx_info("I2S Audio (3 sample rates)\n");
>     > -             dev->audio_mode.i2s_3rates = 1;
>     > -     } else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
>     >                  EM28XX_CHIPCFG_I2S_5_SAMPRATES) {
>     >               em28xx_info("I2S Audio (5 sample rates)\n");
>     >               dev->audio_mode.i2s_5rates = 1;
>     > +     } else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
>     > +                EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
>     > +             em28xx_info("I2S Audio (3 sample rates)\n");
>     > +             dev->audio_mode.i2s_3rates = 1;
>     >       }
>     >
>     >       if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {
>
>     What changes ?
>     If chipcfg is 0xf0, chipcfg & EM28XX_CHIPCFG_AUDIOMASK = 0x30 =
>     EM28XX_CHIPCFG_I2S_5_SAMPRATES and not 0x20 =
>     EM28XX_CHIPCFG_I2S_3_SAMPRATES...
>
>     Frank
>
>

