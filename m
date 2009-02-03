Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:28727
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbZBCWJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 17:09:51 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
Date: Tue, 3 Feb 2009 22:09:43 +0000
Cc: kilgota@banach.math.auburn.edu, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902031302060.1882@banach.math.auburn.edu> <20090203202307.0ae074ec@free.fr>
In-Reply-To: <20090203202307.0ae074ec@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032209.44133.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 February 2009, Jean-Francois Moine wrote:
> Indeed, the problem is there! You must have only one process reading the
> webcam! I do not see how this can work with these 2 processes...

Although 2 processes are created only one ever gets used. 
create_singlethread_workqueue would therefore be less wasteful but make no 
other difference. Google searches for create_freezeable_workqueue bring up 
suggestions to avoid it so I think I will although I guess we ought to check 
at some point how well the camera copes with suspend while streaming.

At 19:53:31 Alan Stern wrote
> If a camera is unplugged while it is in use then 
> waiting until close() is no good -- it will cause destroy_urbs() to 
> pass a stale pointer to usb_buffer_free().  That's the reason for the 
> oops.

I'd go further and suggest that gspca_disconnect should, after calling 
destroy_urbs() do gspca_dev->dev = NULL; Any use of that pointer past that 
point is a bug (the downside is that doing so would have turned the current 
bug into a hard to spot memory leak).

At 03:37:35 Alan Stern wrote
> On Mon, 2 Feb 2009, Adam Baker wrote:
>> This shouldn't be a problem for sq905 (which doesn't use these URBs) or 
>> isochronous cameras (which don't need to resubmit URBs) but the finepix 
>> driver (the other supported bulk device) will need some careful
>> consideration  to avoid a race between killing the URB and resubmitting it.
>
> You shouldn't need to take any special action.  usb_kill_urb() solves 
> these races for you; it guarantees not to return until the URB has been 
> unlinked and the completion handler has finished, and it guarantees 
> that attempts by the completion handler to resubmit the URB will fail.

The sq905 driver doesn't use the URBs provided by gspca, it uses 
usb_control_msg and usb_bulk_msg which I presume do the right thing 
internally. There would be a tiny window in between when it checks the 
dev->streaming flag and when it sends a new USB msg for the disconnect to 
occur and invalidate the dev pointer. That could be fixed by holding 
gspca_dev->usb_lock in gspca_disconnect when it sets gspca_dev->present = 0.

That would also address the race between open and disconnect.

Unfortunately the finepix driver sometimes uses calls to schedule_delayed_work 
in the completion handler which then makes the call to usb_submit_urb. Fixing 
that will require someone with access to a suitable camera to test it 
otherwise there is a significant risk of adding deadlocks. It already suffers 
from this bug so we aren't making it worse.

Calling destroy_urbs from dev_close rather than gspca_disconnect could also 
trigger the same bug on isochronous cameras. I haven't looked at them closely 
but they probably also have the race between open and disconnect which taking 
the lock in disconnect is likely to fix.

I'll do some testing and post a patch if it looks promising.

Adam
