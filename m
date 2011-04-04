Return-path: <mchehab@pedra>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:45361 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751459Ab1DDIBr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 04:01:47 -0400
Date: Mon, 4 Apr 2011 09:42:04 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Florian Mickler <florian@mickler.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, oliver@neukum.org,
	linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media] dib0700: get rid of on-stack dma buffers
In-Reply-To: <1301851423-21969-1-git-send-email-florian@mickler.org>
Message-ID: <alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
References: <1301851423-21969-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Florian,

On Sun, 3 Apr 2011, Florian Mickler wrote:

> Hi,
>
> since I got no reaction[1] on the vp702x driver, I proceed with the
> dib0700.
>
> There are multiple drivers in drivers/media/dvb/dvb-usb/ which use
> usb_control_msg to perform dma to stack-allocated buffers. This is a bad idea
> because of cache-coherency issues and on some platforms the stack is mapped
> virtually and also lib/dma-debug.c warn's about it at runtime.
>
> Patches to ec168, ce6230, au6610 and lmedm04 were already tested and reviewed
> and submitted for inclusion [2]. Patches to a800, vp7045, friio, dw2102, m920x
> and opera1 are still waiting for for review and testing [3].
>
> This patch to dib0700 is a fix for a warning seen and reported by Zdenek
> Kabalec in Bug #15977 [4].
>
> Florian Mickler (2):
>      [media] dib0700: get rid of on-stack dma buffers

For this one we implemented an alternative. See here:

http://git.linuxtv.org/pb/media_tree.git?a=commit;h=16b54de2d8b46e48c5c8bdf9b350eac04e8f6b46

which I pushed, but obviously forgot to send the pull-request.

This is done now.

For the second patch I will incorperate it as soon as I find the time.

best regards,
--

Patrick
