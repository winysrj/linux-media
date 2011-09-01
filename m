Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1IAFr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Sep 2011 01:47:56 -0400
Message-ID: <4E5F1C87.9050207@redhat.com>
Date: Thu, 01 Sep 2011 02:47:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 07/21] [staging] tm6000: Remove artificial delay.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-8-git-send-email-thierry.reding@avionic-design.de> <4E5E9089.8030804@redhat.com> <20110901051324.GC18473@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20110901051324.GC18473@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-09-2011 02:13, Thierry Reding escreveu:
> * Mauro Carvalho Chehab wrote:
>> Em 04-08-2011 04:14, Thierry Reding escreveu:
>>> ---
>>>  drivers/staging/tm6000/tm6000-core.c |    3 ---
>>>  1 files changed, 0 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
>>> index e14bd3d..2c156dd 100644
>>> --- a/drivers/staging/tm6000/tm6000-core.c
>>> +++ b/drivers/staging/tm6000/tm6000-core.c
>>> @@ -86,9 +86,6 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
>>>  	}
>>>  
>>>  	kfree(data);
>>> -
>>> -	msleep(5);
>>> -
>>>  	return ret;
>>>  }
>>>  
>>
>> This delay is needed by some tm5600/6000 devices. Maybe it is due to
>> some specific chipset revision, but I can't remember anymore what
>> device(s) were affected.
>>
>> The right thing to do seems to whitelist the devices that don't need
>> any delay there.
> 
> This was actually the first thing I patched because I couldn't see any need
> for it (the Cinergy Hybrid USB Stick worked fine without) and it made the
> device pretty much unusable (with this delay, firmware loading takes about
> 30 seconds!).

Firmware load timing sucks, but at least the device works. The windows application
load time is even worse than 30 s, at least for the devices I have here.

> 
> Do you want me to follow up with a white-listing patch?

Yes, please. It is good to speed it up, but only when we're sure that this won't cause
troubles.

> 
> Thierry

