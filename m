Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1GYM6L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 08:58:11 -0400
Message-ID: <4E2D685E.6090209@redhat.com>
Date: Mon, 25 Jul 2011 09:58:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge USBLive
 2
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com> <4E2C16B5.5010703@redhat.com> <73512a61-63b5-4e42-bbda-26e33ec8ec35@cnxthub2.bbnet.ad> <CAGoCfizcdGFPyPC6zYBKPcVJxr5PC4TWG7Kt4iNzQaCiKiiCnA@mail.gmail.com>
In-Reply-To: <CAGoCfizcdGFPyPC6zYBKPcVJxr5PC4TWG7Kt4iNzQaCiKiiCnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Palash,

Em 25-07-2011 07:24, Devin Heitmueller escreveu:
> On Mon, Jul 25, 2011 at 1:48 AM, Palash Bandyopadhyay
> <Palash.Bandyopadhyay@conexant.com> wrote:
>> Mauro/Devin,
>>
>>  Can someone give steps to reproduce the problem? Also if we need any particular h/w board to reproduce this problem. 
> I dont seem to recall any delay requirement on the chip at power up/cycle time. Any I also dont recall seeing any
>  problems with the Conexant evk boards. Mauro, have you been able to see this issue with a Conexant board?

This problem were reported with Hauppauge USBLive 2 by several users.
I had a similar problem with another grabber device. My guess is that,
on non-grabber devices, the additional steps needed to control other
device elements spend some time, and, due to that, the delay timing
issue is not noticed.

The first strategy used to fix such bug is the following patch, that
I've forwarded you, back in December:

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

> The problem occurs if the kernel is configured for CONFIG_HZ to 1000
> and on the Hauppauge USBLIve 2 hardware design.  I'm assuming it's
> tied to two factors:
> 
> 1.  Some aspect of the power supply tied to the Mako core being a
> little slow to startup.  I haven't compared the schematic to the EVK,
> but I could do that if we *really* think that is a worthwhile
> exercise.
> 2.  On typical kernels which have CONFIG_HZ set to 100, a call to
> msleep(5) will actually take approximately 10ms (due to the clock
> resolution).  However, if you have CONFIG_HZ set to 1000 then the call
> *actually* takes 5ms which is too short for this design.  In other
> words, you would be unlikely to notice the issue unless you had
> CONFIG_HZ set to a high enough resolution for the msleep(5) to
> actually take 5ms.
> 
> The changed as proposed should be very low impact.  For users who have
> CONFIG_HZ set to 100 (which is typical), there will be no visible
> increase in time (since the call was already taking 10ms).  For users
> who have CONFIG_HZ set to 1000, the net effect is that it takes an
> extra 20ms to switch hardware modes (since the #define in question is
> used at most four times in sequence).

I agree with Devin. The impact is probably not visible for the users whose
boards are already working, but it is very significant for the ones that
have grabber devices whose devices don't work due to the delay issue, as
the device will start working.

>From my side, I don't mind if you want to solve it with another strategy,
for example, like on a code that would check if the device was actually
powered-up, but, if just increasing the delay to 10 ms is is enough and won't
cause side effects, I would just get the simplest fix.

Cheers,
Mauro

