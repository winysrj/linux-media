Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:10879 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbeDRPU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 11:20:26 -0400
Subject: Re: [PATCH] [media] include/media: fix missing | operator when
 setting cfg
To: Colin King <colin.king@canonical.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <ebce8e36-9125-aecb-b0d1-87f068646e67@samsung.com>
Date: Wed, 18 Apr 2018 17:20:17 +0200
MIME-version: 1.0
In-reply-to: <20180418150617.22489-1-colin.king@canonical.com>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20180418150622epcas4p4be934b89937c0e50a2f236116c02d7cb@epcas4p4.samsung.com>
        <20180418150617.22489-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/18/2018 05:06 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The value from a readl is being masked with ITE_REG_CIOCAN_MASK however
> this is not being used and cfg is being re-assigned.  I believe the
> assignment operator should actually be instead the |= operator.
> 
> Detected by CoverityScan, CID#1467987 ("Unused value")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks for the patch.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
