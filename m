Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63155 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2ANUlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 15:41:20 -0500
Received: by werb13 with SMTP id b13so1181861wer.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 12:41:19 -0800 (PST)
Message-ID: <1326573673.2808.1.camel@tvbox>
Subject: Re: [PATCH] [media] [PATCH] don't reset the delivery system on
 DTV_CLEAR
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Sat, 14 Jan 2012 20:41:13 +0000
In-Reply-To: <1326566854.2292.11.camel@tvbox>
References: <1326246270-29272-1-git-send-email-mchehab@redhat.com>
	 <1326566854.2292.11.camel@tvbox>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-01-14 at 18:47 +0000, Malcolm Priestley wrote:
> On Tue, 2012-01-10 at 23:44 -0200, Mauro Carvalho Chehab wrote:
> > As a DVBv3 application may be relying on the delivery system,
> > don't reset it at DTV_CLEAR. For DVBv5 applications, the
> > delivery system should be set anyway.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/media/dvb/dvb-core/dvb_frontend.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> > index a904793..b15db4f 100644
> > --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> > +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> > @@ -909,7 +909,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
> >  
> >  	c->state = DTV_CLEAR;
> >  
> > -	c->delivery_system = fe->ops.delsys[0];
> >  	dprintk("%s() Clearing cache for delivery system %d\n", __func__,
> >  		c->delivery_system);
> >  
> > @@ -2377,6 +2376,8 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
> >  	 * Initialize the cache to the proper values according with the
> >  	 * first supported delivery system (ops->delsys[0])
> >  	 */
> > +
> > +        fe->dtv_property_cache.delivery_system = fe->ops.delsys[0];
> >  	dvb_frontend_clear_cache(fe);
> >  
> >  	mutex_unlock(&frontend_mutex);
> 
> This patch breaks applications.
> 
> Due to the memset in dvb_frontend_clear_cache which clears
> fe->dtv_property_cache.
> ...
> static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
> {
> 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> 	int i;
> 
> 	memset(c, 0, sizeof(struct dtv_frontend_properties));
> ...
> 
> Also, the delivery system can not be reset when making a call to
> DTV_CLEAR.

I have just noticed this is fix with patch;

dvb-core: preserve the delivery system at cache clear



