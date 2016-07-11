Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:21679 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933408AbcGKDI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 23:08:56 -0400
Message-ID: <1468206529.3725.18.camel@mtksdaap41>
Subject: Re: [PATCH 2/2] drivers/media/platform/Kconfig: fix
 VIDEO_MEDIATEK_VCODEC dependency
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 11 Jul 2016 11:08:49 +0800
In-Reply-To: <1468005079-28636-3-git-send-email-hverkuil@xs4all.nl>
References: <1468005079-28636-1-git-send-email-hverkuil@xs4all.nl>
	 <1468005079-28636-3-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2016-07-08 at 21:11 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Allow VIDEO_MEDIATEK_VCODEC to build when COMPILE_TEST is set (even
> without MTK_IOMMU).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 3231b25..2c2670c 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -168,7 +168,7 @@ config VIDEO_MEDIATEK_VPU
>  
>  config VIDEO_MEDIATEK_VCODEC
>  	tristate "Mediatek Video Codec driver"
> -	depends on MTK_IOMMU
> +	depends on MTK_IOMMU || COMPILE_TEST
>  	depends on VIDEO_DEV && VIDEO_V4L2
>  	depends on ARCH_MEDIATEK || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG

reviewed-by: Tiffany Lin <tiffany.lin@mediatek.com>


