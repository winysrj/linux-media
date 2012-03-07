Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:42394 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2CGPYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 10:24:06 -0500
Date: Wed, 7 Mar 2012 17:24:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 25/35] omap3isp: Collect entities that are part of
 the pipeline
Message-ID: <20120307152359.GB1476@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-25-git-send-email-sakari.ailus@iki.fi>
 <6281574.FW0nkSrXHX@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6281574.FW0nkSrXHX@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Mar 07, 2012 at 11:50:19AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Another comment.
> 
> On Tuesday 06 March 2012 18:33:06 Sakari Ailus wrote:
> > Collect entities which are part of the pipeline into a single bit mask.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> [snip]
> 
> > diff --git a/drivers/media/video/omap3isp/ispvideo.h
> > b/drivers/media/video/omap3isp/ispvideo.h index d91bdb91..0423c9d 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.h
> > +++ b/drivers/media/video/omap3isp/ispvideo.h
> > @@ -96,6 +96,7 @@ struct isp_pipeline {
> >  	enum isp_pipeline_stream_state stream_state;
> >  	struct isp_video *input;
> >  	struct isp_video *output;
> > +	u32 entities;
> >  	unsigned long l3_ick;
> >  	unsigned int max_rate;
> >  	atomic_t frame_number;
> 
> Could you please update the structure documentation ?
> 
> @entities: Bitmask of entities in the pipeline (indexed by entity ID)

Sure. I'll take that from your patch. ;-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
