Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53942 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757746AbZBBV7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 16:59:44 -0500
Date: Mon, 2 Feb 2009 16:59:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: kilgota@banach.math.auburn.edu,
	Jean-Francois Moine <moinejf@free.fr>,
	<linux-media@vger.kernel.org>
Subject: Re: Bug in gspca USB webcam driver
In-Reply-To: <200902022135.00908.linux@baker-net.org.uk>
Message-ID: <Pine.LNX.4.44L0.0902021651460.13005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2009, Adam Baker wrote:

> Thanks for confirming that Alan. I'd been looking at this too and suspected 
> this was the case but as it wouldn't fail on my uniprocessor machine I 
> couldn't prove it. (Theodore, if you can generate the log we discussed of 
> this failing it might still be helpful in tracking down the underlying 
> problem.)

Note that I'm looking at the gspca.c routine from 2.6.29-rc3.  If 
changes have been made since that version, I don't know what they are.

> > To summarize: Unplugging the camera while it is in use by a program
> > causes an oops (particularly on an SMP machine).
> >
> > The problem is that gspca_stream_off() calls destroy_urbs(), which in
> > turn calls usb_buffer_free() -- but this happens too late, after
> > gspca_disconnect() has returned.  By that time gspca_dev->dev is a
> > stale pointer, so it shouldn't be passed to usb_buffer_free().
> >
> 
> By my reading it should be OK for gspca_disconnect to have returned as long as 
> video_unregister_device waits for the last close to complete before calling 
> gspca_release. I know that there were some patches a while back that 
> attempted to ensure that was the case so I suspect there is still a hole 
> there.

gspca_disconnect() should _not_ wait for the last close.  It should do 
what it needs to do and return as quickly as possible.  This means 
there must be two paths for releasing USB resources: release upon last 
close and release upon disconnect.

I suppose the easiest way to work around the problem would be to take a
reference to the usb_device structure (usb_get_dev()) for each open and
to drop the reference when the stream is closed.  But it would be
preferable to do things the way I described before: Make disconnect put
an open stream into an error state and release all the USB resources
immediately.

Alan Stern

