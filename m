Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51040 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752697AbZCKPa4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 11:30:56 -0400
Date: Wed, 11 Mar 2009 11:30:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Brandon Philips <brandon@ifup.org>
cc: Greg KH <gregkh@suse.de>, <laurent.pinchart@skynet.be>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
 is probably using the wrong IRQ."
In-Reply-To: <20090310193809.GA8217@jenkins.ifup.org>
Message-ID: <Pine.LNX.4.44L0.0903111125190.2692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Mar 2009, Brandon Philips wrote:

> First observation: I can't reproduce this bug with console=ttyS0,115200
> console=tty0. Everything works great actually. Is writing to the serial
> port causing just enough delay to hide the bug?

Maybe it is, maybe it isn't.  There's no way to know at present.

If you can't reproduce the bug when using a serial console, how did you 
acquire the system log you posted earlier?  Network console?

> /sys/power/disk tests
> ---------------------
> testproc	# OK
> test		# Unlink after no-IRQ? ...
> platform	# Unlink after no-IRQ? ...
> reboot		# Unlink after no-IRQ? ...
> shutdown	# Unlink after no-IRQ? ...

Okay, so "test" is the thing to use.  Although since your system hangs, 
it doesn't make much difference...

The next thing to try is to make sure the bug is still present with the 
lastest development kernel.  That would be 2.6.29-rc7 together with

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-all-2.6.29-rc7.patch

If it is then we'll have to try some diagnostic patches to find out 
what's going wrong.

Alan Stern

