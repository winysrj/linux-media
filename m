Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:43465 "EHLO smtp.220.in.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbcGMIWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 04:22:30 -0400
Subject: Re: si2157: new revision?
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <1467243499-26093-1-git-send-email-crope@iki.fi>
 <1467243499-26093-3-git-send-email-crope@iki.fi>
 <577AAD3C.2060204@kaa.org.ua> <46faadd5-80dc-bb71-be24-8b05fb035423@iki.fi>
 <57816A16.1090800@kaa.org.ua> <fc85f957-a297-7664-59c4-7a3e124017c0@iki.fi>
From: Oleh Kravchenko <oleg@kaa.org.ua>
Message-ID: <5785FA33.8010403@kaa.org.ua>
Date: Wed, 13 Jul 2016 11:22:11 +0300
MIME-Version: 1.0
In-Reply-To: <fc85f957-a297-7664-59c4-7a3e124017c0@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti!

Thank you for your advice. I succeed with demod chip!
...
[ 3454.060649] cx231xx #0: (pipe 0x80000b80): IN:  c0 0d 0f 00 74 00 04
00 <<< 6f 03 00 00
[ 3454.060784] cx231xx #0 at cx231xx_i2c_xfer: read stop addr=0x64 len=10:
[ 3454.060793] cx231xx #0: (pipe 0x80000b80): IN:  c0 05 23 c8 00 00 04 00
[ 3454.061392] <<< 80 44 33 30
[ 3454.061403] cx231xx #0: (pipe 0x80000b80): IN:  c0 05 63 c8 00 00 04
00 <<< 0b 73 33 30
[ 3454.061899] cx231xx #0: (pipe 0x80000b80): IN:  c0 05 61 c8 00 00 02
00 <<< 13 01
[ 3454.062278]  80 44 33 30 0b 73 33 30 13 01
[ 3454.062294] si2168 17-0064: firmware version: 3.0.19

