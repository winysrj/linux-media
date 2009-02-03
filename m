Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4933 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751247AbZBCDhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 22:37:37 -0500
Date: Mon, 2 Feb 2009 22:37:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: kilgota@banach.math.auburn.edu,
	Jean-Francois Moine <moinejf@free.fr>,
	<linux-media@vger.kernel.org>
Subject: Re: Bug in gspca USB webcam driver
In-Reply-To: <200902022328.44386.linux@baker-net.org.uk>
Message-ID: <Pine.LNX.4.44L0.0902022227460.27307-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2009, Adam Baker wrote:

> What I hadn't noticed before is that usb_buffer_free needs the usb device 
> pointer and as you say that is no longer valid after gspca_disconnect returns 
> even if gspca_release hasn't freed the rest of the gspca struct. If that is 
> the problem then I presume the correct behaviour is for gspca_disconnect to 
> ensure that all URBs are killed and freed before gspca_disconnect returns. 

That's right.

> This shouldn't be a problem for sq905 (which doesn't use these URBs) or 
> isochronous cameras (which don't need to resubmit URBs) but the finepix 
> driver (the other supported bulk device) will need some careful consideration 
> to avoid a race between killing the URB and resubmitting it.

You shouldn't need to take any special action.  usb_kill_urb() solves 
these races for you; it guarantees not to return until the URB has been 
unlinked and the completion handler has finished, and it guarantees 
that attempts by the completion handler to resubmit the URB will fail.

> Theodore, could you check if adding a call to destroy_urbs() in 
> gspca_disconnect fixes the crash. (destroy_urbs only frees non NULL urb 
> pointers so should be safe to call from both disconnect and stream_off, 
> whichever occurs first).

If URBs don't get submitted from anywhere but the completion handler
then this will work.  However you do have to worry about the race
between open and disconnect; you don't want open to start submitting
new URBs after disconnect has returned.  Many drivers have to worry 
about this race; usually it is solved by using a private mutex.

Alan Stern

