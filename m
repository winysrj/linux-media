Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54197 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752799AbbFJViN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 17:38:13 -0400
Date: Thu, 11 Jun 2015 00:38:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] omap3isp: Fix sub-device power management code
Message-ID: <20150610213811.GR5904@valkosipuli.retiisi.org.uk>
References: <1432855083-25969-1-git-send-email-sakari.ailus@iki.fi>
 <2107807.pFBTyZhm9E@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2107807.pFBTyZhm9E@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Jun 10, 2015 at 03:52:50AM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday 29 May 2015 02:17:47 Sakari Ailus wrote:
> > The power management code was reworked a little due to interface changes in
> > the MC. Due to those changes the power management broke a bit, fix it so the
> > functionality is reverted to old behaviour.
> 
> I found the commit message a bit vague. How about
> 
> "Commit 813f5c0ac5cc ("media: Change media device link_notify behaviour") 
> modified the media controller link setup notification API and updated the 
> OMAP3 ISP driver accordingly. As a side effect it introduced a bug by turning 
> power on after setting the link instead of before. This results in powered off 
> entities being accessed. Fix it."
> 
> Or have I misunderstood the problem ?

Not entirely, but it's not just that: depending on the order in which the
links are changed and the video nodes opened or closed, the use counts may
end up being too high or too low (even negative).

> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Fixes: 813f5c0ac5cc [media] media: Change media device link_notify behaviour
> > Cc: stable@vger.kernel.org # since v3.10
> > ---
> >  drivers/media/platform/omap3isp/isp.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index a038c05..3e6b97b 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -829,14 +829,14 @@ static int isp_pipeline_link_notify(struct media_link
> > *link, u32 flags, int ret;
> > 
> >  	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> > -	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
> > +	    !(flags & MEDIA_LNK_FL_ENABLED)) {
> 
> Isn't link->flags == flags in the post notification callback ?

It is. IMO it's better to use flags here still. So below is the actual
functional change.

> 
> >  		/* Powering off entities is assumed to never fail. */
> >  		isp_pipeline_pm_power(source, -sink_use);
> >  		isp_pipeline_pm_power(sink, -source_use);
> >  		return 0;
> >  	}
> > 
> > -	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> > +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
> >  		(flags & MEDIA_LNK_FL_ENABLED)) {
> > 
> >  		ret = isp_pipeline_pm_power(source, sink_use);
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
