Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53405 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbcCLXw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2016 18:52:28 -0500
Subject: Re: [PATCH 1/2 v2] [media] au0828: disable tuner links and cache
 tuner/decoder
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <56E2F7E5.7060503@osg.samsung.com>
 <9bc59a78a1e89a5486afd5a1e6fa8293fefea3f6.1457722871.git.mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E4ABB9.10903@osg.samsung.com>
Date: Sat, 12 Mar 2016 16:52:25 -0700
MIME-Version: 1.0
In-Reply-To: <9bc59a78a1e89a5486afd5a1e6fa8293fefea3f6.1457722871.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2016 12:02 PM, Mauro Carvalho Chehab wrote:
> For au0828_enable_source() to work, the tuner links should be
> disabled and the tuner/decoder should be cached at au0828 struct.
> 
> While here, put dev->decoder cache together with dev->tuner, as
> it makes easier to drop both latter if/when we move the enable
> routines to the V4L2 core.
> 
> Fixes: 9822f4173f84 ('[media] au0828: use v4l2_mc_create_media_graph()')
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Thanks for chasing this down. Looking good. I tested it applying
it to the latest media_tree git with this top commit:
commit 840f5b0572ea9ddaca2bf5540a171013e92c97bd
Author: Shuah Khan <shuahkh@osg.samsung.com>
Date:   Wed Mar 9 19:15:38 2016 -0700

    media: au0828 disable tuner to demod link in au0828_media_device_register()

I ran though my basic and mutual exclusion test cases and graphs
look correct at every stage.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Tested-by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah

> ---
>  drivers/media/usb/au0828/au0828-cards.c |  4 ----
>  drivers/media/usb/au0828/au0828-core.c  | 42 +++++++++++++++++++++------------
>  2 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
> index ca861aea68a5..6b469e8c4c6e 100644
> --- a/drivers/media/usb/au0828/au0828-cards.c
> +++ b/drivers/media/usb/au0828/au0828-cards.c
> @@ -228,10 +228,6 @@ void au0828_card_analog_fe_setup(struct au0828_dev *dev)
>  				"au8522", 0x8e >> 1, NULL);
>  		if (sd == NULL)
>  			pr_err("analog subdev registration failed\n");
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -		if (sd)
> -			dev->decoder = &sd->entity;
> -#endif
>  	}
>  
>  	/* Setup tuners */
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 5dc82e8c8670..ecfa18939663 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -456,7 +456,8 @@ static int au0828_media_device_register(struct au0828_dev *dev,
>  {
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	int ret;
> -	struct media_entity *entity, *demod = NULL, *tuner = NULL;
> +	struct media_entity *entity, *demod = NULL;
> +	struct media_link *link;
>  
>  	if (!dev->media_dev)
>  		return 0;
> @@ -482,26 +483,37 @@ static int au0828_media_device_register(struct au0828_dev *dev,
>  	}
>  
>  	/*
> -	 * Find tuner and demod to disable the link between
> -	 * the two to avoid disable step when tuner is requested
> -	 * by video or audio. Note that this step can't be done
> -	 * until dvb graph is created during dvb register.
> +	 * Find tuner, decoder and demod.
> +	 *
> +	 * The tuner and decoder should be cached, as they'll be used by
> +	 *	au0828_enable_source.
> +	 *
> +	 * It also needs to disable the link between tuner and
> +	 * decoder/demod, to avoid disable step when tuner is requested
> +	 * by video or audio. Note that this step can't be done until dvb
> +	 * graph is created during dvb register.
>  	*/
>  	media_device_for_each_entity(entity, dev->media_dev) {
> -		if (entity->function == MEDIA_ENT_F_DTV_DEMOD)
> +		switch (entity->function) {
> +		case MEDIA_ENT_F_TUNER:
> +			dev->tuner = entity;
> +			break;
> +		case MEDIA_ENT_F_ATV_DECODER:
> +			dev->decoder = entity;
> +			break;
> +		case MEDIA_ENT_F_DTV_DEMOD:
>  			demod = entity;
> -		else if (entity->function == MEDIA_ENT_F_TUNER)
> -			tuner = entity;
> +			break;
> +		}
>  	}
> -	/* Disable link between tuner and demod */
> -	if (tuner && demod) {
> -		struct media_link *link;
>  
> -		list_for_each_entry(link, &demod->links, list) {
> -			if (link->sink->entity == demod &&
> -			    link->source->entity == tuner) {
> +	/* Disable link between tuner->demod and/or tuner->decoder */
> +	if (dev->tuner) {
> +		list_for_each_entry(link, &dev->tuner->links, list) {
> +			if (demod && link->sink->entity == demod)
> +				media_entity_setup_link(link, 0);
> +			if (dev->decoder && link->sink->entity == dev->decoder)
>  				media_entity_setup_link(link, 0);
> -			}
>  		}
>  	}
>  
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
