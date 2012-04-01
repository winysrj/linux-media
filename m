Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41528 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2DAQj6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 12:39:58 -0400
Message-ID: <4F7884DC.2070501@iki.fi>
Date: Sun, 01 Apr 2012 19:39:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: linux-media@vger.kernel.org,
	=?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse> <4F762CF5.9010303@iki.fi> <20120331001458.33f12d82@milhouse> <20120331160445.71cd1e78@milhouse> <4F771496.8080305@iki.fi> <20120331182925.3b85d2bc@milhouse> <4F77320F.8050009@iki.fi> <4F773562.6010008@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi> <20120401103315.1149d6bf@milhouse> <20120401141940.04e5220c@milhouse> <4F784A13.5000704@iki.fi> <20120401151153.637d2393@milhouse> <20120401181502.7f5604c3@milhouse> <4F788045.40208@iki.fi> <20120401183220.3e411278@milhouse>
In-Reply-To: <20120401183220.3e411278@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 19:32, Michael Büsch wrote:
> On Sun, 01 Apr 2012 19:20:21 +0300
> Antti Palosaari<crope@iki.fi>  wrote:
>
>> On 01.04.2012 19:15, Michael Büsch wrote:
>>> On Sun, 1 Apr 2012 15:11:53 +0200
>>> Michael Büsch<m@bues.ch>   wrote:
>>>
>>>> [ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)
>>>
>>> Ok, it turns out that it doesn't fail all the time, but only sporadically.
>>> So increasing the number of retries fixes (or at least works around) it.
>>
>> OK, feel free to add ~3 retries inside af9035_ctrl_msg() i think.
>
> Well I didn't retry at that level, but at the fc0011 driver level.
> It does already retry once in fc0011 (with complete tuner reset).
> I increased it to 6 times (3 was not enough).

Maybe some delay is needed in order to wait tuner wakes up after the 
reset. Reason it does not occur the other driver is likely there is some 
delay somewhere...

> I think we can't retry at af9035_ctrl_msg() level, because the
> actual i2c/usb transfer does not fail. The received packet checksum even
> is ok (although we currently don't check it. I'll send a patch for that later).
>
>> You didn't mention if error is coming from af9035 firmware or from USB
>> stack. Just for the interest...
>
> I don't know how much the firmware is involved in this, but _maybe_ this
> glitch is caused by it.

Indeed, you are correct, no changes for af9035_ctrl_msg() are not wanted 
as error is not coming from af9035. Likely some small delay for tuner in 
order to wake up it from the reset.

regards
Antti
-- 
http://palosaari.fi/
