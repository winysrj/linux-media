Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36062 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757386AbcK3JJT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 04:09:19 -0500
Received: by mail-pf0-f175.google.com with SMTP id 189so38154550pfz.3
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2016 01:09:19 -0800 (PST)
Date: Wed, 30 Nov 2016 20:02:31 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161130090229.GB639@shambles.local>
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
>  
> > I wanted to mention that the IR protocol is still showing as unknown.
> > Is there anything that can be done to sort that out?
> 
> It would be nice if that could be sorted out, although that would be 
> a separate patch.
> 
> So all we know right now is what scancode the IR receiver hardware
> produces but we have no idea what IR protocol is being used. In order to
> figure this out we need a recording of the IR the remote sends, for which
> a different IR receiver is needed. Neither your imon nor your 
> dvb_usb_af9035 can do this, something like a mce usb IR receiver would
> be best. Do you have access to one? One with an IR emitter would be
> best.
> 
> So with that we can have a recording of the IR the remote sends, and
> with the emitter we can see which IR protocols the IR receiver 
> understands.

Haven't been able to find anything suitable. I would order something
but I won't be able to follow up for several weeks.
I'll ask on the myth list to see if anyone is up for trying this.

Thanks again for your help with this
Vince
