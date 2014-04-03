Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:35543 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaDCXVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 19:21:16 -0400
Received: by mail-la0-f44.google.com with SMTP id c6so1917515lan.3
        for <linux-media@vger.kernel.org>; Thu, 03 Apr 2014 16:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHLDD1NSe9nrWJ2nfXaeBngZ_=aVYU_hTvsFgWez-n2OtVCLGA@mail.gmail.com>
References: <CAHLDD1NSe9nrWJ2nfXaeBngZ_=aVYU_hTvsFgWez-n2OtVCLGA@mail.gmail.com>
Date: Fri, 4 Apr 2014 09:21:14 +1000
Message-ID: <CAHLDD1OP4C6oJGHZ0ZHdBAPHqa+j0rFmp3=kRzYAkTkNCf=Z9g@mail.gmail.com>
Subject: Re: Lirc codec and starting "space" event
From: Austin Lund <austin.lund@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 April 2014 10:04, Austin Lund <austin.lund@gmail.com> wrote:
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

Just a note that I have tested this patch now and it works.  No idea
what impact it might have on other users.
