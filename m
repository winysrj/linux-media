Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:42544 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbeDIJts (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 05:49:48 -0400
Subject: Re: [PATCH 07/16] media: exymos4-is: allow compile test for EXYNOS
 FIMC-LITE
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <132c72ed-1211-682a-1926-79b10eae42c1@samsung.com>
Date: Mon, 09 Apr 2018 11:49:41 +0200
MIME-version: 1.0
In-reply-to: <3cf43e723f17b55d99d817efa535ded43561b1f6.1522949748.git.mchehab@s-opensource.com>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <3cf43e723f17b55d99d817efa535ded43561b1f6.1522949748.git.mchehab@s-opensource.com>
        <CGME20180409094946epcas1p1db108f4fcd018081c90787478004d907@epcas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/05/2018 07:54 PM, Mauro Carvalho Chehab wrote:
> There's nothing that prevents building this driver with
> COMPILE_TEST. So, enable it.
> 
> While here, make the Kconfig dependency cleaner by removing
> the unneeded if block.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

With s/exymos4-is/exynos4-is in the subject

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Regards,
Sylwester
