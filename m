Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55071 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbcCUMZe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 08:25:34 -0400
Date: Mon, 21 Mar 2016 09:25:29 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media/media-devnode: add missing mutex lock in
 error handler
Message-ID: <20160321092529.46527adb@recife.lan>
In-Reply-To: <145855999281.9224.17355739501867370595.stgit@woodpecker.blarg.de>
References: <145855999281.9224.17355739501867370595.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Mar 2016 12:33:12 +0100
Max Kellermann <max@duempel.org> escreveu:


Please, always send us your Signed-off-by on your patches, as described at:
	https://linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1

Also, please add a description to the patch.

Thanks,
Mauro

> ---
>  drivers/media/media-devnode.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index cea35bf..4d7e8dd 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -266,8 +266,11 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
>  	return 0;
>  
>  error:
> +	mutex_lock(&media_devnode_lock);
>  	cdev_del(&mdev->cdev);
>  	clear_bit(mdev->minor, media_devnode_nums);
> +	mutex_unlock(&media_devnode_lock);
> +
>  	return ret;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
