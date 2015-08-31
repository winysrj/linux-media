Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53838 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbbHaLuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:50:50 -0400
Message-ID: <55E43F5F.4010707@xs4all.nl>
Date: Mon, 31 Aug 2015 13:49:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>, Joe Perches <joe@perches.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Vaishali Thakkar <vthakkar1994@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Takeshi Yoshimura <yos@sslab.ics.keio.ac.jp>,
	linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH v8 42/55] [media] dvb: modify core to implement interfaces/entities
 at MC new gen
References: <cover.1440902901.git.mchehab@osg.samsung.com> <13388f87683ec54554a57235d8ecc2713c740087.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <13388f87683ec54554a57235d8ecc2713c740087.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> The Media Controller New Generation redefines the types for both
> interfaces and entities to be used on DVB. Make the needed
> changes at the DVB core for all interfaces, entities and
> data and interface links to appear in the graph.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index d0e3f9d85f34..baaed28ee975 100644
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -1242,9 +1242,9 @@ int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
>  	}
>  
>  	dvb_register_device(dvb_adapter, &dmxdev->dvbdev, &dvbdev_demux, dmxdev,
> -			    DVB_DEVICE_DEMUX);
> +			    DVB_DEVICE_DEMUX, dmxdev->filternum);
>  	dvb_register_device(dvb_adapter, &dmxdev->dvr_dvbdev, &dvbdev_dvr,
> -			    dmxdev, DVB_DEVICE_DVR);
> +			    dmxdev, DVB_DEVICE_DVR, dmxdev->filternum);
>  
>  	dvb_ringbuffer_init(&dmxdev->dvr_buffer, NULL, 8192);
>  
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
> index fb66184dc9b6..f82cd1ff4f3a 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> @@ -1695,7 +1695,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
>  	pubca->private = ca;
>  
>  	/* register the DVB device */
> -	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA);
> +	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA, 0);
>  	if (ret)
>  		goto free_slot_info;
>  
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 2d06bcff0946..58601bfe0b8d 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2754,7 +2754,7 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
>  			fe->dvb->num, fe->id, fe->ops.info.name);
>  
>  	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
> -			     fe, DVB_DEVICE_FRONTEND);
> +			     fe, DVB_DEVICE_FRONTEND, 0);
>  
>  	/*
>  	 * Initialize the cache to the proper values according with the
> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index b81e026edab3..14f51b68f4fe 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -1503,6 +1503,6 @@ int dvb_net_init (struct dvb_adapter *adap, struct dvb_net *dvbnet,
>  		dvbnet->state[i] = 0;
>  
>  	return dvb_register_device(adap, &dvbnet->dvbdev, &dvbdev_net,
> -			     dvbnet, DVB_DEVICE_NET);
> +			     dvbnet, DVB_DEVICE_NET, 0);
>  }
>  EXPORT_SYMBOL(dvb_net_init);
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 88013d1a2c39..f638c67defbe 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -180,18 +180,86 @@ skip:
>  	return -ENFILE;
>  }
>  
> +static void dvb_create_tsout_entity(struct dvb_device *dvbdev,
> +				    const char *name, int npads)
> +{
> +#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> +	int i, ret = 0;
> +
> +	dvbdev->tsout_pads = kcalloc(npads, sizeof(*dvbdev->tsout_pads),
> +				     GFP_KERNEL);
> +	if (!dvbdev->tsout_pads)
> +		return;
> +	dvbdev->tsout_entity = kcalloc(npads, sizeof(*dvbdev->tsout_entity),
> +				       GFP_KERNEL);
> +	if (!dvbdev->tsout_entity) {
> +		kfree(dvbdev->tsout_pads);
> +		dvbdev->tsout_pads = NULL;
> +		return;
> +	}
> +	for (i = 0; i < npads; i++) {
> +		struct media_pad *pads = &dvbdev->tsout_pads[i];
> +		struct media_entity *entity = &dvbdev->tsout_entity[i];
> +
> +		entity->name = kasprintf(GFP_KERNEL, "%s #%d", name, i);
> +		if (!entity->name) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		entity->type = MEDIA_ENT_T_DVB_TSOUT;
> +		pads->flags = MEDIA_PAD_FL_SINK;
> +
> +		ret = media_entity_init(entity, 1, pads);
> +		if (ret < 0)
> +			break;
> +
> +		ret = media_device_register_entity(dvbdev->adapter->mdev,
> +						   entity);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	if (!ret) {
> +		dvbdev->tsout_num_entities = npads;
> +		return;
> +	}
> +
> +	for (i--; i >= 0; i--) {
> +		media_device_unregister_entity(&dvbdev->tsout_entity[i]);
> +		kfree(dvbdev->tsout_entity[i].name);
> +	}
> +
> +	printk(KERN_ERR
> +		"%s: media_device_register_entity failed for %s\n",
> +		__func__, name);
> +
> +	kfree(dvbdev->tsout_entity);
> +	kfree(dvbdev->tsout_pads);
> +	dvbdev->tsout_entity = NULL;
> +	dvbdev->tsout_pads = NULL;
> +#endif
> +}
> +
> +#define DEMUX_TSOUT	"demux_tsout"
> +#define DVR_TSOUT	"dvr_tsout"
> +

I have a preference for - instead of _.

Your choice, though.

Regards,

	Hans
