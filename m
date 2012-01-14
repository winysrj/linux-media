Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45581 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab2ANSro (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 13:47:44 -0500
Received: by wgbds12 with SMTP id ds12so4161472wgb.1
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 10:47:43 -0800 (PST)
Message-ID: <1326566854.2292.11.camel@tvbox>
Subject: Re: [PATCH] [media] [PATCH] don't reset the delivery system on
 DTV_CLEAR
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Sat, 14 Jan 2012 18:47:34 +0000
In-Reply-To: <1326246270-29272-1-git-send-email-mchehab@redhat.com>
References: <1326246270-29272-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-01-10 at 23:44 -0200, Mauro Carvalho Chehab wrote:
> As a DVBv3 application may be relying on the delivery system,
> don't reset it at DTV_CLEAR. For DVBv5 applications, the
> delivery system should be set anyway.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index a904793..b15db4f 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -909,7 +909,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>  
>  	c->state = DTV_CLEAR;
>  
> -	c->delivery_system = fe->ops.delsys[0];
>  	dprintk("%s() Clearing cache for delivery system %d\n", __func__,
>  		c->delivery_system);
>  
> @@ -2377,6 +2376,8 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
>  	 * Initialize the cache to the proper values according with the
>  	 * first supported delivery system (ops->delsys[0])
>  	 */
> +
> +        fe->dtv_property_cache.delivery_system = fe->ops.delsys[0];
>  	dvb_frontend_clear_cache(fe);
>  
>  	mutex_unlock(&frontend_mutex);

This patch breaks applications.

Due to the memset in dvb_frontend_clear_cache which clears
fe->dtv_property_cache.
...
static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
{
	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
	int i;

	memset(c, 0, sizeof(struct dtv_frontend_properties));
...

Also, the delivery system can not be reset when making a call to
DTV_CLEAR.

So the delivery system must be set dvb_frontend_clear_cache.

Regards


Malcolm

