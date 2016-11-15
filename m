Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42041 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbcKOOuN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 09:50:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Edgar Thier <info@edgarthier.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Add bayer 16-bit format patterns
Date: Tue, 15 Nov 2016 16:50:21 +0200
Message-ID: <5713726.KjK2pZeoAD@avalon>
In-Reply-To: <1561162.tWqexSrnMS@avalon>
References: <87h97achun.fsf@edgarthier.net> <8760np5mjm.fsf@edgarthier.net> <1561162.tWqexSrnMS@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

On Tuesday 15 Nov 2016 16:44:55 Laurent Pinchart wrote:
> On Tuesday 15 Nov 2016 06:39:41 Edgar Thier wrote:
> > From 10ce06db4ab3c037758b3cb5264007f59801f1a1 Mon Sep 17 00:00:00 2001
> > From: Edgar Thier <info@edgarthier.net>
> > Date: Tue, 15 Nov 2016 06:33:10 +0100
> > Subject: [PATCH] uvcvideo: Add bayer 16-bit format patterns
> 
> Which device(s) support these formats ?

And could you please try to fix your e-mail client and/or server to avoid 
corrupting patches ?

> > Signed-off-by: Edgar Thier <info@edgarthier.net>
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
> > 
> > /*
> > ------------------------------------------------------------------------
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index 7e4d3ee..3d6cc62 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -106,6 +106,18 @@
> > #define UVC_GUID_FORMAT_RGGB \
> > { 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
> > 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > +#define UVC_GUID_FORMAT_BG16 \
> > +	{ 'B',  'G',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
> > +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > +#define UVC_GUID_FORMAT_GB16 \
> > +	{ 'G',  'B',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
> > +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > +#define UVC_GUID_FORMAT_RG16 \
> > +	{ 'R',  'G',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
> > +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > +#define UVC_GUID_FORMAT_GR16 \
> > +	{ 'G',  'R',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
> > +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > #define UVC_GUID_FORMAT_RGBP \
> > { 'R',  'G',  'B',  'P', 0x00, 0x00, 0x10, 0x00, \
> > 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}

-- 
Regards,

Laurent Pinchart

