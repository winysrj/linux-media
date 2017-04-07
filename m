Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38404 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753972AbdDGHku (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 03:40:50 -0400
Date: Fri, 7 Apr 2017 10:40:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helen Koike <helen.koike@collabora.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] media-entity: only call dev_dbg_obj if mdev is
 not NULL
Message-ID: <20170407074015.GB4192@valkosipuli.retiisi.org.uk>
References: <1491507120-28112-1-git-send-email-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491507120-28112-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On Thu, Apr 06, 2017 at 04:32:00PM -0300, Helen Koike wrote:
> Fix kernel Oops NULL pointer deference
> Call dev_dbg_obj only after checking if gobj->mdev is not NULL
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> ---
>  drivers/media/media-entity.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 5640ca2..bc44193 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -199,12 +199,12 @@ void media_gobj_create(struct media_device *mdev,
>  
>  void media_gobj_destroy(struct media_gobj *gobj)
>  {
> -	dev_dbg_obj(__func__, gobj);
> -
>  	/* Do nothing if the object is not linked. */
>  	if (gobj->mdev == NULL)
>  		return;
>  
> +	dev_dbg_obj(__func__, gobj);
> +
>  	gobj->mdev->topology_version++;
>  
>  	/* Remove the object from mdev list */

Where is media_gobj_destroy() called with an object with NULL mdev?

I do not object to the change, but would like to know because I don't think
it's supposed to happen.

There are issues though, until the patches fixing object referencing are
finished and merged. Unfortunately I haven't been able to work on those
recently, will pick them up again soon...

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
