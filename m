Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:47353 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753035AbeC1Uop (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 16:44:45 -0400
Subject: Re: [PATCH v4] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and
 merge with gl861
To: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180327174730.1887-1-tskd08@gmail.com>
 <f1ce1268-e918-a12f-959e-98644cafb2fe@iki.fi>
 <e861a533-5517-2089-52af-ce720174e3ae@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <db8f370c-20f5-e9fe-9d2e-d12c1475dc33@iki.fi>
Date: Wed, 28 Mar 2018 23:44:42 +0300
MIME-Version: 1.0
In-Reply-To: <e861a533-5517-2089-52af-ce720174e3ae@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/28/2018 03:37 PM, Akihiro TSUKADA wrote:
> Hi,
> thanks for the comment.
> 
>> You should implement i2c adapter to demod driver and not add such glue
>> to that USB-bridge. I mean that "relayed" stuff, i2c communication to
>> tuner via demod. I2C-mux may not work I think as there is no gate-style
>> multiplexing so you probably need plain i2c adapter. There is few
>> examples already on some demod drivers.
> 
> I am afraid that the glue is actually necessary.
> 
> host - USB -> gl861 - I2C(1) -> tc90522 (addr:X)
>                                    \- I2C(2) -> tua6034 (addr:Y)
> 
> To send an i2c read message to tua6034,
> one has to issue two transactions:
>   1. write via I2C(1) to addr:X, [ reg:0xfe, val: Y ]
>   2. read via I2C(1) from addr:X, [ out_data0, out_data1, ....]
> 
> The problem is that the transaction 1 is (somehow) implemented with
> the different USB request than the other i2c transactions on I2C(1).
> (this is confirmed by a packet capture on Windows box).
> 
> Although tc90522 already creats the i2c adapter for I2C(2),
> tc90522 cannot know/control the USB implementation of I2C(1),
> only the bridge driver can do this.

I simply cannot see why it cannot work. Just add i2c adapter and 
suitable logic there. Transaction on your example is simply and there is 
no problem to implement that kind of logic to demod i2c adapter.

If gl861 driver i2c adapter logic is broken it can be fixed easily too. 
It seems to support only i2c writes with len 1 and 2 bytes, but fixing 
it should be easy if you has some sniffs.



Antti

-- 
http://palosaari.fi/
