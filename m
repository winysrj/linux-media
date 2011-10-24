Return-path: <linux-media-owner@vger.kernel.org>
Received: from contrabass.post.ru ([85.21.78.5]:18653 "EHLO
	contrabass.corbina.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab1JXNIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 09:08:04 -0400
Message-ID: <4EA56322.7040609@darkmike.ru>
Date: Mon, 24 Oct 2011 17:07:46 +0400
From: Mike Mironov <subscribe@darkmike.ru>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Josu Lazkano <josu.lazkano@gmail.com>
Subject: Re: Problem with TeVii S-470
References: <4EA54389.9040505@darkmike.ru> <CAL9G6WX1tTSLsm-iMNWnJdWJWQQ1m31WTTzrvG3eh9BYE8fnfw@mail.gmail.com>
In-Reply-To: <CAL9G6WX1tTSLsm-iMNWnJdWJWQQ1m31WTTzrvG3eh9BYE8fnfw@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

24.10.2011 15:29, Josu Lazkano пишет:
> 2011/10/24 Mike Mironov<subscribe@darkmike.ru>:
>> Hello!
>>
>> I have this card http://www.linuxtv.org/wiki/index.php/TeVii_S470
>>
>> I try to use it under Debian Squeeze, but I can't get channel data from it.
>>
>> I try to use drivers from 2.6.38, 2.6.39 kernels, s2-liplianin drivers with
>> 2.6.32 kernel, last linux-media drivers with 2.6.32
>>
>> With all drivers I can scan channels, but then a I'll try to lock channel I
>> get some error in syslog (module cx23885 loaded with debug=1)
>>
>> cx23885[0]/0: [f373ec80/27] cx23885_buf_queue - append to active
>> cx23885[0]/0: [f373ebc0/28] wakeup reg=477 buf=477
>> cx23885[0]/0: queue is not empty - append to active
>>
>> and finally a lot of
>>
>> cx23885[0]/0: [f42c4240/6] timeout - dma=0x03c5c000
>> cx23885[0]/0: [f42c4180/7] timeout - dma=0x3322b000
>> cx23885[0]/0: [f4374440/8] timeout - dma=0x33048000
>> cx23885[0]/0: [f4374140/9] timeout - dma=0x03d68000
>>
>> In other machine this work under Windows. Under Linux I have same effects.
>>
>> It's problem in drivers or in card? That addition information need to
>> resolve this problem?
>
> Hello Mike, I have same device on same OS, try this:
> mkdir /usr/local/src/dvbcd /usr/local/src/dvbwget
> http://tevii.com/100315_Beta_linux_tevii_ds3000.rarunrar x
> 100315_Beta_linux_tevii_ds3000.rarcp dvb-fe-ds3000.fw
> /lib/firmware/tar xjvf linux-tevii-ds3000.tar.bz2cd
> linux-tevii-ds3000make&&  make install
> Regards.

I'll try use this drivers today, but for this devices drivers exist in 
kernel from 2.6.33. So it must work with in-kernel drivers.

P.S. Firmware from this archive I put in /lib/firmware before all tests.
$ md5sum /lib/firmware/dvb-fe-ds3000.fw
a32d17910c4f370073f9346e71d34b80  /lib/firmware/dvb-fe-ds3000.fw
