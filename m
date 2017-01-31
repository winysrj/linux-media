Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36063
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750933AbdAaKR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:17:57 -0500
Date: Tue, 31 Jan 2017 07:55:07 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Message-ID: <20170131075507.45721c17@vento.lan>
In-Reply-To: <a00be613-169b-4992-dc29-c4b9e82d5501@users.sourceforge.net>
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
        <a00be613-169b-4992-dc29-c4b9e82d5501@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Dec 2016 21:45:50 +0100
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

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

In this specific case, we should keep it, as the message means that
the unregister logic won't work properly, as this loop won't run:

        /*
         * Call device_attach() to reprobe devices
         *
         * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
         * executed.
         */
	while (i--) {
                struct device *d = dev[i];

                if (d && device_attach(d) < 0) {
                        const char *name = "(none)";
                        int lock = device_trylock(d);

                        if (lock && d->driver)
                                name = d->driver->name;
                        dev_err(d, "Failed to re-probe to %s\n", name);
                        if (lock)
                                device_unlock(d);
                }
                put_device(d);
        }

So, IMHO, the proper patch would be to change the message to
be more comprehensive, describing the consequences of not being
able to allocate the dev cache.


>  	mutex_lock(&list_lock);
>  
>  	list_del(&notifier->list);



Thanks,
Mauro
