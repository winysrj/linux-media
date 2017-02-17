Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56244
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934275AbdBQSEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 13:04:16 -0500
Subject: Re: [PATCH 01/15] media: s5p-mfc: Remove unused structures and dead
 code
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075214eucas1p10569ef126fbab2e3f3ca2c9818c9b4d6@eucas1p1.samsung.com>
 <1487058728-16501-2-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <bb1a9a0c-6bbd-d852-434b-12fdd726499a@osg.samsung.com>
Date: Fri, 17 Feb 2017 14:40:16 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:51 AM, Marek Szyprowski wrote:
> Remove unused structures, definitions and functions that are no longer
> called from the driver code.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Also on an Exynos5422 Odroid XU4 and Exyos5800 Peach Pi boards:

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
