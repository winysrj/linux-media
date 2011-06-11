Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab1FKMQs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 08:16:48 -0400
Message-ID: <4DF35CAB.6000408@redhat.com>
Date: Sat, 11 Jun 2011 09:16:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, jarod@wilsonet.com
Subject: Re: [PATCH 09/10] rc-core: lirc use unsigned int
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <20110428151358.8272.94634.stgit@felix.hardeman.nu> <4DC16F57.4030304@redhat.com> <c8ca8a9312f5bb8cd04b7f465e66d268@hardeman.nu>
In-Reply-To: <c8ca8a9312f5bb8cd04b7f465e66d268@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-05-2011 06:46, David Härdeman escreveu:
> On Wed, 04 May 2011 12:23:03 -0300, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 28-04-2011 12:13, David Härdeman escreveu:
>>> Durations can never be negative, so it makes sense to consistently use
>>> unsigned int for LIRC transmission. Contrary to the initial impression,
>>> this shouldn't actually change the userspace API.
>>
>> Patch looked ok to me (except for one small issue - see bellow). 
>>
> ...
>>> diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
>>> index 569b07b..2b1d2df 100644
>>> --- a/drivers/media/rc/ene_ir.c
>>> +++ b/drivers/media/rc/ene_ir.c
>>> @@ -953,13 +953,13 @@ static void ene_set_idle(struct rc_dev *rdev,
> bool
>>> idle)
>>>  }
>>>  
>>>  /* outside interface: transmit */
>>> -static int ene_transmit(struct rc_dev *rdev, int *buf, u32 n)
>>> +static int ene_transmit(struct rc_dev *rdev, unsigned *buf, unsigned
> n)
>>>  {
>>>  	struct ene_device *dev = rdev->priv;
>>>  	unsigned long flags;
>>>  
>>>  	dev->tx_buffer = buf;
>>> -	dev->tx_len = n / sizeof(int);
>>> +	dev->tx_len = n;
>>
>> That hunk seems wrong to me. Or is it a bug fix that you're solving?
> 
> My fault, I didn't mention in the patch description that the third
> argument of the tx function is also changed to mean array size rather
> than size in number of bytes.

Sorry for the long delay. Got sidetracked with other things.

Patch applied.

Thanks,
Mauro
