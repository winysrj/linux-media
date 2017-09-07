Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44059
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932279AbdIGOws (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 10:52:48 -0400
Date: Thu, 7 Sep 2017 11:52:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Brad Love <brad@nextdimension.cc>
Cc: Christian Steiner <christian.steiner@outlook.de>,
        Olli Salonen <olli.salonen@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: add support for Hauppauge WinTV-dualHD DVB
 tuner
Message-ID: <20170907115240.78ea1a06@vento.lan>
In-Reply-To: <b2017939-2029-a306-8767-3f11e780959e@nextdimension.cc>
References: <1459782772-21451-1-git-send-email-olli.salonen@iki.fi>
        <570A6FED.4090700@outlook.de>
        <CAAZRmGy1=8UXe0WqpucCt0qUfZQS+NHsHYmAq3yKu_pxK38yTw@mail.gmail.com>
        <CAAZRmGzXcHz21m4yL4rFOpippzLq07nYsenwTvUgqkhbRJ8X4w@mail.gmail.com>
        <VI1P194MB004719DAD98521F900F5D11191FD0@VI1P194MB0047.EURP194.PROD.OUTLOOK.COM>
        <b2017939-2029-a306-8767-3f11e780959e@nextdimension.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brad,

Em Wed, 31 May 2017 15:01:00 -0500
Brad Love <brad@nextdimension.cc> escreveu:

> Christian et al,
> 
> I am an engineer at Hauppauge. This repo is the staging area for all the
> patches I am testing, with the intention of getting them upstreamed. I
> will be inaccessible for the next 18 days however, so I will not be able
> to put any effort until I get back.

Any news on such patchset?

On a side note, I took a quick look on some of the patches at the
git repository at:

	https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/tree/master/patches/ubuntu-zesty-4.10.0/extra

I suspect that some of the patches there could have some side effect on
existing drivers, like this one that unconditionally changes the size
of URB:

	https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/blob/master/patches/ubuntu-zesty-4.10.0/extra/0003-em28xx-usb-packet-size-tweaks.patch

So, it would be good to be able to test this set also with older
em28xx devices that also support bulk transfers.

Thanks,
Mauro
