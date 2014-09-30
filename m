Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:48968 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbaI3HiT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 03:38:19 -0400
Date: Tue, 30 Sep 2014 09:38:10 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/6] some fixes and cleanups for the em28xx-based HVR-930C
Message-ID: <20140930073810.GA9128@linuxtv.org>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
 <20140929174430.GA18967@linuxtv.org>
 <20140929153018.2f701689@recife.lan>
 <20140929184428.GA447@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929184428.GA447@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 29, 2014 at 08:44:28PM +0200, Johannes Stezenbach wrote:
> On Mon, Sep 29, 2014 at 03:30:18PM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 29 Sep 2014 19:44:30 +0200
> > Johannes Stezenbach <js@linuxtv.org> escreveu:
> > 
> > > Disregarding your mails from the "em28xx breaks after hibernate"
> > > that hibernate doesn't work for you, I decided to give these
> > > changes a try on top of today's media_tree.git
> > > (cf3167c -> 3.17.0-rc5-00741-g9a3fbd8), still inside qemu
> > > (can't upgrade/reboot my main machine right now).
> > 
> > Well, I think I was not clear: It doesn't work for me when 
> > I power down the USB or the machine after suspended. If I keep
> > the device energized, it works ;)
> 
> Ah, OK.  I'll try to test with power removed tomorrow.

I test again in qemu, but this time rmmod and blacklist em28xx
on the host, and unplug HVR-930C during hibernate.  As you
said, it breaks.  Log fter resume:

[   83.308267] usb 1-1: reset high-speed USB device number 2 using ehci-pci
[   83.598182] em2884 #0: Resuming extensions
[   83.599187] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
[   83.604115] xc5000: I2C read failed
[   83.607091] xc5000: I2C write failed (len=3)
[   83.607985] xc5000: firmware upload failed...
[   83.608766]  - too many retries. Giving up
[   83.609553] em2884 #0: fe0 resume -22
[   83.615533] PM: restore of devices complete after 937.567 msecs
[   83.617278] PM: Image restored successfully.
[   83.618262] PM: Basic memory bitmaps freed
[   83.619097] Restarting tasks ... done.
[   83.622320] xc5000: I2C read failed
[   83.623197] xc5000: I2C write failed (len=3)
[   83.623198] xc5000: firmware upload failed...
[   83.623198]  - too many retries. Giving up
[   83.624071] drxk: i2c read error at addr 0x29
[   83.624072] drxk: Error -6 on mpegts_stop
[   83.624073] drxk: Error -6 on start
[   84.621531] drxk: i2c read error at addr 0x29
[   84.623426] drxk: Error -6 on get_dvbt_lock_status
[   84.625477] drxk: Error -6 on get_lock_status


Johannes
