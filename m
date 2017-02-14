Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40419
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754020AbdBNQdB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 11:33:01 -0500
Subject: Re: [PATCH] media: s5p-mfc: Fix initialization of internal structures
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <CGME20170203140530eucas1p17e9d0bbb29da881bae025e8e3bc7cbbb@eucas1p1.samsung.com>
 <1486130718-25998-1-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Message-ID: <37216e17-e6b4-2adb-2d34-d75aaf988ca0@osg.samsung.com>
Date: Tue, 14 Feb 2017 13:32:51 -0300
MIME-Version: 1.0
In-Reply-To: <1486130718-25998-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/03/2017 11:05 AM, Marek Szyprowski wrote:
> Initialize members of the internal device and context structures as early
> as possible to avoid access to uninitialized objects on initialization
> failures. If loading firmware or creating of the hardware instance fails,
> driver will access device or context queue in error handling path, which
> might not be initialized yet, what causes kernel panic. Fix this by moving
> initialization of all static members as early as possible.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Also tested on an Exynos5422 Odroid XU4 and Exynos5800 Peach Pi:

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
