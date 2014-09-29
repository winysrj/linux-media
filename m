Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38435 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaI2SaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 14:30:24 -0400
Date: Mon, 29 Sep 2014 15:30:18 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/6] some fixes and cleanups for the em28xx-based
 HVR-930C
Message-ID: <20140929153018.2f701689@recife.lan>
In-Reply-To: <20140929174430.GA18967@linuxtv.org>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
	<20140929174430.GA18967@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Sep 2014 19:44:30 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> Hi Mauro,
> 
> On Sun, Sep 28, 2014 at 11:23:17PM -0300, Mauro Carvalho Chehab wrote:
> > This patch series addresses some issues with suspend2ram of devices
> > based on DRX-K.
> > 
> > With this patch series, it is now possible to suspend to ram while
> > streaming. At resume, the stream will continue to play.
> > 
> > While doing that, I added a few other changes:
> > 
> > - I moved the init code to .init. That is an initial step to fix
> >   suspend to disk;
> > 
> > - There's a fix to an issue that happens at xc5000 removal (sent
> >   already as a RFC patch);
> > 
> > - A dprintk change at his logic to not require both a boot parameter and
> >   a dynamic_printk enablement. It also re-adds __func__ to the printks,
> >   that got previously removed;
> > 
> > - It removes the unused mfe_sharing var from the dvb attach logic.
> > 
> > Mauro Carvalho Chehab (6):
> >   [media] em28xx: remove firmware before releasing xc5000 priv state
> >   [media] drxk: Fix debug printks
> >   [media] em28xx-dvb: remove unused mfe_sharing
> >   [media] em28xx-dvb: handle to stop/start streaming at PM
> >   [media] em28xx: move board-specific init code
> >   [media] drxk: move device init code to .init callback
> > 
> >  drivers/media/dvb-frontends/drxk_hard.c | 117 ++++++++++++++++----------------
> >  drivers/media/tuners/xc5000.c           |   2 +-
> >  drivers/media/usb/em28xx/em28xx-dvb.c   |  45 ++++++++----
> >  3 files changed, 92 insertions(+), 72 deletions(-)
> 
> 
> Disregarding your mails from the "em28xx breaks after hibernate"
> that hibernate doesn't work for you, I decided to give these
> changes a try on top of today's media_tree.git
> (cf3167c -> 3.17.0-rc5-00741-g9a3fbd8), still inside qemu
> (can't upgrade/reboot my main machine right now).

Well, I think I was not clear: It doesn't work for me when 
I power down the USB or the machine after suspended. If I keep
the device energized, it works ;)

> Works!  For hibernate, using "echo reboot >/sys/power/disk", so
> the host driver cannot interfere with the qemu driver during hibernate.
> Qemu causes several USB resets to the device during
> hibernate -> resume, but the USB power is not cut.
> It works even while running dvbv5-zap and streaming to mplayer.

Thanks for testing it! it is great to have a separate test for
the patches.

Could I add a tested-by tag on those patches?

> I tried both suspend-to-ram and hibernate a couple of times,
> at least in Qemu it all works.
> 
> There are a lot of drxk debug prints now enabled by default,
> not sure if that was intentional.

You're probably probing the device with debug=1, right?

Before the patches, debug=1 were not working well, because:

- it would require to also manually enable the debug lines via
  dynamic_printk sysfs nodes;

- the called function where not displayed. Weveral printks there
  are just dprintk(1, "\n"), used as a way to trace the drxk
  driver. With the old way, this were just printing:
	  drxk: <empty line>

We should likely do some cleanup in some future, removing those
empty printks, as function trace can easily be done via perf, 
and to remove the debug level, using just dynamic_printk.

Regards,
Mauro
