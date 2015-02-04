Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52284 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032AbbBDRQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 12:16:29 -0500
Received: by mail-wi0-f180.google.com with SMTP id h11so5186797wiw.1
        for <linux-media@vger.kernel.org>; Wed, 04 Feb 2015 09:16:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGzYkkGKbP2z98DTM+6KKjuEeiGHsa7Oh5EfZJZhtw7GgQ@mail.gmail.com>
References: <CAPx3zdRNiaSKbG9PtVbnA_fXm-ietqOiciq9H0N5dHQFKibZ_w@mail.gmail.com>
	<CAAZRmGyh83_S0hSAz8f1=HGoCitMx=+kqM_pkQ0xWfOrLOAMyA@mail.gmail.com>
	<CAPx3zdQPBR2_G-N46oVR-XZOvP9YJxaPQUf=2Ycvs4UNHsx+sg@mail.gmail.com>
	<CAAZRmGzYkkGKbP2z98DTM+6KKjuEeiGHsa7Oh5EfZJZhtw7GgQ@mail.gmail.com>
Date: Wed, 4 Feb 2015 18:16:28 +0100
Message-ID: <CAPx3zdSV25E6ag+RbRn2vpteWqTMCBqhYm_4CoiFGSdzqkv0LQ@mail.gmail.com>
Subject: Re: [BUG] - Why anyone fix this problem?
From: Francesco Other <francesco.other@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, Doron Cohen solved the problem in 5 seconds.

There are 2 mode for DVB-T, we need to force mode 4 instead of mode 0.

Thanks to Roberto for trying to solve the problem and to Olli for the
e-mail of Doron Cohen.

Regards

Francesco


2015-02-03 11:57 GMT+01:00 Olli Salonen <olli.salonen@iki.fi>:
> Well, if you suspect that some other change broke the driver, then you
> can try an older kernel (the support was introduced in kernel 3.10) or
> an older media_tree to see if that's indeed the case.
>
> The firmware is just one small piece of the puzzle. Maybe you can just
> replace the firmware or maybe you need to write a lot of code or even
> both. All this is next to impossible to say without having a very
> strictly defined and pinpointed issue or alternatively the actual
> device to play around with. So far it seems you're the only one with
> that device here, so it would help a lot if you can narrow the scope
> down by saying: "it worked fine in kernel xyz, but commit abc seems to
> break the support for the device" or "it seems it has never worked for
> DVB-T".
>
> Cheers,
> -olli
>
>
>
> On 3 February 2015 at 11:42, Francesco Other <francesco.other@gmail.com> wrote:
>> Maybe when Doron Cohen wrote the patch the device worked fine but now,
>> after that someone change the code for their own enjoyment, it
>> doesn't.
>>
>> If you read my question you will find that the device has signal lock
>> but no data stream. There isn't need to write a code from scratch
>> because I have the working firmware that kernel asks for.
>>
>> I don't know what the problem is, I'm an aerospace engineer not a
>> software engineer.
>>
>> Best Regards
>>
>> Francesco
>>
>>
>> 2015-02-03 9:06 GMT+01:00 Olli Salonen <olli.salonen@iki.fi>:
>>> Hi Francesco,
>>>
>>> You need to understand that many people write code for their own
>>> enjoyment. In other words, they often write code to scratch an itch.
>>> Thus it can sometimes happen that there really is no-one here who
>>> could help you. The person who wrote the code originally might have
>>> stopped contributing and is more interested in gardening or
>>> kiteboarding these days. Maybe no-one here just has heard of the
>>> device you're talking about or owns one.
>>>
>>> Anyway, I did some digging for you. The support for your device was
>>> originally added based on this patch
>>> https://patchwork.linuxtv.org/patch/7881/ submitted by Doron Cohen
>>> <doronc@siano-ms.com>. It seems he's working for the Siano company
>>> itself. Have you tried contacting them already?
>>>
>>> Cheers,
>>> -olli
>>>
>>> On 2 February 2015 at 15:10, Francesco Other <francesco.other@gmail.com> wrote:
>>>> Is it possible that the problem I explained here isn't interesting for anyone?
>>>>
>>>> The device is supported by kernel but obviously there is a bug with DVB-T.
>>>>
>>>> I have the working firmware (on Windows) for DVB-T if you need it.
>>>>
>>>> http://www.spinics.net/lists/linux-media/msg85505.html
>>>>
>>>> http://www.spinics.net/lists/linux-media/msg85478.html
>>>>
>>>> http://www.spinics.net/lists/linux-media/msg85432.html
>>>>
>>>> Regards
>>>>
>>>> Francesco
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
