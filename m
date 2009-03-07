Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2656 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751792AbZCGRkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 12:40:55 -0500
Date: Sat, 7 Mar 2009 12:40:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Greg KH <gregkh@suse.de>
cc: Brandon Philips <brandon@ifup.org>, <laurent.pinchart@skynet.be>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
 is probably using the wrong IRQ."
In-Reply-To: <20090307052611.GA15139@suse.de>
Message-ID: <Pine.LNX.4.44L0.0903071237300.6084-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Mar 2009, Greg KH wrote:

> On Fri, Mar 06, 2009 at 11:11:22AM -0800, Brandon Philips wrote:
> > Hello-
> > 
> > When an UVC device is open and a S4 is attempted the thaw hangs (see the
> > stack below). I don't see what the UVC driver is doing wrong to cause
> > this to happen though.
> 
> I don't think this is a uvc driver issue, it looks like all you are
> trying to do is a usb control message when things hang.

Agreed.

> But the problem is the khubd is asleep, from your log file:
> 
> khubd         D 0000000000000000     0   255      2
>  ffff880037509d80 0000000000000046 ffff88007864ba80 ffffffff8088fcf8
>  ffffffff80816f00 ffffffff80816f00 ffff8800375b0380 ffff8800375b06f8
>  0000000080816f00 ffff88007bb9c040 ffff8800375b0380 ffff8800375b06f8
> Call Trace:
>  [<ffffffff802253a5>] ? default_spin_lock_flags+0x17/0x1a
>  [<ffffffff8025e7a9>] refrigerator+0x170/0x1cf
>  [<ffffffffa01187ab>] hub_thread+0x1370/0x13bd [usbcore]
>  [<ffffffff8020a7c2>] ? __switch_to+0xd4/0x4b3
>  [<ffffffff80258ca4>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffffa011743b>] ? hub_thread+0x0/0x13bd [usbcore]
>  [<ffffffff8025890b>] kthread+0x49/0x76
>  [<ffffffff8020d69a>] child_rip+0xa/0x20
>  [<ffffffff802588c2>] ? kthread+0x0/0x76
>  [<ffffffff8020d690>] ? child_rip+0x0/0x20
> 
> udevd is also stuck in the refrigerator, which seems wierd as well.
> a.out is also stuck, is that your test program?
> 
> It looks like things die right after this message:
> 	ehci_hcd 0000:00:1d.7: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
> 
> Alan, what causes this at resume time?

This isn't really resume time.  It's at "thaw" time, which is part of 
hibernation.  After the memory snapshot is created, the system thaws 
all the suspended devices so that the snapshot can be written to disk.  
That's when the hang occurred.

And that's why all those tasks are still in the refrigerator; they
remain there until the end of the resume from hibernation.

Alan Stern

