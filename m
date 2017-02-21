Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34382 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754059AbdBUTNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 14:13:20 -0500
Received: by mail-oi0-f43.google.com with SMTP id 65so9291403oig.1
        for <linux-media@vger.kernel.org>; Tue, 21 Feb 2017 11:13:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170219142725.47991d64@macbox>
References: <CADR1r6hbvri8qMYP2S7Pe9sxGsjh5iE2zWTUybYwcoRsbpgXFA@mail.gmail.com>
 <572edbb2-a542-01a7-9ba0-20cee18a3217@xs4all.nl> <CADR1r6gvOXYpz2Qa5HnuSYmyz9pv6e9-tbRQ6PgtK8pqWWHo6A@mail.gmail.com>
 <20170219142725.47991d64@macbox>
From: Martin Herrman <martin.herrman@gmail.com>
Date: Tue, 21 Feb 2017 20:13:18 +0100
Message-ID: <CADR1r6jOE3AECzFNjXtr0jVSJyMaLCM=L=QYyd+ZH6Hw-CYoaw@mail.gmail.com>
Subject: Re: Cine CT V6.1 code change request
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-02-19 14:27 GMT+01:00 Daniel Scheller <d.scheller.oss@gmail.com>:
>
> Hi Martin,
>
> For someone who has some knowledge on the stv0367 demods, it's probably
> not very hard.
>
> While I don't have that knowledge, I've started tackling
> the "in-kernel" stv0367 module to work as a replacement for DD's
> stv0367dd anyway, and while I didn't get very far yet, this is what I
> found out so far:
>
> - stv0367dd always provides multiple delivery systems (DVB-C, DVB-T)
>   when attached, where stv0367 needs multiple frontends for each
>   delivery systems, e.g. you need to attach the -T and -C
>   frontends separately. Basically, this is also the case in the
>   stv0367dd, but it has some sort of "wrapper" ontop which does the
>   QAM/OFDM operation mode switch transparently.
> - When attaching only one of the two -T/-C code paths, there's still
>   something more that needs to be done. With the QAM path, I got the
>   demod to somewhat do some work (it reported signal statistics when
>   tuned to a frequency) but didn't properly send the transport stream
>   to the bridge.
> - stv0367dd runs at 58MHz IC speed for the QAM mode, but this is rather
>   easy to add since (what I could find out so far) it just requires
>   different values poked into the PLLxDIV regs.
> - The i2c_gate_ctrl() in stv0367 must not be called from inside the
>   demod driver (thinking of a config flag to toggle this) since
>   ddbridge remaps the function pointers to a mutex_lock'ed variant,
>   which in turn will cause a deadlock when the demod driver triggers
>   the i2c_gate itself.
>
> The biggest problem at the moment is 2., e.g. get the transport to the
> bridge working. 1. should be fairly easy to do, 3. and 4. are done. See
> [1] for my attempt on this. But generally speaking, the stv0367 driver
> should work even with DD cards with a few additions.
>
> The TDA18212 "in-tree" tuner frontend works perfectly with the STV and
> also the CXD28xx-based tuners. The work on this was done in around 2013
> or so by Antti Palosaari (see [2]), and it worked out so nicely when I
> first started tackling things I never cared to pick up the
> tda18212DD :-)
>
> Best regards,
> Daniel Scheller
>
> [1]
> https://github.com/herrnst/dddvb-linux-kernel/compare/attic/old-0_9_23-0_9_28-mediatree/master-ddbridge-cttesting-cxd...attic/old-0_9_23-0_9_28-mediatree/master-ddbridge-cttesting-stv
> [2]
> https://github.com/herrnst/dddvb-linux-kernel/commit/905c999f69e58e2c54be24bd7ec6c86ec2ef1e65

Hi Daniel,

Thanks for starting this investigation! If I'm understanding
correctly, there is some work to do, but it can be done and is not a
huge amount of work. (But it is more than just moving something from
the old repo and fixing some errors/warnings.)

I'm not familiar with the linux-media way of organizing the work, or
how priorities are set (on the backlog?). What should be the next step
and what can I do to have this feature/enhancement picked up? I'm not
a developer, but I own the hardware and thus I am able to test any new
code. If there might anything else I can do, please let me know.

Thanks,

Martin
