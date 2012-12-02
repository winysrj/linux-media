Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44441 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2LBOXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Dec 2012 09:23:46 -0500
Message-ID: <50BB6451.7080601@iki.fi>
Date: Sun, 02 Dec 2012 16:23:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Matthew Gyurgyik <matthew@pyther.net>, linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com>
In-Reply-To: <50BB3F2C.5080107@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/02/2012 01:44 PM, Frank Schäfer wrote:
> Am 30.11.2012 02:45, schrieb Matthew Gyurgyik:
>> On 11/29/2012 02:28 PM, Frank Schäfer wrote:
>>> Matthew, stay tuned but be patient. ;) Regards, Frank
>>
>> Sure thing, just let me know what you need me to do!
>>
>
> Ok, please test the attached experimental patch and post the dmesg output.
>
> Open questions:
> - setting of EM2874 register 0x0f (XCLK): the Windows doesn't touch this
> register, so the default value seems to be used.
>    The patch adds 2 debugging lines to find out the default which default
> value the em2874 uses.
>    For now, I've set this to 12MHz, because the picture shows a 12MHz
> oszillator.
> - meaning of the gpio sequence / gpio lines assignment (see comments in
> the patch).
> - remote control support: looking at the product picture on the MSI website,
>    the remote control could be the same as sues by the Digivox III. But
> that's just a guess.
> - LGDT3305 configuration: a few parameters can not be taken form the USB
> log. Will ask the author of the driver for help.
>
> But let's do things step by step and see what happens with the patch.
>
> Regards,
> Frank
>

Hello
I looked the patch quickly and here are the findings:
I2C addresses are in "8-bit" format. Will not work. Example for tuner, 
0xc0 should be 0x60. Same for the demod. Due to that, no worth to test 
patch. I2C addresses are normally 7-bit, but "unofficial" 8-bit notation 
is also used widely. em28xx uses official notation as almost all other 
media drivers.

You are using tda18271c2dd tuner driver. I recommended to change to the 
other driver named tda18271. tda18271c2dd is very bad choice in that 
case as it discards all the I2C error without any error logging and just 
silently ignores. I remember case when I used that tuner driver for one 
em28xx + drx-k combination and wasted very many hours trying to get it 
working due to missing error logging :/

Don't care XCLK register, it most likely will just as it is. There is 
many EM2874 boards already supported.

12MHz clock is correct and it is seen from the hardware. Generally 12MHz 
xtal is used very often for USB (device to device) as it is suitable 
reference clock.

According to comments, GPIO7 is used when streaming is started / 
stopped. It is about 99% sure LOCK LED :)

When you look sniffs and see some GPIO is changed for example just 
before and after tuner communication you could make assumption it does 
have something to do with tuner (example tuner hw reset / standby).

You should look used intermediate frequencies from the tuner driver and 
configure demod according to that. OK, 3-4 MHz sounds very reasonable 
low-IF values used with tda18271. tda18271 driver supports also get IF 
callback, but demod driver not. That callback allows automatically 
configure correct IF according to what tuner uses. Anyhow, in that case 
you must ensure those manually from tuner driver as demod driver does 
not support get IF. IF is *critical*, if it is wrong then nothing works 
(because demodulator does not get signal from tuner).


regards
Antti

-- 
http://palosaari.fi/
