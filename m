Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32868 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbaGWW5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 18:57:23 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9600LKYT3M7D80@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jul 2014 18:57:22 -0400 (EDT)
Date: Wed, 23 Jul 2014 19:57:18 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Austin Lund <austin.lund@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Lirc codec and starting "space" event
Message-id: <20140723195718.14648780.m.chehab@samsung.com>
In-reply-to: <CAHLDD1NSe9nrWJ2nfXaeBngZ_=aVYU_hTvsFgWez-n2OtVCLGA@mail.gmail.com>
References: <CAHLDD1NSe9nrWJ2nfXaeBngZ_=aVYU_hTvsFgWez-n2OtVCLGA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 1 Apr 2014 10:04:16 +1000
Austin Lund <austin.lund@gmail.com> escreveu:

> Hi,
> 
> I've been having a problem with a GPIO ir device in an i.mx6 arm
> system that I have (cubox-i).
> 
> It seems to all work ok, except the output on /dev/lirc0 is not quite
> what lircd seems to expect.  Lircd wants a long space before the
> starting pulse before processing any output. However, no long space is
> sent when I check the output (doing "mode2" and a plain hexdump
> /dev/lirc0).
> 
> This causes problems in detecting button presses on remotes.
> Sometimes it works if you press the buttons quick enough, but after
> waiting a while it doesn't work.
> 
> I have been looking at the code for a while now, and it seems that it
> has something to do with the lirc codec ignoring reset events (just
> returns 0).
> 
> I've made up this patch, but I'm travelling at the moment and haven't
> had a chance to actually test it.
> 
> What I'm wondering is if this issue is known, and if my approach is
> going down the right path.
> 
> The only alternative I could see is to change the way the gpio ir
> driver handles events.  It seems to just call ir_raw_event_store_edge
> which put a zeroed reset event into the queue.  I'm assuming there are
> other users of these functions and that it's probably best not to
> fiddle with that if possible.
> 
> Thanks.
> 
> PS Please CC me as I'm not subscribed.

You forgot to add a:

Signed-off-by: your name <your@email>

on your patch. Please add it and resend.

Thanks!
Mauro
