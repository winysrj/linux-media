Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55565 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab0FNVF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 17:05:59 -0400
Message-ID: <4C1699C4.3010809@gmail.com>
Date: Mon, 14 Jun 2010 14:06:12 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8]i2c:i2c_core Fix warning: variable 'dummy' set but
 not used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>	<1276547208-26569-7-git-send-email-justinmattock@gmail.com> <20100614225315.2bae9e37@hyperion.delvare>
In-Reply-To: <20100614225315.2bae9e37@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2010 01:53 PM, Jean Delvare wrote:
> Hi Justin,
>
> On Mon, 14 Jun 2010 13:26:46 -0700, Justin P. Mattock wrote:
>> could be a right solution, could be wrong
>> here is the warning:
>>    CC      drivers/i2c/i2c-core.o
>> drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
>> drivers/i2c/i2c-core.c:757:15: warning: variable 'dummy' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/i2c/i2c-core.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 1cca263..79c6c26 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -794,6 +794,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>>   	mutex_lock(&core_lock);
>>   	dummy = bus_for_each_drv(&i2c_bus_type, NULL, adap,
>>   				 __process_new_adapter);
>> +	if(!dummy)
>> +		dummy = 0;
>
> One word: scripts/checkpatch.pl

it was this, and/or just take the code out
(since I'm a newbie)

>
> In other news, the above is just plain wrong. First we force people to
> read the result of bus_for_each_drv() and then when they do and don't
> need the value, gcc complains, so we add one more layer of useless
> code, which developers and possibly tools will later wonder and
> complain about? I can easily imagine that a static code analyzer would
> spot the above code as being a potential bug.
>
> Let's stop this madness now please.
>

your telling me!! I haven't even compiled all the way
through the kernel yet.(lots of warnings)

> Either __must_check goes away from bus_for_each_drv() and from every
> other function which raises this problem, or we must disable that new
> type of warning gcc 4.6.0 generates. Depends which warnings we value
> more, as we can't sanely have both.
>
>>   	mutex_unlock(&core_lock);
>>
>>   	return 0;
>
>

up to you guys..
best thing now is deciphering what
and what not is an actual issue.

Justin P. Mattock
