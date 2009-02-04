Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1942 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751358AbZBDB7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 20:59:04 -0500
Date: Tue, 3 Feb 2009 20:59:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Jean-Francois Moine <moinejf@free.fr>,
	<kilgota@banach.math.auburn.edu>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <200902032209.44133.linux@baker-net.org.uk>
Message-ID: <Pine.LNX.4.44L0.0902032045570.18064-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009, Adam Baker wrote:

> The sq905 driver doesn't use the URBs provided by gspca, it uses 
> usb_control_msg and usb_bulk_msg which I presume do the right thing 
> internally. There would be a tiny window in between when it checks the 
> dev->streaming flag and when it sends a new USB msg for the disconnect to 
> occur and invalidate the dev pointer. That could be fixed by holding 
> gspca_dev->usb_lock in gspca_disconnect when it sets gspca_dev->present = 0.
> 
> That would also address the race between open and disconnect.
> 
> Unfortunately the finepix driver sometimes uses calls to schedule_delayed_work 
> in the completion handler which then makes the call to usb_submit_urb. Fixing 
> that will require someone with access to a suitable camera to test it 
> otherwise there is a significant risk of adding deadlocks. It already suffers 
> from this bug so we aren't making it worse.

If the driver submits URBs from a work routine then usb_kill_urb's
guarantees don't apply.  You'll need to synchronize all three routines:
disconnect, the completion handler, and the work routine.  That means 
you'll have to use a spinlock, since a completion handler isn't allowed 
to acquire a mutex.

Alan Stern

