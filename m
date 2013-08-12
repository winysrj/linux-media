Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:40918 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3HLJB5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 05:01:57 -0400
Message-ID: <1376298115.2689.13.camel@linux-fkkt.site>
Subject: Re: [PATCH] uvc: more buffers
From: Oliver Neukum <oliver@neukum.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Mon, 12 Aug 2013 11:01:55 +0200
In-Reply-To: <2017146.oxz2IcHa3F@avalon>
References: <1376053896-8931-1-git-send-email-oliver@neukum.org>
	 <2017146.oxz2IcHa3F@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2013-08-09 at 15:58 +0200, Laurent Pinchart wrote:

Hi,

> > This is necessary to let the new generation of cameras from LiteOn used in
> > Haswell ULT notebook operate. Otherwise the images will be truncated.
> 
> Could you please post the lsusb -v output for the device ?

It is attached.

> Why does it need more buffers, is it a superspeed webcam ?

No. It is HS.

> > Signed-off-by: Oliver Neukum <oneukum@suse.de>
> > ---
> >  drivers/media/usb/uvc/uvcvideo.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index 9e35982..9f1930b 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -114,9 +114,9 @@
> >  /* Number of isochronous URBs. */
> >  #define UVC_URBS		5
> >  /* Maximum number of packets per URB. */
> > -#define UVC_MAX_PACKETS		32
> > +#define UVC_MAX_PACKETS		128
> 
> That would mean up to 384KiB per URB. While not unreasonable, I'd like to know 
> how much data your camera produces to require this.

How to determine that?

> >  /* Maximum number of video buffers. */
> > -#define UVC_MAX_VIDEO_BUFFERS	32
> > +#define UVC_MAX_VIDEO_BUFFERS	128
> 
> I don't think your camera really needs more than 32 V4L2 (full frame) buffers 
> :-)

Unfortunately, experimental evidence is that it does need them at
resolutions above 640x480

	Regards
		Oliver


