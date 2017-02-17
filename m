Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56901
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932655AbdBQUYb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 15:24:31 -0500
Subject: Re: [PATCH 13/15] media: s5p-mfc: Remove special configuration of
 IOMMU domain
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075220eucas1p1451535e571c481c69aacec705a782c09@eucas1p1.samsung.com>
 <1487058728-16501-14-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <30743df2-b16a-df98-a2b0-b72fdd2e6678@osg.samsung.com>
Date: Fri, 17 Feb 2017 17:24:24 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-14-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> The main reason for using special configuration of IOMMU domain was the
> problem with MFC firmware, which failed to operate properly when placed
> at 0 DMA address. Instead of adding custom code for configuring each
> variant of IOMMU domain and architecture specific glue code, simply use
> what arch code provides and if the DMA base address equals zero, skip
> first 128 KiB to keep required alignment. This patch also make the driver
> operational on ARM64 architecture, because it no longer depends on ARM
> specific DMA-mapping and IOMMU glue code functions.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
