Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m09.mx.aol.com ([64.12.143.82]:64922 "EHLO
	omr-m09.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475Ab3HJNWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 09:22:49 -0400
Message-ID: <52063E81.9040303@netscape.net>
Date: Sat, 10 Aug 2013 10:22:09 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC 0/3] Experimental patches for ISDB-T on Mygica X8502/X8507
References: <1375980712-9349-1-git-send-email-m.chehab@samsung.com> <5204311E.6070602@netscape.net> <20130809102410.73d896de@samsung.com>
In-Reply-To: <20130809102410.73d896de@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El 09/08/13 10:24, Mauro Carvalho Chehab escribió:
> Em Thu, 08 Aug 2013 21:00:30 -0300
> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
>
>> Hi
>>
>>
>> El 08/08/13 13:51, Mauro Carvalho Chehab escribió:
>>> This is a first set of experimental patches for Mygica X8502/X8507.
>>>
>>> The last patch is just a very dirty hack, for testing purposes. I intend
>>> to get rid of it, but it is there to replace exactly the same changes that
>>> Alfredo reported to work on Kernel 3.2.
>>>
>>> I intend to remove it on a final series, eventually replacing by some
>>> other changes at mb86a20s.
>>>
>>> Alfredo,
>>>
>>> Please test, and send your tested-by, if this works for you.
>> tested-by:  Alfredo Delaiti <alfredodelaiti@netscape.net>
>>
>>
>>
>> two comments:
>>
>> two  "breaks":
>>
>> @@ -1106,6 +1112,8 @@ static int dvb_register(struct cx23885_tsport *port)
>>    				&i2c_bus2->i2c_adap,
>>    				&mygica_x8506_xc5000_config);
>>    		}
>> +		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
>> +		break;
>>    		break;
>>    		
>>
>> and I would add this on cx23885-cards.c (is not a patch):
>>
>>       case CX23885_BOARD_MYGICA_X8506:
>>       case CX23885_BOARD_MAGICPRO_PROHDTVE2:
>>       case CX23885_BOARD_MYGICA_X8507:
>>           /* GPIO-0 (0)Analog / (1)Digital TV */
>>           /* GPIO-1 reset XC5000 */
>> -        /* GPIO-2 reset LGS8GL5 / LGS8G75 */
>> +        /* GPIO-2 reset LGS8GL5 / LGS8G75 / MB86A20S */
>>           cx23885_gpio_enable(dev, GPIO_0 | GPIO_1 | GPIO_2, 1);
>>           cx23885_gpio_clear(dev, GPIO_1 | GPIO_2);
>>           mdelay(100);
>>           cx23885_gpio_set(dev, GPIO_0 | GPIO_1 | GPIO_2);
>>           mdelay(100);
>>           break;
>>
>>
>> Thanks again Mauro,
> Thank you for your tests. I just pushed a new patch series addressing the
> above, and getting rid of the horrible mb86a20s hack.
>
> Please test it again, to see if the mb86a20s fixes also worked for you.
>
> Thanks!
> Mauro

Thanks, it works, and now more faster, and I only tested with last 
driver that have on git://linuxtv.org/media_build.git

I hope with happiness see those patch on new kernels.

Again,Thannks

Alfredo
