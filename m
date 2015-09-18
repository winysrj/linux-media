Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30249 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbbIROaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 10:30:12 -0400
Message-id: <55FC1FF0.7080506@samsung.com>
Date: Fri, 18 Sep 2015 16:30:08 +0200
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
Subject: Re: [PATCH 2/4] s5p-jpeg: add support for 5433
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <1442586060-23657-3-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1442586060-23657-3-git-send-email-andrzej.p@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On 09/18/2015 04:20 PM, Andrzej Pietrasiewicz wrote:
> JPEG IP found in Exynos5433 is similar to what is in Exynos4, but
> there are some subtle differences which this patch takes into account.
>
> The most important difference is in what is processed by the JPEG IP and
> what has to be provided to it. In case of 5433 the IP does not parse
> Huffman and quantisation tables, so this has to be performed with the CPU
> and the majority of the code in this patch does that.
>
> A small but important difference is in what address is passed to the JPEG
> IP. In case of 5433 it is the SOS (start of scan) position, which is
> natural, because the headers must be parsed elsewhere.
>
> There is also a difference in how the hardware is put to work in
> device_run.
>
> Data structures are extended as appropriate to accommodate the above
> changes.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> ---
>   .../bindings/media/exynos-jpeg-codec.txt           |   3 +-
>   drivers/media/platform/s5p-jpeg/jpeg-core.c        | 378 +++++++++++++++++++--
>   drivers/media/platform/s5p-jpeg/jpeg-core.h        |  31 ++
>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  |  80 ++++-
>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h  |  11 +-
>   drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  85 +++--
>   6 files changed, 522 insertions(+), 66 deletions(-)

Reviewed-by: Jacek Anaszewski <j.anaszewski@samsung.com>

-- 
Best Regards,
Jacek Anaszewski
