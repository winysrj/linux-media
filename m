Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39237 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1JARqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 13:46:53 -0400
Received: by ywb5 with SMTP id 5so2375338ywb.19
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2011 10:46:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s3fXYcgKtEKT0h1H92kOZFyOd5s0zYv1wB6wiZEt+d5AA@mail.gmail.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
	<4E8716D1.9010104@mlbassoc.com>
	<CAAwP0s07U3wHR0LoSmvQzXG3KxUoARgjH7G2gxi911RBVe9HRw@mail.gmail.com>
	<CA+2YH7u=PzkTFUwWgJHuuHphrz8O7UZvOKDWfFoxGcouzzGo7Q@mail.gmail.com>
	<CAAwP0s3fXYcgKtEKT0h1H92kOZFyOd5s0zYv1wB6wiZEt+d5AA@mail.gmail.com>
Date: Sat, 1 Oct 2011 19:46:52 +0200
Message-ID: <CA+2YH7vZvdt=nv4XWeA_4Hefy_us6nB0AxQbM9Ra68UcPz0a3A@mail.gmail.com>
Subject: Re: [PATCH 0/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
From: Enrico <ebutera@users.berlios.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 1, 2011 at 7:27 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> Yes, I saw it. That is why I didn't post our modifications to the ISP
> CCDC driver. Our approach is very similar to the one followed by TI
> (changing the CCDC output buffer every two VD0 interrupts) but we did
> different a few things:
>
> - decouple next buffer obtaining from last buffer releasing
> - maintain two buffers (struct isp_buffer), current and last
> - move move most of the logic to the VD1 interrupt since the ISP is
> already busy while execution VD0 handler.

If you think it is a better approach you can submit it for review,
right now there is no "clean" version supporting bt656 so yours can be
the one.


>>>> Even if it does detect the signal shape (NTSC, PAL), doesn't one still need
>>>> to [externally] configure the pads for this shape?
>>>>
>>>
>>> Yes, that is why I wanted to do the auto-detection for the tvp5151, so
>>> we only have to manually configure the ISP components (or any other
>>> hardware video processing pipeline entities, sorry for my
>>> OMAP-specific comments).
>>
>> Laurent was not very happy [3] about changing video formats out of the
>> driver control, so this should be discussed more.
>>
>> [3]: http://www.spinics.net/lists/linux-omap/msg56983.html
>>
>>
>
> Ok, I thought it was the right thing to do, my bad. Lets do it from
> user-space then using the MCF.

I see there is some ongoing discussion about a similar topic, so just
follow it and see how it turns out.

Enrico
