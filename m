Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51732 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1H1I6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 04:58:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH/RFC v2 3/3] fbdev: sh_mobile_lcdc: Support FOURCC-based format API
Date: Sun, 28 Aug 2011 10:59:00 +0200
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com> <1313746626-23845-4-git-send-email-laurent.pinchart@ideasonboard.com> <4E57D6B2.40001@gmx.de>
In-Reply-To: <4E57D6B2.40001@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108281059.00860.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

Thanks for the review.

On Friday 26 August 2011 19:24:02 Florian Tobias Schandinat wrote:
> On 08/19/2011 09:37 AM, Laurent Pinchart wrote:

[snip]

> > diff --git a/drivers/video/sh_mobile_lcdcfb.c
> > b/drivers/video/sh_mobile_lcdcfb.c index 97ab8ba..ea3f619 100644
> > --- a/drivers/video/sh_mobile_lcdcfb.c
> > +++ b/drivers/video/sh_mobile_lcdcfb.c

[snip]

> > @@ -1099,51 +1154,78 @@ static int sh_mobile_check_var(struct

[snip]

> > +	if (var->format.fourcc > 1) {
> > +		switch (var->format.fourcc) {
> > +		case V4L2_PIX_FMT_NV12:
> > +		case V4L2_PIX_FMT_NV21:
> > +			var->bits_per_pixel = 12;
> > +			break;
> > +		case V4L2_PIX_FMT_RGB565:
> > +		case V4L2_PIX_FMT_NV16:
> > +		case V4L2_PIX_FMT_NV61:
> > +			var->bits_per_pixel = 16;
> > +			break;
> > +		case V4L2_PIX_FMT_BGR24:
> > +		case V4L2_PIX_FMT_NV24:
> > +		case V4L2_PIX_FMT_NV42:
> > +			var->bits_per_pixel = 24;
> > +			break;
> > +		case V4L2_PIX_FMT_BGR32:
> > +			var->bits_per_pixel = 32;
> > +			break;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +
> > +		memset(var->format.reserved, 0, sizeof(var->format.reserved));
> 
> If we decide to use another of the reserved area this won't have the
> desired behavior as the behavior of this driver will change even if it
> does not support the new field. Probably the best thing is to get the
> desired behavior is zeroing the whole struct and setting the supported
> fields to the actual values. You should check and adjust colorspace here
> as well.

Agreed. I'll fix the patch accordingly.

-- 
Regards,

Laurent Pinchart
