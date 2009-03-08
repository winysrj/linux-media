Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:32052 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZCHHzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 03:55:54 -0400
Date: Sat, 7 Mar 2009 23:55:21 -0800
From: Brandon Philips <brandon@ifup.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, laurent.pinchart@skynet.be,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
	is probably using the wrong IRQ."
Message-ID: <20090308075521.GG6869@jenkins.ifup.org>
References: <20090307084225.GF6869@jenkins.ifup.org> <Pine.LNX.4.44L0.0903071230190.6084-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903071230190.6084-100000@netrider.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12:37 Sat 07 Mar 2009, Alan Stern wrote:
> On Sat, 7 Mar 2009, Brandon Philips wrote:
> > On 21:26 Fri 06 Mar 2009, Greg KH wrote:
> > > On Fri, Mar 06, 2009 at 11:11:22AM -0800, Brandon Philips wrote:
> > > > When an UVC device is open and a S4 is attempted the thaw hangs (see the
> > > > stack below). I don't see what the UVC driver is doing wrong to cause
> > > > this to happen though.
> > > 
> > > I don't think this is a uvc driver issue, it looks like all you are
> > > trying to do is a usb control message when things hang.
> > 
> > Indeed. When I was poking at this I tried to supress the control message coming
> > out of the uvcvideo driver after the suspend was issued to see what would
> > happen and the control messages after the resume locked up instead. Eh.
> 
> Have you tried suspending just the two devices plugged into that EHCI 
> controller instead of suspending the entire system?  That would make it 
> a lot easier to carry out testing.

I tried to reproduce with s2ram suspend, echo suspend >
/sys/bus/usb/devices/.../power/level and /sys/power/pm_test levels but none of
them reproduced it. So, at this point the only way I can reproduce this is with
a full S4.

Is there some other method I missed of testing?

Thanks,

	Brandon
