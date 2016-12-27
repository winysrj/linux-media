Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45676 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754507AbcL0Lr4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 06:47:56 -0500
Date: Tue, 27 Dec 2016 13:47:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/8] [media] v4l2-async: Delete an error message for a
 failed memory allocation in v4l2_async_notifier_unregister()
Message-ID: <20161227114718.GM16630@valkosipuli.retiisi.org.uk>
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
 <a00be613-169b-4992-dc29-c4b9e82d5501@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a00be613-169b-4992-dc29-c4b9e82d5501@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 26, 2016 at 09:45:50PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 26 Dec 2016 19:19:49 +0100
> 
> The script "checkpatch.pl" pointed information out like the following.
> 
> WARNING: Possible unnecessary 'out of memory' message
> 
> Thus fix the affected source code place.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 277183f2d514..812d0b2a2f73 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -203,11 +203,6 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  		return;
>  
>  	dev = kmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
> -	if (!dev) {
> -		dev_err(notifier->v4l2_dev->dev,
> -			"Failed to allocate device cache!\n");
> -	}
> -

I'd leave the empty line where it is.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>  	mutex_lock(&list_lock);
>  
>  	list_del(&notifier->list);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
