Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1H2PNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 11:13:45 -0400
Received: by fxh19 with SMTP id 19so4500595fxh.19
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 08:13:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5BA751.6090709@iki.fi>
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>
 <4E485F81.9020700@iki.fi> <4E48FF99.7030006@iki.fi> <4E4C2784.2020003@iki.fi>
 <CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com> <4E5BA751.6090709@iki.fi>
From: =?ISO-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
Date: Mon, 29 Aug 2011 17:13:24 +0200
Message-ID: <CAFk-VPypTuaKgAHPxyvKg7GHYM358rZ2kypabfvxG-x7GjmFpw@mail.gmail.com>
Subject: Re: Smart card reader support for Anysee DVB devices
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/29 Antti Palosaari <crope@iki.fi>:
> On 08/29/2011 05:44 PM, István Váradi wrote:
>>
>> Hi,
>>
>> 2011/8/17 Antti Palosaari<crope@iki.fi>:
>>>
>>> On 08/15/2011 02:14 PM, Antti Palosaari wrote:
>>>>
>>>> On 08/15/2011 02:51 AM, Antti Palosaari wrote:
>>>>>
>>>>> Biggest problem I see whole thing is poor application support. OpenCT
>>>>> is
>>>>> rather legacy but there is no good alternative. All this kind of serial
>>>>> drivers seems to be OpenCT currently.
>>>>
>>>> I wonder if it is possible to make virtual CCID device since CCID seems
>>>> to be unfortunately the only interface SmartCard guys currently care.
>>>
>>> I studied scenario and looks like it is possible to implement way like,
>>> register virtual USB HCI (virtual motherboard USB controller) then
>>> register virtual PC/SC device to that which hooks all calls to HW via
>>> Anysee driver. Some glue surely needed for emulate PC/SC. I think there
>>> is not any such driver yet. Anyhow, there is virtual USB HCI driver
>>> currently in staging which can be used as example, or even use it to
>>> register virtual device. That kind of functionality surely needs more
>>> talking...
>>
>> It maybe that smartcard guys care only for CCID, but wouldn't it be an
>> overkill to implement an emulation of that for the driver? It can be
>> done, of course, but I think it would be much more complicated than
>> the current one. Is it really necessary to put such complexity into
>> the kernel? In my opinion, this should be handled in user-space.
>
> Only De facto serial smartcard protocol is so called Phoenix/Smartmouse,
> implementing new protocol is totally dead idea. It will never got any
> support.
>
> There is already such drivers, at least Infinity Unlimited USB Phoenix
> driver (iuu_phoenix.c). It uses USB-serial driver framework and some small
> emulation for Phoenix protocol. Look that driver to see which kind of
> complexity it adds. Anysee have *just* same situation.

Phoenix/Smartmouse and CCID are quite different aren't they? So to
support Phoenix I would need provide a USB serial device which talks
the protocol, but there would be no need for a virtual USB HCI. Is
that correct?

Regards,

Istvan

>
> regards
> Antti
>
>
> --
> http://palosaari.fi/
>
