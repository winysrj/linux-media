Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53255 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbcCKQBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 11:01:00 -0500
Date: Fri, 11 Mar 2016 13:00:54 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] [media] au0828: disable tuner->decoder on init
Message-ID: <20160311130054.68723d6e@recife.lan>
In-Reply-To: <56E1ED8E.8080401@osg.samsung.com>
References: <436107c4db642cdab28d3f26ccc918f3c6e52e38.1457639860.git.mchehab@osg.samsung.com>
	<56E1ED8E.8080401@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Mar 2016 14:56:30 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 03/10/2016 12:57 PM, Mauro Carvalho Chehab wrote:
> > As au0828 assumes that all links to ATV decoder and DTV demod
> > should be disabled, make sure this is the case.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> >  drivers/media/usb/au0828/au0828-core.c | 19 +++++++++++--------
> >  1 file changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> > index 5dc82e8c8670..af68663915fd 100644
> > --- a/drivers/media/usb/au0828/au0828-core.c
> > +++ b/drivers/media/usb/au0828/au0828-core.c
> > @@ -456,7 +456,9 @@ static int au0828_media_device_register(struct au0828_dev *dev,
> >  {
> >  #ifdef CONFIG_MEDIA_CONTROLLER
> >  	int ret;
> > -	struct media_entity *entity, *demod = NULL, *tuner = NULL;
> > +	struct media_entity *entity;
> > +	struct media_entity *demod = NULL, *tuner = NULL, *decoder = NULL;
> > +	struct media_link *link;
> >  
> >  	if (!dev->media_dev)
> >  		return 0;
> > @@ -490,18 +492,19 @@ static int au0828_media_device_register(struct au0828_dev *dev,
> >  	media_device_for_each_entity(entity, dev->media_dev) {
> >  		if (entity->function == MEDIA_ENT_F_DTV_DEMOD)
> >  			demod = entity;
> > +		else if (entity->function == MEDIA_ENT_F_ATV_DECODER)
> > +			decoder = entity;
> >  		else if (entity->function == MEDIA_ENT_F_TUNER)
> >  			tuner = entity;
> >  	}
> > -	/* Disable link between tuner and demod */
> > -	if (tuner && demod) {
> > -		struct media_link *link;
> >  
> > -		list_for_each_entry(link, &demod->links, list) {
> > -			if (link->sink->entity == demod &&
> > -			    link->source->entity == tuner) {
> > +	/* Disable link between tuner->demod and/or tuner->decoder */
> > +	if (tuner) {
> > +		list_for_each_entry(link, &tuner->links, list) {
> > +			if (demod && link->sink->entity == demod)
> > +				media_entity_setup_link(link, 0);
> > +			if (decoder && link->sink->entity == decoder)
> >  				media_entity_setup_link(link, 0);
> > -			}
> >  		}
> >  	}
> >  
> >   
> 
> You probably don't need this patch if we revert the common
> graph create patch. We will need this when we get the common
> routine working.

Yes. I actually folded it on the patch caching tuner and decoder,
with is also needed for the common routine to work (as the core
knows nothing about any au0828-specific caching).

At the end of the day, we'll need to remove the cache as a hole, as
we move the au0828_enable_source to the core.

Regards,
Mauro

Thanks,
Mauro
