Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56300
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934053AbdBQSJy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 13:09:54 -0500
Subject: Re: [PATCH 05/15] media: s5p-mfc: Simplify alloc/release private
 buffer functions
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075216eucas1p1e3ee119a7e6bbdcda45db5ec0502b6c3@eucas1p1.samsung.com>
 <1487058728-16501-6-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5d40394b-7705-97d7-aee6-f5d068c33fc5@osg.samsung.com>
Date: Fri, 17 Feb 2017 15:09:45 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-6-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:51 AM, Marek Szyprowski wrote:
> Change parameters for s5p_mfc_alloc_priv_buf() and s5p_mfc_release_priv_buf()
> functions. Instead of DMA device pointer and a base, provide common MFC
> device structure and memory bank context identifier.
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
