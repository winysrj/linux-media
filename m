Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:32985 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752845AbZCHQnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 12:43:08 -0400
Date: Sun, 8 Mar 2009 12:43:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Brandon Philips <brandon@ifup.org>
cc: Greg KH <gregkh@suse.de>, <laurent.pinchart@skynet.be>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
 is probably using the wrong IRQ."
In-Reply-To: <20090308075521.GG6869@jenkins.ifup.org>
Message-ID: <Pine.LNX.4.44L0.0903081239430.5243-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 7 Mar 2009, Brandon Philips wrote:

> > Have you tried suspending just the two devices plugged into that EHCI 
> > controller instead of suspending the entire system?  That would make it 
> > a lot easier to carry out testing.
> 
> I tried to reproduce with s2ram suspend, echo suspend >
> /sys/bus/usb/devices/.../power/level and /sys/power/pm_test levels but none of
> them reproduced it. So, at this point the only way I can reproduce this is with
> a full S4.

That's a little misleading.  Unless I misunderstood your log, the hang 
occurred _before_ your system entered S4.  In fact, it occurred before 
the memory image was written out to the disk.

> Is there some other method I missed of testing?

How about echo disk >/sys/power/state with various settings in 
/sys/power/disk?

Alan Stern

