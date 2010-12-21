Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:54417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0LUSbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 13:31:36 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBLIVZff015230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 21 Dec 2010 13:31:36 -0500
Date: Tue, 21 Dec 2010 13:31:35 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] IR fixups for 2.6.37
Message-ID: <20101221183135.GC29880@redhat.com>
References: <20101216190302.GA25148@redhat.com>
 <4D10ADB5.80405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D10ADB5.80405@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, Dec 21, 2010 at 11:37:57AM -0200, Mauro Carvalho Chehab wrote:
> Em 16-12-2010 17:03, Jarod Wilson escreveu:
> > Hey Mauro,
> > 
> > As previously discussed, here's a handful of IR patches I'd like to see
> > make it into 2.6.37 still, as they fix a number of issues with the
> > mceusb, streamzap, nuvoton and lirc_dev drivers.
> > 
> > The last three mceusb patches are not yet in the v4l/dvb tree, but I've
> > just posted them.
> > 
> > The following changes since commit b0c3844d8af6b9f3f18f31e1b0502fbefa2166be:
> > 
> >   Linux 2.6.37-rc6 (2010-12-15 17:24:48 -0800)
> > 
> > are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git for-2.6.37
> > 
> > Dan Carpenter (2):
> >       [media] lirc_dev: stray unlock in lirc_dev_fop_poll()
> >       [media] lirc_dev: fixes in lirc_dev_fop_read()
> > 
> > Jarod Wilson (10):
> >       [media] mceusb: add support for Conexant Hybrid TV RDU253S
> >       [media] nuvoton-cir: improve buffer parsing responsiveness
> >       [media] mceusb: fix up reporting of trailing space
> >       [media] mceusb: buffer parsing fixups for 1st-gen device
> >       [media] IR: add tv power scancode to rc6 mce keymap
> >       [media] mceusb: fix keybouce issue after parser simplification
> >       [media] streamzap: merge timeout space with trailing space
> >       mceusb: add another Fintek device ID
> >       mceusb: fix inverted mask inversion logic
> >       mceusb: set a default rx timeout
> > 
> > Paul Bender (1):
> >       rc: fix sysfs entry for mceusb and streamzap
> > 
> >  drivers/media/IR/keymaps/rc-rc6-mce.c |   21 ++--
> >  drivers/media/IR/lirc_dev.c           |   29 +++---
> >  drivers/media/IR/mceusb.c             |  174 ++++++++++++++++++++------------
> >  drivers/media/IR/nuvoton-cir.c        |   10 ++-
> >  drivers/media/IR/streamzap.c          |   21 +++--
> >  5 files changed, 156 insertions(+), 99 deletions(-)
> > 
> 
> Hi Jarod,
> 
> I've pulled from your tree and added them at the master branch of my -next tree, at:
> 	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git
> 
> As we've discussed on #lirc channel, I solved the conflicts at mceusb and streamzap
> by just doing a diff between the merged tree and:
> 	ssh://linuxtv.org/git/jarod/linux-2.6-ir.git for-2.6.38
> 
> The merge patch had a weird diff, as it just showed the mceusb.c driver as a new one,
> so I suspect that it might have something wrong at the conflict resolution.

Hrm, yeah, diff is a bit odd, but the resulting mceusb.c looks correct.

> Also, there's one small error generated with allyesconfig:
> 
> drivers/media/rc/streamzap.c: In function ‘streamzap_probe’:
> drivers/media/rc/streamzap.c:460:2: warning: statement with no effect

Hm. That's pointing at the line that loads the rc5-sz decoder. With an
allyesconfig, that does become a no-op, since the decoder would already be
built in, so I think that should be fine. At least, it should be no
different than any of the other decoders, except for where they're loaded
from.

> Could you please take a look on both things, to double check if everything is ok?

Looks good to me.


-- 
Jarod Wilson
jarod@redhat.com

