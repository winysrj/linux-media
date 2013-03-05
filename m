Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da03.mx.aol.com ([205.188.105.145]:53605 "EHLO
	imr-da03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3CEABD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 19:01:03 -0500
Message-ID: <51353591.4040709@netscape.net>
Date: Mon, 04 Mar 2013 21:00:17 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com>
In-Reply-To: <20130304164234.18df36a7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

El 04/03/13 16:42, Mauro Carvalho Chehab escribió:
> Em Sun, 3 Mar 2013 13:40:51 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
>
>> Em Sun, 03 Mar 2013 11:50:25 -0300
>> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
>>
>>
>>> The new data replacement in mb86a20s
>>>
>>> /*
>>>    * Initialization sequence: Use whatevere default values that PV SBTVD
>>>    * does on its initialisation, obtained via USB snoop
>>>    */
>>> static struct regdata mb86a20s_init[] = {
>> Please test first my mb86a20s patchset. If it doesn't work, we'll need
>> to dig into the differences.
>>
>> The better is to group these and reorder them to look like what's there
>> at the driver, and send it like a diff. That would make a way easier to
>> see what's different there.
>>
>> Anyway, it follows my comments about a few things that came into my eyes.
>>
>>>       { 0x09, 0x3a },
>> No idea what's here, but it seems a worth trial to change it.
> It controls inversion. I just pushed a patch that will let it handle
> both normal and inverted spectrum. The DVB core will automatically
> switch inversion during device tuning.

I test, but not work.

Before the latest patches, obtained as follows, for example:

dmesg
[  397.076641] mb86a20s: mb86a20s_read_status:
[  397.077129] mb86a20s: mb86a20s_read_status: val = X, status = 0xXX

and now, I don't get anything. But if I use VLC I get this:


dtvdebug: frontend status: 0x00

dtvdebug: frontend status: 0x03

dtvdebug: frontend status: 0x07

dtvdebug: frontend status: 0x01


Before only got:


dtvdebug: frontend status: 0x00

dtvdebug: frontend status: 0x01



>>>       { 0x28, 0x2a },
>>>       { 0x29, 0x00 },
>>>       { 0x2a, 0xfd },
>>>       { 0x2b, 0xc8 },
>> Hmm... the above may explain why it is not working. This is calculated
>> from the XTAL frequency, and IF (if different than 4MHz).
>>
>> Just changing it could fix the issue.
> I also added a patch that allows using a different XTAL frequency.
>
> You can use the calculus there to convert from 0x00fdc8 into the XTAL
> frequency, if you have the IF set by xc5000.
I don't have the IF. How I can know the intermediate frequency?

Xtal near of xc5000 is 32.000MHz. Perhaps 32/8=4 -->IF

There are other 2 xtal of 16.000MHz and other of 28.636MHz.
Xtal of mb86a20s is 32.571MHz.

In total there are 4 xtal.

With mb86a20s changes made, the logs (i2c traffic) obtained are 
different from those obtained with Windows

I have yet to thoroughly analyze 24 samples I took with the logic 
analyzer and try to see your logic. This is going to take some time.


Again thank you very much,

Alfredo
