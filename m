Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:51516 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757227AbdIICJ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 22:09:27 -0400
Received: from homiemail-a81.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 70C1B85A24
        for <linux-media@vger.kernel.org>; Fri,  8 Sep 2017 19:09:27 -0700 (PDT)
Subject: Re: [PATCH] em28xx: add support for Hauppauge WinTV-dualHD DVB tuner
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Brad Love <brad@nextdimension.cc>
Cc: Christian Steiner <christian.steiner@outlook.de>,
        Olli Salonen <olli.salonen@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1459782772-21451-1-git-send-email-olli.salonen@iki.fi>
 <570A6FED.4090700@outlook.de>
 <CAAZRmGy1=8UXe0WqpucCt0qUfZQS+NHsHYmAq3yKu_pxK38yTw@mail.gmail.com>
 <CAAZRmGzXcHz21m4yL4rFOpippzLq07nYsenwTvUgqkhbRJ8X4w@mail.gmail.com>
 <VI1P194MB004719DAD98521F900F5D11191FD0@VI1P194MB0047.EURP194.PROD.OUTLOOK.COM>
 <b2017939-2029-a306-8767-3f11e780959e@nextdimension.cc>
 <20170907115240.78ea1a06@vento.lan>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <168a572a-5f7a-b459-2657-ee5b879a27ae@nextdimension.cc>
Date: Fri, 8 Sep 2017 21:09:25 -0500
MIME-Version: 1.0
In-Reply-To: <20170907115240.78ea1a06@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


On 2017-09-07 09:52, Mauro Carvalho Chehab wrote:
> Hi Brad,
>
> Em Wed, 31 May 2017 15:01:00 -0500
> Brad Love <brad@nextdimension.cc> escreveu:
>
>> Christian et al,
>>
>> I am an engineer at Hauppauge. This repo is the staging area for all t=
he
>> patches I am testing, with the intention of getting them upstreamed. I=

>> will be inaccessible for the next 18 days however, so I will not be ab=
le
>> to put any effort until I get back.
> Any news on such patchset?
>
> On a side note, I took a quick look on some of the patches at the
> git repository at:
>
> 	https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/tree/mas=
ter/patches/ubuntu-zesty-4.10.0/extra
>
> I suspect that some of the patches there could have some side effect on=

> existing drivers, like this one that unconditionally changes the size
> of URB:
>
> 	https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/blob/mas=
ter/patches/ubuntu-zesty-4.10.0/extra/0003-em28xx-usb-packet-size-tweaks.=
patch
>
> So, it would be good to be able to test this set also with older
> em28xx devices that also support bulk transfers.
>
> Thanks,
> Mauro

I apologize for delay of action on my growing patchset, summer has been
quite busy for me. I can find time to work on this now though. There is
an initial cluster of the set that I think are ready, but I agree the
unconditional URB size change should be tested against other em28xx
devices. We've found the size changes optimal, but haven't tested
against anyone else's hardware. I will try and source and source some
bulk models from other manufacturers to verify they still operate with
the modification.

Regards,

Brad
