Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56911 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbbIKPZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 11:25:04 -0400
Message-ID: <55F2F209.7000208@xs4all.nl>
Date: Fri, 11 Sep 2015 17:23:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: =?windows-1252?Q?Rafael_Louren=E7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 11/18] [media] au0828:: enforce check for graph creation
References: <cover.1441559233.git.mchehab@osg.samsung.com> <771213e570c44ef74ba1bed24e9b7c4f1faa353a.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <771213e570c44ef74ba1bed24e9b7c4f1faa353a.1441559233.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> If the graph creation fails, don't register the device.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 35c607c35155..399c6712faf9 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -172,9 +172,9 @@ static void au0828_usb_v4l2_release(struct v4l2_device *v4l2_dev)
>  	struct au0828_dev *dev =
>  		container_of(v4l2_dev, struct au0828_dev, v4l2_dev);
>  
> -	au0828_usb_v4l2_media_release(dev);
>  	v4l2_ctrl_handler_free(&dev->v4l2_ctrl_hdl);
>  	v4l2_device_unregister(&dev->v4l2_dev);
> +	au0828_usb_v4l2_media_release(dev);
>  	au0828_usb_release(dev);
>  }
>  #endif
> @@ -251,16 +251,16 @@ static void au0828_media_device_register(struct au0828_dev *dev,
>  }
>  
>  
> -static void au0828_create_media_graph(struct au0828_dev *dev)
> +static int au0828_create_media_graph(struct au0828_dev *dev)
>  {
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_device *mdev = dev->media_dev;
>  	struct media_entity *entity;
>  	struct media_entity *tuner = NULL, *decoder = NULL;
> -	int i;
> +	int i, ret;
>  
>  	if (!mdev)
> -		return;
> +		return 0;
>  
>  	media_device_for_each_entity(entity, mdev) {
>  		switch (entity->type) {
> @@ -277,15 +277,23 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
>  
>  	/* Something bad happened! */
>  	if (!decoder)
> -		return;
> +		return -EINVAL;
>  
> -	if (tuner)
> -		media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, decoder, 0,
> -				      MEDIA_LNK_FL_ENABLED);
> -	media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
> -			      MEDIA_LNK_FL_ENABLED);
> -	media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
> -			      MEDIA_LNK_FL_ENABLED);
> +	if (tuner) {
> +		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
> +					    decoder, 0,
> +				            MEDIA_LNK_FL_ENABLED);
> +		if (ret)
> +			return ret;
> +	}
> +	ret = media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
> +			 	    MEDIA_LNK_FL_ENABLED);
> +	if (ret)
> +		return ret;
> +	ret = media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
> +				    MEDIA_LNK_FL_ENABLED);
> +	if (ret)
> +		return ret;
>  
>  	for (i = 0; i < AU0828_MAX_INPUT; i++) {
>  		struct media_entity *ent = &dev->input_ent[i];
> @@ -297,20 +305,27 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
>  		case AU0828_VMUX_CABLE:
>  		case AU0828_VMUX_TELEVISION:
>  		case AU0828_VMUX_DVB:
> -			if (tuner)
> -				media_create_pad_link(ent, 0, tuner,
> -						      TUNER_PAD_RF_INPUT,
> -						      MEDIA_LNK_FL_ENABLED);
> +			if (!tuner)
> +				break;
> +
> +			ret = media_create_pad_link(ent, 0, tuner,
> +						    TUNER_PAD_RF_INPUT,
> +						    MEDIA_LNK_FL_ENABLED);
> +			if (ret)
> +				return ret;
>  			break;
>  		case AU0828_VMUX_COMPOSITE:
>  		case AU0828_VMUX_SVIDEO:
>  		default: /* AU0828_VMUX_DEBUG */
>  			/* FIXME: fix the decoder PAD */
> -			media_create_pad_link(ent, 0, decoder, 0, 0);
> +			ret = media_create_pad_link(ent, 0, decoder, 0, 0);
> +			if (ret)
> +				return ret;
>  			break;
>  		}
>  	}
>  #endif
> +	return 0;
>  }
>  
>  static int au0828_usb_probe(struct usb_interface *interface,
> @@ -425,7 +440,12 @@ static int au0828_usb_probe(struct usb_interface *interface,
>  
>  	mutex_unlock(&dev->lock);
>  
> -	au0828_create_media_graph(dev);
> +	retval = au0828_create_media_graph(dev);
> +	if (retval) {
> +		pr_err("%s() au0282_dev_register failed to create graph\n",
> +		       __func__);
> +		au0828_usb_disconnect(interface);
> +	}
>  
>  	return retval;
>  }
> 

