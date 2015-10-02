Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61142 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbJBW0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 18:26:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 5/7] [media] mipi-csis: make sparse happy
Date: Sat, 03 Oct 2015 00:25:57 +0200
Message-ID: <4962836.RxBJeKxGZM@wuerfel>
In-Reply-To: <de2ce8fd84f965a270bad28d284932bf20c349be.1443737683.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com> <de2ce8fd84f965a270bad28d284932bf20c349be.1443737683.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 October 2015 19:17:27 Mauro Carvalho Chehab wrote:
> diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
> index d74e1bec3d86..4b85105dc159 100644
> --- a/drivers/media/platform/exynos4-is/mipi-csis.c
> +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
> @@ -706,7 +706,8 @@ static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
>                 else
>                         offset = S5PCSIS_PKTDATA_ODD;
>  
> -               memcpy(pktbuf->data, state->regs + offset, pktbuf->len);
> +               memcpy(pktbuf->data, (u8 __force *)state->regs + offset,
> +                      pktbuf->len);
>                 pktbuf->data = NULL;
> 

I think this is what memcpy_toio() is meant for.

	Arnd
