Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39408 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbbKWWfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 17:35:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v8 45/55] [media] media: Use a macro to interate between all interfaces
Date: Tue, 24 Nov 2015 00:36:04 +0200
Message-ID: <5987917.OMoM1bBMFU@avalon>
In-Reply-To: <3d9230b2ced520c413291a5f69ed7ef672920194.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <3d9230b2ced520c413291a5f69ed7ef672920194.1441540862.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

In the subject line, s/interate between all/iterate over all/

On Sunday 06 September 2015 09:03:05 Mauro Carvalho Chehab wrote:
> Just like we do with entities, use a similar macro for the
> interfaces loop.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c
> b/drivers/media/dvb-core/dvbdev.c index 6babc688801b..f00f1a5f279c 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -578,9 +578,10 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
>  	}
> 
>  	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca 
*/
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
> @@ -113,6 +113,11 @@ struct media_device *media_device_find_devres(struct
> device *dev); #define media_device_for_each_entity(entity, mdev)			\
>  	list_for_each_entry(entity, &(mdev)->entities, list)
> 
> +/* Iterate over all interfaces. */
> +#define media_device_for_each_intf(intf, mdev)			\
> +	list_for_each_entry(intf, &(mdev)->interfaces, list)
> +
> +

One blank line should be enough.

>  #else
>  static inline int media_device_register(struct media_device *mdev)
>  {

-- 
Regards,

Laurent Pinchart

