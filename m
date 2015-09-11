Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45855 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbbIKPYE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 11:24:04 -0400
Message-ID: <55F2F1CA.9030201@xs4all.nl>
Date: Fri, 11 Sep 2015 17:22:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?windows-1252?Q?Rafael_Louren=E7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Michael Ira Krufky <mkrufky@linuxtv.org>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Luis de Bethencourt <luis@debethencourt.com>
Subject: Re: [PATCH 08/18] [media] dvb core: must check dvb_create_media_graph()
References: <cover.1441559233.git.mchehab@osg.samsung.com> <fbc05ef2908903fe1978ed1df68aecc8464efdfc.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <fbc05ef2908903fe1978ed1df68aecc8464efdfc.1441559233.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> If media controller is enabled and mdev is filled, it should
> ensure that the media graph will be properly initialized.
> 
> Enforce that.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
> index f4305ae800f4..ab345490a43a 100644
> --- a/drivers/media/common/siano/smsdvb-main.c
> +++ b/drivers/media/common/siano/smsdvb-main.c
> @@ -1183,7 +1183,11 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
>  	if (smsdvb_debugfs_create(client) < 0)
>  		pr_info("failed to create debugfs node\n");
>  
> -	dvb_create_media_graph(&client->adapter);
> +	rc = dvb_create_media_graph(&client->adapter);
> +	if (rc < 0) {
> +		pr_err("dvb_create_media_graph failed %d\n", rc);
> +		goto client_error;
> +	}
>  
>  	pr_info("DVB interface registered.\n");
>  	return 0;
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 5c51084a331a..df2fe4cc2d47 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -430,17 +430,6 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
>  		return -ENOMEM;
>  	}
>  
> -	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
> -	if (ret) {
> -		printk(KERN_ERR
> -		      "%s: dvb_register_media_device failed to create the mediagraph\n",
> -		      __func__);
> -
> -		dvb_media_device_free(dvbdev);
> -		mutex_unlock(&dvbdev_register_lock);
> -		return ret;
> -	}
> -
>  	dvbdevfops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
>  
>  	if (!dvbdevfops){
> @@ -493,6 +482,17 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
>  		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
>  		return PTR_ERR(clsdev);
>  	}
> +
> +	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
> +	if (ret) {
> +		printk(KERN_ERR
> +		      "%s: dvb_register_media_device failed to create the media graph\n",
> +		      __func__);
> +
> +		dvb_unregister_device(dvbdev);
> +		return ret;
> +	}
> +
>  	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
>  		adap->num, dnames[type], id, minor, minor);
>  
> diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
> index 9e24aafeb9ea..bd9fac91c7b9 100644
> --- a/drivers/media/dvb-core/dvbdev.h
> +++ b/drivers/media/dvb-core/dvbdev.h
> @@ -210,7 +210,7 @@ int dvb_register_device(struct dvb_adapter *adap,
>  void dvb_unregister_device(struct dvb_device *dvbdev);
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -int dvb_create_media_graph(struct dvb_adapter *adap);
> +__must_check int dvb_create_media_graph(struct dvb_adapter *adap);
>  static inline void dvb_register_media_controller(struct dvb_adapter *adap,
>  						 struct media_device *mdev)
>  {
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> index c01772c4f9f0..cd542b49a6c2 100644
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -486,12 +486,14 @@ static int dvb_register(struct au0828_dev *dev)
>  	dvb->start_count = 0;
>  	dvb->stop_count = 0;
>  
> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -	dvb_create_media_graph(&dvb->adapter);
> -#endif
> +	result = dvb_create_media_graph(&dvb->adapter);
> +	if (result < 0)
> +		goto fail_create_graph;
>  
>  	return 0;
>  
> +fail_create_graph:
> +	dvb_net_release(&dvb->net);
>  fail_fe_conn:
>  	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
>  fail_fe_mem:
> diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> index 66ee161fc7ba..aaf8ef246f13 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> @@ -551,10 +551,14 @@ static int register_dvb(struct cx231xx_dvb *dvb,
>  
>  	/* register network adapter */
>  	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
> -	dvb_create_media_graph(&dvb->adapter);
> +	result = dvb_create_media_graph(&dvb->adapter);
> +	if (result < 0)
> +		goto fail_create_graph;
>  
>  	return 0;
>  
> +fail_create_graph:
> +	dvb_net_release(&dvb->net);
>  fail_fe_conn:
>  	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
>  fail_fe_mem:
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> index f5df9eaba04f..6d3f61f6dc77 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> @@ -698,7 +698,9 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  		}
>  	}
>  
> -	dvb_create_media_graph(&adap->dvb_adap);
> +	ret = dvb_create_media_graph(&adap->dvb_adap);
> +	if (ret < 0)
> +		goto err_dvb_unregister_frontend;
>  
>  	return 0;
>  
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> index 8a260c854653..b51dbdf03f42 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> @@ -318,10 +318,12 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  
>  		adap->num_frontends_initialized++;
>  	}
> +	if (ret)
> +		return ret;
>  
> -	dvb_create_media_graph(&adap->dvb_adap);
> +	ret = dvb_create_media_graph(&adap->dvb_adap);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  int dvb_usb_adapter_frontend_exit(struct dvb_usb_adapter *adap)
> 

