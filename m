Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39299 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbBCJma (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 04:42:30 -0500
Received: by mail-wi0-f177.google.com with SMTP id r20so20466587wiv.4
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 01:42:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGyh83_S0hSAz8f1=HGoCitMx=+kqM_pkQ0xWfOrLOAMyA@mail.gmail.com>
References: <CAPx3zdRNiaSKbG9PtVbnA_fXm-ietqOiciq9H0N5dHQFKibZ_w@mail.gmail.com>
	<CAAZRmGyh83_S0hSAz8f1=HGoCitMx=+kqM_pkQ0xWfOrLOAMyA@mail.gmail.com>
Date: Tue, 3 Feb 2015 10:42:29 +0100
Message-ID: <CAPx3zdQPBR2_G-N46oVR-XZOvP9YJxaPQUf=2Ycvs4UNHsx+sg@mail.gmail.com>
Subject: Re: [BUG] - Why anyone fix this problem?
From: Francesco Other <francesco.other@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maybe when Doron Cohen wrote the patch the device worked fine but now,
after that someone change the code for their own enjoyment, it
doesn't.

If you read my question you will find that the device has signal lock
but no data stream. There isn't need to write a code from scratch
because I have the working firmware that kernel asks for.

I don't know what the problem is, I'm an aerospace engineer not a
software engineer.

Best Regards

Francesco


2015-02-03 9:06 GMT+01:00 Olli Salonen <olli.salonen@iki.fi>:
> Hi Francesco,
>
> You need to understand that many people write code for their own
> enjoyment. In other words, they often write code to scratch an itch.
> Thus it can sometimes happen that there really is no-one here who
> could help you. The person who wrote the code originally might have
> stopped contributing and is more interested in gardening or
> kiteboarding these days. Maybe no-one here just has heard of the
> device you're talking about or owns one.
>
> Anyway, I did some digging for you. The support for your device was
> originally added based on this patch
> https://patchwork.linuxtv.org/patch/7881/ submitted by Doron Cohen
> <doronc@siano-ms.com>. It seems he's working for the Siano company
> itself. Have you tried contacting them already?
>
> Cheers,
> -olli
>
> On 2 February 2015 at 15:10, Francesco Other <francesco.other@gmail.com> wrote:
>> Is it possible that the problem I explained here isn't interesting for anyone?
>>
>> The device is supported by kernel but obviously there is a bug with DVB-T.
>>
>> I have the working firmware (on Windows) for DVB-T if you need it.
>>
>> http://www.spinics.net/lists/linux-media/msg85505.html
>>
>> http://www.spinics.net/lists/linux-media/msg85478.html
>>
>> http://www.spinics.net/lists/linux-media/msg85432.html
>>
>> Regards
>>
>> Francesco
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
