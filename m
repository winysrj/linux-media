Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51810 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753104AbdHGKSm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 06:18:42 -0400
Subject: Re: [PATCH 06/12] [media] exynos-gsc: constify v4l2_m2m_ops
 structures
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, bhumirks@gmail.com,
        kernel-janitors@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <44bf7134-14c9-fcb2-75d1-398a900e6de3@samsung.com>
Date: Mon, 07 Aug 2017 12:18:33 +0200
MIME-version: 1.0
In-reply-to: <1502007921-22968-7-git-send-email-Julia.Lawall@lip6.fr>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1502007921-22968-1-git-send-email-Julia.Lawall@lip6.fr>
        <1502007921-22968-7-git-send-email-Julia.Lawall@lip6.fr>
        <CGME20170807101839epcas2p41e7c3092b876487e132a8a640e9ed262@epcas2p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2017 10:25 AM, Julia Lawall wrote:
> The v4l2_m2m_ops structures are only passed as the only
> argument to v4l2_m2m_init, which is declared as const.
> Thus the v4l2_m2m_ops structures themselves can be const.
> 
> Done with the help of Coccinelle.

> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
