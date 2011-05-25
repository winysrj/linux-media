Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42196 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab1EYFgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 01:36:36 -0400
Received: by bwz15 with SMTP id 15so6232967bwz.19
        for <linux-media@vger.kernel.org>; Tue, 24 May 2011 22:36:35 -0700 (PDT)
Date: Wed, 25 May 2011 16:40:05 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] xc5000, fix fw upload crash
Message-ID: <20110525164005.0a8dda2c@glory.local>
In-Reply-To: <4DD6E9A5.10406@redhat.com>
References: <20110517142352.7d311ee8@glory.local>
	<BANLkTimk-WrKKqW4b_1G99euY6vjcoQxeQ@mail.gmail.com>
	<20110520144615.2345c2d6@glory.local>
	<BANLkTi=otyZxEof89KbDbLXCLz4XsT=5ww@mail.gmail.com>
	<4DD6E9A5.10406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 20 May 2011 19:22:29 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 20-05-2011 10:04, Devin Heitmueller escreveu:
> > On Friday, May 20, 2011, Dmitri Belimov <d.belimov@gmail.com> wrote:
> >> Hi Devin
> >>
> >> snip
> >>
> >>> NACK!
> >>>
> >>> I don't think this patch is correct.  Concurrency problems are
> >>> expected to be handled in the upper layers, as there are usually
> >>> much more significant problems than just this case.  For example,
> >>> if this is a race between V4L2 and DVB, it is the responsibility
> >>> of bridge driver to provide proper locking.
> >>>
> 
> ...
> 
> >>
> >> I see two different way add mutex to function where firmware is
> >> loaded or to xc5000_set_analog_params
> >>
> >> Both of this is working I already test it.
> >>
> >> What you think about it??
> 
> ...
> 
> >> [  110.010686]  [<f81cb6d8>] ? set_mode_freq+0xe4/0xff [tuner]
> >> [  110.010689]  [<f81cb8d4>] ? tuner_s_std+0x26/0x5aa [tuner]
> >> [  110.010692]  [<f81cb8ae>] ? tuner_s_std+0x0/0x5aa [tuner]
> 
> Hmm... this is probably caused by the BKL removal patches. 
> 
> Basically, tuner_s_std is being called without holding dev->lock. The
> fix is simple, but requires some care: we need either to convert
> saa7134 to the v4l2 core support (probably not an easy task) or to
> review all places where dev->lock should be used, e. g. at (almost
> all) ioctls, and at the other file ops (open, close, mmap, etc). This
> driver is complex, due to the mpeg optional module used on some
> devices. So, maybe the in-core locking schema is not the proper way
> to fix it.
> 
> Cheers,
> Mauro.

Right now we can add mutex to xc5000 for solve crash problem and add FIXME string for remove it later
and TODO for main core.

What you think?

With my best regards, Dmitry.


