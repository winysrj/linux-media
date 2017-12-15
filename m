Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:38026 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754706AbdLODFh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 22:05:37 -0500
Received: by mail-qk0-f172.google.com with SMTP id z203so8824114qkb.5
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 19:05:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <23090.62262.800851.660592@morden.metzler>
References: <20171214080316.nadtlgwyng3r7gro@mwanda> <23090.62262.800851.660592@morden.metzler>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Thu, 14 Dec 2017 22:05:36 -0500
Message-ID: <CAGoCfiwFPEYe3QEsUHiyHfrghWj3mBP1w2XJc5jrfAkMempJFQ@mail.gmail.com>
Subject: Re: [bug report] drx: add initial drx-d driver
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I think I wrote the driver more than 10 years ago and somebody later submitted it
> to the kernel.

I'm pretty sure that was me, or perhaps I was the first person to get
it to work with a device upstream - it was so long ago.

> I don't know if there is a anybody still maintaining this. Is it even used anymore?
> I could write a patch but cannot test it (e.g. to see if it really always
> loops 1000 times ...)

Pretty sure the register was a status register that had bits set for
pending writes, and when the transfer was complete all the bits would
be zero (at which point it should stop polling the register and bail
out).

I would have to test it to be sure, but I'm 80% confident that in
normal operation that loop only does a few iterations.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
