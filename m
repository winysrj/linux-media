Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42012 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933070AbcKOOpI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 09:45:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Edgar Thier <info@edgarthier.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Add bayer 16-bit format patterns
Date: Tue, 15 Nov 2016 16:45:16 +0200
Message-ID: <4240902.Ryzmde8dbC@avalon>
In-Reply-To: <20161115134532.GW3217@valkosipuli.retiisi.org.uk>
References: <87h97achun.fsf@edgarthier.net> <8760np5mjm.fsf@edgarthier.net> <20161115134532.GW3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 15 Nov 2016 15:45:32 Sakari Ailus wrote:
> On Tue, Nov 15, 2016 at 06:39:41AM +0100, Edgar Thier wrote:
> > From 10ce06db4ab3c037758b3cb5264007f59801f1a1 Mon Sep 17 00:00:00 2001
> > From: Edgar Thier <info@edgarthier.net>
> > Date: Tue, 15 Nov 2016 06:33:10 +0100
> > Subject: [PATCH] uvcvideo: Add bayer 16-bit format patterns
> > 
> > Signed-off-by: Edgar Thier <info@edgarthier.net>
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> > ---
> > drivers/media/usb/uvc/uvc_driver.c | 20 ++++++++++++++++++++
> > drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
> > 2 files changed, 32 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index 87b2fc3b..9d1fc33 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -168,6 +168,26 @@ static struct uvc_format_desc uvc_fmts[] = {
> > .guid		= UVC_GUID_FORMAT_RW10,
> > .fcc		= V4L2_PIX_FMT_SRGGB10P,
> > },
> > +	{
> > +			.name		= "Bayer 16-bit (SBGGR16)",
> 
> Laurent, are these still needed? The V4L2 framework fills in the format
> name... certainly out of scope for this patch though.

I'll fix that.

> > +			.guid		= UVC_GUID_FORMAT_BG16,
> > +			.fcc		= V4L2_PIX_FMT_SBGGR16,
> > +	},
> > +	{
> > +			.name		= "Bayer 16-bit (SGBRG16)",
> > +			.guid		= UVC_GUID_FORMAT_GB16,
> > +			.fcc		= V4L2_PIX_FMT_SGBRG16,
> > +	},
> > +	{
> > +			.name		= "Bayer 16-bit (SRGGB16)",
> > +			.guid		= UVC_GUID_FORMAT_RG16,
> > +			.fcc		= V4L2_PIX_FMT_SRGGB16,
> > +	},
> > +	{
> > +			.name		= "Bayer 16-bit (SGRBG16)",
> > +			.guid		= UVC_GUID_FORMAT_GR16,
> > +			.fcc		= V4L2_PIX_FMT_SGRBG16,
> > +	},
> > };

-- 
Regards,

Laurent Pinchart

