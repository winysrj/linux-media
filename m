Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41047 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbcGDTg2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 15:36:28 -0400
Subject: Re: si2157: new revision?
To: Oleh Kravchenko <oleg@kaa.org.ua>, linux-media@vger.kernel.org
References: <1467243499-26093-1-git-send-email-crope@iki.fi>
 <1467243499-26093-3-git-send-email-crope@iki.fi>
 <577AAD3C.2060204@kaa.org.ua> <46faadd5-80dc-bb71-be24-8b05fb035423@iki.fi>
 <577AB16A.3050902@kaa.org.ua>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <dd130cf4-9997-2a24-dee4-b9d81145d2f6@iki.fi>
Date: Mon, 4 Jul 2016 22:36:26 +0300
MIME-Version: 1.0
In-Reply-To: <577AB16A.3050902@kaa.org.ua>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am not interested at all about analog support. Analog transmissions 
are ran down many, many years ago here.

regards
Antti


On 07/04/2016 09:56 PM, Oleh Kravchenko wrote:
> Thank you for your reply!
>
> What about Analog TV support? Do you plan to implement it?
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

-- 
http://palosaari.fi/
