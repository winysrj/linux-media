Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab0BBUwp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 15:52:45 -0500
Message-ID: <4B689094.2070204@redhat.com>
Date: Tue, 02 Feb 2010 18:52:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] -  tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de>
In-Reply-To: <4B688E41.2050806@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 02.02.2010 21:03, schrieb Mauro Carvalho Chehab:
>>>>> @@ -404,6 +432,7 @@ int tm6000_init (struct tm6000_core *dev)
>>>>>  {
>>>>>      int board, rc=0, i, size;
>>>>>      struct reg_init *tab;
>>>>> +    u8 buf[40];
>>>>>     
>>>>>         
>>>> Why "40" ? Please avoid using magic numbers here, especially if you're
>>>> not checking at the logic if you're writing outside the buffer.
>>>>
>>>>   
>>>>       
>>> It important for tm6010 init sequence to enable the demodulator, because
>>> the demodulator haven't found after init tuner.
>>>     
>> Probably, there is some i2c gate to enable/disable the i2c access to the
>> demodulator. The better way is to add a call to the tm6000-dvb and let it
>> init the demodulator.
>>
>> Also, since there's a gate for the demodulator, the proper way is to add
>> a callback to control it. Please take a look at saa7134 and seek for i2c_gate_ctrl
>> to see how such logic works.
>>
>>   
> It has followed structure schema without the GPIOs:
> 1. tm6010 init
> 2. enable zl10353
> 3. tm6010 re-init
> 
> If it board specific then it's better when board number definition 
> switch from tm6000-card.c to tm6000.h . We can use in all tm6000*.c
> files the board definition .

What's board specific: all stuff that has GPIO, and the demod/frontend enable code.
In order to have a better structure, the demod/frontend enable code should be at the tm6000-dvb,
just like the other drivers. There, you'll have a switch for those devices that have DVB
(Among others, I have here one 10moons device that is analog-only, with a tm5600 - a stripped
down version of tm6000, without the DVB part).

-- 

Cheers,
Mauro
