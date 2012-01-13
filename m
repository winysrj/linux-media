Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34642 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2AMQKR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 11:10:17 -0500
Received: by wgbds12 with SMTP id ds12so3252282wgb.1
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2012 08:10:15 -0800 (PST)
Message-ID: <4F105616.20001@gmail.com>
Date: Fri, 13 Jan 2012 17:04:38 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] dvb-core: preserve the delivery system at cache
 clear
References: <4F101940.2020408@gmail.com> <1326462636-8869-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326462636-8869-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 13/01/2012 14:50, Mauro Carvalho Chehab ha scritto:
> The changeset 240ab508aa is incomplete, as the first thing that
> happens at cache clear is to do a memset with 0 to the cache.
> 
> So, the delivery system needs to be explicitly preserved there.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> ---
> 
> If Kaffeine doesn't call FE_SET_PROPERTY for non-DVB-S2, this should
> fix the current issue.
> 
>  drivers/media/dvb/dvb-core/dvb_frontend.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 2ad7faf..f5fa7aa 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -904,8 +904,11 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>  {
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	int i;
> +	u32 delsys;
>  
> +	delsys = c->delivery_system;
>  	memset(c, 0, sizeof(struct dtv_frontend_properties));
> +	c->delivery_system = delsys;
>  
>  	c->state = DTV_CLEAR;
>  

Hi Mauro,
I applied this new patch on top of the current media_build tree and I
can confirm that the issue with Kaffeine is solved.
All of my DVB-T sticks works fine again.

Best regards,
Gianluca
