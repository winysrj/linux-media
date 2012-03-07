Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52535 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab2CGSIK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 13:08:10 -0500
Date: Wed, 7 Mar 2012 20:08:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 33/35] omap3isp: Find source pad from external entity
Message-ID: <20120307180806.GG1476@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-33-git-send-email-sakari.ailus@iki.fi>
 <3442301.74He9Ect2M@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3442301.74He9Ect2M@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!!

On Wed, Mar 07, 2012 at 12:04:01PM +0100, Laurent Pinchart wrote:
> On Tuesday 06 March 2012 18:33:14 Sakari Ailus wrote:
> > No longer assume pad number 0 is the source pad of the external entity. Find
> > the source pad from the external entity and use it instead.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> (with one comment below)
> 
> > ---
> >  drivers/media/video/omap3isp/isp.c |   13 ++++++++++++-
> >  1 files changed, 12 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/isp.c
> > b/drivers/media/video/omap3isp/isp.c index f54953d..0718b0a 100644
> > --- a/drivers/media/video/omap3isp/isp.c
> > +++ b/drivers/media/video/omap3isp/isp.c
> > @@ -1744,6 +1744,7 @@ static int isp_register_entities(struct isp_device
> > *isp) struct media_entity *input;
> >  		unsigned int flags;
> >  		unsigned int pad;
> > +		unsigned int i;
> > 
> >  		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
> >  		if (sensor == NULL)
> > @@ -1791,7 +1792,17 @@ static int isp_register_entities(struct isp_device
> > *isp) goto done;
> >  		}
> > 
> > -		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
> > +		for (i = 0; i < sensor->entity.num_pads; i++)
> > +			if (sensor->entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
> > +				break;
> 
> While not strictly needed, I find the code easier to read with brackets for 
> the for statement. It's up to you though.

Brackets added.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
