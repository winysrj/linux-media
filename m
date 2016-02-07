Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51630 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750980AbcBGSH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 13:07:56 -0500
Date: Sun, 7 Feb 2016 20:07:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: weiyj_lk@163.com
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] [media] media: davinci_vpfe: fix missing unlock on error
 in vpfe_prepare_pipeline()
Message-ID: <20160207180714.GD32612@valkosipuli.retiisi.org.uk>
References: <1454680320-18307-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454680320-18307-1-git-send-email-weiyj_lk@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Fri, Feb 05, 2016 at 09:52:00PM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function
> vpfe_prepare_pipeline() in the error handling case.
> 
> video->lock is lock/unlock in function vpfe_open(),
> and no need to unlock it here, so remove unlock
> video->lock.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 3ec7e65..db49af9 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -147,7 +147,7 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
>  	mutex_lock(&mdev->graph_mutex);
>  	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
>  	if (ret) {
> -		mutex_unlock(&video->lock);
> +		mutex_unlock(&mdev->graph_mutex);

Oh dear. I wonder how could this have happened... thanks for the fix!

I've applied this to my tree.

>  		return -ENOMEM;
>  	}
>  	media_entity_graph_walk_start(&graph, entity);
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
