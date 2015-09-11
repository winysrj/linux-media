Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59940 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbbIKPtb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 11:49:31 -0400
Message-ID: <55F2F7C3.6030305@xs4all.nl>
Date: Fri, 11 Sep 2015 17:48:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 18/18] [media] dvbdev: Don't create indirect links
References: <cover.1441559233.git.mchehab@osg.samsung.com> <2460617268cac8bbabad0db7372914379f7c8644.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <2460617268cac8bbabad0db7372914379f7c8644.1441559233.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 07:31 PM, Mauro Carvalho Chehab wrote:
> Indirect links are those whose the interface indirectly controls

s/the//

> other functions.
> 
> There are two interfaces that have indirect controls at the DVB
> side:
> - the network interface, with also controls the demux;

s/with/which/

> - the DVR interface with also controls the demux.

ditto

> 
> One could argue that the frontend control to the tuner is indirect.
> Well, that's debateable. There's no way to create subdef interfaces

s/debateable/debatable/
s/subdef/subdev/

> for tuner and demod, as those devices are tightly coupled. So, it
> was decided that just one interface is the best to control both
> entities, and there's no plan (or easy way) to decouple both. So,
> the DVB frontend interface should link to both entities.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

With the typos fixed:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Note: I am not convinced that the dvr->demux indirect link isn't needed, but
it can be enabled later, so it's OK for me to keep it under #if 0 for now.

Regards,

	Hans

> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index ea76fe54e0e4..e9f24c1479dd 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -619,7 +619,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
>  		}
>  	}
>  
> -	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
> +	/* Create interface links for FE->tuner, DVR->demux and CA->ca */
>  	media_device_for_each_intf(intf, mdev) {
>  		if (intf->type == MEDIA_INTF_T_DVB_CA && ca) {
>  			link = media_create_intf_link(ca, intf,
> @@ -634,13 +634,19 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
>  			if (!link)
>  				return -ENOMEM;
>  		}
> -
> +#if 0
> +		/*
> +		 * Indirect link - let's not create yet, as we don't know how
> +		 *		   to handle indirect links, nor if this will
> +		 *		   actually be needed.
> +		 */
>  		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux) {
>  			link = media_create_intf_link(demux, intf,
>  						      MEDIA_LNK_FL_ENABLED);
>  			if (!link)
>  				return -ENOMEM;
>  		}
> +#endif
>  		if (intf->type == MEDIA_INTF_T_DVB_DVR) {
>  			ret = dvb_create_io_intf_links(adap, intf, DVR_TSOUT);
>  			if (ret)
> 


