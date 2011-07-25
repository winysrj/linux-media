Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxt09253.conexant.com ([198.62.9.253]:9100 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1GYGKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 02:10:48 -0400
Received: from nbwsmx2.bbnet.ad (nbwsmx2.bbnet.ad [157.152.183.212]) (using TLSv1 with cipher
 RC4-MD5 (128/128 bits)) (No client certificate requested) by cnxtsmtp2.conexant.com (Axway MailGate
 3.8.1) with ESMTP id 20B3623AF3E for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 22:53:06 -0700
 (PDT)
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Devin Heitmueller" <dheitmueller@kernellabs.com>
cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Gerd Hoffmann" <kraxel@redhat.com>,
	"Sri Deevi" <Srinivasa.Deevi@conexant.com>
Date: Sun, 24 Jul 2011 22:48:23 -0700
Subject: RE: [PATCH] Fix regression introduced which broke the Hauppauge USBLive 2
Message-ID: <73512a61-63b5-4e42-bbda-26e33ec8ec35@cnxthub2.bbnet.ad>
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>,<4E2C16B5.5010703@redhat.com>
In-Reply-To: <4E2C16B5.5010703@redhat.com>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro/Devin,

  Can someone give steps to reproduce the problem? Also if we need any particular h/w board to reproduce this problem. I dont seem to recall any delay requirement on the chip at power up/cycle time. Any I also dont recall seeing any problems with the Conexant evk boards. Mauro, have you been able to see this issue with a Conexant board?

Thanks,
Palash
________________________________________
From: Mauro Carvalho Chehab [mchehab@redhat.com]
Sent: Sunday, July 24, 2011 5:57 AM
To: Devin Heitmueller
Cc: Linux Media Mailing List; Gerd Hoffmann; Sri Deevi; Palash Bandyopadhyay
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge USBLive 2

Hi Devin,

Em 23-07-2011 22:17, Devin Heitmueller escreveu:
> The following patch addresses the regression introduced in the cx231xx
> driver which stopped the Hauppauge USBLive2 from working.
>
> Confirmed working by both myself and the user who reported the issue
> on the KernelLabs blog (Robert DeLuca).
>
> cx231xx: Fix regression introduced which broke the Hauppauge USBLive 2
>
> From: Devin Heitmueller <dheitmueller@kernellabs.com>
>
> At some point during refactoring of the cx231xx driver, the USBLive 2 device
> became broken.  This patch results in the device working again.
>
> Thanks to Robert DeLuca for sponsoring this work.
>
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: Robert DeLuca <robertdeluca@me.com>
>
> diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c
> b/drivers/media/video/cx231xx/cx231xx-cards.c
> index 4b22afe..d02c63a 100644
> --- a/drivers/media/video/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/video/cx231xx/cx231xx-cards.c
> @@ -387,6 +387,7 @@ struct cx231xx_board cx231xx_boards[] = {
>               .norm = V4L2_STD_NTSC,
>               .no_alt_vanc = 1,
>               .external_av = 1,
> +             .dont_use_port_3 = 1,
>               .input = {{
>                       .type = CX231XX_VMUX_COMPOSITE1,
>                       .vmux = CX231XX_VIN_2_1,

I proposed the same fix sometime ago, when Gerd reported this issue
for me. His feedback was that this partially fixed the issue, but
he reported that he also needed to increase the set_power_mode delay
from 5 to 50 ms in order to fully initialize the cx231xx hardware,
as on the enclosed patch. It seems he tested with vanilla Fedora kernel.

So, I suspect that HZ may be affecting this driver as well. As you know,
if HZ is configured with 100, the minimum msleep() delay will be 10.
so, instead of waiting for 5ms, it will wait for 10ms for the device
to powerup.

It would be great to configure HZ with 1000 and see the differences with
and without Gerd's patch.

Cheers,
Mauro.

-

>From a83a7574e07b48b1c6a222d833a7fa0a67133b5c Mon Sep 17 00:00:00 2001
From: Gerd Hoffmann <kraxel@gmail.com>
Date: Thu, 16 Dec 2010 17:39:17 +0100
Subject: [PATCH] cx231xx: raise delay after powerup.

Wait a bit longer after power up so the chips have enougth
time to come up before we try talking to them via i2c.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/media/video/cx231xx/cx231xx-avcore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index cf50faf..cf412cd 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -2412,7 +2412,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
                break;
        }

-       msleep(PWR_SLEEP_INTERVAL);
+       msleep(PWR_SLEEP_INTERVAL * 10);

        /* For power saving, only enable Pwr_resetout_n
           when digital TV is selected. */
--
Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

