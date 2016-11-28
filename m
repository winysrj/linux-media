Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35833 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbcK1IfR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 03:35:17 -0500
Received: by mail-pf0-f180.google.com with SMTP id i88so23770007pfk.2
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2016 00:35:17 -0800 (PST)
Date: Mon, 28 Nov 2016 19:35:05 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161128083502.GA11075@shambles.local>
References: <20161118220107.GA3510@shambles.local>
 <20161120132948.GA23247@gofer.mess.org>
 <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
 <20161122092043.GA8630@gofer.mess.org>
 <20161123123851.GB14257@shambles.local>
 <20161123223419.GA25515@gofer.mess.org>
 <20161124121253.GA17639@shambles.local>
 <20161124133459.GA32385@gofer.mess.org>
 <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
 <20161127193510.GA20548@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161127193510.GA20548@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 27, 2016 at 07:35:10PM +0000, Sean Young wrote:
> > The application I am trying to use it with is the mythtv frontend.  I
> > am doing the keycode munging from an SSH session while myth is still
> > running on the main screen. I didn't think this would matter (since it
> > worked for KEY_OK->KEY_ENTER) but perhaps it does. Obviously
> > ir-keytable -t intercepts the scancodes when it is running, but when I
> > kill it myth responds normally to some keys, but not all.
> 
> X and keycodes is a bit messy. You might need xmodmap mappings. You
> can check them xev. I don't know much about this, I'm afraid. What
> linux distribution, version and keyboard layout are you using? I could
> try and see if I can reproduce/fix this.

I mostly figured this out but something weird happens with the most
significant bit (see my follow-on email). FWIW, this is on ubuntu 16.04
with their standard kernel (4.4) and a bog-standard US english layout.


> > I wanted to mention that the IR protocol is still showing as unknown.
> > Is there anything that can be done to sort that out?
> 
> It would be nice if that could be sorted out, although that would be 
> a separate patch.

That's fine. For the current patch, please feel free to add my
Tested-By: vincent.mcintyre@gmail.com

> So all we know right now is what scancode the IR receiver hardware
> produces but we have no idea what IR protocol is being used. In
> order to figure this out we need a recording of the IR the remote
> sends, for which a different IR receiver is needed. Neither your
> imon nor your dvb_usb_af9035 can do this, something like a mce usb
> IR receiver would be best. Do you have access to one? One with an IR
> emitter would be best.
> 
> So with that we can have a recording of the IR the remote sends, and
> with the emitter we can see which IR protocols the IR receiver
> understands.
> 

I'll poke around to see if I can find something, will take a few days.
Thanks again for your interest in this.
Vince
