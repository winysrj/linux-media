Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58830 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab1I3Pg3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 11:36:29 -0400
Message-ID: <4E85E1FA.7020709@iki.fi>
Date: Fri, 30 Sep 2011 18:36:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
	=?UTF-8?B?SXN0dsOhbiBWw6E=?= =?UTF-8?B?cmFkaQ==?=
	<ivaradi@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>	<4E485F81.9020700@iki.fi> <4E48FF99.7030006@iki.fi>	<4E4C2784.2020003@iki.fi>	<CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>	<4E5BA751.6090709@iki.fi>	<CAFk-VPypTuaKgAHPxyvKg7GHYM358rZ2kypabfvxG-x7GjmFpw@mail.gmail.com>	<4E5BAF03.503@iki.fi> <87wrdri4sp.fsf@nemi.mork.no> <4E60DB09.1060304@iki.fi> <4E832FE6.7020103@iki.fi>
In-Reply-To: <4E832FE6.7020103@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2011 05:32 PM, Antti Palosaari wrote:
> On 09/02/2011 04:32 PM, Antti Palosaari wrote:

>> As I see that CCID still more complex as serial device I will still look
>> implementing it as serial as now.
>
> Here it is, patch attached. Implemented as serial device. Anysee uses
> two different smart card interfaces, CST56I01 and TDA8024. That one is
> old CST56I01, I will try to add TDA8024 later, maybe even tonight.
>
> Anyhow, it is something like proof-of-concept currently, missing locks
> and abusing ttyUSB. Have you any idea if I should reserve own major
> device numbers for Anysee or should I reserve one like DVB common?
>
> Any other ideas?

http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/anysee

Now it works for TDA8024 based readers too (addition to CST56I01). Main 
difference was that TDA8024 designs reads card presence from GPIO whilst 
for CST56I01 it was got from anysee firmware (I think CST56I01 outputs 
that using I2C whilst TDA8024 have external IO line).

I tested it;
* E30 Combo Plus (TDA8024)
* E7 T2C (TDA8024)
* E30 C (CST56I01)

If you would like to help me then you can find out correct device name 
and whats needed for that. I mainly see following possibilities;
* /dev/ttyAnyseeN
* /dev/ttyDVBN
* /dev/adapterN/serial

regards
Antti
-- 
http://palosaari.fi/
