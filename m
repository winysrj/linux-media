Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52451 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3KDNR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 08:17:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: g@valkosipuli.retiisi.org.uk, linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: omap3isp: Move code out of mutex-protected section
Date: Mon, 04 Nov 2013 14:17:53 +0100
Message-ID: <3877980.gXG2nDA4fQ@avalon>
In-Reply-To: <20131104112010.GB21655@valkosipuli.retiisi.org.uk>
References: <1383559668-11003-1-git-send-email-laurent.pinchart@ideasonboard.com> <20131104112010.GB21655@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 04 November 2013 13:20:11 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch.
> 
> On Mon, Nov 04, 2013 at 11:07:48AM +0100, Laurent Pinchart wrote:
> > The pad::get_fmt call must be protected by a mutex, but preparing its
> > arguments doesn't need to be. Move the non-critical code out of the
> > mutex-protected section.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/omap3isp/ispvideo.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> > b/drivers/media/platform/omap3isp/ispvideo.c index a908d00..f6304bb
> > 100644
> > --- a/drivers/media/platform/omap3isp/ispvideo.c
> > +++ b/drivers/media/platform/omap3isp/ispvideo.c
> > @@ -339,14 +339,11 @@ __isp_video_get_format(struct isp_video *video,
> > struct v4l2_format *format)> 
> >  	if (subdev == NULL)
> >  	
> >  		return -EINVAL;
> > 
> > -	mutex_lock(&video->mutex);
> > -
> > 
> >  	fmt.pad = pad;
> >  	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > 
> > -	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> > -	if (ret == -ENOIOCTLCMD)
> > -		ret = -EINVAL;
> 
> By removing these lines, you're also returning -ENOIOCTLCMD to the caller.
> Is this intentional?
> 
> That return value will end up to at least one place which seems to be
> isp_video_streamon() and, unless I'm mistaken, will cause
> ioctl(VIDIOC_STREAMON) also return ENOTTY.

I should have split this in two patches, or at least explained the rationale 
in the commit message. The remote subdev is always an internal ISP subdev, the 
pad::get_fmt operation is thus guaranteed to be implemented. There's no need 
to check for ENOIOCTLCMD.

> > +	mutex_lock(&video->mutex);
> > +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> > 
> >  	mutex_unlock(&video->mutex);
> >  	
> >  	if (ret)
-- 
Regards,

Laurent Pinchart

