Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:5765
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956AbZBBX2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 18:28:49 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bug in gspca USB webcam driver
Date: Mon, 2 Feb 2009 23:28:44 +0000
Cc: kilgota@banach.math.auburn.edu,
	"Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <Pine.LNX.4.44L0.0902021651460.13005-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902021651460.13005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902022328.44386.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 02 February 2009, Alan Stern wrote:
> On Mon, 2 Feb 2009, Adam Baker wrote:
<snip>
> > > To summarize: Unplugging the camera while it is in use by a program
> > > causes an oops (particularly on an SMP machine).
> > >
> > > The problem is that gspca_stream_off() calls destroy_urbs(), which in
> > > turn calls usb_buffer_free() -- but this happens too late, after
> > > gspca_disconnect() has returned.  By that time gspca_dev->dev is a
> > > stale pointer, so it shouldn't be passed to usb_buffer_free().
> >
> > By my reading it should be OK for gspca_disconnect to have returned as
> > long as video_unregister_device waits for the last close to complete
> > before calling gspca_release. I know that there were some patches a while
> > back that attempted to ensure that was the case so I suspect there is
> > still a hole there.
>
> gspca_disconnect() should _not_ wait for the last close.  It should do
> what it needs to do and return as quickly as possible.  This means
> there must be two paths for releasing USB resources: release upon last
> close and release upon disconnect.
>

I was being slightly imprecise in saying it waits, it uses the 
device_register / unregister mechanism so it does effectively set a flag that 
results in the release being called on last close. video_unregister_device 
does use a mutex while updating some internal flags but as far as I can tell 
the USB subsystem won't call gspca_disconnect in interrupt context so that 
should be OK.

What I hadn't noticed before is that usb_buffer_free needs the usb device 
pointer and as you say that is no longer valid after gspca_disconnect returns 
even if gspca_release hasn't freed the rest of the gspca struct. If that is 
the problem then I presume the correct behaviour is for gspca_disconnect to 
ensure that all URBs are killed and freed before gspca_disconnect returns. 
This shouldn't be a problem for sq905 (which doesn't use these URBs) or 
isochronous cameras (which don't need to resubmit URBs) but the finepix 
driver (the other supported bulk device) will need some careful consideration 
to avoid a race between killing the URB and resubmitting it.

Theodore, could you check if adding a call to destroy_urbs() in 
gspca_disconnect fixes the crash. (destroy_urbs only frees non NULL urb 
pointers so should be safe to call from both disconnect and stream_off, 
whichever occurs first).

> I suppose the easiest way to work around the problem would be to take a
> reference to the usb_device structure (usb_get_dev()) for each open and
> to drop the reference when the stream is closed.  But it would be
> preferable to do things the way I described before: Make disconnect put
> an open stream into an error state and release all the USB resources
> immediately.
>
> Alan Stern

Adam
