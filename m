Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56660
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753335AbdBQTav (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 14:30:51 -0500
Subject: Re: [PATCH 10/15] media: s5p-mfc: Reduce firmware buffer size for MFC
 v6+ variants
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075218eucas1p157d3da30dab72acd2bea1ea99795a274@eucas1p1.samsung.com>
 <1487058728-16501-11-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <e63c437d-95a9-42fa-a583-0625fa897339@osg.samsung.com>
Date: Fri, 17 Feb 2017 16:30:44 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-11-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> Firmware for MFC v6+ variants is not larger than 400 KiB, so there is no
> need to allocate a full 1 MiB buffer for it. Reduce it to 512 KiB to keep
> proper alignment of allocated buffer.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
