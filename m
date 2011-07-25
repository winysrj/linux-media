Return-path: <linux-media-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab1GYOao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 10:30:44 -0400
Received: from cnxtsmtp2.conexant.com (cnxt09253.conexant.com [198.62.9.253])
	by hera.kernel.org (8.14.4/8.14.3) with ESMTP id p6PEUgD5028070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 14:30:43 GMT
Received: from nbwsmx2.bbnet.ad (nbwsmx2.bbnet.ad [157.152.183.212]) (using TLSv1 with cipher
 RC4-MD5 (128/128 bits)) (No client certificate requested) by cnxtsmtp2.conexant.com (Axway MailGate
 3.8.1) with ESMTP id 29AA423B6B4 for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 07:30:38 -0700
 (PDT)
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Devin Heitmueller" <dheitmueller@kernellabs.com>
cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Gerd Hoffmann" <kraxel@redhat.com>,
	"Sri Deevi" <Srinivasa.Deevi@conexant.com>
Date: Mon, 25 Jul 2011 07:30:37 -0700
Subject: RE: [PATCH] Fix regression introduced which broke the Hauppauge USBLive 2
Message-ID: <e43a564b-3bb6-466f-bce6-1a90a40d15d2@cnxthub1.bbnet.ad>
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
 <4E2C16B5.5010703@redhat.com> <73512a61-63b5-4e42-bbda-26e33ec8ec35@cnxthub2.bbnet.ad>
 <CAGoCfizcdGFPyPC6zYBKPcVJxr5PC4TWG7Kt4iNzQaCiKiiCnA@mail.gmail.com>,<4E2D685E.6090209@redhat.com>
In-Reply-To: <4E2D685E.6090209@redhat.com>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro and Devin,

  Thanks for the explainations. The fix proposed is ok and as Devin mentioned, should have very low impact. I'll see if I can dig into the issue to root cause it. 

Thanks for your help.

Rgds,
Palash

Signed off by Palash Bandyopadhyay

________________________________________
From: Mauro Carvalho Chehab [mchehab@redhat.com]
Sent: Monday, July 25, 2011 5:58 AM
To: Devin Heitmueller
Cc: Palash Bandyopadhyay; Linux Media Mailing List; Gerd Hoffmann; Sri Deevi
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge USBLive 2

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
Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

