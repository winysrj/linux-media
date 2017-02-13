Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49191 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbdBMOf2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 09:35:28 -0500
Subject: Re: [PATCH 1/2] [media] exynos-gsc: Do not swap cb/cr for semi planar
 formats
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <983a36ab-bcba-b51d-6078-5d020b47b8d1@samsung.com>
Date: Mon, 13 Feb 2017 15:35:16 +0100
MIME-version: 1.0
In-reply-to: <1485979523-32404-2-git-send-email-javier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 8bit
References: <1485979523-32404-1-git-send-email-javier@osg.samsung.com>
 <1485979523-32404-2-git-send-email-javier@osg.samsung.com>
 <CGME20170213143524epcas5p1e1fdcf49d5fd9b0c40cc9ffe849f10d9@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2017 09:05 PM, Javier Martinez Canillas wrote:
> From: Thibault Saunier <thibault.saunier@osg.samsung.com>
> 
> In the case of semi planar formats cb and cr are in the same plane
> in memory, meaning that will be set to 'cb' whatever the format is,
> and whatever the (packed) order of those components are.
> 
> Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
