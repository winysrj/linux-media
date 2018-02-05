Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59615 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753019AbeBEMjI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 07:39:08 -0500
Date: Mon, 5 Feb 2018 10:39:05 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH] media-device: add index field to media_v2_pad
Message-ID: <20180205103905.6ff43f9e@vento.lan>
In-Reply-To: <f29798d5-6f90-e433-93d5-81ba3e420d34@xs4all.nl>
References: <f29798d5-6f90-e433-93d5-81ba3e420d34@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 4 Feb 2018 14:53:31 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Userspace has no way of knowing the pad index for the entity that
> owns the pad with the MEDIA_IOC_G_TOPOLOGY ioctl. However, various
> v4l-subdev ioctls need to pass this as an argument.

While I'm OK on adding a pad index, it still misses a way for Kernelspace
to inform the kind of signal it is expected for the cases where an entity
provides multiple PAD inputs or outputs with different meanings, e. g.
for cases like TV tuner, where different PAD outputs have different
signals and should be connected to different entities, based on the PAD
type.

In other words, we need also either a:
	- pad name;
	- pad type;
	- pad signal.

> 
> Add this missing information.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> RFC, so no documentation yet. This works fine, but how would applications
> know that media_v2_pad has been extended with a new index field? Currently
> this is 0, which is a valid index.
> 
> If no one is using this API (or only for DVB devices) then we can do that.
> The other alternative is to add a new pad flag MEDIA_PAD_FL_HAS_INDEX.
> ---
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index e79f72b8b858..16964d3dfb1e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -318,6 +320,7 @@ static long media_device_get_topology(struct media_device *mdev,
>  		kpad.id = pad->graph_obj.id;
>  		kpad.entity_id = pad->entity->graph_obj.id;
>  		kpad.flags = pad->flags;
> +		kpad.index = pad->index;
> 
>  		if (copy_to_user(upad, &kpad, sizeof(kpad)))
>  			ret = -EFAULT;
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index b9b9446095e9..c3e7a668e122 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -375,7 +375,8 @@ struct media_v2_pad {
>  	__u32 id;
>  	__u32 entity_id;
>  	__u32 flags;
> -	__u32 reserved[5];
> +	__u16 index;
> +	__u16 reserved[9];
>  } __attribute__ ((packed));
> 
>  struct media_v2_link {



Thanks,
Mauro
