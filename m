Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36348 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaGQLvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:51:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Salva =?ISO-8859-1?Q?Peir=F3?= <speiro@ai2.upv.es>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH] media-device: Remove duplicated memset() in media_enum_entities()
Date: Thu, 17 Jul 2014 13:51:20 +0200
Message-ID: <1640168.vYZHkKuLz0@avalon>
In-Reply-To: <1402152104-16865-1-git-send-email-speiro@ai2.upv.es>
References: <1402152104-16865-1-git-send-email-speiro@ai2.upv.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Salva,

Thank you for the patch.

On Saturday 07 June 2014 16:41:44 Salva Peiró wrote:
> After the zeroing the whole struct struct media_entity_desc u_ent,
> it is no longer necessary to memset(0) its u_ent.name field.
> 
> Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
> 
> To: Mauro Carvalho Chehab <m.chehab@samsung.com>
> CC: linux-media@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: stable@kernel.org

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/media-device.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 703560f..88c1606 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -106,8 +106,6 @@ static long media_device_enum_entities(struct
> media_device *mdev, if (ent->name) {
>  		strncpy(u_ent.name, ent->name, sizeof(u_ent.name));
>  		u_ent.name[sizeof(u_ent.name) - 1] = '\0';
> -	} else {
> -		memset(u_ent.name, 0, sizeof(u_ent.name));
>  	}
>  	u_ent.type = ent->type;
>  	u_ent.revision = ent->revision;

-- 
Regards,

Laurent Pinchart

