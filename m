Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:7234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZCKRUk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 13:20:40 -0400
Date: Wed, 11 Mar 2009 10:20:31 -0700
From: Brandon Philips <brandon@ifup.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, laurent.pinchart@skynet.be,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
	is probably using the wrong IRQ."
Message-ID: <20090311172031.GC22789@jenkins.ifup.org>
References: <20090310193809.GA8217@jenkins.ifup.org> <Pine.LNX.4.44L0.0903111125190.2692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903111125190.2692-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11:30 Wed 11 Mar 2009, Alan Stern wrote:
> On Tue, 10 Mar 2009, Brandon Philips wrote:
> > First observation: I can't reproduce this bug with console=ttyS0,115200
> > console=tty0. Everything works great actually. Is writing to the serial
> > port causing just enough delay to hide the bug?
> 
> Maybe it is, maybe it isn't.  There's no way to know at present.
> 
> If you can't reproduce the bug when using a serial console, how did you 
> acquire the system log you posted earlier?  Network console?

Yes, I used netconsole.

> > /sys/power/disk tests
> > ---------------------
> > testproc	# OK
> > test		# Unlink after no-IRQ? ...
> > platform	# Unlink after no-IRQ? ...
> > reboot		# Unlink after no-IRQ? ...
> > shutdown	# Unlink after no-IRQ? ...
> 
> Okay, so "test" is the thing to use.  Although since your system hangs, 
> it doesn't make much difference...
> 
> The next thing to try is to make sure the bug is still present with the 
> lastest development kernel.  That would be 2.6.29-rc7 together with
> 
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-all-2.6.29-rc7.patch
> 
> If it is then we'll have to try some diagnostic patches to find out 
> what's going wrong.

It still locks up with "Unlink after no-IRQ" with -rc7 + greg's patches
and test in /sys/power/disk.

One of the times when I booted up this new Kernel I got some errors out
of ehci_hcd/khubd: http://ifup.org/~philips/467317/khubd.timeout It only
happened on that boot and I haven't seen those ehci_hcd/khubd errors
again since.

Thanks,

	Brandon
