Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36727 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbABLlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 06:41:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 1/1] omap3isp: Correctly set QUERYCAP capabilities
Date: Fri, 02 Jan 2015 13:42:03 +0200
Message-ID: <7936187.KpBi4ciavk@avalon>
In-Reply-To: <20150102085441.GP17565@valkosipuli.retiisi.org.uk>
References: <1420146834-13458-1-git-send-email-sakari.ailus@iki.fi> <17321888.FUCG9ahuk4@avalon> <20150102085441.GP17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 02 January 2015 10:54:41 Sakari Ailus wrote:
> On Fri, Jan 02, 2015 at 01:04:16AM +0200, Laurent Pinchart wrote:
> > On Thursday 01 January 2015 23:13:54 Sakari Ailus wrote:
> > > device_caps in struct v4l2_capability were inadequately set in
> > > VIDIOC_QUERYCAP. Fix this.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  drivers/media/platform/omap3isp/ispvideo.c |    7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> > > b/drivers/media/platform/omap3isp/ispvideo.c index cdfec27..d644164
> > > 100644
> > > --- a/drivers/media/platform/omap3isp/ispvideo.c
> > > +++ b/drivers/media/platform/omap3isp/ispvideo.c
> > > @@ -602,10 +602,13 @@ isp_video_querycap(struct file *file, void *fh,
> > > struct v4l2_capability *cap) strlcpy(cap->card, video->video.name,
> > > sizeof(cap->card));
> > > 
> > >  	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
> > > 
> > > +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
> > > +		| V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
> > 
> > I would align the | under the =. Apart from that,
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I assume you'd apply the patch to your tree eventually? Can you make the
> change, or would you prefer me to resend?

I can make the change when applying, no need to resend. I'll send a pull 
request for v3.20.

-- 
Regards,

Laurent Pinchart