But with tuner chip I have only error -32 :(
...
[ 2795.770276] cx231xx #0 at cx231xx_i2c_xfer: read stop addr=0x60 len=1:
[ 2795.770281] cx231xx #0: (pipe 0x80000680): IN:  c0 06 21 c0 00 00 01 00
[ 2795.771045] <<< fe
[ 2795.771048]  fe
[ 2795.771205] cx231xx #0 at cx231xx_i2c_xfer: write stop addr=0x60
len=15: c0 00 00 00 00 01 01 01 01 01 01 02 00 00 01
[ 2795.771234] cx231xx #0: (pipe 0x80000600): OUT:  40 02 21 c0 00 00 0f 00
[ 2795.771235] >>>
[ 2795.771236]  c0
[ 2795.771237]  00 00 00 00 01 01 01 01 01 01 02 00 00 01FAILED!
[ 2795.771886] cx231xx 1-2:1.1: cx231xx_send_usb_command: failed with
status --32
[ 2795.771888] cx231xx #0 at cx231xx_i2c_xfer:  ERROR: -32

But I discovered one thing, error will come - if write payload is bigger
than 4 bytes..
Any ideas, why this happening?
...
[ 3454.143285] cx231xx #0 at cx231xx_i2c_xfer: write stop addr=0x60
len=4: c0 00 00 00
[ 3454.143288] cx231xx #0: (pipe 0x80000b00): OUT:  40 02 21 c0 00 00 04 00
[ 3454.143289] >>> c0 00 00 00
[ 3454.143884] cx231xx #0 at cx231xx_i2c_xfer: read stop addr=0x60 len=1:
[ 3454.143893] cx231xx #0: (pipe 0x80000b80): IN:  c0 06 21 c0 00 00 01 00
[ 3454.144242] <<< fe
[ 3454.144244]  fe
[ 3454.144391] cx231xx #0 at cx231xx_i2c_xfer: write stop addr=0x60
len=1: 02
[ 3454.144406] cx231xx #0: (pipe 0x80000b00): OUT:  40 02 21 c0 00 00 01 00
[ 3454.144406] >>>
[ 3454.144407]  02
[ 3454.144767] cx231xx #0 at cx231xx_i2c_xfer: read stop addr=0x60 len=13:
[ 3454.144767] cx231xx #0: (pipe 0x80000b80): IN:  c0 06 23 c0 00 00 04
00 <<< fe fe fe fe
[ 3454.145397] cx231xx #0: (pipe 0x80000b80): IN:  c0 06 63 c0 00 00 04
00 <<< fe fe fe fe
[ 3454.145893] cx231xx #0: (pipe 0x80000b80): IN:  c0 06 63 c0 00 00 04 00
[ 3454.146377] <<< fe fe fe fe
[ 3454.146394] cx231xx #0: (pipe 0x80000b80): IN:  c0 06 61 c0 00 00 01 00
[ 3454.146639] <<< fe
[ 3454.146640]  fe fe fe fe fe fe fe fe fe fe fe fe fe
[ 3454.146676] si2157 15-0060: unknown chip version
Si21254-\xfffffffe\xfffffffe\xfffffffe


On 10.07.16 01:34, Antti Palosaari wrote:
> Hey, that's your problem :] Driver development is all the time
> resolving this kind of issues and you really need to resolve those
> yourself.
>
> You will need to get I2C communication working with all the chips.
> First si2168 demod and after it answers to I2C you will need to get
> connection to Si2157 tuner. After both of those are answering you
> could try to get tuning tests to see if demod locks. After demod locks
> you know tuner is working and also demod is somehow working. If demod
> lock but there is no picture you know problem is TS interface. Try
> different TS settings for both USB-bridge and demod - those should
> match. If it does not starts working then you have to look sniffs and
> start replacing driver code with data from sniffs to until it starts
> working => problematic setting is found.
>
> regards
> Antti
>
>
>
> On 07/10/2016 12:18 AM, Oleh Kravchenko wrote:
>> Hello!
>>
>> I'm started playing i2c, but stuck with unknown error for me - 32
>> (EPIPE?):
>>     [ 5651.958763] cx231xx #0 at cx231xx_i2c_xfer: write stop addr=0x60
>> len=15: c0 00 00 00 00 01 01 01 01 01 01 02 00 00 01
>>     [ 5651.958774] cx231xx #0: (pipe 0x80001000): OUT:  40 02 21 c0
>> 00 00
>> 0f 00
>>     [ 5651.958775] >>> c0 00 00 00 00 01 01 01 01 01 01 02 00 00
>> 01FAILED!
>>     [ 5651.959110] cx231xx 1-2:1.1: cx231xx_send_usb_command: failed
>> with
>> status --32
>>     [ 5651.959111] cx231xx #0 at cx231xx_i2c_xfer:  ERROR: -32
>>
>> How this error can be fixed? :)
>>
>> On 04.07.16 21:47, Antti Palosaari wrote:
>>> Hello
>>> On 07/04/2016 09:38 PM, Oleh Kravchenko wrote:
>>>> Hello Antti!
>>>>
>>>> I started reverse-engineering of my new TV tuner "Evromedia USB Full
>>>> Hybrid Full HD" and discovered that start sequence is different from
>>>> si2157.c:
>>>> i2c_read_C1
>>>>  1 \xFE
>>>> i2c_write_C0
>>>>  15 \xC0\x00\x00\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01
>>>>
>>>> Do you familiar with this revision?
>>>> Should I merge my changes to si2158.c?
>>>> Or define another driver?
>>>
>>> According to chip markings those are tuner Si2158-A20 and demod
>>> Si2168-A30. Both are supported already by si2157 and si2168 drivers.
>>>
>>> Difference is just some settings. You need to identify which setting is
>>> wrong and add that to configuration options. It should be pretty
>>> easy to
>>> find it from the I2C dumps and just testing.
>>>
>>> regards
>>> Antti
>>>
>>
>


