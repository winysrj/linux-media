Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:57439 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbdEaUjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 16:39:44 -0400
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com [209.85.161.182])
        by imap.netup.ru (Postfix) with ESMTPSA id E929F8B4738
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 23:39:42 +0300 (MSK)
Received: by mail-yw0-f182.google.com with SMTP id b68so11861121ywe.3
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 13:39:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170531223204.5d1de002@macbox>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
 <20170528234738.6726df65@macbox> <CAK3bHNW9sM0fZFqYEX-mEhv-Rax82u25KdgjQftGcoY6wV1O0A@mail.gmail.com>
 <CAK3bHNVu9_x492P+KQQHEVe8HOCvnktPaLSyHjRgMN_svQ56+A@mail.gmail.com> <20170531223204.5d1de002@macbox>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 16:39:20 -0400
Message-ID: <CAK3bHNW7ymsOz5d8R5WEico9pkHiSgpVN_tOW+4htOefiEmQ3w@mail.gmail.com>
Subject: Re: [PATCH 00/19] cxd2841er/ddbridge: support Sony CXD28xx hardware
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>, rjkm@metzlerbros.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

ok, perfect !
Will check this flags later when I switch back to driver :) Current
situation with configurable flags is ok.


2017-05-31 16:32 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> Am Wed, 31 May 2017 08:30:34 -0400
> schrieb Abylay Ospan <aospan@netup.ru>:
>
> Hi Abylay,
>
>> I have ack'ed all patches related to cxd2841er. Please check am i
>> missing something ?
>
> Thank you very much for your review and your ACKs, and in general
> taking time to look into them! You didn't miss any of the patches :)
> Will add your ACKs to the cxd2841er patches in a very likely upcoming V2
> of the series.
>
>> I see some good flags (CXD2841ER_NO_WAIT_LOCK and
>> CXD2841ER_EARLY_TUNE). I should check it for our boards too :)
>
> Re EARLY_TUNE - I wasn't sure if the order of tuner/demod setup is of
> importance on your devices. When picking the IF freq from the tuner
> though, we first need to tune and then set up the demod since the demod
> queries the tuner about this. If your hardware also works with the
> "earlier tune", maybe we should drop this flag/condition and just move
> the tune call up.
>
> Re NO_WAIT_LOCK - works fine with or without this. However, when e.g.
> using TVH and looking at the stats, the Web UI will freeze if a retune
> occurs. Again, not sure if it's absolutely required on your
> hardware/software - if not, I suggest to remove the flag together with
> the wait lock entirely.
>
> Looking forward for your results and opinions! :-)
>
> Best regards,
> Daniel Scheller



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
