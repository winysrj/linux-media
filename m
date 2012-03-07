Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:57056 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab2CGSCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 13:02:32 -0500
Date: Wed, 7 Mar 2012 20:02:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 30/35] omap3isp: Move CCDC link validation to
 ccdc_link_validate()
Message-ID: <20120307180225.GF1476@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-30-git-send-email-sakari.ailus@iki.fi>
 <1437113.Q2NA52b0Is@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1437113.Q2NA52b0Is@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments.

On Wed, Mar 07, 2012 at 12:00:48PM +0100, Laurent Pinchart wrote:
> On Tuesday 06 March 2012 18:33:11 Sakari Ailus wrote:
> > Perform CCDC link validation in ccdc_link_validate() instead of
> > isp_video_validate_pipeline(). Also perform maximum data rate check in
> > isp_video_check_external_subdevs().
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> [snip]
> 
> > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > b/drivers/media/video/omap3isp/ispvideo.c index 6d4ad87..51075b3 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.c
> > +++ b/drivers/media/video/omap3isp/ispvideo.c
> 
> [snip]
> 
> > @@ -950,6 +867,7 @@ static int isp_video_check_external_subdevs(struct
> > isp_pipeline *pipe) struct v4l2_subdev_format fmt;
> >  	struct v4l2_ext_controls ctrls;
> >  	struct v4l2_ext_control ctrl;
> > +	unsigned int rate = UINT_MAX;
> 
> You can move this variable inside the if statement below.

Fixed.

> >  	int i;
> >  	int ret = 0;
> > 
> > @@ -1002,6 +920,16 @@ static int isp_video_check_external_subdevs(struct
> > isp_pipeline *pipe)
> > 
> >  	pipe->external_rate = ctrl.value64;
> > 
> > +	if (pipe->entities & (1 << isp->isp_ccdc.subdev.entity.id)) {
> > +		/*
> > +		 * Check that maximum allowed CCDC pixel rate isn't
> > +		 * exceeded by the pixel rate.
> 
> What's wrong with 80 columns, really ? :-)

Is it said somewhere in CodingStyle the comments have to be wrapped at 80
characters and no earlier? It's like speed limits: you are allowed to drive
slower than the limit. :-)

> > +		 */
> > +		omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
> > +		if (pipe->external_rate > rate)
> > +			return -ENOSPC;
> > +	}
> > +
> >  	return 0;
> >  }
> 
> Pending those two changes,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks. :-)

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
