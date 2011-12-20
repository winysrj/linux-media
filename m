Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43492 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab1LTPm6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 10:42:58 -0500
Message-ID: <4EF0ACFD.6040903@iki.fi>
Date: Tue, 20 Dec 2011 17:42:53 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driver
References: <4EE929D5.6010106@iki.fi> <4EF08FFC.2070802@redhat.com> <4EF0A141.7010100@iki.fi> <4EF0A92B.6010504@redhat.com>
In-Reply-To: <4EF0A92B.6010504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/20/2011 05:26 PM, Mauro Carvalho Chehab wrote:
> On 20-12-2011 12:52, Antti Palosaari wrote:
>> On 12/20/2011 03:39 PM, Mauro Carvalho Chehab wrote:

>>>> +        break;
>>>> +    case 2:
>>>> +        str_constellation = "QAM16";
>>>> +        c->modulation = QAM_16;
>>>> +        break;
>>>> +    case 3:
>>>> +        str_constellation = "QAM32";
>>>> +        c->modulation = QAM_32;
>>>> +        break;
>>>> +    case 4:
>>>> +        str_constellation = "QAM64";
>>>> +        c->modulation = QAM_64;
>>>> +        break;
>>>
>>> Please, avoid magic numbers. Instead, use macros for each
>>> value.
>>
>> I disagree that. Those numbers are coming from demodulator
>> register value. Same way is used almost every driver that
>> supports reading current transmission params from the demod.
>
> There are drivers that don't code it well, but it is always preferred
> to use macros for register values. Good drivers have it.

I still disagree. Are we speaking same issue?

val = read_reg(rgister)
switch (val) {
case 2:
	c->modulation = QAM_16;
	break;
case 3:
	c->modulation = QAM_32;
	break;
}

Why I should define macros here?
Or do you mean I should define macros for the selecting correct bits 
from the register?

Anyhow, for me that piece of code looks very clear. And it is used 
similarly very many drivers.



>> After all as I see there is no big bugs. Those findings are mostly related
>> of missing DMB-TH API support (and was even commented clearly). And 1-2 CodingStyle issues.
>
> One issue is pure CodingStyle. The other no-API related aren't.
>
>> As there is still few other DMB-TH drivers having similar issues already in
>> the master I don't see why not to add that too. Anyhow, if you see that must
>> be put to staging until DMB-TH is defined to API it is OK for me.
>
> Please fix the non-API related issues. If you ack to provide us the API improvements
> for DMB for 3.4, and get rid of "auto_mode = true" for all cases, I'm
> ok on merging it after the fixes at drivers/media/dvb.

If I don't add DMB-TH support to API you will push that to the staging?

Adding those to API is not mission impossible. Interleaver is only new 
parameter and all the rest are just extending values. But my time is 
limited... and I really would like to finally got Anysee smart card 
reader integrated to USB serial first.

regards
Antti

-- 
http://palosaari.fi/
