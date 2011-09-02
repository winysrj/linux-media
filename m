Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48976 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab1IBIIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 04:08:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: Getting started with OMAP3 ISP
Date: Fri, 2 Sep 2011 10:09:21 +0200
Cc: Enrico <ebutera@users.berlios.de>, linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
References: <4E56734A.3080001@mlbassoc.com> <201109012014.32996.laurent.pinchart@ideasonboard.com> <4E5FCC93.1090807@mlbassoc.com>
In-Reply-To: <4E5FCC93.1090807@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109021009.22196.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Thursday 01 September 2011 20:18:59 Gary Thomas wrote:
> On 2011-09-01 12:14, Laurent Pinchart wrote:
> > On Thursday 01 September 2011 19:24:54 Enrico wrote:
> >> On Thu, Sep 1, 2011 at 6:14 PM, Enrico<ebutera@users.berlios.de>  wrote:
> >>> On Thu, Sep 1, 2011 at 5:16 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
> >>>> - entity 16: tvp5150m1 2-005c (1 pad, 1 link)
> >>>> 
> >>>>              type V4L2 subdev subtype Unknown
> >>>>              device node name /dev/v4l-subdev8
> >>>>         
> >>>>         pad0: Output [unknown 720x480 (1,1)/720x480]
> >>>>         
> >>>>                 ->  'OMAP3 ISP CCDC':pad0 [ACTIVE]
> >>>> 
> >>>> Ideas where to look for the 'unknown' mode?
> >>> 
> >>> I didn't notice that, if you are using UYVY8_2X8 the reason is in
> >>> media-ctl main.c:
> >>> 
> >>> { "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
> >>> 
> >>> You can add a line like:
> >>> 
> >>> { "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
> >>> 
> >>> recompile and it should work, i'll try it now.
> >> 
> >> That worked, but now there is another problem.
> > 
> > That's correct. My bad for not spotting it sooner.
> 
> Will you be adding this to the media-ctl tree?  Would you like a patch?

I need to think about format names. I've used V4L2 FOURCC names so far to 
refer to media bus format codes, that proved not to be the best idea. I will 
fix that.

> >> yavta will set UYVY (PIX_FMT), this will cause a call to
> >> ispvideo.c:isp_video_pix_to_mbus(..), that will do this:
> >> 
> >> for (i = 0; i<  ARRAY_SIZE(formats); ++i) {
> >> 
> >>                  if (formats[i].pixelformat == pix->pixelformat)
> >>                  
> >>                          break;
> >> 
> >> }
> >> 
> >> that is it will stop at the first matching array item, and that's:
> >> 
> >> { V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
> >> 
> >>            V4L2_MBUS_FMT_UYVY8_1X16, 0,
> >>            V4L2_PIX_FMT_UYVY, 16, 16, },
> >> 
> >> but you wanted this:
> >> 
> >> { V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
> >> 
> >>            V4L2_MBUS_FMT_UYVY8_2X8, 0,
> >>            V4L2_PIX_FMT_UYVY, 8, 16, },
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
> Not yet - I was able to configure the pipeline as
>    # media-ctl -f '"tvp5150m1 2-005c":0[UYVY2X8 720x480], "OMAP3 ISP
> CCDC":0[UYVY2X8 720x480], "OMAP3 ISP CCDC":1[UYVY2X8 720x480]' and this
> gets me all the way into my driver (which I'm now working on)

OK.

-- 
Regards,

Laurent Pinchart
