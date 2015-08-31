Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36998 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbbHaLSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:18:06 -0400
Message-ID: <55E437B4.2030106@xs4all.nl>
Date: Mon, 31 Aug 2015 13:17:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v8 28/55] [media] uapi/media.h: Fix entity namespace
References: <cover.1440902901.git.mchehab@osg.samsung.com> <df9a272928de3326c7139210a1c957d35197d86e.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <df9a272928de3326c7139210a1c957d35197d86e.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Now that interfaces got created, we need to fix the entity
> namespace.
> 
> So, let's create a consistent new namespace and add backward
> compatibility macros to keep the old namespace preserved.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 14d32cdcdd47..88013d1a2c39 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -230,17 +230,17 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
>  
>  	switch (type) {
>  	case DVB_DEVICE_FRONTEND:
> -		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_FE;
> +		dvbdev->entity->type = MEDIA_ENT_T_DVB_DEMOD;
>  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
>  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
>  		break;
>  	case DVB_DEVICE_DEMUX:
> -		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DEMUX;
> +		dvbdev->entity->type = MEDIA_ENT_T_DVB_DEMUX;
>  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
>  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
>  		break;
>  	case DVB_DEVICE_CA:
> -		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_CA;
> +		dvbdev->entity->type = MEDIA_ENT_T_DVB_CA;
>  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
>  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
>  		break;
> @@ -439,7 +439,7 @@ EXPORT_SYMBOL(dvb_unregister_device);
>  void dvb_create_media_graph(struct dvb_adapter *adap)
>  {
>  	struct media_device *mdev = adap->mdev;
> -	struct media_entity *entity, *tuner = NULL, *fe = NULL;
> +	struct media_entity *entity, *tuner = NULL, *demod = NULL;
>  	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
>  	struct media_interface *intf;
>  
> @@ -451,26 +451,26 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
>  		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
>  			tuner = entity;
>  			break;
> -		case MEDIA_ENT_T_DEVNODE_DVB_FE:
> -			fe = entity;
> +		case MEDIA_ENT_T_DVB_DEMOD:
> +			demod = entity;
>  			break;
> -		case MEDIA_ENT_T_DEVNODE_DVB_DEMUX:
> +		case MEDIA_ENT_T_DVB_DEMUX:
>  			demux = entity;
>  			break;
> -		case MEDIA_ENT_T_DEVNODE_DVB_DVR:
> +		case MEDIA_ENT_T_DVB_TSOUT:
>  			dvr = entity;
>  			break;
> -		case MEDIA_ENT_T_DEVNODE_DVB_CA:
> +		case MEDIA_ENT_T_DVB_CA:
>  			ca = entity;
>  			break;
>  		}
>  	}
>  
> -	if (tuner && fe)
> -		media_create_pad_link(tuner, 0, fe, 0, 0);
> +	if (tuner && demod)
> +		media_create_pad_link(tuner, 0, demod, 0, 0);
>  
> -	if (fe && demux)
> -		media_create_pad_link(fe, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
> +	if (demod && demux)
> +		media_create_pad_link(demod, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
>  
>  	if (demux && dvr)
>  		media_create_pad_link(demux, 1, dvr, 0, MEDIA_LNK_FL_ENABLED);
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index aca828709bad..3bbda409353f 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -42,31 +42,71 @@ struct media_device_info {
>  
>  #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
>  
> +/*
> + * Base numbers for entity types
> + *
> + * Please notice that the huge gap of 16 bits for each base is overkill!
> + * 8 bits is more than enough to avoid starving entity types for each
> + * subsystem.
> + *
> + * However, It is kept this way just to avoid binary breakages with the
> + * namespace provided on legacy versions of this header.
> + */
> +#define MEDIA_ENT_T_DVB_BASE		0x00000001

I would change this to 0x00000000, see follow-up comment later for why.

> +#define MEDIA_ENT_T_V4L2_BASE		0x00010000
> +#define MEDIA_ENT_T_V4L2_SUBDEV_BASE	0x00020000
> +
> +/*
> + * V4L2 entities - Those are used for DMA (mmap/DMABUF) and
> + *	read()/write() data I/O associated with the V4L2 devnodes.
> + */
> +#define MEDIA_ENT_T_V4L2_VIDEO		(MEDIA_ENT_T_V4L2_BASE + 1)
> +	/*
> +	 * Please notice that numbers between MEDIA_ENT_T_V4L2_BASE + 2 and
> +	 * MEDIA_ENT_T_V4L2_BASE + 4 can't be used, as those values used
> +	 * to be declared for FB, ALSA and DVB entities.
> +	 * As those values were never actually used in practice, we're just
> +	 * adding them as backward compatibility macros and keeping the
> +	 * numberspace clean here. This way, we avoid breaking compilation,
> +	 * in the case of having some userspace application using the old
> +	 * symbols.
> +	 */
> +#define MEDIA_ENT_T_V4L2_VBI		(MEDIA_ENT_T_V4L2_BASE + 5)
> +	/* for TX radio, as RX is done via either ALSA or wire */
> +#define MEDIA_ENT_T_V4L2_RADIO		(MEDIA_ENT_T_V4L2_BASE + 6)

But TX is also done via either ALSA or wire. This shouldn't be needed.

> +#define MEDIA_ENT_T_V4L2_SWRADIO	(MEDIA_ENT_T_V4L2_BASE + 7)

How about MEDIA_ENT_T_DVB_IO_* and MEDIA_ENT_T_V4L2_IO_* to indicate that
this entity deals with data I/O?

Or, perhaps even better, MEDIA_ENT_T_IO_DVB_ and MEDIA_ENT_T_IO_V4L2_.

Entities should do something, and just saying 'V4L2_VIDEO' doesn't really convey
that meaning. It is also very easy to confuse with INTF_T_V4L_* types. BTW, we
should decide whether V4L2 or V4L is used here (interfaces now use V4L, entities
V4L2). Since entities already use V4L2, I think the interface defines should
use V4L2 as well.

> +
> +/* V4L2 Sub-device entities */
> +#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 1)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 2)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 3)
> +	/* A converter of analogue video to its digital representation. */
> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 4)
> +	/* Tuner entity is actually both V4L2 and DVB subdev */
> +#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 5)
> +
> +/* DVB entities */
> +#define MEDIA_ENT_T_DVB_DEMOD		(MEDIA_ENT_T_DVB_BASE)

After changing DVB_BASE to 0, change this to DVB_BASE + 1, and adjust the other DVB
entity types accordingly.

This keeps the base defines consistent (i.e. the lower 16 bits are always 0).

It surprised me when reading this patch, so I'm probably not the only one.

Regards,

	Hans

> +#define MEDIA_ENT_T_DVB_DEMUX		(MEDIA_ENT_T_DVB_BASE + 1)
> +#define MEDIA_ENT_T_DVB_TSOUT		(MEDIA_ENT_T_DVB_BASE + 2)
> +#define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 3)
> +#define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 4)
> +
> +/* Legacy symbols used to avoid userspace compilation breakages */
>  #define MEDIA_ENT_TYPE_SHIFT		16
>  #define MEDIA_ENT_TYPE_MASK		0x00ff0000
>  #define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
>  
> -#define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENT_TYPE_SHIFT)
> -#define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
> +#define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_T_V4L2_BASE
> +#define MEDIA_ENT_T_V4L2_SUBDEV		MEDIA_ENT_T_V4L2_SUBDEV_BASE
> +
> +#define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_T_V4L2_VIDEO
> +
>  #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
>  #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> -#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE + 4)
> -#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE + 5)
> -#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE + 6)
> -#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE + 7)
> -#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE + 8)
> +#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
>  
> -/* Legacy symbol. Use it to avoid userspace compilation breakages */
> -#define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DEVNODE_DVB_FE
> -
> -#define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENT_TYPE_SHIFT)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
> -/* A converter of analogue video to its digital representation. */
> -#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
> -
> -#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV + 5)
> +/* Entity types */
>  
>  #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
>  
> 

