Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:33740 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZJKWAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 18:00:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [Linux-uvc-devel] [PATCH] Re: uvcvideo: Finally fix Logitech Quickcam for Notebooks Pro
Date: Mon, 12 Oct 2009 00:01:56 +0200
Cc: linux-uvc-devel@lists.berlios.de, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <200910061607.07195.linux@rainbow-software.org> <200910090104.26371.laurent.pinchart@ideasonboard.com> <200910090832.09254.linux@rainbow-software.org>
In-Reply-To: <200910090832.09254.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910120001.56790.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ondrej,

On Friday 09 October 2009 08:32:06 Ondrej Zary wrote:
> On Friday 09 October 2009, Laurent Pinchart wrote:
> > Hi Ondrej,
> >
> > On Wednesday 07 October 2009 14:59:40 Ondrej Zary wrote:
> > > On Tuesday 06 October 2009, Ondrej Zary wrote:
> > > > Hello,
> > > > I have a Logitech Quickcam for Notebooks Pro camera (046d:08c3) which
> > > > just does not work even with kernel 2.6.31 and has never worked well
> > > > before.
> > > >
> > > > On http://linux-uvc.berlios.de/, there are two problems listed. I
> > > > want to really fix these two problems so the camera will just work
> > > > after plugging in (and not disconnect). I started with problem no. 2
> > > > as this causes the camera not to work at all when plugged in:
> > > >
> > > > usb 5-2.4: new high speed USB device using ehci_hcd and address 7
> > > > usb 5-2.4: configuration #1 chosen from 1 choice
> > > > uvcvideo: Found UVC 1.00 device <unnamed> (046d:08c3)
> > > > uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling
> > > > workaround.
> > > > uvcvideo: Failed to query (129) UVC probe control : -110 (exp. 26).
> > > > uvcvideo: Failed to initialize the device (-5).
> > > >
> > > > When I do "modprobe snd_usb_audio", then "rmmod snd_usb_audio" and
> > > > finally "modprobe uvcvideo", it works. So it looks like snd_usb_audio
> > > > does some initialization that allows uvcvideo to work. It didn't work
> > > > at all I didn't have snd_usb_audio module compiled.
> > > >
> > > > What was the change that supposedly broke this in 2.6.22?
> > >
> > > I discovered that it's not related to usb audio at all. Doing "rmmod
> > >  uvcvideo" and "modprobe uvcvideo" repeatedly succeeded after a couple
> > > of tries. Increasing UVC_CTRL_STREAMING_TIMEOUT to 3000 helped (2000
> > > was not enough).
> > >
> > >
> > > Increase UVC_CTRL_STREAMING_TIMEOUT to fix initialization of
> > > Logitech Quickcam for Notebooks Pro.
> > > This fixes following error messages:
> > > uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling
> > >  workaround. uvcvideo: Failed to query (129) UVC probe control : -110
> > > (exp. 26). uvcvideo: Failed to initialize the device (-5).
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > >
> > > --- linux-2.6.31-orig/drivers/media/video/uvc/uvcvideo.h	2009-09-10
> > >  00:13:59.000000000 +0200 +++
> > >  linux-2.6.31/drivers/media/video/uvc/uvcvideo.h	2009-10-07
> > >  13:47:27.000000000 +0200 @@ -304,7 +304,7 @@
> > >  #define UVC_MAX_STATUS_SIZE	16
> > >
> > >  #define UVC_CTRL_CONTROL_TIMEOUT	300
> > > -#define UVC_CTRL_STREAMING_TIMEOUT	1000
> > > +#define UVC_CTRL_STREAMING_TIMEOUT	3000
> > >
> > >  /* Devices quirks */
> > >  #define UVC_QUIRK_STATUS_INTERVAL	0x00000001
> >
> > Thanks for the patch. I wonder if it will help other Logitech users.
> >
> > The UVC specification unfortunately doesn't give a time boundary for
> > answering streaming requests, so that's up to the developers. I'm pretty
> > sure we will find at least one webcam model that will require 3001ms at
> > some point :-)
> >
> > I was thinking about adding a module parameter to set the streaming
> > control timeout. I'm not sure what the default value should be though.
> > What's your opinion on this ? If we decide to increase the default value,
> > where should we stop ?
> 
> I really don't know. Maybe only the first request is slow as the hardware
> needs some time to initialize?

That's my guess as well.

> If someone knows what value is used by Windows or Mac OS X, that's probably
> the "right" choice as most devices are tested with them.

I've committed a patch that turns the timeout value into a module parameter 
and asked Mauro to pull from my repository. The default timeout value has been 
increased to 3000ms.

It seems the value used by the Windows driver is 5000ms. I have no information 
about what's done on Mac OS X. If it works with 3000ms lets keep it that way. 
I wouldn't be surprised if the 5000ms was some kind of rounded-up guessed 
value anyway :-)

-- 
Regards,

Laurent Pinchart
