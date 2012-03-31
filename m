Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46392 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2CaQsf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 12:48:35 -0400
Message-ID: <4F773562.6010008@iki.fi>
Date: Sat, 31 Mar 2012 19:48:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse> <4F762CF5.9010303@iki.fi> <20120331001458.33f12d82@milhouse> <20120331160445.71cd1e78@milhouse> <4F771496.8080305@iki.fi> <20120331182925.3b85d2bc@milhouse> <4F77320F.8050009@iki.fi>
In-Reply-To: <4F77320F.8050009@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I dropped Mauro from cc since he is not likely interested of that 
development.

On 31.03.2012 19:34, Antti Palosaari wrote:
> On 31.03.2012 19:29, Michael Büsch wrote:
>> On Sat, 31 Mar 2012 17:28:38 +0300
>> Antti Palosaari<crope@iki.fi> wrote:
>>
>>> Googling the filename reveals many links, here is one:
>>> http://xgazza.altervista.org/Linux/DVB/dvb-usb-af9035-01.fw
>>
>> Hm, on tuner register access I get these errors:
>>
>> [ 9259.080907] af9035_ctrl_msg: command=03 failed fw error=2
>> [ 9259.080922] i2c i2c-8: I2C write reg failed, reg: 07, val: 0f
>>
>> Is it possible that this firmware is incompatible with my stick?
>> The firmware that I successfully used with the other af9035 driver
>> seems to
>> be incompatible with your driver, though. It crashes it somewhere
>> on firmware download in one of the USB transfer's memcpy.
>
> Most likely it is incompatible. It is surely one of the earliest
> firmwares. I will try to make that new fw downloaded ASAP, likely
> tomorrow morning it is done.
>
> And good news about IT9035 support - it is working. It was very few
> changes needed, new initialization tables for af9033 and new firmware
> uploader for af9035. Of course new tuner drivers is also needed, but it
> seems to be very simple. yay, AF9035 is basically same as IT9035 +
> integrated tuner.

Ooops, I mean IT9135.

And about the new FW downloader, that supports those new firmwares, feel 
free to implement it if you wish too. I will now goto out of house and 
will back during few hours. If you wish to do it just reply during 4 
hours, and I will not start working for it. Instead I will continue with 
IT9135.

regards
Antti
-- 
http://palosaari.fi/
