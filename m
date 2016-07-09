Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42240 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbcGIWeb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jul 2016 18:34:31 -0400
Subject: Re: si2157: new revision?
To: Oleh Kravchenko <oleg@kaa.org.ua>, linux-media@vger.kernel.org
References: <1467243499-26093-1-git-send-email-crope@iki.fi>
 <1467243499-26093-3-git-send-email-crope@iki.fi>
 <577AAD3C.2060204@kaa.org.ua> <46faadd5-80dc-bb71-be24-8b05fb035423@iki.fi>
 <57816A16.1090800@kaa.org.ua>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <fc85f957-a297-7664-59c4-7a3e124017c0@iki.fi>
Date: Sun, 10 Jul 2016 01:34:28 +0300
MIME-Version: 1.0
In-Reply-To: <57816A16.1090800@kaa.org.ua>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey, that's your problem :] Driver development is all the time resolving 
this kind of issues and you really need to resolve those yourself.

You will need to get I2C communication working with all the chips. First 
si2168 demod and after it answers to I2C you will need to get connection 
to Si2157 tuner. After both of those are answering you could try to get 
tuning tests to see if demod locks. After demod locks you know tuner is 
working and also demod is somehow working. If demod lock but there is no 
picture you know problem is TS interface. Try different TS settings for 
both USB-bridge and demod - those should match. If it does not starts 
working then you have to look sniffs and start replacing driver code 
with data from sniffs to until it starts working => problematic setting 
is found.

regards
Antti



On 07/10/2016 12:18 AM, Oleh Kravchenko wrote:
> Hello!
>
> I'm started playing i2c, but stuck with unknown error for me - 32 (EPIPE?):
> 	[ 5651.958763] cx231xx #0 at cx231xx_i2c_xfer: write stop addr=0x60
> len=15: c0 00 00 00 00 01 01 01 01 01 01 02 00 00 01
> 	[ 5651.958774] cx231xx #0: (pipe 0x80001000): OUT:  40 02 21 c0 00 00
> 0f 00
> 	[ 5651.958775] >>> c0 00 00 00 00 01 01 01 01 01 01 02 00 00 01FAILED!
> 	[ 5651.959110] cx231xx 1-2:1.1: cx231xx_send_usb_command: failed with
> status --32
> 	[ 5651.959111] cx231xx #0 at cx231xx_i2c_xfer:  ERROR: -32
>
> How this error can be fixed? :)
>
> On 04.07.16 21:47, Antti Palosaari wrote:
>> Hello
>> On 07/04/2016 09:38 PM, Oleh Kravchenko wrote:
>>> Hello Antti!
>>>
>>> I started reverse-engineering of my new TV tuner "Evromedia USB Full
>>> Hybrid Full HD" and discovered that start sequence is different from
>>> si2157.c:
>>> i2c_read_C1
>>>  1 \xFE
>>> i2c_write_C0
>>>  15 \xC0\x00\x00\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01
>>>
>>> Do you familiar with this revision?
>>> Should I merge my changes to si2158.c?
>>> Or define another driver?
>>
>> According to chip markings those are tuner Si2158-A20 and demod
>> Si2168-A30. Both are supported already by si2157 and si2168 drivers.
>>
>> Difference is just some settings. You need to identify which setting is
>> wrong and add that to configuration options. It should be pretty easy to
>> find it from the I2C dumps and just testing.
>>
>> regards
>> Antti
>>
>

-- 
http://palosaari.fi/
