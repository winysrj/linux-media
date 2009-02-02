Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:13230
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598AbZBBVfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 16:35:04 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bug in gspca USB webcam driver
Date: Mon, 2 Feb 2009 21:35:00 +0000
Cc: kilgota@banach.math.auburn.edu,
	"Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <Pine.LNX.4.44L0.0902021558280.10089-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902021558280.10089-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902022135.00908.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 02 February 2009, Alan Stern wrote:
> On Mon, 2 Feb 2009 kilgota@banach.math.auburn.edu wrote:
> > The attached file is an extract from dmesg from the Pentium4 Dual Core
> > machine. One can see that the camera has been attached, and then an svv
> > session has been run. The kernel is the "stock" Slackware 2.6.27.7 kernel
> > (*). We have a situation, again, in which svv (**) can not be exited. We
> > have an oops in the log, and we have a filesystem check on reboot, which
> > is going on as I write this.
>
> Well, the problem is clear enough, and it is in the gspca.c module, not
> your sq905-3 driver.  I'm not sure what the best way is to fix it, so
> I'm CC'ing the people responsible for the gspca driver.
>
Thanks for confirming that Alan. I'd been looking at this too and suspected 
this was the case but as it wouldn't fail on my uniprocessor machine I 
couldn't prove it. (Theodore, if you can generate the log we discussed of 
this failing it might still be helpful in tracking down the underlying 
problem.)

> To summarize: Unplugging the camera while it is in use by a program
> causes an oops (particularly on an SMP machine).
>
> The problem is that gspca_stream_off() calls destroy_urbs(), which in
> turn calls usb_buffer_free() -- but this happens too late, after
> gspca_disconnect() has returned.  By that time gspca_dev->dev is a
> stale pointer, so it shouldn't be passed to usb_buffer_free().
>

By my reading it should be OK for gspca_disconnect to have returned as long as 
video_unregister_device waits for the last close to complete before calling 
gspca_release. I know that there were some patches a while back that 
attempted to ensure that was the case so I suspect there is still a hole 
there.

> What should happen is that as part of disconnect processing, the
> existing stream(s) should be put in an error state and destroy_urbs()
> should be called immediately.  Then when gspca_stream_off() calls
> destroy_urbs() again there would be no more work left to do.
>
> Alan Stern
>

Adam Baker

