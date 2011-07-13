Return-path: <mchehab@localhost>
Received: from casper.infradead.org ([85.118.1.10]:39834 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1GMOgW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 10:36:22 -0400
Message-ID: <4E1DAD47.9030100@infradead.org>
Date: Wed, 13 Jul 2011 11:35:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Fabio Belavenuto <belavenuto@gmail.com>
CC: Jean Delvare <jdelvare@suse.de>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] tea5764: Fix module parameter permissions
References: <201107081100.37406.jdelvare@suse.de> <fe03786e-e629-4260-b637-80a58ce37728@email.android.com> <201107111354.09782.jdelvare@suse.de> <CAHmkXtGiry-ieG5okHd4Uxo3LS6gapPYCdE6BsJBsw2HVsmGiA@mail.gmail.com>
In-Reply-To: <CAHmkXtGiry-ieG5okHd4Uxo3LS6gapPYCdE6BsJBsw2HVsmGiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>

Em 11-07-2011 09:25, Fabio Belavenuto escreveu:
> Hi,
> 
> I'm the author. Sorry for my bad english, I'm from Brazil. :D
> 
> Yes, the intent of the "1" is to set the default value, in case
> compile built-in.
> 
> I like the module to be generic, decided to choose enabled by default.
> 
> Fábio
> 
> 2011/7/11 Jean Delvare <jdelvare@suse.de>:
>> Hi Andy,
>>
>> On Friday 08 July 2011 12:34:38 pm Andy Walls wrote:
>>> Jean Delvare <jdelvare@suse.de> wrote:
>>>> The third parameter of module_param is supposed to represent sysfs
>>>> file permissions. A value of "1" leads to the following:
>>>>
>>>> $ ls -l /sys/module/radio_tea5764/parameters/
>>>> total 0
>>>> ---------x 1 root root 4096 Jul  8 09:17 use_xtal
>>>>
>>>> I am changing it to "0" to align with the other module parameters in
>>>> this driver.
>>>>
>>>> Signed-off-by: Jean Delvare <jdelvare@suse.de>
>>>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>>>> Cc: Fabio Belavenuto <belavenuto@gmail.com>
>>>> ---
>>>> drivers/media/radio/radio-tea5764.c |    2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> ---
>>>> linux-3.0-rc6.orig/drivers/media/radio/radio-tea5764.c      2011-05-20
>>>> 10:41:19.000000000 +0200
>>>> +++ linux-3.0-rc6/drivers/media/radio/radio-tea5764.c        2011-07-08
>>>> 09:15:16.000000000 +0200
>>>> @@ -596,7 +596,7 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
>>>> MODULE_DESCRIPTION(DRIVER_DESC);
>>>> MODULE_LICENSE("GPL");
>>>>
>>>> -module_param(use_xtal, int, 1);
>>>> +module_param(use_xtal, int, 0);
>>>> MODULE_PARM_DESC(use_xtal, "Chip have a xtal connected in board");
>>>> module_param(radio_nr, int, 0);
>>>> MODULE_PARM_DESC(radio_nr, "video4linux device number to use");
>>>
>>> To whomever might know:
>>>
>>> Was the intent of the "1" to set the default value of the parameter?
>>
>> My guess is yes, and as a matter of fact 1 is indeed the default value
>> of use_xtal. Only the author of the code (Fabio Belavenuto) could tell
>> for sure, but he seems to be no longer involved so I wouldn't wait for
>> him.

The value there is not the default value, but the permissions. From what
I understand, the xtal frequency should be set at boot time, so setting
it to 000 seems to do the work. So, I'm applying Jean's patch.

>>
>> --
>> Jean Delvare
>> Suse L3
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

