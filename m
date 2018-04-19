Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44268 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751184AbeDSLYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 07:24:46 -0400
Subject: Re: [PATCH RESEND 1/6] omap: omap-iommu.h: allow building drivers
 with COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
References: <cover.1524136402.git.mchehab@s-opensource.com>
 <ea5db7e817bf018927cc5d80f6f392c1897c65cb.1524136402.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b8ed08a1-05da-2c1f-d40f-409b40d11479@xs4all.nl>
Date: Thu, 19 Apr 2018 13:24:36 +0200
MIME-Version: 1.0
In-Reply-To: <ea5db7e817bf018927cc5d80f6f392c1897c65cb.1524136402.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/18 13:15, Mauro Carvalho Chehab wrote:
> Drivers that depend on omap-iommu.h (currently, just omap3isp)
> need a stub implementation in order to be built with COMPILE_TEST.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  include/linux/omap-iommu.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/omap-iommu.h b/include/linux/omap-iommu.h
> index c1aede46718b..ce1b7c6283ee 100644
> --- a/include/linux/omap-iommu.h
> +++ b/include/linux/omap-iommu.h
> @@ -13,7 +13,12 @@
>  #ifndef _OMAP_IOMMU_H_
>  #define _OMAP_IOMMU_H_
>  
> +#ifdef CONFIG_OMAP_IOMMU
>  extern void omap_iommu_save_ctx(struct device *dev);
>  extern void omap_iommu_restore_ctx(struct device *dev);
> +#else
> +static inline void omap_iommu_save_ctx(struct device *dev) {}
> +static inline void omap_iommu_restore_ctx(struct device *dev) {}
> +#endif
>  
>  #endif
> 
