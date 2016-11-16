Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44288
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932855AbcKPOa7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 09:30:59 -0500
Date: Wed, 16 Nov 2016 12:30:51 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 06/34] [media] DaVinci-VPBE: Return an error code only
 by a single variable in vpbe_initialize()
Message-ID: <20161116123051.25f3a640@vento.lan>
In-Reply-To: <31e1f827-3539-3bcf-e6c1-2b9df5fd3619@users.sourceforge.net>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
        <31e1f827-3539-3bcf-e6c1-2b9df5fd3619@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 12 Oct 2016 16:40:22 +0200
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 11 Oct 2016 14:15:57 +0200
> 
> An error code was assigned to the local variable "err" in an if branch.
> But this variable was not used further then.
> 
> Use the local variable "ret" instead like at other places in this function.
> 
> Fixes: 66715cdc3224a4e241c1a92856b9a4af3b70e06d ("[media] davinci vpbe:
> VPBE display driver")
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/platform/davinci/vpbe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 4c4cd81..afa8ff7 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -665,7 +665,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>  		if (err) {
>  			v4l2_err(&vpbe_dev->v4l2_dev,
>  				 "unable to initialize the OSD device");
> -			err = -ENOMEM;
> +			ret = -ENOMEM;
>  			goto fail_dev_unregister;
>  		}
>  	}

Hmm... why are you keeping both "err" and "ret" variables here?
Just one var is needed. Also, why not just return the error code?

If you want to cleanup the code, please look at the entire function,
and not to just this occurrence.

I mean, IMHO, this code (and all similar occurrences), should be, instead:

		ret = osd_device->ops.initialize(osd_device);
                if (ret) {
                        v4l2_err(&vpbe_dev->v4l2_dev,
                                 "unable to initialize the OSD device");
                        goto fail_dev_unregister;
                }

and the "err" var can probably be removed.


Thanks,
Mauro
