Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37282 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752357AbeEGKpL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 06:45:11 -0400
Date: Mon, 7 May 2018 13:45:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: media-device: fix ioctl function types
Message-ID: <20180507104509.lq4ep22fm6h53gra@valkosipuli.retiisi.org.uk>
References: <20180427195430.237342-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180427195430.237342-1-samitolvanen@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi,

On Fri, Apr 27, 2018 at 12:54:30PM -0700, Sami Tolvanen wrote:
> This change fixes function types for media device ioctls to avoid
> indirect call mismatches with Control-Flow Integrity checking.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  drivers/media/media-device.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 35e81f7c0d2f..bc5c024906e6 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -54,9 +54,10 @@ static int media_device_close(struct file *filp)
>  	return 0;
>  }
>  
> -static int media_device_get_info(struct media_device *dev,
> -				 struct media_device_info *info)
> +static long media_device_get_info(struct media_device *dev, void *arg)
>  {
> +	struct media_device_info *info = (struct media_device_info *)arg;

How about removing the cast? It's not really needed.

Same below.

> +
>  	memset(info, 0, sizeof(*info));
>  
>  	if (dev->driver_name[0])
> @@ -93,9 +94,9 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
>  	return NULL;
>  }
>  
> -static long media_device_enum_entities(struct media_device *mdev,
> -				       struct media_entity_desc *entd)
> +static long media_device_enum_entities(struct media_device *mdev, void *arg)
>  {
> +	struct media_entity_desc *entd = (struct media_entity_desc *)arg;
>  	struct media_entity *ent;
>  
>  	ent = find_entity(mdev, entd->id);
> @@ -146,9 +147,9 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
>  	upad->flags = kpad->flags;
>  }
>  
> -static long media_device_enum_links(struct media_device *mdev,
> -				    struct media_links_enum *links)
> +static long media_device_enum_links(struct media_device *mdev, void *arg)
>  {
> +	struct media_links_enum *links = (struct media_links_enum *)arg;
>  	struct media_entity *entity;
>  
>  	entity = find_entity(mdev, links->entity);
> @@ -195,9 +196,9 @@ static long media_device_enum_links(struct media_device *mdev,
>  	return 0;
>  }
>  
> -static long media_device_setup_link(struct media_device *mdev,
> -				    struct media_link_desc *linkd)
> +static long media_device_setup_link(struct media_device *mdev, void *arg)
>  {
> +	struct media_link_desc *linkd = (struct media_link_desc *)arg;
>  	struct media_link *link = NULL;
>  	struct media_entity *source;
>  	struct media_entity *sink;
> @@ -225,9 +226,9 @@ static long media_device_setup_link(struct media_device *mdev,
>  	return __media_entity_setup_link(link, linkd->flags);
>  }
>  
> -static long media_device_get_topology(struct media_device *mdev,
> -				      struct media_v2_topology *topo)
> +static long media_device_get_topology(struct media_device *mdev, void *arg)
>  {
> +	struct media_v2_topology *topo = (struct media_v2_topology *)arg;
>  	struct media_entity *entity;
>  	struct media_interface *intf;
>  	struct media_pad *pad;

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
