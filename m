Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:39531 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbbBCIGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 03:06:33 -0500
Received: by mail-ig0-f175.google.com with SMTP id hn18so24697405igb.2
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 00:06:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPx3zdRNiaSKbG9PtVbnA_fXm-ietqOiciq9H0N5dHQFKibZ_w@mail.gmail.com>
References: <CAPx3zdRNiaSKbG9PtVbnA_fXm-ietqOiciq9H0N5dHQFKibZ_w@mail.gmail.com>
Date: Tue, 3 Feb 2015 10:06:32 +0200
Message-ID: <CAAZRmGyh83_S0hSAz8f1=HGoCitMx=+kqM_pkQ0xWfOrLOAMyA@mail.gmail.com>
Subject: Re: [BUG] - Why anyone fix this problem?
From: Olli Salonen <olli.salonen@iki.fi>
To: Francesco Other <francesco.other@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Francesco,

You need to understand that many people write code for their own
enjoyment. In other words, they often write code to scratch an itch.
Thus it can sometimes happen that there really is no-one here who
could help you. The person who wrote the code originally might have
stopped contributing and is more interested in gardening or
kiteboarding these days. Maybe no-one here just has heard of the
device you're talking about or owns one.

Anyway, I did some digging for you. The support for your device was
originally added based on this patch
https://patchwork.linuxtv.org/patch/7881/ submitted by Doron Cohen
<doronc@siano-ms.com>. It seems he's working for the Siano company
itself. Have you tried contacting them already?

Cheers,
-olli

On 2 February 2015 at 15:10, Francesco Other <francesco.other@gmail.com> wrote:
> Is it possible that the problem I explained here isn't interesting for anyone?
>
> The device is supported by kernel but obviously there is a bug with DVB-T.
>
> I have the working firmware (on Windows) for DVB-T if you need it.
>
> http://www.spinics.net/lists/linux-media/msg85505.html
>
> http://www.spinics.net/lists/linux-media/msg85478.html
>
> http://www.spinics.net/lists/linux-media/msg85432.html
>
> Regards
>
> Francesco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
