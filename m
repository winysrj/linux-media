Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:36169 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaI2Sof (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 14:44:35 -0400
Date: Mon, 29 Sep 2014 20:44:28 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/6] some fixes and cleanups for the em28xx-based HVR-930C
Message-ID: <20140929184428.GA447@linuxtv.org>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
 <20140929174430.GA18967@linuxtv.org>
 <20140929153018.2f701689@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929153018.2f701689@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 29, 2014 at 03:30:18PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 29 Sep 2014 19:44:30 +0200
> Johannes Stezenbach <js@linuxtv.org> escreveu:
> 
> > Disregarding your mails from the "em28xx breaks after hibernate"
> > that hibernate doesn't work for you, I decided to give these
> > changes a try on top of today's media_tree.git
> > (cf3167c -> 3.17.0-rc5-00741-g9a3fbd8), still inside qemu
> > (can't upgrade/reboot my main machine right now).
> 
> Well, I think I was not clear: It doesn't work for me when 
> I power down the USB or the machine after suspended. If I keep
> the device energized, it works ;)

Ah, OK.  I'll try to test with power removed tomorrow.

> > Works!  For hibernate, using "echo reboot >/sys/power/disk", so
> > the host driver cannot interfere with the qemu driver during hibernate.
> > Qemu causes several USB resets to the device during
> > hibernate -> resume, but the USB power is not cut.
> > It works even while running dvbv5-zap and streaming to mplayer.
> 
> Thanks for testing it! it is great to have a separate test for
> the patches.
> 
> Could I add a tested-by tag on those patches?

sure

> > I tried both suspend-to-ram and hibernate a couple of times,
> > at least in Qemu it all works.
> > 
> > There are a lot of drxk debug prints now enabled by default,
> > not sure if that was intentional.
> 
> You're probably probing the device with debug=1, right?

right, forgot I had added this to the kernel command line
in my qemu start script


Thanks,
Johannes
