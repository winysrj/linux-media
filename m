Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:36252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab1EITpq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:45:46 -0400
Message-ID: <4DC84470.7060603@redhat.com>
Date: Mon, 09 May 2011 15:45:52 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?SnVhbiBKZXPDunMgR2FyY8OtYSBkZSBTb3JpYSBMdWNlbmE=?=
	<skandalfo@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ite-cir: make IR receive work after resume
References: <dwy71fckod7ba37187igo82l.1304967460349@email.android.com>
In-Reply-To: <dwy71fckod7ba37187igo82l.1304967460349@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Juan Jesús García de Soria Lucena wrote:
> Hi Jarod, and thanks for looking at this.
>
> El 09/05/2011 20:28, "Jarod Wilson"<jarod@redhat.com>  escribió:
>> --- a/drivers/media/rc/ite-cir.c
>> +++ b/drivers/media/rc/ite-cir.c
>> @@ -1684,6 +1684,8 @@ static int ite_resume(struct pnp_dev *pdev)
>>                 /* wake up the transmitter */
>>                 wake_up_interruptible(&dev->tx_queue);
>>         } else {
>> +               /* reinitialize hardware config registers */
>> +               dev->params.init_hardware(dev);
>>                 /* enable the receiver */
>>                 dev->params.enable_rx(dev);
>>         }
>> --
>> 1.7.1
>>
>
> But... wouldn't the hardware initialization be required too if the hardware got suspended while doing TX? I mean, probably the call to init_hardware() should be done in any case, just before the if... (forgive me if I'm off target; I'm looking at the code as I remember it, since I don't have it before me right now).

Well, looking at the resume function, I wasn't sure if I wanted to
mess with things while it was possibly trying to finish up tx, but
upon closer inspection, I don't think we can ever get into the
state where we're actually doing anything in the tx handler where
it would matter. If dev->transmitting is true and we're actually
able to grab the spinlock, it means we're just in the middle of
the mdelay for remaining_us, and everything done after that is
partially redundant with init_hardware anyway. So yeah, it looks
safe to me to just put in the init_hardware unconditionally above
the check for dev->transmitting.

On a related note though... what are the actual chances that we are
suspending in the middle of tx, and what are the chances it would
actually be of any use to resume that tx after waking up?

So what I'm now thinking is this: add a wait_event_interruptible on
tx_ended in the suspend path if dev->transmitting to let tx finish
before we suspend. Then in resume, we're never resuming in the
middle of tx and the whole conditional goes away.

-- 
Jarod Wilson
jarod@redhat.com


