Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:5108 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZCJTiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 15:38:22 -0400
Date: Tue, 10 Mar 2009 12:38:10 -0700
From: Brandon Philips <brandon@ifup.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, laurent.pinchart@skynet.be,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
	is probably using the wrong IRQ."
Message-ID: <20090310193809.GA8217@jenkins.ifup.org>
References: <20090308075521.GG6869@jenkins.ifup.org> <Pine.LNX.4.44L0.0903081239430.5243-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903081239430.5243-100000@netrider.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12:43 Sun 08 Mar 2009, Alan Stern wrote:
> On Sat, 7 Mar 2009, Brandon Philips wrote:
> > > Have you tried suspending just the two devices plugged into that EHCI 
> > > controller instead of suspending the entire system?  That would make it 
> > > a lot easier to carry out testing.
> > 
> > I tried to reproduce with s2ram suspend, echo suspend >
> > /sys/bus/usb/devices/.../power/level and /sys/power/pm_test levels but none of
> > them reproduced it. So, at this point the only way I can reproduce this is with
> > a full S4.
> 
> That's a little misleading.

Sorry, what I meant by "full" was `echo disk > /sys/power/state` with
none in /sys/power/pm_test

> Unless I misunderstood your log, the hang occurred _before_ your
> system entered S4.  In fact, it occurred before the memory image was
> written out to the disk.

Yes, this is correct. It freezes before the image is written.

> > Is there some other method I missed of testing?
> 
> How about echo disk >/sys/power/state with various settings in 
> /sys/power/disk?

First observation: I can't reproduce this bug with console=ttyS0,115200
console=tty0. Everything works great actually. Is writing to the serial
port causing just enough delay to hide the bug?

/sys/power/disk tests
---------------------
testproc	# OK
test		# Unlink after no-IRQ? ...
platform	# Unlink after no-IRQ? ...
reboot		# Unlink after no-IRQ? ...
shutdown	# Unlink after no-IRQ? ...

Cheers,

	Brandon
