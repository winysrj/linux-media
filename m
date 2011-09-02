Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60401 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1IBL12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 07:27:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Subject: Re: Getting started with OMAP3 ISP
Date: Fri, 2 Sep 2011 13:27:58 +0200
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
References: <4E56734A.3080001@mlbassoc.com> <201109012014.32996.laurent.pinchart@ideasonboard.com> <CA+2YH7s9EEQi55TbzhE7yHdFB196t5g24Za0WJbWut+SzZHv2A@mail.gmail.com>
In-Reply-To: <CA+2YH7s9EEQi55TbzhE7yHdFB196t5g24Za0WJbWut+SzZHv2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109021327.59221.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Friday 02 September 2011 11:02:23 Enrico wrote:
> On Thu, Sep 1, 2011 at 8:14 PM, Laurent Pinchart wrote:
> > On Thursday 01 September 2011 19:24:54 Enrico wrote:
> >> yavta will set UYVY (PIX_FMT), this will cause a call to
> >> ispvideo.c:isp_video_pix_to_mbus(..), that will do this:
> >> 
> >> for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> >>                 if (formats[i].pixelformat == pix->pixelformat)
> >>                         break;
> >> }
> >> 
> >> that is it will stop at the first matching array item, and that's:
> >> 
> >> { V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
> >>           V4L2_MBUS_FMT_UYVY8_1X16, 0,
> >>           V4L2_PIX_FMT_UYVY, 16, 16, },
> >> 
> >> 
> >> but you wanted this:
> >> 
> >> { V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
> >>           V4L2_MBUS_FMT_UYVY8_2X8, 0,
> >>           V4L2_PIX_FMT_UYVY, 8, 16, },
> >> 
> >> so a better check could be to check for width too, but i don't know if
> >> it's possibile to pass a width requirement or if it's already there in
> >> some struct passed to the function.
> > 
> > That's not really an issue, as the isp_video_pix_to_mbus() and
> > isp_video_mbus_to_pix() calls in isp_video_set_format() are just used to
> > fill the bytesperline and sizeimage fields. From a quick look at the
> > code isp_video_check_format() should succeed as well.
> > 
> > Have you run into any specific issue with isp_video_pix_to_mbus() when
> > using V4L2_MBUS_FMT_UYVY8_2X8 ?
> 
> No, i assumed it was used to set the format on the pad too but this is
> not the case, sorry for the noise.
> 
> Right now my problem is that i can't get the isp to generate
> interrupts, i think there is some isp configuration error.

If your device generates interlaced images that's not surprising, as the CCDC 
will only receive half the number of lines it expects.

-- 
Regards,

Laurent Pinchart
