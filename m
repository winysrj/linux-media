Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:34026 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbaI2Rom (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 13:44:42 -0400
Date: Mon, 29 Sep 2014 19:44:30 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/6] some fixes and cleanups for the em28xx-based HVR-930C
Message-ID: <20140929174430.GA18967@linuxtv.org>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sun, Sep 28, 2014 at 11:23:17PM -0300, Mauro Carvalho Chehab wrote:
> This patch series addresses some issues with suspend2ram of devices
> based on DRX-K.
> 
> With this patch series, it is now possible to suspend to ram while
> streaming. At resume, the stream will continue to play.
> 
> While doing that, I added a few other changes:
> 
> - I moved the init code to .init. That is an initial step to fix
>   suspend to disk;
> 
> - There's a fix to an issue that happens at xc5000 removal (sent
>   already as a RFC patch);
> 
> - A dprintk change at his logic to not require both a boot parameter and
>   a dynamic_printk enablement. It also re-adds __func__ to the printks,
>   that got previously removed;
> 
> - It removes the unused mfe_sharing var from the dvb attach logic.
> 
> Mauro Carvalho Chehab (6):
>   [media] em28xx: remove firmware before releasing xc5000 priv state
>   [media] drxk: Fix debug printks
>   [media] em28xx-dvb: remove unused mfe_sharing
>   [media] em28xx-dvb: handle to stop/start streaming at PM
>   [media] em28xx: move board-specific init code
>   [media] drxk: move device init code to .init callback
> 
>  drivers/media/dvb-frontends/drxk_hard.c | 117 ++++++++++++++++----------------
>  drivers/media/tuners/xc5000.c           |   2 +-
>  drivers/media/usb/em28xx/em28xx-dvb.c   |  45 ++++++++----
>  3 files changed, 92 insertions(+), 72 deletions(-)


Disregarding your mails from the "em28xx breaks after hibernate"
that hibernate doesn't work for you, I decided to give these
changes a try on top of today's media_tree.git
(cf3167c -> 3.17.0-rc5-00741-g9a3fbd8), still inside qemu
(can't upgrade/reboot my main machine right now).

Works!  For hibernate, using "echo reboot >/sys/power/disk", so
the host driver cannot interfere with the qemu driver during hibernate.
Qemu causes several USB resets to the device during
hibernate -> resume, but the USB power is not cut.
It works even while running dvbv5-zap and streaming to mplayer.

I tried both suspend-to-ram and hibernate a couple of times,
at least in Qemu it all works.

There are a lot of drxk debug prints now enabled by default,
not sure if that was intentional.


Thanks,
Johannes
