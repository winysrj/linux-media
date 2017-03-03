Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57627 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdCCJYH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 04:24:07 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OM801FZ2FFHHTD0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 03 Mar 2017 18:23:41 +0900 (KST)
Subject: Re: [v2,01/15] media: s5p-mfc: Remove unused structures and dead code
From: Smitha T Murthy <smitha.t@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
In-reply-to: <1487597944-2000-2-git-send-email-m.szyprowski@samsung.com>
Date: Fri, 03 Mar 2017 14:54:55 +0530
Message-id: <1488533095.2691.2.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1487597944-2000-2-git-send-email-m.szyprowski@samsung.com>
 <CGME20170303092341epcas5p1e7f35d8911c06f9f43023b0e0177b31c@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-02-20 at 14:38 +0100, Marek Szyprowski wrote:
> Remove unused structures, definitions and functions that are no longer
> called from the driver code.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Acked-by: Andrzej Hajda <a.hajda@samsung.com>

Hi Marek,
I tested this complete series on Exynos7880, along with my MFC v10.10
patchset v2 [1] and it's working fine.

Please review MFC v10.10 series. 

Tested-by: Smitha T Murthy <smitha.t@samsung.com>

[1]: https://www.spinics.net/lists/arm-kernel/msg566019.html

Thanks,
Smitha T Murthy
