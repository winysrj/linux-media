Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39093 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbbIKO6e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:58:34 -0400
Message-ID: <55F2EBD2.2010603@xs4all.nl>
Date: Fri, 11 Sep 2015 16:57:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: =?windows-1252?Q?Rafael_Louren=E7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH 02/18] [media] au0828: add support for the connectors
References: <cover.1441559233.git.mchehab@osg.samsung.com> <03ff3c6c6ee5ddc03ddbfd3f0da5bb4a4f13c8a6.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <03ff3c6c6ee5ddc03ddbfd3f0da5bb4a4f13c8a6.1441559233.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> Depending on the input, an au0828 may have a different
> number of connectors. add entities to represent them.

Hmm, this patch uses the new connector defines that are only added in patch 6!
So this doesn't compile.

Is there a reason why the connector support is needed now? I would prefer to have
this in a separate follow-up patch series.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index f54c7d10f350..fe9a60484343 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -153,11 +153,26 @@ static void au0828_usb_release(struct au0828_dev *dev)
>  }
>  
>  #ifdef CONFIG_VIDEO_AU0828_V4L2
> +
> +static void au0828_usb_v4l2_media_release(struct au0828_dev *dev)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	int i;
> +
> +	for (i = 0; i < AU0828_MAX_INPUT; i++) {
> +		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
> +			return;
> +		media_device_unregister_entity(&dev->input_ent[i]);
> +	}
> +#endif
> +}
> +
>  static void au0828_usb_v4l2_release(struct v4l2_device *v4l2_dev)
>  {
>  	struct au0828_dev *dev =
>  		container_of(v4l2_dev, struct au0828_dev, v4l2_dev);
>  
> +	au0828_usb_v4l2_media_release(dev);
>  	v4l2_ctrl_handler_free(&dev->v4l2_ctrl_hdl);
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  	au0828_usb_release(dev);
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 4511e2893282..806b8d320bae 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1793,6 +1793,69 @@ static int au0828_vb2_setup(struct au0828_dev *dev)
>  	return 0;
>  }
>  
> +static void au0828_analog_create_entities(struct au0828_dev *dev)
> +{
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	static const char *inames[] = {
> +		[AU0828_VMUX_COMPOSITE] = "Composite",
> +		[AU0828_VMUX_SVIDEO] = "S-Video",
> +		[AU0828_VMUX_CABLE] = "Cable TV",
> +		[AU0828_VMUX_TELEVISION] = "Television",
> +		[AU0828_VMUX_DVB] = "DVB",
> +		[AU0828_VMUX_DEBUG] = "tv debug"
> +	};
> +	int ret, i;
> +
> +	/* Initialize Video and VBI pads */
> +	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
> +	ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad);
> +	if (ret < 0)
> +		pr_err("failed to initialize video media entity!\n");
> +
> +	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
> +	ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad);
> +	if (ret < 0)
> +		pr_err("failed to initialize vbi media entity!\n");
> +
> +	/* Create entities for each input connector */
> +	for (i = 0; i < AU0828_MAX_INPUT; i++) {
> +		struct media_entity *ent = &dev->input_ent[i];
> +
> +		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
> +			break;
> +
> +		ent->name = inames[AUVI_INPUT(i).type];
> +		ent->flags = MEDIA_ENT_FL_CONNECTOR;
> +		dev->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
> +
> +		switch(AUVI_INPUT(i).type) {
> +		case AU0828_VMUX_COMPOSITE:
> +			ent->type = MEDIA_ENT_T_CONN_COMPOSITE;
> +			break;
> +		case AU0828_VMUX_SVIDEO:
> +			ent->type = MEDIA_ENT_T_CONN_SVIDEO;
> +			break;
> +		case AU0828_VMUX_CABLE:
> +		case AU0828_VMUX_TELEVISION:
> +		case AU0828_VMUX_DVB:
> +			ent->type = MEDIA_ENT_T_CONN_RF;
> +			break;
> +		default: /* AU0828_VMUX_DEBUG */
> +			ent->type = MEDIA_ENT_T_CONN_TEST;
> +			break;
> +		}
> +
> +		ret = media_entity_init(ent, 1, &dev->input_pad[i]);
> +		if (ret < 0)
> +			pr_err("failed to initialize input pad[%d]!\n", i);
> +
> +		ret = media_device_register_entity(dev->media_dev, ent);
> +		if (ret < 0)
> +			pr_err("failed to register input entity %d!\n", i);
> +	}
> +#endif
> +}
> +
>  /**************************************************************************/
>  
>  int au0828_analog_register(struct au0828_dev *dev,
> @@ -1881,17 +1944,8 @@ int au0828_analog_register(struct au0828_dev *dev,
>  	dev->vbi_dev.queue->lock = &dev->vb_vbi_queue_lock;
>  	strcpy(dev->vbi_dev.name, "au0828a vbi");
>  
> -#if defined(CONFIG_MEDIA_CONTROLLER)
> -	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
> -	ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad);
> -	if (ret < 0)
> -		pr_err("failed to initialize video media entity!\n");
> -
> -	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
> -	ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad);
> -	if (ret < 0)
> -		pr_err("failed to initialize vbi media entity!\n");
> -#endif
> +	/* Init entities at the Media Controller */
> +	au0828_analog_create_entities(dev);
>  
>  	/* initialize videobuf2 stuff */
>  	retval = au0828_vb2_setup(dev);
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index d3644b3fe6fa..b7940c54d006 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -93,7 +93,6 @@ struct au0828_board {
>  	unsigned char has_ir_i2c:1;
>  	unsigned char has_analog:1;
>  	struct au0828_input input[AU0828_MAX_INPUT];
> -
>  };
>  
>  struct au0828_dvb {
> @@ -281,6 +280,8 @@ struct au0828_dev {
>  	struct media_device *media_dev;
>  	struct media_pad video_pad, vbi_pad;
>  	struct media_entity *decoder;
> +	struct media_entity input_ent[AU0828_MAX_INPUT];
> +	struct media_pad input_pad[AU0828_MAX_INPUT];
>  #endif
>  };
>  
> 

