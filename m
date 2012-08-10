Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40446 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2HJRlo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 13:41:44 -0400
Received: by qafi31 with SMTP id i31so284550qaf.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 10:41:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120810094758.GA18223@pequod.mess.org>
References: <CADTwmX8-yf3iNhrOozQGFnHg=H+rq6rti8AO=uRBzsj+OHEdyQ@mail.gmail.com>
 <20120810094758.GA18223@pequod.mess.org>
From: Partha Guha Roy <partha.guha.roy@gmail.com>
Date: Fri, 10 Aug 2012 23:41:23 +0600
Message-ID: <CADTwmX-odw+=GXuYAo9y3E6=7-TLuW0U5GSU2dnpWYtm4RXGLA@mail.gmail.com>
Subject: Re: Philips saa7134 IR remote problem with linux kernel v2.6.35
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

I am not an expert on the kernel. So please excuse me if I give the
wrong answer somewhere.

On Fri, Aug 10, 2012 at 3:47 PM, Sean Young <sean@mess.org> wrote:
>
> Are you runnning the lircd user space process for input or relying on
> the in-kernel decoders?

For my testing, I booted the vanilla kernel into ubuntu recovery mode
and just pressed a few keys on the remote. No lircd process was
running at that point. So, I am guessing that I used the in-kernel
decoders.

> Also what remote are you using (or more
> specifically, what IR protocol does it use)?
>

The remove came with the analog TV card (avermedia pci pure m135a). I
am not sure what protocol the remote uses. I'd really appreciate it if
you could let me know how I can find that out.

> Can you reproduce the issue on a more contemporary kernel?
>

Yes. The buggy behavior is present in Ubuntu 12.04 (IIRC, kernel
v3.2.*). I also know that the buggy behavior is present at v3.4.x of
the kernel. I haven't tested more recent kernels.

> Note that the commit only affects kernel space IR decoders so it should
> not affect lircd.
>

Ok. But as I mentioned, I think I am using kernel space decoders.

> I wouldn't be surprised if the 15ms delay for processing in
> saa7134_raw_decode_irq (bottom of saa7134-input.c) needs increasing.
>

Thank you very much for your feedback.

Regards.

/Partha Roy
