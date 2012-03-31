Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54354 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab2CaO2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 10:28:46 -0400
Message-ID: <4F771496.8080305@iki.fi>
Date: Sat, 31 Mar 2012 17:28:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse> <4F762CF5.9010303@iki.fi> <20120331001458.33f12d82@milhouse> <20120331160445.71cd1e78@milhouse>
In-Reply-To: <20120331160445.71cd1e78@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31.03.2012 17:04, Michael Büsch wrote:
> On Sat, 31 Mar 2012 00:14:58 +0200
> Michael Büsch<m@bues.ch>  wrote:
>
>> On Sat, 31 Mar 2012 01:00:21 +0300
>> Antti Palosaari<crope@iki.fi>  wrote:
>>
>>> Feel free to do that. Actually, I just tried it about 2 hours ago. But I
>>> failed, since there callbacks given as a param for tuner attach and it
>>> is wrong. There is frontend callback defined just for that. Look example
>>> from some Xceive tuners also hd29l2 demod driver contains one example.
>>> Use git grep DVB_FRONTEND_COMPONENT_ drivers/media/ to see all those
>>> existing callbacks.
>>
>> Cool. Thanks for the hint. I'll fix this.
>
> Ok, so I cooked something up here.
> I'm wondering where to get the firmware file from, so I can test it.

Googling the filename reveals many links, here is one:
http://xgazza.altervista.org/Linux/DVB/dvb-usb-af9035-01.fw

I will try to make new firmware loader during that weekend, now I am 
busy hacking with it9035 I have. It is rather similar, but for some 
nasty reason I haven't got lock. If it does not found soon I will jump 
back for implementing those missing basic features.

regards
Antti
-- 
http://palosaari.fi/
