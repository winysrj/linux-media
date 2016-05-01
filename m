Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34274 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbcEAWQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 May 2016 18:16:29 -0400
Subject: Re: [PATCH 1/2] media: exynos4-is: fix deadlock on driver probe
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1461839104-29135-1-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57267EB2.3050909@xs4all.nl>
Date: Mon, 2 May 2016 00:09:54 +0200
MIME-Version: 1.0
In-Reply-To: <1461839104-29135-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/28/2016 12:25 PM, Marek Szyprowski wrote:
> Commit 0c426c472b5585ed6e59160359c979506d45ae49 ("[media] media: Always
> keep a graph walk large enough around") changed
> media_device_register_entity() function to take mdev->graph_mutex. This
> causes deadlock in driver probe, which calls (indirectly) this function
> with ->graph_mutex taken. This patch removes taking ->graph_mutex in
> driver probe to avoid deadlock. Other drivers don't take ->graph_mutex
> for entity registration, so this change should be safe.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index 04348b502232..891625e77ef5 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -1448,22 +1448,13 @@ static int fimc_md_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, fmd);
>  
> -	/* Protect the media graph while we're registering entities */
> -	mutex_lock(&fmd->media_dev.graph_mutex);
> -
>  	ret = fimc_md_register_platform_entities(fmd, dev->of_node);
> -	if (ret) {
> -		mutex_unlock(&fmd->media_dev.graph_mutex);
> +	if (ret)
>  		goto err_clk;
> -	}
>  
>  	ret = fimc_md_register_sensor_entities(fmd);
> -	if (ret) {
> -		mutex_unlock(&fmd->media_dev.graph_mutex);
> +	if (ret)
>  		goto err_m_ent;
> -	}
> -
> -	mutex_unlock(&fmd->media_dev.graph_mutex);
>  
>  	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
>  	if (ret)
> 
