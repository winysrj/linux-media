Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23260 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2IQCTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 22:19:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=EUC-KR
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAH006T42GKPDJ0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Sep 2012 11:19:32 +0900 (KST)
Received: from [10.90.51.68] by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MAH00E6H2GH7170@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Sep 2012 11:19:32 +0900 (KST)
Message-id: <505688BD.2050403@samsung.com>
Date: Mon, 17 Sep 2012 11:19:41 +0900
From: =?EUC-KR?B?sei9wr/s?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: sw0312.kim@samsung.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] [media] gscaler: mark it as BROKEN
References: <1347723514-18361-1-git-send-email-mchehab@redhat.com>
In-reply-to: <1347723514-18361-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

On 2012³â 09¿ù 16ÀÏ 00:38, Mauro Carvalho Chehab wrote:
> -EMISSINGMAKEFILE
> 
> Without a Makefile, the driver will not compile, causing
> breakages for arm exynos5 sub-architecture.
> 
> Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Cc: Sungchun Kang <sungchun.kang@samsung.com>
> Cc: "Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"  <sw0312.kim@samsung.com>

Cc: Seung-Woo Kim <sw0312.kim@samsung.com> is enough, but it is not big
deal.

> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/platform/Kconfig  | 1 +
>  drivers/media/platform/Makefile | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 682594e..aa84d1d 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -184,6 +184,7 @@ config VIDEO_MX2_EMMAPRP
>  config VIDEO_SAMSUNG_EXYNOS_GSC
>  	tristate "Samsung Exynos G-Scaler driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5
> +	depends on BROKEN
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	help
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index baaa550..12d34c4 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -33,7 +33,9 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
>  
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
> -obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
> +
> +# FIXME!!! This driver is broken, as there's no makefile there!
> +#obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
>  
>  obj-$(CONFIG_BLACKFIN)                  += blackfin/
>  
> 

Thanks and Regards,
- Seung-Woo Kim

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

