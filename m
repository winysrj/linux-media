Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1GXM5a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 08:57:30 -0400
Message-ID: <4E2C16B5.5010703@redhat.com>
Date: Sun, 24 Jul 2011 09:57:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge USBLive
 2
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
In-Reply-To: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
>  		.norm = V4L2_STD_NTSC,
>  		.no_alt_vanc = 1,
>  		.external_av = 1,
> +		.dont_use_port_3 = 1,
>  		.input = {{
>  			.type = CX231XX_VMUX_COMPOSITE1,
>  			.vmux = CX231XX_VIN_2_1,

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
 
-	msleep(PWR_SLEEP_INTERVAL);
+	msleep(PWR_SLEEP_INTERVAL * 10);
 
 	/* For power saving, only enable Pwr_resetout_n
 	   when digital TV is selected. */
-- 
