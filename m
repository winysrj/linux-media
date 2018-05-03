Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:47022 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbeECMxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 08:53:03 -0400
Received: by mail-lf0-f53.google.com with SMTP id v85-v6so25768637lfa.13
        for <linux-media@vger.kernel.org>; Thu, 03 May 2018 05:53:02 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 3 May 2018 14:53:00 +0200
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [bug report] media: rcar-vin: add group allocator functions
Message-ID: <20180503125300.GB9120@bigcity.dyn.berto.se>
References: <20180503123630.GA19539@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180503123630.GA19539@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thanks for your report. A proposed fix to this is available [1], 
awaiting inclusion in the media-tree :-)

1. https://patchwork.linuxtv.org/patch/49025/

On 2018-05-03 15:36:30 +0300, Dan Carpenter wrote:
> Hello Niklas Söderlund,
> 
> The patch 3bb4c3bc85bf: "media: rcar-vin: add group allocator
> functions" from Apr 14, 2018, leads to the following static checker
> warning:
> 
> 	drivers/media/platform/rcar-vin/rcar-core.c:346 rvin_group_put()
> 	error: potential NULL dereference 'vin->group'.
> 
> drivers/media/platform/rcar-vin/rcar-core.c
>    339  static void rvin_group_put(struct rvin_dev *vin)
>    340  {
>    341          mutex_lock(&vin->group->lock);
>    342  
>    343          vin->group = NULL;
>                 ^^^^^^^^^^^^^^^^^
> Set to NULL.
> 
>    344          vin->v4l2_dev.mdev = NULL;
>    345  
>    346          if (WARN_ON(vin->group->vin[vin->id] != vin))
>                             ^^^^^^^^^^^^^^^^^^^^^^^^
>    347                  goto out;
>    348  
>    349          vin->group->vin[vin->id] = NULL;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^
>    350  out:
>    351          mutex_unlock(&vin->group->lock);
>                               ^^^^^^^^^^^^^^^^
>    352  
>    353          kref_put(&vin->group->refcount, rvin_group_release);
>                           ^^^^^^^^^^^^^^^^^^^^
> 
> There are a bunch of NULL dereferences here...
> 
>    354  }
> 
> regards,
> dan carpenter

-- 
Regards,
Niklas Söderlund
