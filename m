Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60114 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab1H2OvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 10:51:00 -0400
Message-ID: <4E5BA751.6090709@iki.fi>
Date: Mon, 29 Aug 2011 17:50:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com> <4E485F81.9020700@iki.fi> <4E48FF99.7030006@iki.fi> <4E4C2784.2020003@iki.fi> <CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>
In-Reply-To: <CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2011 05:44 PM, István Váradi wrote:
> Hi,
>
> 2011/8/17 Antti Palosaari<crope@iki.fi>:
>> On 08/15/2011 02:14 PM, Antti Palosaari wrote:
>>> On 08/15/2011 02:51 AM, Antti Palosaari wrote:
>>>> Biggest problem I see whole thing is poor application support. OpenCT is
>>>> rather legacy but there is no good alternative. All this kind of serial
>>>> drivers seems to be OpenCT currently.
>>>
>>> I wonder if it is possible to make virtual CCID device since CCID seems
>>> to be unfortunately the only interface SmartCard guys currently care.
>>
>> I studied scenario and looks like it is possible to implement way like,
>> register virtual USB HCI (virtual motherboard USB controller) then
>> register virtual PC/SC device to that which hooks all calls to HW via
>> Anysee driver. Some glue surely needed for emulate PC/SC. I think there
>> is not any such driver yet. Anyhow, there is virtual USB HCI driver
>> currently in staging which can be used as example, or even use it to
>> register virtual device. That kind of functionality surely needs more
>> talking...
>
> It maybe that smartcard guys care only for CCID, but wouldn't it be an
> overkill to implement an emulation of that for the driver? It can be
> done, of course, but I think it would be much more complicated than
> the current one. Is it really necessary to put such complexity into
> the kernel? In my opinion, this should be handled in user-space.

Only De facto serial smartcard protocol is so called Phoenix/Smartmouse, 
implementing new protocol is totally dead idea. It will never got any 
support.

There is already such drivers, at least Infinity Unlimited USB Phoenix 
driver (iuu_phoenix.c). It uses USB-serial driver framework and some 
small emulation for Phoenix protocol. Look that driver to see which kind 
of complexity it adds. Anysee have *just* same situation.

regards
Antti


-- 
http://palosaari.fi/
