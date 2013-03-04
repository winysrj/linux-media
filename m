Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-mb01.mx.aol.com ([64.12.207.164]:62117 "EHLO
	imr-mb01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3CEAAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 19:00:53 -0500
Message-ID: <513529AE.9080000@netscape.net>
Date: Mon, 04 Mar 2013 20:09:34 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303131519.6214bcf4@redhat.com>
In-Reply-To: <20130303131519.6214bcf4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and others



El 03/03/13 13:15, Mauro Carvalho Chehab escribió:
> Em Sun, 03 Mar 2013 11:50:25 -0300
> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
>
>> Hi Mauro and others from the list
>> I searched for a plan B to get the data bus and after several
>> alternative plans that were available to me was to do a logic analyzer
>> (http://tfla-01.berlios.de).
> Yeah, that should work too.
>
>> With the logic analyzer I could get the data transmitted by the I2C bus
>> under Windows, but when I put this data in replacement of originals in
>> mb86a20s.c and I try to run the Linux TV board, do not get the logic
>> analyzer with the same sequence.
> Well, there are other I2C devices on the bus,

Yes, logic analyzer "said":

Write to PCF8574 at address 0

and IC that not have name on TV card have the form and number of pin 
that pcf8574
also EEPROM FM24C02

>   and the order that they're
> initialized in Linux are different than on the original driver.
>> The new data replacement in mb86a20s
> I just posted today a series of patches improving several things on
> mb86a20s and replacing its initialization table to one found on a newer
> driver. It also allows using different IF frequencies on the tuner side.
>
> Perhaps this is enough to fix.

I tested all patches (those of yesterday and today), but it did not work.
I have not yet seen the changes with the logic analyzer.

>> /*
>>    * Initialization sequence: Use whatevere default values that PV SBTVD
>>    * does on its initialisation, obtained via USB snoop
>>    */
>> static struct regdata mb86a20s_init[] = {
>>
>>       { 0x70, 0x0f },
>>       { 0x70, 0xff },
>>       { 0x09, 0x3a },
>>       { 0x50, 0xd1 },
>>       { 0x51, 0x22 },
>>       { 0x39, 0x00 },
>>       { 0x28, 0x2a },
>>       { 0x29, 0x00 },
>>       { 0x2a, 0xfd },
>>       { 0x2b, 0xc8 },
>>       { 0x3b, 0x21 },
>>       { 0x3c, 0x38 },
>>       { 0x28, 0x20 },
>>       { 0x29, 0x3e },
>>       { 0x2a, 0xde },
>>       { 0x2b, 0x4d },
>>       { 0x28, 0x22 },
>>       { 0x29, 0x00 },
>>       { 0x2a, 0x1f },
>>       { 0x2b, 0xf0 },
>>       { 0x01, 0x0d },
>>       { 0x04, 0x08 },
>>       { 0x05, 0x03 },
>>       { 0x04, 0x0e },
>>       { 0x05, 0x00 },
>>       { 0x08, 0x1e },
>>       { 0x05, 0x32 },
>>       { 0x04, 0x0b },
>>       { 0x05, 0x78 },
>>       { 0x04, 0x00 },
>>       { 0x05, 0x00 },
>>       { 0x04, 0x01 },
>>       { 0x05, 0x1e },
>>       { 0x04, 0x02 },
>>       { 0x05, 0x07 },
>>       { 0x04, 0x03 },
>>       { 0x0a, 0xa0 },
>>       { 0x04, 0x09 },
>>       { 0x05, 0x00 },
>>       { 0x04, 0x0a },
>>       { 0x05, 0xff },
>>       { 0x04, 0x27 },
>>       { 0x05, 0x00 },
>>       { 0x08, 0x50 },
>>       { 0x05, 0x00 },
>>       { 0x04, 0x28 },
>>       { 0x05, 0x00 },
>>       { 0x04, 0x1e },
>>       { 0x05, 0x00 },
>>       { 0x04, 0x29 },
>>       { 0x05, 0x64 },
>>       { 0x04, 0x32 },
>>       { 0x05, 0x68 },
>>       { 0x04, 0x14 },
>>       { 0x05, 0x02 },
>>       { 0x04, 0x04 },
>>       { 0x05, 0x00 },
>>       { 0x08, 0x0a },
>>       { 0x05, 0x22 },
>>       { 0x04, 0x06 },
>>       { 0x05, 0x0e },
>>       { 0x04, 0x07 },
>>       { 0x05, 0xd8 },
>>       { 0x04, 0x12 },
>>       { 0x05, 0x00 },
>>       { 0x04, 0x13 },
>>       { 0x05, 0xff },
>>       { 0x52, 0x01 },
>>       { 0x50, 0xa7 },
>>       { 0x51, 0x00 },
>>       { 0x50, 0xa8 },
>>       { 0x51, 0xfe },
>>       { 0x50, 0xa9 },
>>       { 0x51, 0xff },
>>       { 0x50, 0xaa },
>>       { 0x51, 0x00 },
>>       { 0x50, 0xab },
>>       { 0x51, 0xff },
>>       { 0x50, 0xac },
>>       { 0x51, 0xff },
>>       { 0x50, 0xad },
>>       { 0x51, 0x00 },
>>       { 0x50, 0xae },
>>       { 0x51, 0xff },
>>       { 0x50, 0xaf },
>>       { 0x51, 0xff },
>>       { 0x5e, 0x07 },
>>       { 0x50, 0xdc },
>>       { 0x51, 0x3f },
>>       { 0x50, 0xdd },
>>       { 0x51, 0xff },
>>       { 0x50, 0xde },
>>       { 0x51, 0x3f },
>>       { 0x80, 0xdf },
>>
>> So I conclude that there must be some logic that I'm not understanding.
>> Could you indicate the meaning of the data in the table if there are
>> any? or if I'm doing something wrong, what do I do wrong?
> I'll take a look on it, and see what it is doing differently.
>
>> I have also observed that the data passing through the I2C bus are not
>> always the same under Windows, there are some differences between them
>> in parts.
> Hmm... that's interesting. Did you map the changes?

Not yet.
Below I put two different early (on Windows 7)

-----
0.178147 - Start
0.262532 - b00100001 - 0x21 - 33
0.271909 - ACK
0.356294 - b00010011 - 0x13 - 19
0.367545 - NACK
0.517564 - b00000000 - 0x00 - 0
0.528815 - ACK
0.613201 - b11100000 - 0xe0 - 224
0.622577 - ACK
0.703212 - b00011110 - 0x1e - 30
0.718214 - Stop

0.84573 - b00100000 - 0x20 - 32
0.856981 - ACK
0.941366 - b01110000 - 0x70 - 112
0.950743 - ACK
1.03888 - b11111111 - 0xff - 255
1.04825 - ACK
1.16077 - b00100000 - 0x20 - 32
1.17202 - ACK
1.25828 - b00001001 - 0x09 - 9
1.26766 - ACK
1.35017 - b00111010 - 0x3a - 58
1.36142 - ACK
1.50206 - b00100000 - 0x20 - 32
1.51331 - ACK
1.59957 - b01010000 - 0x50 - 80
1.61082 - ACK
1.79085 - Write to PCF8574 at address 0
1.79085 - b01000000 - 0x40 - 64
1.80022 - ACK
1.88461 - b10100010 - 0xa2 - 162
1.89398 - ACK
1.98024 - b01000100 - 0x44 - 68
1.99525 - Error

2.029 - Start
2.12089 - b00100000 - 0x20 - 32
2.13026 - ACK
2.21652 - b00111001 - 0x39 - 57
2.22778 - ACK
2.31216 - b00000000 - 0x00 - 0
2.32154 - ACK
2.46218 - b00100000 - 0x20 - 32
2.47343 - ACK
2.55782 - b00101000 - 0x28 - 40
2.56719 - ACK
2.6422 - b00101010 - 0x2a - 42
...

------------------------------------------------

0.176518 - Start
0.260132 - b00100001 - 0x21 - 33
0.271281 - ACK
0.356753 - b00010011 - 0x13 - 19
0.364185 - NACK
0.490535 - b00100000 - 0x20 - 32
0.501683 - ACK
0.585297 - b01110000 - 0x70 - 112
0.596446 - ACK
0.678202 - b00001111 - 0x0f - 15
0.68935 - ACK
0.8157 - b00100000 - 0x20 - 32
0.826848 - ACK
0.91232 - b01110000 - 0x70 - 112
0.921611 - ACK
1.00337 - b11111111 - 0xff - 255
1.01266 - ACK
1.14272 - b00100000 - 0x20 - 32
1.15201 - ACK
1.23563 - b00001001 - 0x09 - 9
1.24678 - ACK
1.32667 - b00111010 - 0x3a - 58
1.33782 - ACK
1.46789 - b00100000 - 0x20 - 32
1.47904 - ACK
1.57008 - b01010000 - 0x50 - 80
1.58123 - NACK
1.6667 - b10100010 - 0xa2 - 162
1.67599 - Stop

1.79305 - b00100000 - 0x20 - 32
1.8042 - ACK
1.89525 - b01010010 - 0x52 - 82
1.90454 - ACK
1.99187 - b01000100 - 0x44 - 68
2.00488 - Stop

2.12379 - b00100000 - 0x20 - 32
2.13494 - ACK
2.2167 - b00111001 - 0x39 - 57
2.22785 - ACK
2.30774 - b00000000 - 0x00 - 0
2.31889 - ACK
2.4471 - b00100000 - 0x20 - 32
2.45825 - ACK
2.54 - b00101000 - 0x28 - 40
2.55115 - ACK
2.63105 - b00101010 - 0x2a - 42
...


If I have observed that changes occur when any stop.
Below I put another example:

case 1:

...
3.12789 - b00100000 - 0x20 - 32
3.13914 - ACK
3.22352 - b00101010 - 0x2a - 42
3.2329 - ACK
3.31916 - b11111101 - 0xfd - 253
3.33041 - ACK
3.46918 - b00100000 - 0x20 - 32
3.48043 - ACK
3.56482 - b00101011 - 0x2b - 43
3.57232 - ACK
3.6567 - b11001000 - 0xc8 - 200
3.66608 - ACK
3.80485 - b00100000 - 0x20 - 32
3.81422 - ACK
3.90236 - b00111011 - 0x3b - 59
3.91173 - ACK
3.99612 - b00100001 - 0x21 - 33
4.00737 - ACK
4.14989 - b00100000 - 0x20 - 32
4.15926 - ACK
4.24177 - b00111100 - 0x3c - 60
4.25303 - ACK
4.33366 - b00111000 - 0x38 - 56
4.34491 - ACK
4.48931 - b00100000 - 0x20 - 32
4.49868 - ACK
4.57744 - b00101000 - 0x28 - 40
4.58869 - ACK
4.67308 - b00100000 - 0x20 - 32
4.68245 - ACK
4.8231 - b00100000 - 0x20 - 32
4.83435 - ACK
4.91498 - b00101001 - 0x29 - 41
4.92623 - ACK
5.0125 - b00111110 - 0x3e - 62
5.02 - ACK
5.15876 - b00100000 - 0x20 - 32
5.17001 - ACK
5.2544 - b00101010 - 0x2a - 42
5.2619 - ACK
5.34816 - b11011110 - 0xde - 222
...

Case 2:

...
3.103 - b00100000 - 0x20 - 32
3.11415 - ACK
3.19405 - b00101010 - 0x2a - 42
3.2052 - ACK
3.28695 - b11111101 - 0xfd - 253
3.2981 - ACK
3.42817 - b00100000 - 0x20 - 32
3.43932 - ACK
3.52107 - b00101011 - 0x2b - 43
3.53036 - ACK
3.61212 - b11001000 - 0xc8 - 200
3.62327 - ACK
3.75891 - b00100000 - 0x20 - 32
3.7682 - ACK
3.85367 - b01110110 - 0x76 - 118
3.86482 - ACK
3.94843 - b01000010 - 0x42 - 66
3.9633 - Stop

4.08407 - b00100000 - 0x20 - 32
4.09151 - ACK
4.17512 - b00111100 - 0x3c - 60
4.18627 - ACK
4.27174 - b00111000 - 0x38 - 56
4.28103 - ACK
4.40738 - b00100000 - 0x20 - 32
4.41853 - ACK
4.50214 - b00101000 - 0x28 - 40
4.51329 - ACK
4.59505 - b00100000 - 0x20 - 32
4.6062 - ACK
4.73255 - b00100000 - 0x20 - 32
4.74369 - ACK
4.82917 - b00101001 - 0x29 - 41
4.8366 - ACK
4.92207 - b00111110 - 0x3e - 62
4.93322 - ACK
5.06329 - b00100000 - 0x20 - 32
5.07258 - ACK
5.15619 - b00101010 - 0x2a - 42
5.16734 - ACK
5.24724 - b11011110 - 0xde - 222
...

>
>> Then I put a few fragments of what I get under Windows 7 and Linux. Not
>> the entire I put because they are of a size of 200KiB.
>>
>> _Under_Windows_7_
>>
>> 0.184315 - Start
>> 0.268094 - b00100001 - 0x21 - 33
>> 0.279265 - ACK
>> 0.361182 - b00010011 - 0x13 - 19
>> 0.372353 - NACK
> This is a read.
>
>> 0.511985 - b00100000 - 0x20 - 32
>> 0.523156 - ACK
>> 0.603211 - b01110000 - 0x70 - 112
>> 0.614382 - ACK
>> 0.698161 - b00001111 - 0x0f - 15
>> 0.70747 - ACK
>> 0.847102 - b00100000 - 0x20 - 32
>> 0.858273 - ACK
>> 0.938329 - b01110000 - 0x70 - 112
>> 0.949499 - ACK
>> 1.03514 - b11111111 - 0xff - 255
>> 1.04445 - ACK
> Funny that it doesn't write 01 to register 08 here.
> I think that the this is to disable TS while resetting.
>
> ...
>
>> _Under_Linux_
>>
>> 0.268594 - Start
>> 0.358125 - b00100000 - 0x20 - 32
>> 0.367451 - ACK
>> 0.447656 - b01110000 - 0x70 - 112
>> 0.456982 - ACK
>> 0.548379 - b11111111 - 0xff - 255
>> 0.55957 - ACK
>> 0.686406 - b00100000 - 0x20 - 32
>> 0.697597 - ACK
>> 0.781533 - b00001000 - 0x08 - 8
>> 0.790859 - NACK
>> 0.871064 - b00000001 - 0x01 - 1
>> 0.882256 - ACK
> You're likely still using the old table.
>
>> In the next letter, if you let me, I'll cut the old text, because I
>> guess we're back on topic and not too heavy (KB) message.
> Sure. I always cut not commented parts of the messages I answer.
>
>
> Cheers,
> Mauro
I answer in the other letters the other questions

Thanks,

Alfredo
