Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41936 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761846Ab3DDP1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 11:27:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH/RFC] uvcvideo: Disable USB autosuspend for Creative Live! Cam Optia AF
Date: Thu, 04 Apr 2013 17:28:01 +0200
Message-ID: <1675297.SBVpg0UeLp@avalon>
In-Reply-To: <Pine.LNX.4.44L0.1303281043140.1652-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1303281043140.1652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Thursday 28 March 2013 10:45:27 Alan Stern wrote:
> On Thu, 28 Mar 2013, Laurent Pinchart wrote:
> > The camera fails to start video streaming after having been autosuspend.
> > Add a new quirk to selectively disable autosuspend for devices that
> > don't support it.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++++-
> >  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> > 
> > I've tried to set the reset resume quirk for this device in the USB core
> > but the camera still failed to start video streaming after having been
> > autosuspended. Regardless of whether the reset resume quirk was set, it
> > would respond to control messages but wouldn't send video data.
> 
> Presumably the camera won't work after a system suspend, either.

That was my expectation as well, but the device has survived system suspend 
without being reenumerated. I don't know if the USB port power got cut off 
during system suspend.

> > This solution below is a hack, but I'm not sure what else I can try. Crazy
> > ideas are welcome.
> 
> It's not a hack; it's a normal use for a quirk flag.  Of course, if you
> can figure out what's wrong with the camera and see how to fix it, that
> would be best.

I've tried to but I can't figure out what goes wrong exactly.

> How does the camera perform on a Windows system after being put to
> sleep and then woken up?

I don't know, I have no Windows system to test the camera on.

-- 
Regards,

Laurent Pinchart

