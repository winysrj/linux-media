Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50733 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423389AbcFGWdJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 18:33:09 -0400
Subject: Re: [PATCH 1/3] ARM: dts: exynos: replace hardcoded reserved memory
 ranges with auto-allocated ones
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <2241b7f4-4565-d17b-10f3-5c27cd9985da@osg.samsung.com>
 <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <0b4685cb-7fae-2dca-8136-4949a40bc3e9@osg.samsung.com>
Date: Tue, 7 Jun 2016 18:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 06/07/2016 08:03 AM, Marek Szyprowski wrote:
> Generic reserved memory regions bindings allow to automatically allocate
> region of given parameters (alignment and size), so use this feature
> instead of the hardcoded values, which had no dependency on the real
> hardware. This patch also increases "left" region from 8MiB to 16MiB to
> make the codec really usable with nowadays steams (with 8MiB reserved
> region it was not even possible to decode 480p H264 video).
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

The patch looks good to me and I've also tested it on an Exynos5800 Peach
Pi Chromebook and an Exynos5420 Odroid XU4 board.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
