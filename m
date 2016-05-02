Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49916 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbcEBNg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 09:36:56 -0400
Subject: Re: [PATCH 2/2] media: s3c-camif: fix deadlock on driver probe()
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1461839104-29135-1-git-send-email-m.szyprowski@samsung.com>
 <1461839104-29135-2-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <572757F0.8000904@xs4all.nl>
Date: Mon, 2 May 2016 15:36:48 +0200
MIME-Version: 1.0
In-Reply-To: <1461839104-29135-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/28/16 12:25, Marek Szyprowski wrote:
> Commit 0c426c472b5585ed6e59160359c979506d45ae49 ("[media] media: Always
> keep a graph walk large enough around") changed
> media_device_register_entity() function to take mdev->graph_mutex. This
> causes deadlock in driver probe, which calls (indirectly) this function
> with ->graph_mutex taken. This patch removes taking ->graph_mutex in
> driver probe to avoid deadlock. Other drivers don't take ->graph_mutex
> for entity registration, so this change should be safe.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/platform/s3c-camif/camif-core.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
> index 0b44b9accf50..af237af204e2 100644
> --- a/drivers/media/platform/s3c-camif/camif-core.c
> +++ b/drivers/media/platform/s3c-camif/camif-core.c
> @@ -493,21 +493,17 @@ static int s3c_camif_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err_sens;
>  
> -	mutex_lock(&camif->media_dev.graph_mutex);
> -
>  	ret = v4l2_device_register_subdev_nodes(&camif->v4l2_dev);
>  	if (ret < 0)
> -		goto err_unlock;
> +		goto err_sens;
>  
>  	ret = camif_register_video_nodes(camif);
>  	if (ret < 0)
> -		goto err_unlock;
> +		goto err_sens;
>  
>  	ret = camif_create_media_links(camif);
>  	if (ret < 0)
> -		goto err_unlock;
> -
> -	mutex_unlock(&camif->media_dev.graph_mutex);
> +		goto err_sens;
>  
>  	ret = media_device_register(&camif->media_dev);
>  	if (ret < 0)
> @@ -516,8 +512,6 @@ static int s3c_camif_probe(struct platform_device *pdev)
>  	pm_runtime_put(dev);
>  	return 0;
>  
> -err_unlock:
> -	mutex_unlock(&camif->media_dev.graph_mutex);
>  err_sens:
>  	v4l2_device_unregister(&camif->v4l2_dev);
>  	media_device_unregister(&camif->media_dev);
> 
