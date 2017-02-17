Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56637
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752588AbdBQTYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 14:24:18 -0500
Subject: Re: [PATCH 09/15] media: s5p-mfc: Allocate firmware with internal
 private buffer alloc function
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075218eucas1p188d8d26aa2a6c9157587e1c979008817@eucas1p1.samsung.com>
 <1487058728-16501-10-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <c095a851-9fd6-9b94-dd2c-87e1db477acd@osg.samsung.com>
Date: Fri, 17 Feb 2017 16:24:10 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-10-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hell Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> Once firmware buffer has been converted to use s5p_mfc_priv_buf structure,
> it is possible to allocate it with existing s5p_mfc_alloc_priv_buf()
> function. This change will help to reduce code variants in the next
> patches.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
