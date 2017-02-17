Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57065
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934927AbdBQVQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 16:16:16 -0500
Subject: Re: [PATCH 15/15] ARM: dts: exynos: Remove MFC reserved buffers
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075221eucas1p18648b047f71e9dd95626e5766c74601b@eucas1p1.samsung.com>
 <1487058728-16501-16-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <b7e431ea-7577-2cca-cc76-4d933ec7ff31@osg.samsung.com>
Date: Fri, 17 Feb 2017 18:16:08 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-16-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> During my research I found that some of the requirements for the memory
> buffers for MFC v6+ devices were blindly copied from the previous (v5)
> version and simply turned out to be excessive. The relaxed requirements
> are applied by the recent patches to the MFC driver and the driver is
> now fully functional even without the reserved memory blocks for all
> v6+ variants. This patch removes those reserved memory nodes from all
> boards having MFC v6+ hardware block.
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
