Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47301 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbbEHLj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 07:39:29 -0400
Message-ID: <554CA060.7090006@xs4all.nl>
Date: Fri, 08 May 2015 13:39:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 02/18] media controller: deprecate entity subtype
References: <cover.1431046915.git.mchehab@osg.samsung.com> <80e0882a4194460ca232f19ebbc85fa3338eda3f.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <80e0882a4194460ca232f19ebbc85fa3338eda3f.1431046915.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just a typo, after that you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> The media controller entity subtype doesn't make much sense,
> especially since V4L2 subdevices may also have associated devnodes.
> 
> So, better to get rid of it while it is not too late.
> 
> We need, of course, to keep the old symbols to avoid userspace
> breakage, but we should avoid using them internally at the
> Kernel.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 4e816be3de39..775c11c6b173 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -42,31 +42,45 @@ struct media_device_info {
>  
>  #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
>  
> +/* Used values for media_entity_desc::type */
> +
> +#define MEDIA_ENT_T_DEVNODE_V4L		(((1 << 16)) + 1)
> +#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE_V4L + 3)
> +#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE_V4L + 4)
> +#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE_V4L + 5)
> +#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE_V4L + 6)
> +#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE_V4L + 7)
> +
> +#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	((2 << 16) + 1)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 1)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 2)
> +/* A converter of analogue video to its digital representation. */
> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 3)
> +
> +#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 4)
> +
> +#if 1
> +/*
> + * Legacy symbols.
> + * Kept just to avoid userspace compilation breakages.
> + * One day, the symbols bellow will be removed

bellow -> below

> + */
> +
>  #define MEDIA_ENT_TYPE_SHIFT		16
>  #define MEDIA_ENT_TYPE_MASK		0x00ff0000
>  #define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
>  
>  #define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENT_TYPE_SHIFT)
> -#define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
> +#define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENT_TYPE_SHIFT)
> +
>  #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
>  #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> -#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE + 4)
> -#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE + 5)
> -#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE + 6)
> -#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE + 7)
> -#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE + 8)
>  
> -/* Legacy symbol. Use it to avoid userspace compilation breakages */
> +
>  #define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DEVNODE_DVB_FE
> +#endif
>  
> -#define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENT_TYPE_SHIFT)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
> -/* A converter of analogue video to its digital representation. */
> -#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
> -
> -#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV + 5)
> +/* Used bitmasks for media_entity_desc::flags */
>  
>  #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
>  
> 

