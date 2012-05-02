Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41054 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2EBLQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:16:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: whittenburg@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: omap3isp: isp_video_mbus_to_pix causes WARN_ON
Date: Wed, 02 May 2012 13:16:43 +0200
Message-ID: <1508632.vF7XM4fJOR@avalon>
In-Reply-To: <CABcw_O=n34Y1jCbSzgBkDr-ZnFMTnycvTAWw9kAwUEtXnU3dOg@mail.gmail.com>
References: <CABcw_O=n34Y1jCbSzgBkDr-ZnFMTnycvTAWw9kAwUEtXnU3dOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Thursday 26 April 2012 10:54:58 Chris Whittenburg wrote:
> I'm using a 3.0.17 kernel on a dm3730 with a custom 8-bit grayscale sensor.
> 
> When using a simple gstreamer pipeline to test:
> 
> gst-launch -v v4l2src device=/dev/video2 !
> 'video/x-raw-gray,bpp=(int)8,framerate=(fraction)10/1,width=640,height=480'
> ! fakesink
> 
> I get lots of calls to isp_video_try_format for unrelated formats like
> YU12, YV12, BGR3, and RGB3.  I assume this is gstreamer's fault, since
> I implemented isp_video_enum_format which only returns
> V4L2_PIX_FMT_GREY.
> 
> Anyway, isp_video_try_format makes calls to isp_video_pix_to_mbus for
> each of these formats, and since they aren't in the list of
> isp_format_info formats, WARN_ON gets called.
> 
> Is this expected?  What would be the best way to resolve it?

This has been fixed in

commit c3cd257402fdcd650816ec25b83480a24912430a
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Mon Nov 28 08:25:30 2011 -0300

    [media] omap3isp: video: Don't WARN() on unknown pixel formats
    
    When mapping from a V4L2 pixel format to a media bus format in the
    VIDIOC_TRY_FMT and VIDIOC_S_FMT handlers, the requested format may be
    unsupported by the driver. Return a hardcoded format instead of
    WARN()ing in that case.
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

-- 
Regards,

Laurent Pinchart

