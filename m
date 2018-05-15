Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:17190 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbeEOJr5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 05:47:57 -0400
Subject: Re: [PATCH 26/61] media: platform: exynos4-is: simplify getting
 .drvdata
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <613c3648-1d2e-e008-60a8-d9f21eca9fae@samsung.com>
Date: Tue, 15 May 2018 11:47:49 +0200
MIME-version: 1.0
In-reply-to: <20180419140641.27926-27-wsa+renesas@sang-engineering.com>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20180419140641.27926-1-wsa+renesas@sang-engineering.com>
        <20180419140641.27926-27-wsa+renesas@sang-engineering.com>
        <CGME20180515094754epcas2p2715cc9c6376ddbb5f400830ef41b514b@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/2018 04:05 PM, Wolfram Sang wrote:
> We should get drvdata from struct device directly. Going via
> platform_device is an unneeded step back and forth.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
