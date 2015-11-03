Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55000 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755197AbbKCWWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2015 17:22:40 -0500
Date: Wed, 4 Nov 2015 00:22:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 04/19] media: Move struct media_entity_graph definition up
Message-ID: <20151103222238.GJ17128@valkosipuli.retiisi.org.uk>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
 <1445900510-1398-5-git-send-email-sakari.ailus@iki.fi>
 <20151028093650.67648946@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151028093650.67648946@concha.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Oct 28, 2015 at 09:36:50AM +0900, Mauro Carvalho Chehab wrote:
> Em Tue, 27 Oct 2015 01:01:35 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > It will be needed in struct media_pipeline shortly.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Reviewed-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> (but see below)
> 
> > ---
> >  include/media/media-entity.h | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index fc54192..dde9a5f 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -87,6 +87,16 @@ struct media_entity_enum {
> >  	int idx_max;
> >  };
> >  
> > +struct media_entity_graph {
> 
> Not a problem on this patch itself, but since you're touching this
> struct, it would be nice to take the opportunity and document it ;)

I'll document it in a separate patch on top of the set. Would you be fine
with that?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
