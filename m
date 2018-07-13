Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44000 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbeGMHmt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 03:42:49 -0400
Date: Fri, 13 Jul 2018 09:29:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC] usb: add usb_fill_iso_urb()
Message-ID: <20180713072923.GA31191@kroah.com>
References: <20180620164945.xb24m7wlbtb6cys5@linutronix.de>
 <Pine.LNX.4.44L0.1806201322260.1758-100000@iolanthe.rowland.org>
 <20180712223527.5nmxndignujo7smt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180712223527.5nmxndignujo7smt@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 13, 2018 at 12:35:27AM +0200, Sebastian Andrzej Siewior wrote:
> Provide usb_fill_iso_urb() for the initialisation of isochronous URBs.
> We already have one of this helpers for control, bulk and interruptible
> URB types. This helps to keep the initialisation of the URB members in
> one place.
> Update the documentation by adding this to the available init functions
> and remove the suggestion to use the `_int_' helper which might provide
> wrong encoding for the `interval' member.
> 
> This looks like it would cover most users nicely. The sound subsystem
> initialises the ->iso_frame_desc[].offset + length member (often) at a
> different location and I'm not sure ->interval will work always as
> expected. So we might need to overwrite those two in worst case.
> 
> Some users also initialise ->iso_frame_desc[].actual_length but I don't
> this is required since it is the return value.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  Documentation/driver-api/usb/URB.rst | 12 +++----
>  include/linux/usb.h                  | 53 ++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 6 deletions(-)

Do you have a few example patches of using this new function?  Many many
years ago we tried to create this function, but we gave up as it just
didn't seem to work for the majority of the users of ISO packets.  Maybe
things have changed since then and people do it all more in a "standard"
way and we can take advantage of this.  But it would be nice to see
proof it can be used before taking this patch.

thanks,

greg k-h
