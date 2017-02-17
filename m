Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56245
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934053AbdBQSEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 13:04:16 -0500
Subject: Re: [PATCH 02/15] media: s5p-mfc: Use generic
 of_device_get_match_data helper
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075215eucas1p1e77dbae8e0be9f7f5bf66765c5d57f5f@eucas1p1.samsung.com>
 <1487058728-16501-3-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <aff8c825-86d0-f9a8-f51a-d0fc97055b6e@osg.samsung.com>
Date: Fri, 17 Feb 2017 14:42:06 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-3-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:51 AM, Marek Szyprowski wrote:
> Replace custom code with generic helper to retrieve driver data.
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
