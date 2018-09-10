Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:50304 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727714AbeIJURl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 16:17:41 -0400
Subject: Re: [PATCH 1/2] vicodec: Drop unneeded symbol dependency
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
References: <20180910152154.14291-1-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <09c8a682-209a-e325-cc56-1224773eab61@xs4all.nl>
Date: Mon, 10 Sep 2018 17:23:01 +0200
MIME-Version: 1.0
In-Reply-To: <20180910152154.14291-1-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 05:21 PM, Ezequiel Garcia wrote:
> The vicodec doesn't use the Subdev API, so drop the dependency.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/platform/vicodec/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vicodec/Kconfig b/drivers/media/platform/vicodec/Kconfig
> index 2503bcb1529f..ad13329e3461 100644
> --- a/drivers/media/platform/vicodec/Kconfig
> +++ b/drivers/media/platform/vicodec/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_VICODEC
>  	tristate "Virtual Codec Driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API

But it definitely needs the MEDIA_CONTROLLER. That's what it should depend on.

Regards,

	Hans

> +	depends on VIDEO_DEV && VIDEO_V4L2
>  	select VIDEOBUF2_VMALLOC
>  	select V4L2_MEM2MEM_DEV
>  	default n
> 
