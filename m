Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62988 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdHHMhM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:37:12 -0400
Subject: Re: [PATCH 5/6] [media] exynos4-is: constify video_subdev
 structures
To: Julia Lawall <Julia.Lawall@lip6.fr>, linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, bhumirks@gmail.com,
        kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <5c673a72-98f6-1501-845e-7d83fabfa659@samsung.com>
Date: Tue, 08 Aug 2017 14:37:03 +0200
MIME-version: 1.0
In-reply-to: <1502189912-28794-6-git-send-email-Julia.Lawall@lip6.fr>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
        <1502189912-28794-6-git-send-email-Julia.Lawall@lip6.fr>
        <CGME20170808123709epcas2p229a31cfa19e3a5bf3986e547162e2613@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2017 12:58 PM, Julia Lawall wrote:
> The v4l2_subdev_ops structures are only passed as the second
> argument of v4l2_subdev_init, which is const, so the
> v4l2_subdev_ops structures can be const as well.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
