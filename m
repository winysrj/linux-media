Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55131 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752441AbbKCWoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2015 17:44:54 -0500
Date: Wed, 4 Nov 2015 00:44:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 14/19] v4l: omap3isp: Use media entity enumeration API
Message-ID: <20151103224452.GM17128@valkosipuli.retiisi.org.uk>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
 <1445900510-1398-15-git-send-email-sakari.ailus@iki.fi>
 <20151028103030.0d4adaab@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151028103030.0d4adaab@concha.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Oct 28, 2015 at 10:30:30AM +0900, Mauro Carvalho Chehab wrote:
> Em Tue, 27 Oct 2015 01:01:45 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/platform/omap3isp/isp.c      | 21 +++++++++++++--------
> >  drivers/media/platform/omap3isp/isp.h      |  5 +++--
> >  drivers/media/platform/omap3isp/ispccdc.c  |  2 +-
> >  drivers/media/platform/omap3isp/ispvideo.c | 20 ++++++++++++++------
> >  drivers/media/platform/omap3isp/ispvideo.h |  4 ++--
> >  5 files changed, 33 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> > index 4a01a36..61c128e 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -896,7 +896,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
> >  	 * starting entities if the pipeline won't start anyway (those entities
> >  	 * would then likely fail to stop, making the problem worse).
> >  	 */
> > -	if (pipe->entities & isp->crashed)
> > +	if (media_entity_enum_intersects(&pipe->entities, &isp->crashed))
> >  		return -EIO;
> 
> If the size of entities/crashed enums is different, it should be
> returning an error, I guess, as this would be a driver's problem, and the
> graph traversal on OMAP3 would likely be wrong.

They should always have the same size. The omap3isp does not support dynamic
entity (un)registration. Both enums are initialised once all the entities
have been registered.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
