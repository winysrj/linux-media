Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39121 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab1LOLxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 06:53:55 -0500
Date: Thu, 15 Dec 2011 13:53:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 1/4] omap3isp: Implement validate_pipeline
Message-ID: <20111215115351.GE3677@valkosipuli.localdomain>
References: <20111215095015.GC3677@valkosipuli.localdomain>
 <1323942635-13058-1-git-send-email-sakari.ailus@iki.fi>
 <201112151118.53618.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112151118.53618.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!!!

On Thu, Dec 15, 2011 at 11:18:53AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Thursday 15 December 2011 10:50:32 Sakari Ailus wrote:
> > Validate pipeline of any external entity connected to the ISP driver.
> > The validation of the pipeline for the part that involves links inside the
> > domain of another driver must be done by that very driver.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/omap3isp/ispvideo.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > b/drivers/media/video/omap3isp/ispvideo.c index f229057..17bc03c 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.c
> > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > @@ -355,6 +355,18 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe) fmt_source.format.height != fmt_sink.format.height)
> >  			return -EPIPE;
> > 
> > +		if (subdev->host_priv) {
> > +			/*
> > +			 * host_priv != NULL: this is a sensor. Issue
> > +			 * validate_pipeline. We're at our end of the
> > +			 * pipeline so we quit now.
> > +			 */
> > +			ret = v4l2_subdev_call(subdev, pad, validate_pipeline);
> > +			if (IS_ERR_VALUE(ret))
> 
> Is the validate pipeline operation expected to return a value different than 0 
> on success ? If not if (ret < 0) should do.
> 
> Although there's another issue. Not all sensors will implement the 
> validate_pipeline operation, so you shouldn't return an error if ret == -
> ENOIOCTLCMD.
> 
> I will comment on the validate_pipeline approach itself in the "On controlling 
> sensors" mail thread.

Good point. I'll fix this; same for your comment on the third patch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
