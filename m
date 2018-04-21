Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:39748 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752911AbeDUR5o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 13:57:44 -0400
Received: by mail-ua0-f173.google.com with SMTP id g10so7663025ual.6
        for <linux-media@vger.kernel.org>; Sat, 21 Apr 2018 10:57:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180420215432.GA3747@minime.bse>
References: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
 <20180417045300.GA7723@minime.bse> <CAGoCfiwwCtp0entUfK74PhJDAubxAQeuAYgf6Jotw_EOT7+hSw@mail.gmail.com>
 <CAGoCfizXy6j5rgzDghT3Lo3ZKvoUjLt7P3k7qo5wnX+xEE7m-g@mail.gmail.com>
 <20180418182959.GA19152@minime.bse> <20180420215432.GA3747@minime.bse>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Sat, 21 Apr 2018 13:57:42 -0400
Message-ID: <CAGoCfiyTpHauT1abn8XsGV=uzrJcm4-Qg=SfGz2LY+_YKQeuKw@mail.gmail.com>
Subject: Re: cx88 invalid video opcodes when VBI enabled
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

My apologies for the delayed replies; been out of town for the last
couple of days.

On Fri, Apr 20, 2018 at 5:54 PM, Daniel Gl=C3=B6ckner <daniel-gl@gmx.net> w=
rote:
> for some reason I feel like buffer_queue in cx88-vbi.c should not be
> calling cx8800_start_vbi_dma as it is also called a few lines further
> down in start_streaming.
>
> Devin, can you check if it helps to remove that line and if VBI still
> works afterwards?

So I've commented out that line in buffer_queue, and so far haven't
been able to reproduce the issue, and it does look like VBI is working
as expected (captions are being rendered in VLC).  This doesn't
suggest I've done exhaustive testing by any means, but it's certainly
a good sign.

I've seen drivers in the past which start the main data pump when
buffer_queue() or buffer_prepare() is called (whether it be to start a
DMA engine in the case of PCI or start URB submission in the case of
USB devices).  However it's not clear that's required, in particular
with VB2 which will automatically call start_streaming() in the case
where read() is used.  If I had to guess, I suspect the origin of
starting DMA that early was probably oriented around users who wanted
to simply run "cat /dev/video0 > out.mpeg" without having to
explicitly issue a bunch of V4L ioctl() calls beforehand.

It's worth noting that we're also doing it in the buffer_queue()
routine for video and not just VBI.  Presumably we would want to drop
both cases.

Hans, you did the VB2 conversion and have obviously been through this
exercise with a number of other drivers.  Any thoughts on whether we
can drop the starting of DMA engine in buffer_queue()?

On a related note, a quick review of the start/stop logic for DMA in
that driver suggests the calls might not be properly balanced.  Looks
like portions of the core logic are also duplicated between
stop_streaming() and stop_video_dma() (which is only ever used if
CONFIG_PM is defined).  It feels like it could probably use some
review/cleanup, although I'm loathed to touch such a mature driver for
fear of breaking something subtle.

Thanks,

Devin

--=20
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
