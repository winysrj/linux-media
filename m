Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:22132 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaAMRuw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 12:50:52 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZC0071TPKR9Q70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jan 2014 12:50:51 -0500 (EST)
Date: Mon, 13 Jan 2014 15:50:37 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/7] Fix remaining issues with em28xx device removal
Message-id: <20140113155037.01e5f9cd@samsung.com>
In-reply-to: <52D422B0.2020104@iki.fi>
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
 <52D422B0.2020104@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 13 Jan 2014 19:30:24 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 13.01.2014 01:00, Mauro Carvalho Chehab wrote:
> > Even after Frank's series, there are several issues with device module
> > removal.
> >
> > This series fix those issues, by use kref to deallocate the common
> > data (struct em28xx *dev).
> >
> > It also fixes a circular deppendency inside em28xx-audio.
> >
> > Mauro Carvalho Chehab (7):
> >    em28xx-audio: fix return code on device disconnect
> >    em28xx-audio: simplify error handling
> >    em28xx: Only deallocate struct em28xx after finishing all extensions
> >    em28xx-audio: disconnect before freeing URBs
> >    em28xx-audio: remove a deplock circular dependency
> >    em28xx: print a message at disconnect
> >    em28xx: Fix usb diconnect logic
> >
> >   drivers/media/usb/em28xx/em28xx-audio.c | 47 ++++++++++++++++++++-------------
> >   drivers/media/usb/em28xx/em28xx-cards.c | 41 +++++++++++++---------------
> >   drivers/media/usb/em28xx/em28xx-dvb.c   |  7 ++++-
> >   drivers/media/usb/em28xx/em28xx-input.c | 10 ++++++-
> >   drivers/media/usb/em28xx/em28xx-video.c | 13 ++++-----
> >   drivers/media/usb/em28xx/em28xx.h       |  9 +++++--
> >   6 files changed, 76 insertions(+), 51 deletions(-)
> >
> 
> 
> 
> Tested-by: Antti Palosaari <crope@iki.fi>
> 
> 
> I tested quite many em28xx devices and it seems to work very well.
> 
> However, there is that (it looks new) error dump coming after device is 
> unplugged.

That's likely because now the lockdep code is able to go one step further
on their tests.

> tammi 13 18:50:56 localhost.localdomain kernel: usb 8-2: USB disconnect, 
> device number 2
> tammi 13 18:50:56 localhost.localdomain kernel: em2884 #0: Disconnecting 
> em2884 #0
> tammi 13 18:50:56 localhost.localdomain kernel: em2884 #0: Disconnecting 
> video extension
> tammi 13 18:50:56 localhost.localdomain kernel: em2884 #0: V4L2 device 
> video0 deregistered
> tammi 13 18:50:56 localhost.localdomain kernel: em2884 #0: Disconnecting 
> audio extension
> tammi 13 18:50:56 localhost.localdomain kernel: em2884 #0: Disconnecting 
> DVB extension
> tammi 13 18:50:56 localhost.localdomain kernel: xc5000 6-0061: 
> destroying instance
> tammi 13 18:50:56 localhost.localdomain kernel: em2884 #0: Disconnecting 
> input extensionINFO: trying to register non-static key.
> tammi 13 18:50:56 localhost.localdomain kernel: the code is fine but 
> needs lockdep annotation.
> tammi 13 18:50:56 localhost.localdomain kernel: turning off the locking 
> correctness validator.

I suspect that the reason is because we're not flushing/canceling the
pending work on em28xx-alsa and em28xx-rc.

I can't reproduce it here, but could you please check if this patch fixes
it?
	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/144f41066bdab280869e309f76f7a42ad5b2be72

> tammi 13 18:50:56 localhost.localdomain kernel: CPU: 3 PID: 34 Comm: 
> khubd Tainted: G           O 3.13.0-rc1+ #79
> tammi 13 18:50:56 localhost.localdomain kernel: Hardware name: System 
> manufacturer System Product Name/M5A78L-M/USB3, BIOS 1801    11/12/2013
> tammi 13 18:50:56 localhost.localdomain kernel:  ffff88030da1a8a0 
> ffff88030dbb99a8 ffffffff816b8da9 0000000000000002
> tammi 13 18:50:56 localhost.localdomain kernel:  ffff88030dbb99b8 
> ffffffff816b285c ffff88030dbb9a28 ffffffff810bb9ae
> tammi 13 18:50:56 localhost.localdomain kernel:  ffffffff810b9bc9 
> 00000007810b648d ffff88030da1a8a0 ffffffff810cbe27
> tammi 13 18:50:56 localhost.localdomain kernel: Call Trace:
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff816b8da9>] 
> dump_stack+0x4d/0x66
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff816b285c>] 
> register_lock_class.part.40+0x38/0x3c
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff810bb9ae>] 
> __lock_acquire+0x9fe/0xc40
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff810b9bc9>] ? 
> mark_held_locks+0xb9/0x140
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff810cbe27>] ? 
> vprintk_emit+0x1d7/0x5e0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff810bbca0>] 
> lock_acquire+0xb0/0x150
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81087f75>] ? 
> flush_work+0x5/0x60
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81087fa6>] 
> flush_work+0x36/0x60
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81087f75>] ? 
> flush_work+0x5/0x60
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff8108858a>] 
> __cancel_work_timer+0x8a/0x120
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81088653>] 
> cancel_delayed_work_sync+0x13/0x20
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffffa0839ba8>] 
> em28xx_ir_fini+0x48/0xc0 [em28xx_rc]
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffffa07a4b8e>] 
> em28xx_close_extension+0x3e/0x70 [em28xx]
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffffa07a6600>] 
> em28xx_usb_disconnect+0x60/0x80 [em28xx]
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814b7c87>] 
> usb_unbind_interface+0x67/0x1d0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814378ff>] 
> __device_release_driver+0x7f/0xf0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81437995>] 
> device_release_driver+0x25/0x40
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814371fc>] 
> bus_remove_device+0x11c/0x1a0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81433c26>] 
> device_del+0x136/0x1d0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814b5660>] 
> usb_disable_device+0xb0/0x290
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814aa5f5>] 
> usb_disconnect+0xb5/0x1d0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814acfe6>] 
> hub_port_connect_change+0xd6/0xad0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814b40a4>] ? 
> usb_control_msg+0xd4/0x110
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814adcf3>] 
> hub_events+0x313/0x9b0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814ae3c5>] 
> hub_thread+0x35/0x190
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff810b12d0>] ? 
> abort_exclusive_wait+0xb0/0xb0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff814ae390>] ? 
> hub_events+0x9b0/0x9b0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff8109044f>] 
> kthread+0xff/0x120
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81090350>] ? 
> kthread_create_on_node+0x250/0x250
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff816ca67c>] 
> ret_from_fork+0x7c/0xb0
> tammi 13 18:50:56 localhost.localdomain kernel:  [<ffffffff81090350>] ? 
> kthread_create_on_node+0x250/0x250
> tammi 13 18:50:56 localhost.localdomain kernel: em2884 #0: Freeing device
> 
> regards
> Antti
> 
> 
> 


-- 

Cheers,
Mauro
