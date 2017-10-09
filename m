Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58778 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751257AbdJILOR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:14:17 -0400
Date: Mon, 9 Oct 2017 14:14:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 01/24] media: v4l2-dev.h: add kernel-doc to two macros
Message-ID: <20171009111414.xkisr2lqvexpmabo@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <2169c19a54e142dcdba99d7c9011552944c74c84.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2169c19a54e142dcdba99d7c9011552944c74c84.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Oct 09, 2017 at 07:19:07AM -0300, Mauro Carvalho Chehab wrote:
> There are two macros at v4l2-dev.h that aren't documented.
> 
> Document them, for completeness.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-dev.h | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index e657614521e3..de1a1453cfd9 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -260,9 +260,21 @@ struct video_device
>  	struct mutex *lock;
>  };
>  
> -#define media_entity_to_video_device(__e) \
> -	container_of(__e, struct video_device, entity)
> -/* dev to video-device */
> +/**
> + * media_entity_to_video_device - Returns a &struct video_device from
> + * 	the &struct media_entity embedded on it.
> + *
> + * @entity: pointer to &struct media_entity
> + */
> +#define media_entity_to_video_device(entity) \
> +	container_of(entity, struct video_device, entity)
> +
> +/**
> + * media_entity_to_video_device - Returns a &struct video_device from

-> to_video_device

With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> + * 	the &struct device embedded on it.
> + *
> + * @cd: pointer to &struct device
> + */
>  #define to_video_device(cd) container_of(cd, struct video_device, dev)
>  
>  /**

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
