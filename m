Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:62093 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3DUMBE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 08:01:04 -0400
Message-ID: <5173D2DC.4060200@bfs.de>
Date: Sun, 21 Apr 2013 13:51:56 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] media: info leak in media_device_enum_entities()
References: <20130421111003.GD6171@elgon.mountain>
In-Reply-To: <20130421111003.GD6171@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 21.04.2013 13:10, schrieb Dan Carpenter:
> The last part of the "u_ent.name" buffer isn't cleared so it still has
> uninitialized stack memory.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 99b80b6..1957c0d 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -102,9 +102,12 @@ static long media_device_enum_entities(struct media_device *mdev,
>  		return -EINVAL;
>  
>  	u_ent.id = ent->id;
> -	u_ent.name[0] = '\0';
> -	if (ent->name)
> -		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
> +	if (ent->name) {
> +		strncpy(u_ent.name, ent->name, sizeof(u_ent.name));
> +		u_ent.name[sizeof(u_ent.name) - 1] = '\0';
> +	} else {
> +		memset(u_ent.name, 0, sizeof(u_ent.name));
> +	}

I would always memset()
and then do strncpy() for sizeof(u_ent.name) - 1
the rest is always zero.

re,
 wh


>  	u_ent.type = ent->type;
>  	u_ent.revision = ent->revision;
>  	u_ent.flags = ent->flags;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
