Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:51759 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752645AbdHGKXo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 06:23:44 -0400
Subject: Re: [PATCH 03/12] [media] s5p-g2d: constify v4l2_m2m_ops structures
To: Julia Lawall <Julia.Lawall@lip6.fr>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Kamil Debski <kamil@wypas.org>,
        linux-kernel@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        bhumirks@gmail.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <bc93fea6-89fb-25c3-ce97-9e8c17d13ac8@samsung.com>
Date: Mon, 07 Aug 2017 12:23:36 +0200
MIME-version: 1.0
In-reply-to: <1502007921-22968-4-git-send-email-Julia.Lawall@lip6.fr>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1502007921-22968-1-git-send-email-Julia.Lawall@lip6.fr>
        <1502007921-22968-4-git-send-email-Julia.Lawall@lip6.fr>
        <CGME20170807102341epcas2p2da8478bd73ca0678071912323830e456@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2017 10:25 AM, Julia Lawall wrote:
> The v4l2_m2m_ops structures are only passed as the only
> argument to v4l2_m2m_init, which is declared as const.
> Thus the v4l2_m2m_ops structures themselves can be const.
> 
> Done with the help of Coccinelle.

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
