Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10551 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbcDNJFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 05:05:40 -0400
Subject: Re: [PATCH] [media] exynos-gsc: remove an always false condition
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <26a7ed9c18193dc7a3dfba33e3c711822f4bdd29.1460575950.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <570F5D4D.9040207@samsung.com>
Date: Thu, 14 Apr 2016 11:05:17 +0200
MIME-version: 1.0
In-reply-to: <26a7ed9c18193dc7a3dfba33e3c711822f4bdd29.1460575950.git.mchehab@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2016 09:32 PM, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> drivers/media/platform/exynos-gsc/gsc-core.c:1073 gsc_probe() warn: impossible condition '(gsc->id < 0) => (0-65535 < 0)'
> drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_probe':
> drivers/media/platform/exynos-gsc/gsc-core.c:1073:51: warning: comparison is always false due to limited range of data type [-Wtype-limits]
>   if (gsc->id >= drv_data->num_entities || gsc->id < 0) {
>                                                    ^
> 
> gsc->id is an u16, so it can never be a negative number. So,
> remove the always false condition.
> 
> Fixes: c1ac057173ba "[media] exynos-gsc: remove non-device-tree init code"
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Thanks for fixing this.
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Regards,
Sylwester
