Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43132 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752166AbZBBVPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 16:15:03 -0500
Date: Mon, 2 Feb 2009 16:15:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: kilgota@banach.math.auburn.edu
cc: Jean-Francois Moine <moinejf@free.fr>,
	<linux-media@vger.kernel.org>
Subject: Bug in gspca USB webcam driver
In-Reply-To: <alpine.LNX.2.00.0902021207550.32604@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.44L0.0902021558280.10089-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2009 kilgota@banach.math.auburn.edu wrote:

> The attached file is an extract from dmesg from the Pentium4 Dual Core
> machine. One can see that the camera has been attached, and then an svv
> session has been run. The kernel is the "stock" Slackware 2.6.27.7 kernel
> (*). We have a situation, again, in which svv (**) can not be exited. We 
> have an oops in the log, and we have a filesystem check on reboot, which 
> is going on as I write this.

Well, the problem is clear enough, and it is in the gspca.c module, not 
your sq905-3 driver.  I'm not sure what the best way is to fix it, so 
I'm CC'ing the people responsible for the gspca driver.

To summarize: Unplugging the camera while it is in use by a program 
causes an oops (particularly on an SMP machine).

The problem is that gspca_stream_off() calls destroy_urbs(), which in
turn calls usb_buffer_free() -- but this happens too late, after
gspca_disconnect() has returned.  By that time gspca_dev->dev is a
stale pointer, so it shouldn't be passed to usb_buffer_free().

What should happen is that as part of disconnect processing, the 
existing stream(s) should be put in an error state and destroy_urbs() 
should be called immediately.  Then when gspca_stream_off() calls 
destroy_urbs() again there would be no more work left to do.

Alan Stern

