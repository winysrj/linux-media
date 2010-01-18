Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:28380 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab0ARTGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 14:06:01 -0500
Received: by fg-out-1718.google.com with SMTP id 22so844949fge.1
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 11:05:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B54AD5B.7040305@gmail.com>
References: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
	 <ad6681df0912220841n2f77f2c3v7aad0604575b5564@mail.gmail.com>
	 <ad6681df1001180701s26584cdfua9e413d9bb843a35@mail.gmail.com>
	 <829197381001180716v59b84ee2ia8ca2d9be4be5b22@mail.gmail.com>
	 <4B54864E.1050801@yahoo.it>
	 <829197381001180817r561bb1cdj9edda6ab3affbba0@mail.gmail.com>
	 <d9def9db1001180829n733471c6g375295f29fc349ea@mail.gmail.com>
	 <829197381001180836ybc4a4c6l6cf1c2bbabdf96b8@mail.gmail.com>
	 <d9def9db1001180933x3fc31353g87cd06312a57cbf1@mail.gmail.com>
	 <4B54AD5B.7040305@gmail.com>
Date: Mon, 18 Jan 2010 20:05:59 +0100
Message-ID: <d9def9db1001181105i7eac4a0ct3b8845b0f2904e38@mail.gmail.com>
Subject: Re: Info
From: Markus Rechberger <mrechberger@gmail.com>
To: fogna <fogna80@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Adriano Gigante <adrigiga@yahoo.it>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2010 at 7:50 PM, fogna <fogna80@gmail.com> wrote:
> Il 01/18/2010 06:33 PM, Markus Rechberger ha scritto:
>> On Mon, Jan 18, 2010 at 5:36 PM, Devin Heitmueller
>> <dheitmueller@kernellabs.com> wrote:
>>
>>> Hello Markus,
>>>
>>> On Mon, Jan 18, 2010 at 11:29 AM, Markus Rechberger
>>> <mrechberger@gmail.com> wrote:
>>>
>>>> Just fyi there's a hardware bug with the 0072/terratec hybrid xs fm
>>>> (cx25843 - xc5000):
>>>>
>>>> http://img91.imageshack.us/i/00000004qf8.png/
>>>> http://img104.imageshack.us/i/00000009cp4.png/
>>>>
>>>> nothing that can be fixed with the driver.
>>>>
>>> Interesting.  If it cannot be fixed with the driver, how does the
>>> Windows driver work then?  Is this some sort of premature hardware
>>> failure that occurs (after which point it is irreversible)?
>>>
>>>
>> conexant cx25843 - xceive xc5000 failure (as what I've heard conexant
>> laid off people in that area years ago while xceive (see their driver
>> changelog if you have access to it) tried to fix it with their
>> firmware but didn't succeed), it also happens with windows. Those
>> screenshots are taken from a videoclip
>> it was of course a big problem for business customers (almost all of
>> them happily switched away from it)
>> This is the same retail hardware as everyone else uses out there. XS
>> FM is not being sold anymore.
>> I only know one company in Ireland still sticking with it, also in
>> terms of videoquality I'd avoid that combination.
>>
>> Markus
>>
>>
>>> Thanks for taking the time to point this out though, since I could
>>> totally imagine banging my head against the wall for quite a while
>>> once I saw this.
>>>
>>> Devin
>>>
>>> --
>>> Devin J. Heitmueller - Kernel Labs
>>> http://www.kernellabs.com
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> Hi Markus, thanks for the info, i didn't know of this hardware problem,
> i have this usb stick and at the moment all works normally, now i know
> when it will be time to replace it :)
>

it happens sporadically sometimes 1 time/5 minutes sometimes 1 time/10 minutes.
I think in windows it sometimes drops frames it also happens there and
can be seen with VLC
maybe some codecs also compensate it a little bit. There's no generic
rule about this the xc5000
overdrives the videodecoder (it's not empia related issue actually
moreover conexant/xceive)

Markus
