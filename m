Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37023 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932210AbbFRSSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 14:18:08 -0400
Message-ID: <55830B49.7080601@xs4all.nl>
Date: Thu, 18 Jun 2015 20:17:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?windows-1252?Q?Rafael_Louren=E7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH] [media] au0828: Cache the decoder info at au0828 dev
 structure
References: <f1db7aa1f599caa447323f2390e7ffbde5788244.1434648469.git.mchehab@osg.samsung.com>
In-Reply-To: <f1db7aa1f599caa447323f2390e7ffbde5788244.1434648469.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/18/2015 07:27 PM, Mauro Carvalho Chehab wrote:
> Instead of seeking for the decoder every time analog stream is
> started, cache it.
> 
> Requested-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
> index 6b469e8c4c6e..f7337dbbc59f 100644
> --- a/drivers/media/usb/au0828/au0828-cards.c
> +++ b/drivers/media/usb/au0828/au0828-cards.c
> @@ -228,6 +228,10 @@ void au0828_card_analog_fe_setup(struct au0828_dev *dev)
>  				"au8522", 0x8e >> 1, NULL);
>  		if (sd == NULL)
>  			pr_err("analog subdev registration failed\n");
> +#if CONFIG_MEDIA_CONTROLLER
> +		if (sd)
> +			dev->decoder = &sd->entity;
> +#endif
>  	}
>  
>  	/* Setup tuners */
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 4ebe13673adf..939b2ad73501 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -641,11 +641,11 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
>  {
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_device *mdev = dev->media_dev;
> -	struct media_entity  *entity, *decoder = NULL, *source;
> +	struct media_entity  *entity, *source;
>  	struct media_link *link, *found_link = NULL;
>  	int i, ret, active_links = 0;
>  
> -	if (!mdev)
> +	if (!mdev || !dev->decoder)
>  		return 0;
>  
>  	/*
> @@ -655,18 +655,9 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
>  	 * do DVB streaming while the DMA engine is being used for V4L2,
>  	 * this should be enough for the actual needs.
>  	 */
> -	media_device_for_each_entity(entity, mdev) {
> -		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
> -			decoder = entity;
> -			break;
> -		}
> -	}
> -	if (!decoder)
> -		return 0;
> -
> -	for (i = 0; i < decoder->num_links; i++) {
> -		link = &decoder->links[i];
> -		if (link->sink->entity == decoder) {
> +	for (i = 0; i < dev->decoder->num_links; i++) {
> +		link = &dev->decoder->links[i];
> +		if (link->sink->entity == dev->decoder) {
>  			found_link = link;
>  			if (link->flags & MEDIA_LNK_FL_ENABLED)
>  				active_links++;
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index 7e6a3bbc68ab..d3644b3fe6fa 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -280,6 +280,7 @@ struct au0828_dev {
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_device *media_dev;
>  	struct media_pad video_pad, vbi_pad;
> +	struct media_entity *decoder;
>  #endif
>  };
>  
> 

