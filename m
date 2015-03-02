Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42833 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbbCBOHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 09:07:25 -0500
Message-ID: <54F46E83.2010008@xs4all.nl>
Date: Mon, 02 Mar 2015 15:06:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?windows-1252?Q?Rafael_Louren=E7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
Subject: Re: [PATCH 1/2] [media] dvbdev: use adapter arg for dvb_create_media_graph()
References: <b32471cf9f1ac95ae4bf181c7abfcbd6382554d7.1425304947.git.mchehab@osg.samsung.com>
In-Reply-To: <b32471cf9f1ac95ae4bf181c7abfcbd6382554d7.1425304947.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Small nitpick:

On 03/02/2015 03:02 PM, Mauro Carvalho Chehab wrote:
> Instead of using media_dev argument for dvb_create_media_graph(),
> use the adapter.
> 
> That allows to create a stub for this function, if compiled
> without DVB support, avoiding to add extra if's at the drivers.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
> index dd3c1516013f..387db145d37e 100644
> --- a/drivers/media/common/siano/smsdvb-main.c
> +++ b/drivers/media/common/siano/smsdvb-main.c
> @@ -1185,7 +1185,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
>  	if (smsdvb_debugfs_create(client) < 0)
>  		pr_info("failed to create debugfs node\n");
>  
> -	dvb_create_media_graph(coredev->media_dev);
> +	dvb_create_media_graph(&client->adapter);
>  
>  	pr_info("DVB interface registered.\n");
>  	return 0;
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 0af9d0c5f889..13bb57f0457f 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -381,9 +381,10 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
>  EXPORT_SYMBOL(dvb_unregister_device);
>  
>  
> -void dvb_create_media_graph(struct media_device *mdev)
> -{
>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> +void dvb_create_media_graph(struct dvb_adapter *adap)
> +{
> +	struct media_device *mdev = adap->mdev;
>  	struct media_entity *entity, *tuner = NULL, *fe = NULL;
>  	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
>  
> @@ -421,9 +422,9 @@ void dvb_create_media_graph(struct media_device *mdev)
>  
>  	if (demux && ca)
>  		media_entity_create_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
> -#endif
>  }
>  EXPORT_SYMBOL_GPL(dvb_create_media_graph);
> +#endif
>  
>  static int dvbdev_check_free_adapter_num(int num)
>  {
> diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
> index 467c1311bd4c..caf4d4791a8b 100644
> --- a/drivers/media/dvb-core/dvbdev.h
> +++ b/drivers/media/dvb-core/dvbdev.h
> @@ -122,7 +122,12 @@ extern int dvb_register_device (struct dvb_adapter *adap,
>  				int type);
>  
>  extern void dvb_unregister_device (struct dvb_device *dvbdev);
> -void dvb_create_media_graph(struct media_device *mdev);
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> +void dvb_create_media_graph(struct dvb_adapter *adap);
> +#else
> +static inline void dvb_create_media_graph(struct dvb_adapter *adap) {};

Unnecessary trailing ';'.

Regards,

	Hans

> +#endif
>  
>  extern int dvb_generic_open (struct inode *inode, struct file *file);
>  extern int dvb_generic_release (struct inode *inode, struct file *file);
> diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> index 44229a2c2d32..8bf2baae387f 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> @@ -540,9 +540,8 @@ static int register_dvb(struct cx231xx_dvb *dvb,
>  
>  	/* register network adapter */
>  	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -	dvb_create_media_graph(dev->media_dev);
> -#endif
> +	dvb_create_media_graph(&dvb->adapter);
> +
>  	return 0;
>  
>  fail_fe_conn:
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> index 0666c8f33ac7..08a3cd1c8b44 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> @@ -702,7 +702,7 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  		}
>  	}
>  
> -	dvb_create_media_graph(adap->dvb_adap.mdev);
> +	dvb_create_media_graph(&adap->dvb_adap);
>  
>  	return 0;
>  
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> index a7bc4535c58f..6c9f5ecf949c 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> @@ -320,7 +320,7 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  		adap->num_frontends_initialized++;
>  	}
>  
> -	dvb_create_media_graph(adap->dvb_adap.mdev);
> +	dvb_create_media_graph(&adap->dvb_adap);
>  
>  	return 0;
>  }
> 
