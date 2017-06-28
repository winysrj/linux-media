Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:17301 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdF1IvU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 04:51:20 -0400
Subject: Re: [PATCH 2/3] media: ti-vpe: cal: use
 of_graph_get_remote_endpoint()
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <edd9f256-ccd8-e9e1-ec9e-36e14d0953c3@samsung.com>
Date: Wed, 28 Jun 2017 10:51:11 +0200
MIME-version: 1.0
In-reply-to: <87k23xez30.wl%kuninori.morimoto.gx@renesas.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <87mv8tez69.wl%kuninori.morimoto.gx@renesas.com>
        <87k23xez30.wl%kuninori.morimoto.gx@renesas.com>
        <CGME20170628085117epcas5p20400db1d5eb6613a2ef167d54024f716@epcas5p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2017 02:33 AM, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Now, we can use of_graph_get_remote_endpoint(). Let's use it.
> 
> Signed-off-by: Kuninori Morimoto<kuninori.morimoto.gx@renesas.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
