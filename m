Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36450 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdEaUcL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 16:32:11 -0400
Received: by mail-wm0-f66.google.com with SMTP id k15so6327025wmh.3
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 13:32:10 -0700 (PDT)
Date: Wed, 31 May 2017 22:32:04 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Abylay Ospan <aospan@netup.ru>
Cc: Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>, rjkm@metzlerbros.de
Subject: Re: [PATCH 00/19] cxd2841er/ddbridge: support Sony CXD28xx hardware
Message-ID: <20170531223204.5d1de002@macbox>
In-Reply-To: <CAK3bHNVu9_x492P+KQQHEVe8HOCvnktPaLSyHjRgMN_svQ56+A@mail.gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
        <20170528234738.6726df65@macbox>
        <CAK3bHNW9sM0fZFqYEX-mEhv-Rax82u25KdgjQftGcoY6wV1O0A@mail.gmail.com>
        <CAK3bHNVu9_x492P+KQQHEVe8HOCvnktPaLSyHjRgMN_svQ56+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 31 May 2017 08:30:34 -0400
schrieb Abylay Ospan <aospan@netup.ru>:

Hi Abylay,

> I have ack'ed all patches related to cxd2841er. Please check am i
> missing something ?

Thank you very much for your review and your ACKs, and in general
taking time to look into them! You didn't miss any of the patches :)
Will add your ACKs to the cxd2841er patches in a very likely upcoming V2
of the series.

> I see some good flags (CXD2841ER_NO_WAIT_LOCK and
> CXD2841ER_EARLY_TUNE). I should check it for our boards too :)

Re EARLY_TUNE - I wasn't sure if the order of tuner/demod setup is of
importance on your devices. When picking the IF freq from the tuner
though, we first need to tune and then set up the demod since the demod
queries the tuner about this. If your hardware also works with the
"earlier tune", maybe we should drop this flag/condition and just move
the tune call up.

Re NO_WAIT_LOCK - works fine with or without this. However, when e.g.
using TVH and looking at the stats, the Web UI will freeze if a retune
occurs. Again, not sure if it's absolutely required on your
hardware/software - if not, I suggest to remove the flag together with
the wait lock entirely.

Looking forward for your results and opinions! :-)

Best regards,
Daniel Scheller
