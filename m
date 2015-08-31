Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50192 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbbHaMCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 08:02:12 -0400
Message-ID: <55E4420C.2030706@xs4all.nl>
Date: Mon, 31 Aug 2015 14:01:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v8 45/55] [media] media: Use a macro to interate between
 all interfaces
References: <cover.1440902901.git.mchehab@osg.samsung.com> <9e511a1a223c99f489330c29f50d099f58d0c34b.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <9e511a1a223c99f489330c29f50d099f58d0c34b.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Just like we do with entities, use a similar macro for the
> interfaces loop.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 610d2bab1368..95b5b4b11230 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -578,9 +578,10 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
>  	}
>  
>  	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
> -	list_for_each_entry(intf, &mdev->interfaces, list) {
> +	media_device_for_each_intf(intf, mdev) {
>  		if (intf->type == MEDIA_INTF_T_DVB_CA && ca)
>  			media_create_intf_link(ca, intf, 0);
> +
>  		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner)
>  			media_create_intf_link(tuner, intf, 0);
>  
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 51807efa505b..f23d686aaac6 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -113,6 +113,11 @@ struct media_device *media_device_find_devres(struct device *dev);
>  #define media_device_for_each_entity(entity, mdev)			\
>  	list_for_each_entry(entity, &(mdev)->entities, list)
>  
> +/* Iterate over all interfaces. */
> +#define media_device_for_each_intf(intf, mdev)			\
> +	list_for_each_entry(intf, &(mdev)->interfaces, list)
> +
> +
>  #else
>  static inline int media_device_register(struct media_device *mdev)
>  {
> 

