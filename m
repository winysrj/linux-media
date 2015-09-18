Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30288 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbIROan (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 10:30:43 -0400
Message-id: <55FC2010.3060007@samsung.com>
Date: Fri, 18 Sep 2015 16:30:40 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 3/4] MAINTAINERS: add exynos jpeg codec maintainers
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <1442586060-23657-4-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1442586060-23657-4-git-send-email-andrzej.p@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/18/2015 04:20 PM, Andrzej Pietrasiewicz wrote:
> Add Andrzej Pietrasiewicz and Jacek Anaszewski
> as maintainers of drivers/media/platform/s5p-jpeg.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> ---
>   MAINTAINERS | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8133cef..ee9240b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1452,6 +1452,14 @@ L:	linux-media@vger.kernel.org
>   S:	Maintained
>   F:	drivers/media/platform/s5p-tv/
>
> +ARM/SAMSUNG S5P SERIES JPEG CODEC SUPPORT
> +M:	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> +M:	Jacek Anaszewski <j.anaszewski@samsung.com>
> +L:	linux-arm-kernel@lists.infradead.org
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/platform/s5p-jpeg/
> +
>   ARM/SHMOBILE ARM ARCHITECTURE
>   M:	Simon Horman <horms@verge.net.au>
>   M:	Magnus Damm <magnus.damm@gmail.com>
>

Acked-by: Jacek Anaszewski <j.anaszewski@samsung.com>

-- 
Best Regards,
Jacek Anaszewski
