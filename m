Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47719 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3HTRda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 13:33:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: more buffers
Date: Tue, 20 Aug 2013 19:34:43 +0200
Message-ID: <12081572.xS4pFlgJZG@avalon>
In-Reply-To: <1376298115.2689.13.camel@linux-fkkt.site>
References: <1376053896-8931-1-git-send-email-oliver@neukum.org> <2017146.oxz2IcHa3F@avalon> <1376298115.2689.13.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

On Monday 12 August 2013 11:01:55 Oliver Neukum wrote:
> On Fri, 2013-08-09 at 15:58 +0200, Laurent Pinchart wrote:
> > > This is necessary to let the new generation of cameras from LiteOn used
> > > in Haswell ULT notebook operate. Otherwise the images will be truncated.
> > 
> > Could you please post the lsusb -v output for the device ?
> 
> It is attached.

No it isn't :-)

> > Why does it need more buffers, is it a superspeed webcam ?
> 
> No. It is HS.
> 
> > > Signed-off-by: Oliver Neukum <oneukum@suse.de>
> > > ---
> > > 
> > >  drivers/media/usb/uvc/uvcvideo.h | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > > b/drivers/media/usb/uvc/uvcvideo.h index 9e35982..9f1930b 100644
> > > --- a/drivers/media/usb/uvc/uvcvideo.h
> > > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > > @@ -114,9 +114,9 @@
> > > 
> > >  /* Number of isochronous URBs. */
> > >  #define UVC_URBS		5
> > >  /* Maximum number of packets per URB. */
> > > 
> > > -#define UVC_MAX_PACKETS		32
> > > +#define UVC_MAX_PACKETS		128
> > 
> > That would mean up to 384KiB per URB. While not unreasonable, I'd like to
> > know how much data your camera produces to require this.
> 
> How to determine that?

The UVC descriptors might provide some information.

Do you get errors in the kernel log with UVC_MAX_PACKETS set to 32 ?

> > >  /* Maximum number of video buffers. */
> > > 
> > > -#define UVC_MAX_VIDEO_BUFFERS	32
> > > +#define UVC_MAX_VIDEO_BUFFERS	128
> > 
> > I don't think your camera really needs more than 32 V4L2 (full frame)
> > buffers :-)
> 
> Unfortunately, experimental evidence is that it does need them at
> resolutions above 640x480

Could you please test it again with UVC_MAX_PACKETS set to 128 and 
UVC_MAX_VIDEO_BUFFERS set to 32 ? UVC_MAX_VIDEO_BUFFERS sets the maximum 
number of V4L2 full frame buffers, even 32 is probably way too high.

-- 
Regards,

Laurent Pinchart

