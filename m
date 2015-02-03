Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:56203 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbbBCK5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 05:57:03 -0500
Received: by mail-ig0-f182.google.com with SMTP id h15so8466800igd.3
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 02:57:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPx3zdQPBR2_G-N46oVR-XZOvP9YJxaPQUf=2Ycvs4UNHsx+sg@mail.gmail.com>
References: <CAPx3zdRNiaSKbG9PtVbnA_fXm-ietqOiciq9H0N5dHQFKibZ_w@mail.gmail.com>
	<CAAZRmGyh83_S0hSAz8f1=HGoCitMx=+kqM_pkQ0xWfOrLOAMyA@mail.gmail.com>
	<CAPx3zdQPBR2_G-N46oVR-XZOvP9YJxaPQUf=2Ycvs4UNHsx+sg@mail.gmail.com>
Date: Tue, 3 Feb 2015 12:57:01 +0200
Message-ID: <CAAZRmGzYkkGKbP2z98DTM+6KKjuEeiGHsa7Oh5EfZJZhtw7GgQ@mail.gmail.com>
Subject: Re: [BUG] - Why anyone fix this problem?
From: Olli Salonen <olli.salonen@iki.fi>
To: Francesco Other <francesco.other@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well, if you suspect that some other change broke the driver, then you
can try an older kernel (the support was introduced in kernel 3.10) or
an older media_tree to see if that's indeed the case.

The firmware is just one small piece of the puzzle. Maybe you can just
replace the firmware or maybe you need to write a lot of code or even
both. All this is next to impossible to say without having a very
strictly defined and pinpointed issue or alternatively the actual
device to play around with. So far it seems you're the only one with
that device here, so it would help a lot if you can narrow the scope
down by saying: "it worked fine in kernel xyz, but commit abc seems to
break the support for the device" or "it seems it has never worked for
DVB-T".

Cheers,
-olli



On 3 February 2015 at 11:42, Francesco Other <francesco.other@gmail.com> wrote:
> Maybe when Doron Cohen wrote the patch the device worked fine but now,
> after that someone change the code for their own enjoyment, it
> doesn't.
>
> If you read my question you will find that the device has signal lock
> but no data stream. There isn't need to write a code from scratch
> because I have the working firmware that kernel asks for.
>
> I don't know what the problem is, I'm an aerospace engineer not a
> software engineer.
>
> Best Regards
>
> Francesco
>
>
> 2015-02-03 9:06 GMT+01:00 Olli Salonen <olli.salonen@iki.fi>:
>> Hi Francesco,
>>
>> You need to understand that many people write code for their own
>> enjoyment. In other words, they often write code to scratch an itch.
>> Thus it can sometimes happen that there really is no-one here who
>> could help you. The person who wrote the code originally might have
>> stopped contributing and is more interested in gardening or
>> kiteboarding these days. Maybe no-one here just has heard of the
>> device you're talking about or owns one.
>>
>> Anyway, I did some digging for you. The support for your device was
>> originally added based on this patch
>> https://patchwork.linuxtv.org/patch/7881/ submitted by Doron Cohen
>> <doronc@siano-ms.com>. It seems he's working for the Siano company
>> itself. Have you tried contacting them already?
>>
>> Cheers,
>> -olli
>>
>> On 2 February 2015 at 15:10, Francesco Other <francesco.other@gmail.com> wrote:
>>> Is it possible that the problem I explained here isn't interesting for anyone?
>>>
>>> The device is supported by kernel but obviously there is a bug with DVB-T.
>>>
>>> I have the working firmware (on Windows) for DVB-T if you need it.
>>>
>>> http://www.spinics.net/lists/linux-media/msg85505.html
>>>
>>> http://www.spinics.net/lists/linux-media/msg85478.html
>>>
>>> http://www.spinics.net/lists/linux-media/msg85432.html
>>>
>>> Regards
>>>
>>> Francesco
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
