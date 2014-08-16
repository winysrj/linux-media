Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:63012 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaHPRqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 13:46:11 -0400
Received: by mail-oi0-f53.google.com with SMTP id e131so2454455oig.26
        for <linux-media@vger.kernel.org>; Sat, 16 Aug 2014 10:46:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN39uTrPc=VCCJ+v985eXu2Sr_aqLTvGMk0GOC+PS8moaKShQg@mail.gmail.com>
References: <53EF73DC.4000704@kohlhas.info> <53EF7B12.3090700@iki.fi> <CAN39uTrPc=VCCJ+v985eXu2Sr_aqLTvGMk0GOC+PS8moaKShQg@mail.gmail.com>
From: Dreamcat4 <dreamcat4@gmail.com>
Date: Sat, 16 Aug 2014 18:45:30 +0100
Message-ID: <CAN39uTqT-qeVNxJMcTJnLv-T9DuM585ckUPQbW7dsFjwOXn3tw@mail.gmail.com>
Subject: Re: S482
To: Antti Palosaari <crope@iki.fi>
Cc: Jahn Kohlhas <jahn@kohlhas.info>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been told that the S482 is actually 2x S662, just in a different
form-factor. Where S492 is 2 units on a single internal PCI card. The
S662 is external single tuner. So if someone do submit for a S482 or
S662 device, they should probably include for completeness the other
one also at same time.

I was briefly in possession of a S662 last week. However I had to
return it unopened (sealed box) as there was a better product
available. If the box had already been open, then I would have been
able to test and submit CrazyCat's patch for S662. Which is in
CrazyCat's fork of the lappanian. The lappanian itself has S482 only
(but no S662). CrazyCat's has both of them in it.

I read some people on Ubuntu forums did complain that Tevii S662
didn't work, since S660 is supported and technically a very similar
device. Then they tried CrazyCat's patch for Tevii S662 and say that
it is working with Crazy patch. And didn't have any good reason to
doubt them, in fact buying one such device.

FYI the other hardware I ended up swapping it for was a Telestar
Digibit R1 / Grundig GSS.Box1. Being a quad receiver and SAT>IP it
just seemed like a lot better value for the money.

> On Sat, Aug 16, 2014 at 4:38 PM, Antti Palosaari <crope@iki.fi> wrote:
>>
>> Moikka
>>
>>
>> On 08/16/2014 05:08 PM, Jahn Kohlhas wrote:
>>>
>>> Hey,
>>> is it possible to include the patches from Tevii for the media-build in
>>> your git repo?
>>> http://www.tevii.com/Tevii_Product_20140428_media_build_b6.tar.bz2.rar
>>> the files they have patched:
>>> dw2102.c patched
>>> m88ts202x.h new
>>>
>>> Would be very nice to get the S482 working with the git build ;)
>>> Thanks
>>
>>
>> If you have a device and enough experience then do it. I cannot do as I don't have such device.
>>
>> regards
>> Antti
>>
>>
>> --
>> http://palosaari.fi/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
