Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62134 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1JAR16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 13:27:58 -0400
Received: by yxl31 with SMTP id 31so2440230yxl.19
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2011 10:27:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7u=PzkTFUwWgJHuuHphrz8O7UZvOKDWfFoxGcouzzGo7Q@mail.gmail.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <4E8716D1.9010104@mlbassoc.com> <CAAwP0s07U3wHR0LoSmvQzXG3KxUoARgjH7G2gxi911RBVe9HRw@mail.gmail.com>
 <CA+2YH7u=PzkTFUwWgJHuuHphrz8O7UZvOKDWfFoxGcouzzGo7Q@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sat, 1 Oct 2011 19:27:37 +0200
Message-ID: <CAAwP0s3fXYcgKtEKT0h1H92kOZFyOd5s0zYv1wB6wiZEt+d5AA@mail.gmail.com>
Subject: Re: [PATCH 0/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
To: Enrico <ebutera@users.berlios.de>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 1, 2011 at 6:39 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Sat, Oct 1, 2011 at 5:55 PM, Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>> We hack a few bits of the ISP CCDC driver to support ITU-R BT656
>> interlaced data with embedded syncs video format and ported the
>> tvp5150 driver to the MCF so it can be detected as a sub-device and be
>> part of the OMAP ISP image processing pipeline (as a source pad).
>
> That was already posted on the list [1], there was some discussion but
> i don't know what's the status/plan to get it into mainline.
>

Hello Enrico,

Yes, I saw it. That is why I didn't post our modifications to the ISP
CCDC driver. Our approach is very similar to the one followed by TI
(changing the CCDC output buffer every two VD0 interrupts) but we did
different a few things:

- decouple next buffer obtaining from last buffer releasing
- maintain two buffers (struct isp_buffer), current and last
- move move most of the logic to the VD1 interrupt since the ISP is
already busy while execution VD0 handler.

> And, as you can see in [2], don't expect many comments :D
>

Yes, now I saw that you already posted this, sorry for not doing a
correct mail archive browsing before posting the patch.

> [1]: http://www.spinics.net/lists/linux-media/msg37710.html
> [2]: http://www.spinics.net/lists/linux-media/msg37116.html
>
>
>>> Even if it does detect the signal shape (NTSC, PAL), doesn't one still need
>>> to [externally] configure the pads for this shape?
>>>
>>
>> Yes, that is why I wanted to do the auto-detection for the tvp5151, so
>> we only have to manually configure the ISP components (or any other
>> hardware video processing pipeline entities, sorry for my
>> OMAP-specific comments).
>
> Laurent was not very happy [3] about changing video formats out of the
> driver control, so this should be discussed more.
>
> [3]: http://www.spinics.net/lists/linux-omap/msg56983.html
>
>

Ok, I thought it was the right thing to do, my bad. Lets do it from
user-space then using the MCF.

>> I didn't know that the physical connection affected the video output
>> format, I thought that it was only a physical medium to carry the same
>> information, sorry if my comments are silly but I'm really newbie with
>> video in general.
>
> I think you got it right, i haven't tested it but the output format
> shouldn't be affected by the video source( if it stays pal/ntsc of
> course). Maybe you will get only a different "active" video area so
> only cropping will be affected.
>
> Enrico
>

Thanks and best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
