Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1GRRrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 13:47:24 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6IHlOja026064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 13:47:24 -0400
Message-ID: <4E24719C.8040809@redhat.com>
Date: Mon, 18 Jul 2011 13:47:08 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/9] [media] mceusb: give hardware time to reply to cmds
References: <1310681394-3530-1-git-send-email-jarod@redhat.com> <1310681394-3530-3-git-send-email-jarod@redhat.com> <4E1F7C11.1050608@redhat.com>
In-Reply-To: <4E1F7C11.1050608@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em 14-07-2011 19:09, Jarod Wilson escreveu:
>> Sometimes the init routine is blasting commands out to the hardware
>> faster than it can reply. Throw a brief delay in there to give the
>> hardware a chance to reply before we send the next command.
>>
>> Signed-off-by: Jarod Wilson<jarod@redhat.com>
>> ---
>>   drivers/media/rc/mceusb.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
>> index 111bead..13a853b 100644
>> --- a/drivers/media/rc/mceusb.c
>> +++ b/drivers/media/rc/mceusb.c
>> @@ -37,6 +37,7 @@
>>   #include<linux/slab.h>
>>   #include<linux/usb.h>
>>   #include<linux/usb/input.h>
>> +#include<linux/delay.h>
>>   #include<media/rc-core.h>
>>
>>   #define DRIVER_VERSION	"1.91"
>> @@ -735,6 +736,7 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
>>   static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
>>   {
>>   	mce_request_packet(ir, data, size, MCEUSB_TX);
>> +	mdelay(10);
>
> Can't it be a msleep() instead? Delays spend more power, and keeps the CPU busy while
> running.

I think I was thinking we'd end up sleeping in an interrupt handler when 
we shouldn't be, but upon closer code inspection and actual testing, 
that's not the case, so yeah, those can be msleeps. While testing all 
code paths, I also discovered that patch 6 in the series breaks lirc tx 
support (the lirc dev is registered before the tx function pointers are 
filled in), so I'll resend at least patches 2 and 6...

-- 
Jarod Wilson
jarod@redhat.com


