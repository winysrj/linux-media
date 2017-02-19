Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35377 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdBSN1c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 08:27:32 -0500
Received: by mail-wr0-f194.google.com with SMTP id q39so9452754wrb.2
        for <linux-media@vger.kernel.org>; Sun, 19 Feb 2017 05:27:32 -0800 (PST)
Date: Sun, 19 Feb 2017 14:27:25 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Martin Herrman <martin.herrman@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Cine CT V6.1 code change request
Message-ID: <20170219142725.47991d64@macbox>
In-Reply-To: <CADR1r6gvOXYpz2Qa5HnuSYmyz9pv6e9-tbRQ6PgtK8pqWWHo6A@mail.gmail.com>
References: <CADR1r6hbvri8qMYP2S7Pe9sxGsjh5iE2zWTUybYwcoRsbpgXFA@mail.gmail.com>
        <572edbb2-a542-01a7-9ba0-20cee18a3217@xs4all.nl>
        <CADR1r6gvOXYpz2Qa5HnuSYmyz9pv6e9-tbRQ6PgtK8pqWWHo6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wed, 15 Feb 2017 20:20:58 +0100 Martin Herrman
<martin.herrman@gmail.com>:

Hi Martin,

> The ddbridge and cxd2099 are in the latest media_build, but the
> stv0367dd and tda18212dd are missing (however, the stv0367 and
> tda18212 are available). How hard is it to add these two?

For someone who has some knowledge on the stv0367 demods, it's probably
not very hard.

While I don't have that knowledge, I've started tackling
the "in-kernel" stv0367 module to work as a replacement for DD's
stv0367dd anyway, and while I didn't get very far yet, this is what I
found out so far:

- stv0367dd always provides multiple delivery systems (DVB-C, DVB-T)
  when attached, where stv0367 needs multiple frontends for each
  delivery systems, e.g. you need to attach the -T and -C
  frontends separately. Basically, this is also the case in the
  stv0367dd, but it has some sort of "wrapper" ontop which does the
  QAM/OFDM operation mode switch transparently.
- When attaching only one of the two -T/-C code paths, there's still
  something more that needs to be done. With the QAM path, I got the
  demod to somewhat do some work (it reported signal statistics when
  tuned to a frequency) but didn't properly send the transport stream
  to the bridge.
- stv0367dd runs at 58MHz IC speed for the QAM mode, but this is rather
  easy to add since (what I could find out so far) it just requires
  different values poked into the PLLxDIV regs.
- The i2c_gate_ctrl() in stv0367 must not be called from inside the
  demod driver (thinking of a config flag to toggle this) since
  ddbridge remaps the function pointers to a mutex_lock'ed variant,
  which in turn will cause a deadlock when the demod driver triggers
  the i2c_gate itself.

The biggest problem at the moment is 2., e.g. get the transport to the
bridge working. 1. should be fairly easy to do, 3. and 4. are done. See
[1] for my attempt on this. But generally speaking, the stv0367 driver
should work even with DD cards with a few additions.

The TDA18212 "in-tree" tuner frontend works perfectly with the STV and
also the CXD28xx-based tuners. The work on this was done in around 2013
or so by Antti Palosaari (see [2]), and it worked out so nicely when I
first started tackling things I never cared to pick up the
tda18212DD :-)

Best regards,
Daniel Scheller

[1]
https://github.com/herrnst/dddvb-linux-kernel/compare/attic/old-0_9_23-0_9_28-mediatree/master-ddbridge-cttesting-cxd...attic/old-0_9_23-0_9_28-mediatree/master-ddbridge-cttesting-stv
[2]
https://github.com/herrnst/dddvb-linux-kernel/commit/905c999f69e58e2c54be24bd7ec6c86ec2ef1e65
