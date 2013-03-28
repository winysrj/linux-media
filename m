Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46349 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756373Ab3C1Op2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 10:45:28 -0400
Date: Thu, 28 Mar 2013 10:45:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, <linux-usb@vger.kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH/RFC] uvcvideo: Disable USB autosuspend for Creative Live!
 Cam Optia AF
In-Reply-To: <1364471612-31792-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.44L0.1303281043140.1652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Mar 2013, Laurent Pinchart wrote:

> The camera fails to start video streaming after having been autosuspend.
> Add a new quirk to selectively disable autosuspend for devices that
> don't support it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++++-
>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> I've tried to set the reset resume quirk for this device in the USB core but
> the camera still failed to start video streaming after having been
> autosuspended. Regardless of whether the reset resume quirk was set, it would
> respond to control messages but wouldn't send video data.

Presumably the camera won't work after a system suspend, either.

> This solution below is a hack, but I'm not sure what else I can try. Crazy
> ideas are welcome.

It's not a hack; it's a normal use for a quirk flag.  Of course, if you 
can figure out what's wrong with the camera and see how to fix it, that 
would be best.

How does the camera perform on a Windows system after being put to
sleep and then woken up?

Alan Stern

