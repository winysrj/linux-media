Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.atlantis.sk ([80.94.52.35]:35257 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZJGNfe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2009 09:35:34 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: [Linux-uvc-devel] [PATCH] Re: uvcvideo: Finally fix Logitech  Quickcam for Notebooks Pro
Date: Wed, 7 Oct 2009 15:34:54 +0200
Cc: laurent.pinchart@skynet.be, linux-uvc-devel@lists.berlios.de,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <200910061607.07195.linux@rainbow-software.org> <200910071459.43622.linux@rainbow-software.org> <561c252c0910070612v6c7f6363xbb9548f62c834fbd@mail.gmail.com>
In-Reply-To: <561c252c0910070612v6c7f6363xbb9548f62c834fbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910071534.55687.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 07 October 2009, Gianluca Cecchi wrote:
> On Wed, Oct 7, 2009 at 2:59 PM, Ondrej Zary 
<linux@rainbow-software.org>wrote:
> > [snip]
> >
> > > What was the change that supposedly broke this in 2.6.22?
> >
> > I discovered that it's not related to usb audio at all. Doing "rmmod
> > uvcvideo"
> > and "modprobe uvcvideo" repeatedly succeeded after a couple of tries.
> > Increasing
> > UVC_CTRL_STREAMING_TIMEOUT to 3000 helped (2000 was not enough).
> >
> >
> > Increase UVC_CTRL_STREAMING_TIMEOUT to fix initialization of
> > Logitech Quickcam for Notebooks Pro.
> > This fixes following error messages:
> > uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling
> > workaround.
> > uvcvideo: Failed to query (129) UVC probe control : -110 (exp. 26).
> > uvcvideo: Failed to initialize the device (-5).
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > --- linux-2.6.31-orig/drivers/media/video/uvc/uvcvideo.h       
> > 2009-09-10 00:13:59.000000000 +0200
> > +++ linux-2.6.31/drivers/media/video/uvc/uvcvideo.h     2009-10-07
> > 13:47:27.000000000 +0200
> > @@ -304,7 +304,7 @@
> >  #define UVC_MAX_STATUS_SIZE    16
> >
> >  #define UVC_CTRL_CONTROL_TIMEOUT       300
> > -#define UVC_CTRL_STREAMING_TIMEOUT     1000
> > +#define UVC_CTRL_STREAMING_TIMEOUT     3000
> >
> >  /* Devices quirks */
> >  #define UVC_QUIRK_STATUS_INTERVAL      0x00000001
> >
> >
> > --
> > Ondrej Zary
>
> Could this kind of fix also be useful in my case with Omnivision oem in
> Dell sp2208wfp monitor, in your opinion?
> See thread
> https://lists.berlios.de/pipermail/linux-uvc-devel/2008-February/003076.html
>
> incidentally at that time I was using Fedora 8 32bit with kernel
> 2.6.23.15-137.fc8 that indeed is post 2.6.22....

I don't know - try it. My patch is not related to 2.6.22 and usb-audio at all.

-- 
Ondrej Zary
