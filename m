Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50872 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965540Ab2C3WA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 18:00:28 -0400
Message-ID: <4F762CF5.9010303@iki.fi>
Date: Sat, 31 Mar 2012 01:00:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse>
In-Reply-To: <20120330234545.45f4e2e8@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31.03.2012 00:45, Michael Büsch wrote:
> On Fri, 30 Mar 2012 15:33:02 +0300
> Antti Palosaari<crope@iki.fi>  wrote:
>
>> Terve Mauro and all the other hackers,
>>
>> I did some massive rewrite for my old AF9035/AF9033 driver that was
>> never merged. Anyhow, here it is.
>>
>> New drivers here are:
>> Infineon TUA 9001 silicon tuner driver
>> Afatech AF9033 DVB-T demodulator driver
>> Afatech AF9035 DVB USB driver
>
> This looks pretty nice.
>
> I recently wrote a tuner driver for the fc0011 tuner, which is used in some
> af9035 sticks:
> http://patchwork.linuxtv.org/patch/10503/
>
> It was developed against an af903x driver by Hans-Frieder Vogt.
>
> I'll port it to your AF9035 driver, ASAP, to check whether this works
> on my DVB USB stick.

Feel free to do that. Actually, I just tried it about 2 hours ago. But I 
failed, since there callbacks given as a param for tuner attach and it 
is wrong. There is frontend callback defined just for that. Look example 
from some Xceive tuners also hd29l2 demod driver contains one example. 
Use git grep DVB_FRONTEND_COMPONENT_ drivers/media/ to see all those 
existing callbacks.

struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe, struct 
i2c_adapter *i2c, u8 i2c_address, int (*tuner_reset)(unsigned long, 
unsigned long),unsigned long tuner_reset_arg0,unsigned long 
tuner_reset_arg1)

My short term plans are now
* fix af9033 IF freq control (now Zero-IF only)
* change firmware download to use new firmware syntax
* dual tuner support
* check if IT9035 is enough similar (My personal suspicion is that 
integrated tuner is only main difference, whilst USB-interface and demod 
are same. But someone has told that it is quite different design though.)
* implement SNR, BER and USB counters
* implement remote controller

regards
Antti
-- 
http://palosaari.fi/
