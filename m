Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35443 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbEUOWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 10:22:10 -0400
Received: by qgew3 with SMTP id w3so40563178qge.2
        for <linux-media@vger.kernel.org>; Thu, 21 May 2015 07:22:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
	<1427824092-23163-2-git-send-email-a.seppala@gmail.com>
	<20150519203851.GC18036@hardeman.nu>
	<CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
	<20150520182901.GB13624@hardeman.nu>
	<CAKv9HNZdsse=ETkKpZWPN8Z+kLA_aNxpvEtr_WFGp5ZpaZ36dg@mail.gmail.com>
	<20150520204557.GB15223@hardeman.nu>
	<CAKv9HNZEQJkCE3b0OcOGg_o59aYiTwLhQ0f=ji1obcJcG7ePwA@mail.gmail.com>
	<32cae92aa099067315d1a13c7302957f@hardeman.nu>
	<CAKv9HNZ_JjCutG-V+77vu2xMEihbRrYJSr4QR+LESSdrM71+yQ@mail.gmail.com>
	<db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
Date: Thu, 21 May 2015 17:22:08 +0300
Message-ID: <CAKv9HNY5jM-i5i420iu_kcfS2ZsnnMjdED59fxkxH5e5mjYe=Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	James Hogan <james@albanarts.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 May 2015 at 15:30, David Härdeman <david@hardeman.nu> wrote:
> On 2015-05-21 13:51, Antti Seppälä wrote:
>>
>> On 21 May 2015 at 12:14, David Härdeman <david@hardeman.nu> wrote:
>>>
>>> I'm talking about ir_raw_encode_scancode() which is entirely broken in
>>> its
>>> current state. It will, given more than one enabled protocol, encode a
>>> scancode to pulse/space events according to the rules of a randomly
>>> chosen
>>> protocol. That random selection will be influenced by things like *module
>>> load order* (independent of the separate fact that passing multiple
>>> protocols to it is completely bogus in the first place).
>>>
>>> To be clear: the same scancode may be encoded differently depending on if
>>> you've load the nec decoder before or after the rc5 decoder! That kind of
>>> behavior can't go into a release kernel (Mauro...).
>>>
>>
>> So... if the ir_raw_handler_list is sorted to eliminate the randomness
>> caused by module load ordering you will be happy (or happier)?
>
>
> No, cause it's a horrible hack. And the caller of ir_raw_handler_list()
> still has no idea of knowing (given more than one protocol) which protocol a
> given scancode will be encoded according to.
>

Okay, so how about "demuxing" the first protocol before handing them
to encoder callback? Simply something like below:

-               if (handler->protocols & protocols && handler->encode) {
+               if (handler->protocols & ffs(protocols) && handler->encode) {

Now the behavior is well-defined even when multiple protocols are selected.

>> That is something that could be useful even for the ir-decoding
>> functionality and might be worth a separate patch.
>
>
> Useful how?

Keeping dynamically filled lists sorted is a good practice if one
wishes to achieve determinism in behavior (like running decoders
always in certain order too).

-- 
Antti
