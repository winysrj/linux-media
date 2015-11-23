Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38893 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbbKWRqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 12:46:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 14/18] [media] media-device: export the entity function via new ioctl
Date: Mon, 23 Nov 2015 19:46:22 +0200
Message-ID: <2850958.hkaPDHPL2k@avalon>
In-Reply-To: <13a08789f63775c6f014c08969bc8ed3f0550c82.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com> <13a08789f63775c6f014c08969bc8ed3f0550c82.1441559233.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 14:30:57 Mauro Carvalho Chehab wrote:
> Now that entities have a main function, expose it via
> MEDIA_IOC_G_TOPOLOGY ioctl.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index ccef9621d147..32090030c342 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -263,6 +263,7 @@ static long __media_device_get_topology(struct
> media_device *mdev, /* Copy fields to userspace struct if not error */
>  		memset(&uentity, 0, sizeof(uentity));
>  		uentity.id = entity->graph_obj.id;
> +		uentity.function = entity->function;
>  		strncpy(uentity.name, entity->name,
>  			sizeof(uentity.name));
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 69433405aec2..d232cc680c67 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -284,7 +284,8 @@ struct media_links_enum {
>  struct media_v2_entity {
>  	__u32 id;
>  	char name[64];		/* FIXME: move to a property? (RFC says so) */
> -	__u16 reserved[14];
> +	__u32 function;		/* Main function of the entity */

Shouldn't we use kerneldoc instead of inline comments ?

Also, as this is the main function only, I'd mention that in the subject line. 
The implementation itself looks fine to me, I'll discuss the API over the 
documentation patch.

> +	__u16 reserved[12];
>  };
> 
>  /* Should match the specific fields at media_intf_devnode */

-- 
Regards,

Laurent Pinchart

